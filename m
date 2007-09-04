Return-Path: <linux-kernel-owner+w=401wt.eu-S1752703AbXIDHzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703AbXIDHzq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 03:55:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751616AbXIDHzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 03:55:39 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36669 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751679AbXIDHzi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 03:55:38 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <46DA0AB1.8050504@tmr.com>
References: <46DA0AB1.8050504@tmr.com> <000701c7eb49$cff701c0$6fe50540$@com> <1188513433.6626.24.camel@heimdal.trondhjem.org> <alpine.LFD.0.999.0708302038310.25853@woody.linux-foundation.org> <1188577275.6649.133.camel@heimdal.trondhjem.org>
To: Bill Davidsen <davidsen@tmr.com>
Cc: dhowells@redhat.com, Trond Myklebust <trond.myklebust@fys.uio.no>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frank van Maarseveen <frankvm@frankvm.com>,
       Hua Zhong <hzhong@gmail.com>,
       "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org
Subject: Re: recent nfs change causes autofs regression
X-Mailer: MH-E 8.0.3; nmh 1.2-20070115cvs; GNU Emacs 22.1.50
Date: Tue, 04 Sep 2007 08:54:28 +0100
Message-ID: <5813.1188892468@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Davidsen <davidsen@tmr.com> wrote:

> mount /base on point1 - rw	[ hopefully really r/w ]
> mount /base on point2 - ro	[ hopefully r/o ]

I think Al Viro probably has the right idea as to how to fix this: Move the
R/O R/W flag into vfsmount and count the number of R/W vfsmounts in the
superblock.  I never quite finished implementing the patch to do this, but I
can go back and revisit it.

David
