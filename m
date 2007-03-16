Return-Path: <linux-kernel-owner+w=401wt.eu-S1753464AbXCPKaL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464AbXCPKaL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 06:30:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753461AbXCPKaL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 06:30:11 -0400
Received: from pfx2.jmh.fr ([194.153.89.55]:52294 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753464AbXCPKaJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 06:30:09 -0400
From: Eric Dumazet <dada1@cosmosbay.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 0/3] FUTEX : new PRIVATE futexes, SMP and NUMA improvements
Date: Fri, 16 Mar 2007 11:30:06 +0100
User-Agent: KMail/1.9.5
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Ulrich Drepper <drepper@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>, Ravikiran G Thirumalai <kiran@scalex86.org>,
       "Shai Fultheim (Shai@scalex86.org)" <shai@scalex86.org>,
       pravin b shelar <pravin.shelar@calsoftinc.com>,
       linux-kernel@vger.kernel.org
References: <20060808070708.GA3931@localhost.localdomain> <200703161030.17597.dada1@cosmosbay.com> <1174039813.7124.25.camel@twins>
In-Reply-To: <1174039813.7124.25.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703161130.06669.dada1@cosmosbay.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 March 2007 11:10, Peter Zijlstra wrote:

> http://programming.kicks-ass.net/kernel-patches/futex-vma-cache/vma_cache.p
>atch

Oh thanks

>
> > But if it has to walk the vmas (and take mmap_sem), you already loose the
> > PRIVATE benefit.
>
> It doesn't take mmap_sem, I am aware of the problems.

Yes but the vma_anon() -> vma_cache_find() needs to read 3 cache lines on 
x86_64 (sizeof(struct vma_cache) = 136)
and dirty one bit, so it might be more expensive than the mmap_sem ...

