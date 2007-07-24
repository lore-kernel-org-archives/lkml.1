Return-Path: <linux-kernel-owner+w=401wt.eu-S1761555AbXGXRme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761555AbXGXRme (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 13:42:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754872AbXGXRm1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 13:42:27 -0400
Received: from pat.uio.no ([129.240.10.15]:41060 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753432AbXGXRm0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 13:42:26 -0400
Subject: Re: [PATCH 6/8] i386: bitops: Don't mark memory as clobbered
	unnecessarily
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Satyam Sharma <ssatyam@cse.iitk.ac.in>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0707241021210.3607@woody.linux-foundation.org>
References: <20070723160528.22137.84144.sendpatchset@cselinux1.cse.iitk.ac.in>
	 <20070723160558.22137.71943.sendpatchset@cselinux1.cse.iitk.ac.in>
	 <alpine.LFD.0.999.0707231054290.3607@woody.linux-foundation.org>
	 <1185270756.5439.256.camel@localhost.localdomain>
	 <alpine.LFD.0.999.0707241021210.3607@woody.linux-foundation.org>
Content-Type: text/plain
Date: Tue, 24 Jul 2007 13:42:12 -0400
Message-Id: <1185298932.6586.22.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.098)
X-UiO-Scanned: 146321A392BE9F514C21476A37B158D873EA4CDF
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 417 total 2954694 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-24 at 10:24 -0700, Linus Torvalds wrote:
> 
> On Tue, 24 Jul 2007, Benjamin Herrenschmidt wrote:
> > 
> > In fact, it's more than that... the bitops that return a value are often
> > used to have hand-made spinlock semantics. I'm sure we would get funky
> > bugs if loads or stores leaked out of the locked region. I think a full
> > "memory" clobber should be kept around for those cases.
> 
> Not helpful.
> 
> The CPU ordering constraints for "test_and_set_bit()" and friends are weak 
> enough that even if you have a full memory clobber, it still wouldn't work 
> as a lock.
> 
> That's exactly why we have smp_mb__after_set_bit() and friends. On some 
> architectures (arm, mips, parsic, powerpc), *that* is where the CPU memory 
> barrier is, because the "test_and_set_bit()" itself is just a 
> cache-coherent operation, not an actual barrier.

That's not what the Documentation/memory-barriers.txt states:

        Any atomic operation that modifies some state in memory and returns information
        about the state (old or new) implies an SMP-conditional general memory barrier
        (smp_mb()) on each side of the actual operation.  These include:
        
        .....
        
        test_and_set_bit();
        test_and_clear_bit();
        test_and_change_bit();
...

Trond

