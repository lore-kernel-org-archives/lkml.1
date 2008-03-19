Return-Path: <linux-kernel-owner+w=401wt.eu-S934568AbYCSXzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934568AbYCSXzs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 19:55:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934741AbYCSW3Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 18:29:24 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39055 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763528AbYCSW3V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 18:29:21 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0803200227440.22605@peripatetic.hades>
References: <Pine.LNX.4.64.0803200227440.22605@peripatetic.hades>
To: Arun Raghavan <arunsr@cse.iitk.ac.in>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [keys] Always use key_get() to increment key refcount
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Wed, 19 Mar 2008 22:29:06 +0000
Message-ID: <8036.1205965746@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arun Raghavan <arunsr@cse.iitk.ac.in> wrote:

> Patch to use key_get() wherever the keys code manually increments the
> key refcount.
> 
> This should make debugging a little simpler for clients, since it
> becomes easier to track where a key's refcount changes.

The problem with this is that key_get() is not simply an atomic_inc().  You
end up introducing an extra conditional into each of these places where one is
not required.  Now it's possible that the compiler's optimiser is sufficiently
clever to get rid of them all, but do you guarantee that?

David
