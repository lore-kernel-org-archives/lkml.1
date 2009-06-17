Return-Path: <linux-kernel-owner+w=401wt.eu-S1763290AbZFQA0l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763290AbZFQA0l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 20:26:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754267AbZFQA0c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 20:26:32 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59003 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752135AbZFQA0c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 20:26:32 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090617001157.065ee652@lxorguk.ukuu.org.uk>
References: <20090617001157.065ee652@lxorguk.ukuu.org.uk> <20090616203845.4526.60013.stgit@warthog.procyon.org.uk> <10437.1245193192@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: dhowells@redhat.com, torvalds@osdl.org, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-afs@lists.infradead.org
Subject: Re: [PATCH 00/17] [RFC] AFS: Implement OpenAFS pioctls(version)s
Date: Wed, 17 Jun 2009 01:25:58 +0100
Message-ID: <11650.1245198358@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> But if we add an ABI we end up stuck with it and this one is really
> really rather ugly.

Somewhat less ugly than ioctl, for instance, but you're not entirely wrong.
There is no good way of doing this.

> Can you not put pioctl() into a C library linked with the openafs utilities
> that generates more sensible interface calls?  I mean you have to produce
> the pioctl() syscall wrapper anyway so why not make "pioctl" a user space
> compat library?

pioctl() is almost implementable with a combination of (l)setxattr,
(l)getxattr, set_key, keyctl_read, and if all else fails, open + ioctl or
open(O_NOFOLLOW) + ioctl, but not quite completely.  There are things you can't
open, even with O_NOFOLLOW.  And doing state-retaining setxattr/getxattr pairs
is even more nasty than pioctl (IIRC, that's something Christoph suggested a
while back).

Besides, I want a set of utilities that I can use in conjunction with both kAFS
and OpenAFS without having to recompile.

David
