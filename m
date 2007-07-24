Return-Path: <linux-kernel-owner+w=401wt.eu-S1762486AbXGXRYj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762486AbXGXRYj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 13:24:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754724AbXGXRYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 13:24:32 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49966 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753579AbXGXRYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 13:24:31 -0400
Date: Tue, 24 Jul 2007 10:24:10 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Satyam Sharma <ssatyam@cse.iitk.ac.in>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 6/8] i386: bitops: Don't mark memory as clobbered
 unnecessarily
In-Reply-To: <1185270756.5439.256.camel@localhost.localdomain>
Message-ID: <alpine.LFD.0.999.0707241021210.3607@woody.linux-foundation.org>
References: <20070723160528.22137.84144.sendpatchset@cselinux1.cse.iitk.ac.in>
  <20070723160558.22137.71943.sendpatchset@cselinux1.cse.iitk.ac.in> 
 <alpine.LFD.0.999.0707231054290.3607@woody.linux-foundation.org>
 <1185270756.5439.256.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 24 Jul 2007, Benjamin Herrenschmidt wrote:
> 
> In fact, it's more than that... the bitops that return a value are often
> used to have hand-made spinlock semantics. I'm sure we would get funky
> bugs if loads or stores leaked out of the locked region. I think a full
> "memory" clobber should be kept around for those cases.

Not helpful.

The CPU ordering constraints for "test_and_set_bit()" and friends are weak 
enough that even if you have a full memory clobber, it still wouldn't work 
as a lock.

That's exactly why we have smp_mb__after_set_bit() and friends. On some 
architectures (arm, mips, parsic, powerpc), *that* is where the CPU memory 
barrier is, because the "test_and_set_bit()" itself is just a 
cache-coherent operation, not an actual barrier.

		Linus
