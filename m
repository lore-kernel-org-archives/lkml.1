Return-Path: <linux-kernel-owner+w=401wt.eu-S1757949AbXJANV1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757949AbXJANV1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 09:21:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756164AbXJANO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 09:14:58 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44061 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756158AbXJANO4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 09:14:56 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20070929132848.GA21169@wotan.suse.de>
References: <20070929132848.GA21169@wotan.suse.de>
To: Nick Piggin <npiggin@suse.de>
Cc: dhowells@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
       Paul McKenney <paulmck@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>
Subject: Re: [rfc][patch] i386: remove comment about barriers
X-Mailer: MH-E 8.0.3; nmh 1.2-20070115cvs; GNU Emacs 22.1.50
Date: Mon, 01 Oct 2007 14:14:44 +0100
Message-ID: <29721.1191244484@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <npiggin@suse.de> wrote:

> [ This is true for x86's sfence/lfence, but raises a question about Linux's
> memory barriers. Does anybody expect that a sequence of smp_wmb and smp_rmb
> would ever provide a full smp_mb barrier? I've always assumed no, but I
> don't know if it is actually documented? ]

I think you have to assume that smp_wmb() only orders stores and write
barriers, and that smp_rmb() only orders reads and read barriers.

smp_mb() implies both smp_wmb() and smp_rmb(), but is greater than the
combination of the two.

David
