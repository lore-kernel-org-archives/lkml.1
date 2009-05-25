Return-Path: <linux-kernel-owner+w=401wt.eu-S1755455AbZEYFzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455AbZEYFzk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 01:55:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752474AbZEYFzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 01:55:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:39856 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752193AbZEYFzc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 01:55:32 -0400
Message-ID: <4A1A32AB.4090905@kernel.org>
Date: Sun, 24 May 2009 22:54:51 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Pekka J Enberg <penberg@cs.helsinki.fi>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Jeff Garzik <jgarzik@pobox.com>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [GIT PULL] scheduler fixes
References: <alpine.LFD.2.01.0905180955550.3301@localhost.localdomain> <20090518170909.GA1623@elte.hu> <20090518190320.GA20260@elte.hu> <alpine.LFD.2.01.0905181208130.3301@localhost.localdomain> <20090518202031.GA26549@elte.hu> <alpine.LFD.2.01.0905181457320.3301@localhost.localdomain> <Pine.LNX.4.64.0905241911120.12189@melkki.cs.Helsinki.FI> <4A199327.5030503@kernel.org> <20090525025353.GA2580@elte.hu> <4A1A2261.1000504@kernel.org> <20090525051521.GC23032@elte.hu>
In-Reply-To: <20090525051521.GC23032@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> Ok, i think this all looks pretty realistic - but there's quite a 
> bit of layering on top of pending changes in the x86 and irq trees. 
> We could do this on top of those topic branches in -tip, and rebase 
> in the merge window. Or delay it to .32.

would have move setup_per_cpu_areas after mem_init().
some kind of limiting bootmem related in setup_arch()

> 
> ... plus i think we are _very_ close to being able to remove all of 
> bootmem on x86 (with some compatibility/migration mechanism in 
> place). Which bootmem calls do we have before kmalloc init with 
> Pekka's patch applied? I think it's mostly the page table init code.

need to decide what should be in setup_arch_mem, or setup_arch_rest().
before initmem_init() ==>  setup_arch_mem
after initmem_init()
	reserve_bootmem related should stay in setup_arch_mem
try to move other call in setup_arch to _reset after ane setup_arch_rest will
be called after mem_init()

>  
> ( beyond the page allocator internal use - where we could use 
>   straight e820 based APIs that clip memory off from the beginning 
>   of existing e820 RAM ranges - enriched with NUMA/SRAT locality 
>   info. )

yes. it is there. need to dynamic early_res array.

YH
