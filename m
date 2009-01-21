Return-Path: <linux-kernel-owner+w=401wt.eu-S1764379AbZAUMGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764379AbZAUMGV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 07:06:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754315AbZAUMGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 07:06:12 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:59394 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753363AbZAUMGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 07:06:10 -0500
Message-ID: <49770EB3.5040404@cs.helsinki.fi>
Date: Wed, 21 Jan 2009 14:01:55 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.19 (Macintosh/20081209)
MIME-Version: 1.0
To: "=?UTF-8?B?5YiY55Sf5bmz?=" <liushengping@tsinghua.org.cn>
CC: eduard.munteanu@linux360.ro, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Kmemtrace(slab and slub, except slob) doesn't work on PPC64 board,
References: <18682661.270411232413952442.JavaMail.coremail@mailserver2>
In-Reply-To: <18682661.270411232413952442.JavaMail.coremail@mailserver2>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(I am cc'ing linux-kernel)

刘生平 wrote:
> Hi Guys,
> I have done several experiments on Apple Xserver G5(using kernel config files: linux-2.6-torvalds/arch/powerpc/configs/g5_defconfig)
> and on moto_acta6101, found kmemtrace can cause kernel panic during system startup when enabling slab or slub except slob, I think it only happened on PPC64 platform, the kernel panic message as follows:
> Console: colour dummy device 80x25�console handover: boot [udbg0] -> real [ttyPZ0]
> Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
> Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
> Memory: 1007104k/1048576k available (5152k kernel code, 40816k reserved, 712k data, 208k bss, 236k init)
> Unable to handle kernel paging request for data at address 0x6000000000000000
> Faulting instruction address: 0xc0000000000cb5d0
> Oops: Kernel access of bad area, sig: 11 [#1]
> PREEMPT LTT NESTING LEVEL : 0 
> PowerMac
> Modules linked in:
> NIP: c0000000000cb5d0 LR: c0000000000cb5c4 CTR: 0000000000000000
> REGS: c0000000005bf800 TRAP: 0300   Not tainted  (2.6.27.11-WR3.0zz_standard)
> MSR: 9000000000009032 <EE,ME,IR,DR>  CR: 84000084  XER: 00000000
> DAR: 6000000000000000, DSISR: 0000000008000000
> TASK = c00000000052dd50[0] 'swapper' THREAD: c0000000005bc000
> GPR00: c0000000000cb5c4 c0000000005bfa80 c0000000005bf8e0 6000000000000000 
> GPR04: 00000000000004d0 d000000000000000 c000000001540068 0000000000000000 
> GPR08: 0000000000000000 0000000000000000 0000000000000000 0000000800000000 
> GPR12: 0000000084000084 c0000000005cd300 c00000000052da20 0000000000000391 
> GPR16: d000000000005000 d000000000004fff 000000000023f3b8 c00000000045fbe8 
> GPR20: c0000000005c9000 d000000000005000 c00000003d006e00 c00000000050dfe0 
> GPR24: c0000000005bfd40 0000000000000391 c0000000000ade04 00000000000004d0 
> GPR28: 0000000000000000 0000000000000001 c000000000562828 0000000000000005 
> NIP [c0000000000cb5d0] .kmem_cache_alloc+0x50/0x180
> LR [c0000000000cb5c4] .kmem_cache_alloc+0x44/0x180
> Call Trace:
> [c0000000005bfa80] [c0000000000cb5c4] .kmem_cache_alloc+0x44/0x180 (unreliable)
> [c0000000005bfb30] [c0000000000ade04] .__pud_alloc+0x34/0xe0
> [c0000000005bfbc0] [c0000000000bc550] .map_vm_area+0x320/0x350
> [c0000000005bfcd0] [c0000000000bccf0] .__vmalloc_area_node+0x100/0x1d0
> [c0000000005bfd90] [c000000000092958] .relay_open+0x3a8/0x580
> [c0000000005bfe70] [c0000000000d114c] .kmemtrace_init+0x4c/0xe0
> [c0000000005bfef0] [c0000000004cd8a4] .start_kernel+0x2cc/0x410
> [c0000000005bff90] [c0000000000073a4] .start_here_common+0x3c/0x98
> Instruction dump:
> f8010010 ebc29180 f821ff51 7c7c1b78 7c9b2378 38000000 8bad01ca 980d01ca 
> 481418e1 60000000 78631f24 7c7c182a <81230000> 2f890000 419e0108 3929ffff 
> ---[ end trace 31fd0ba7d8756001 ]---
> Kernel panic - not syncing: Attempted to kill the idle task!
> Rebooting in 180 seconds..
> Apple RackMac3,1 5.1.7f1 BootROM built on 08/25/04 at 15:11:09
> Copyright 1994-2004 Apple Computer, Inc.
> All Rights Reserved.
> 
> Welcome to Open Firmware, the system time and date is: 06:44:18 07/27/1970
> 
> To continue booting, type "mac-boot" and press return.
> To shut down, type "shut-down" and press return.
> 
> 
> what's your suggestion?

Hmm, I can't really work out what exactly is going wrong there. I 
suspect that the fact that ppc64 uses kmem_cache_alloc() for 
__pud_alloc() -> pud_alloc_one() whereas x86 uses the page allocator is 
the culprit here.

Eduard, thoughts?

		Pekka
