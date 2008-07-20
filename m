Return-Path: <linux-kernel-owner+w=401wt.eu-S1756941AbYGTJX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756941AbYGTJX7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 05:23:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754230AbYGTJXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 05:23:51 -0400
Received: from cable-85.28.84.48.coditel.net ([85.28.84.48]:41367 "EHLO
	ibiza.bxl.tuxicoman.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753979AbYGTJXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 05:23:49 -0400
Date: Sun, 20 Jul 2008 11:23:45 +0200
From: Guy Martin <gmsoft@tuxicoman.be>
To: Kyle McMartin <kyle@mcmartin.ca>
Cc: linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 64bit kernel not booting with CONFIG_PRINTK_TIME=y
Message-ID: <20080720112345.07869299@bleh.bxl.tuxicoman.be>
In-Reply-To: <20080719230418.GA4263@phobos.i.cabal.ca>
References: <20080717190502.74c238d5@bleh.bxl.tuxicoman.be>
	<20080719215459.GA2550@phobos.i.cabal.ca>
	<20080719230418.GA4263@phobos.i.cabal.ca>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Kyle,


Thanks, this does work like a charm. This is the output now :

Branching to kernel entry point 0x00100000.  If this is the last
message you see, you may need to switch your console.  This is
a common symptom -- search the FAQ and mailing list at parisc-linux.org

[    0.000000] FP[0] enabled: Rev 1 Model 16
[    0.000000] The 64-bit Kernel has started...
[    0.000000] console [ttyB0] enabled
[    0.000000] Initialized PDC Console for debugging.
[    0.000000] Determining PDC firmware type: 64 bit PAT.
[    0.000000] model 00005d90 00000491 00000000 00000002 09972987 100000f0 00000008 000000b2 000000b2
[    0.000000] vers  00000301
[    0.000000] CPUID vers 18 rev 11 (0x0000024b)
[    0.000000] capabilities 0x1
[    0.000000] model 9000/800/L2000-5X
[    0.000000] Memory Ranges:
[    0.000000]  0) Start 0x0000000000000000 End 0x00000000efffffff Size   3840 MB
[    0.000000]  1) Start 0x00000010f0000000 End 0x00000010ffffffff Size    256 MB
[    0.000000] Total Memory: 4096 MB
[    0.000000] Linux version 2.6.26 (root@spiderman) (gcc version 4.2.4 (Gentoo 4.2.4 p1.0)) #5 SMP Sun Jul 20 11:12:00 CEST 2008
[    0.000000] SMP: bootstrap CPU ID is 0
[17179569.184000] Built 2 zonelists in Zone order, mobility grouping on.  Total pages: 1034240
[17179569.184000] Kernel command line: root=/dev/md1 console=ttyS0 palo_kernel=2/vmlinux.test
[17179569.184000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[17179569.184000] Console: colour dummy device 160x64
[17179569.196000] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[17179569.216000] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[17179569.676000] Memory: 4115968k/4194304k available (3467k kernel code, 77952k reserved, 1364k data, 244k init)
[17179569.776000] Mount-cache hash table entries: 256
[17179569.776000] Brought up 1 CPUs



Cheers,
  Guy



On Sat, 19 Jul 2008 19:04:18 -0400
Kyle McMartin <kyle@mcmartin.ca> wrote:

> On Sat, Jul 19, 2008 at 05:54:59PM -0400, Kyle McMartin wrote:
> > I'm *guessing* that umoddi3 or udivdi3 is doing an xmpyu or
> > something, which since this is probably before fpu init, is
> > trapping, which is trying to printk, which is recursively exploding.
> > 
> 
> If my guess is right, this quick fix might work. Can you please test
> it, as my a500 decided to have its scsi controller die in the middle
> of this...
> 
> (Proper fix is probably to bring fpu bringup into head.S, since it
> will be necessary for any printk with CONFIG_PRINTK_TIME on. (Or
> bring back my use embedded libgcc patch, which was buggy on
> 32-bit. :\ ))
> 
> diff --git a/init/main.c b/init/main.c
> index edeace0..729b150 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -560,9 +560,9 @@ asmlinkage void __init start_kernel(void)
>  	tick_init();
>  	boot_cpu_init();
>  	page_address_init();
> +	setup_arch(&command_line);
>  	printk(KERN_NOTICE);
>  	printk(linux_banner);
> -	setup_arch(&command_line);
>  	mm_init_owner(&init_mm, &init_task);
>  	setup_command_line(command_line);
>  	unwind_setup();


-- 
Guy Martin
Gentoo Linux - HPPA port lead
