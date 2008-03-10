Return-Path: <linux-kernel-owner+w=401wt.eu-S1753608AbYCJMZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608AbYCJMZp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 08:25:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751794AbYCJMZf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 08:25:35 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60971 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291AbYCJMZe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 08:25:34 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0803082235430.27953@peripatetic.hades>
References: <Pine.LNX.4.64.0803082235430.27953@peripatetic.hades>
To: Arun Raghavan <arunsr@cse.iitk.ac.in>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org, satyam@infradead.org
Subject: Re: [PATCH] keyring: Incorrect permissions checking in __keyring_search_one()
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Mon, 10 Mar 2008 12:25:21 +0000
Message-ID: <10809.1205151921@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arun Raghavan <arunsr@cse.iitk.ac.in> wrote:

> The __keyring_search_one() function currently has 2 issues with regards
> to permissions:
> 
>  1. It does not check for KEY_SEARCH on the keyring before performing a
>     search

That is correct.  This is used by key_create_or_update() to check to see
whether there's a key in the current keyring that it can update rather than
adding a new key entirely.  key_create_or_update() mustn't be bound by
KEY_SEARCH permission, and similarly the target key doesn't require KEY_SEARCH
permission either; the control here is whether or not the target key has
KEY_WRITE permission.

>  2. It accepts a "perm" parameter to check whether a given key in the
>     keyring may be returned.

The "perm" parameter is superfluous given that nothing else now calls this
function.

David
