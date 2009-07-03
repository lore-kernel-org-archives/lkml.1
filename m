Return-Path: <linux-kernel-owner+w=401wt.eu-S1758602AbZGCT2D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758602AbZGCT2D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 15:28:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756929AbZGCT1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 15:27:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37850 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756475AbZGCT1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 15:27:53 -0400
Message-ID: <4A4E4493.3040009@zytor.com>
Date: Fri, 03 Jul 2009 10:49:07 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: mingo@redhat.com, paulus@samba.org, acme@redhat.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       eric.dumazet@gmail.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       arnd@arndb.de, fweisbec@gmail.com, dhowells@redhat.com,
       Andrew Morton <akpm@linux-foundation.org>, tglx@linutronix.de,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [tip:perfcounters/urgent] x86: atomic64: The atomic64_t data
 type should be 8 bytes aligned on 32-bit too
References: <alpine.LFD.2.01.0907021653030.3210@localhost.localdomain> <tip-bbf2a330d92c5afccfd17592ba9ccd50f41cf748@git.kernel.org> <alpine.LFD.2.01.0907030947300.3210@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0907030947300.3210@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> It's not necessarily even about "two cachelines". It's true that crossing 
> cachelines is extra painful, but from a CPU core angle, there's another 
> access width that matters almost as much, namely the width of the bus 
> between the core and the L1 cache. If it's not aligned to that, the core 
> needs to do each 8-byte read/write as two accesses, even if it's to the 
> same cacheline, and that complicates things.
> 
> The cacheline itself is generally larger than the cache access width. I 
> could easily see a 64B cacheline, but a 256b (32B) bus between the cache 
> and the core.
> 
> Making the atomics be naturally aligned means that you never cross either 
> one, of course.
> 

Sometimes, of course, that down-mux is where alignment happens, too.
Either which way, I don't think there is any doubt that unaligned
atomics are just asking for trouble.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

