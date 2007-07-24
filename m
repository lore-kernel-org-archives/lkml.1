Return-Path: <linux-kernel-owner+w=401wt.eu-S935605AbXGXJXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935605AbXGXJXT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 05:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932088AbXGXJXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 05:23:08 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45598 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763550AbXGXJXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 05:23:07 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <alpine.LFD.0.999.0707231043540.3607@woody.linux-foundation.org>
References: <alpine.LFD.0.999.0707231043540.3607@woody.linux-foundation.org> <20070723160528.22137.84144.sendpatchset@cselinux1.cse.iitk.ac.in> <20070723160543.22137.9416.sendpatchset@cselinux1.cse.iitk.ac.in>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Satyam Sharma <ssatyam@cse.iitk.ac.in>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/8] i386: bitops: Rectify bogus "+m" constraints
X-Mailer: MH-E 8.0; nmh 1.2-20070115cvs; GNU Emacs 22.0.50
Date: Tue, 24 Jul 2007 10:22:44 +0100
Message-ID: <18925.1185268964@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > So, using the "+" constraint modifier for memory, like "+m" is bogus.
> > We must simply specify "=m" which handles the case correctly.
> 
> No. This is wrong.

Agreed.

> "=m" means that the new value of the memory location is *set*.
> 
> Which means that gcc will potentially optimize away any previous stores to 
> that memory location.
> 
> And yes, it happens, and yes, we've seen it.

I had a lot of "fun" with this when mucking around with the asm-optimised R/W
semaphores.

David
