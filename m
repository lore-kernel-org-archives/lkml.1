Return-Path: <linux-kernel-owner+w=401wt.eu-S1758712AbYHUNYb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758712AbYHUNYb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 09:24:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753432AbYHUNYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 09:24:21 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40438 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752414AbYHUNYU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 09:24:20 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20080819003211.ba6b0ac5.akpm@linux-foundation.org>
References: <20080819003211.ba6b0ac5.akpm@linux-foundation.org> <1218322941.24441.11.camel@brick> <12514.1218365916@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dhowells@redhat.com, Harvey Harrison <harvey.harrison@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cred: remove const qualifiers
X-Mailer: MH-E 8.0.3+cvs; nmh 1.3; GNU Emacs 23.0.50
Date: Thu, 21 Aug 2008 14:24:12 +0100
Message-ID: <5816.1219325052@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:

> That information should have been included in a code comment.

It was explained in the covering note:

	Subject: [PATCH 00/24] Introduce credentials [ver #7]
	...
	 (c) task_struct::cred is a const struct cred *, as are all pointers
	     that aren't used specifically for creating new credentials.  This
	     catches places that are changing creds when they shouldn't be at
	     compile time.

	     To get a new ref on a const cred, use get_cred() which casts away
	     the const and calls atomic_inc().

It should've gone in the log entry for the "CRED: Inaugurate COW credentials"
patch and also into the documentation.  I don't know whether I can amend the
former, but I can amend the latter.  I'll also amend the comment to make it
crystal clear.

David
