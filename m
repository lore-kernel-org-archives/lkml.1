Return-Path: <linux-kernel-owner+w=401wt.eu-S935258AbXGXLno@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935258AbXGXLno (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 07:43:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759117AbXGXLng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 07:43:36 -0400
Received: from mail4.iitk.ac.in ([203.197.196.4]:59381 "EHLO mail4.iitk.ac.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763769AbXGXLnf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 07:43:35 -0400
X-Virus-Scanner: This message was checked by NOD32 Antivirus system
	for Linux Server. For more information on NOD32 Antivirus System,
	please, visit our website: http://www.nod32.com/.
Date: Tue, 24 Jul 2007 17:15:00 +0530 (IST)
From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 8/8] i386: bitops: smp_mb__{before, after}_clear_bit()
 definitions
In-Reply-To: <46A5E366.8030605@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0707241708350.1433@cselinux1.cse.iitk.ac.in>
References: <423904.37199.qm@web53810.mail.re2.yahoo.com>
 <Pine.LNX.4.64.0707241631220.1433@cselinux1.cse.iitk.ac.in>
 <46A5E366.8030605@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jul 2007, Nick Piggin wrote:

> > > For the purpose of this discussion (Linux memory
> > > barrier semantics, on WB memory), it is true of CPU
> > > and compiler barriers.
> > 
> > On later Intel processors, if the memory address range being referenced
> > (and say written to) by the (locked) instruction is in the cache of a
> > CPU, then it will not assert the LOCK signal on the system bus --
> > thus not assume exclusive use of shared memory. So other CPUs are free
> > to modify (other) memory at that point. Cache coherency will still
> > ensure _that_ (locked) memory area is still updated atomically, though.
> 
> The system bus does not need to be serialised because the CPU already
> holds the cacheline in exclusive state. That *is* the cache coherency
> protocol.
> 
> The memory ordering is enforced by the CPU effectively preventing
> speculative loads to pass the locked instruction and ensuring all
> stores reach the cache before it is executed. (I say effectively
> because the CPU might do clever tricks without you knowing).

Looks like when you said "CPU memory barrier extends to all memory
references" you were probably referring to a _given_ CPU ... yes,
that statement is correct in that case.

> > > Are you saying that it is OK for the store to var to
> > > be reordered below the clear_bit? If not, what are you
> > > saying?
> > 
> > 
> > I might be making a radical turn-around here, but all of a
> > sudden I think it's actually a good idea to put a complete
> > memory clobber in set_bit/clear_bit and friends themselves,
> > and leave the "__" variants as they are.
> 
> Why?

Well, why not. Callers who don't want/need any guarantees whatsoever
can still use __foo() -- for others, it makes sense to just use
foo() and get *both* the compiler and CPU barrier semantics -- I think
that's the behaviour most callers would want anyway.


Satyam
