Return-Path: <linux-kernel-owner+w=401wt.eu-S1754132AbXDMSzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132AbXDMSzs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 14:55:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754133AbXDMSzs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 14:55:48 -0400
Received: from waste.org ([66.93.16.53]:48938 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754132AbXDMSzr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 14:55:47 -0400
Date: Fri, 13 Apr 2007 13:42:34 -0500
From: Matt Mackall <mpm@selenic.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Tim Yamin <plasmaroo@gentoo.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>
Subject: Re: [PATCH UPDATE] deflate stack usage in lib/inflate.c
Message-ID: <20070413184234.GB11166@waste.org>
References: <461DED14.1070603@goop.org> <461E9BAD.8050202@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <461E9BAD.8050202@goop.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2007 at 01:50:54PM -0700, Jeremy Fitzhardinge wrote:
> Subject: deflate stack usage in lib/inflate.c
> 
> inflate_fixed and huft_build together use around 2.7k of stack.  When
> using 4k stacks, I saw stack overflows from interrupts arriving while
> unpacking the root initrd:
> 
> do_IRQ: stack overflow: 384
>  [<c0106b64>] show_trace_log_lvl+0x1a/0x30
>  [<c01075e6>] show_trace+0x12/0x14
>  [<c010763f>] dump_stack+0x16/0x18
>  [<c0107ca4>] do_IRQ+0x6d/0xd9
>  [<c010202b>] xen_evtchn_do_upcall+0x6e/0xa2
>  [<c0106781>] xen_hypervisor_callback+0x25/0x2c
>  [<c010116c>] xen_restore_fl+0x27/0x29
>  [<c0330f63>] _spin_unlock_irqrestore+0x4a/0x50
>  [<c0117aab>] change_page_attr+0x577/0x584
>  [<c0117b45>] kernel_map_pages+0x8d/0xb4
>  [<c016a314>] cache_alloc_refill+0x53f/0x632
>  [<c016a6c2>] __kmalloc+0xc1/0x10d
>  [<c0463d34>] malloc+0x10/0x12
>  [<c04641c1>] huft_build+0x2a7/0x5fa
>  [<c04645a5>] inflate_fixed+0x91/0x136
>  [<c04657e2>] unpack_to_rootfs+0x5f2/0x8c1
>  [<c0465acf>] populate_rootfs+0x1e/0xe4
> 
> (This was under Xen, but there's no reason it couldn't happen on bare
>   hardware.)
> 
> This patch mallocs the local variables, thereby reducing the stack
> usage to sane levels.
> 
> Also, up the heap size for the kernel decompressor to deal with the
> extra allocation.

Lost the non-x86 bits again.

-- 
Mathematics is the supreme nostalgia of our time.
