Return-Path: <linux-kernel-owner+w=401wt.eu-S1754271AbXD1WAQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271AbXD1WAQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 18:00:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754272AbXD1WAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 18:00:15 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57432 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754271AbXD1WAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 18:00:13 -0400
Date: Sat, 28 Apr 2007 14:59:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: William Heimbigner <icxcnika@mar.tar.cc>
Cc: linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@sw.ru>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: PANIC: 2.6.21-rc7-mm2, Kernel access of bad area, sig: 11
Message-Id: <20070428145926.a550a1c1.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0704282135580.25153@server.thyself>
References: <Pine.LNX.4.64.0704282135580.25153@server.thyself>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Apr 2007 21:40:19 +0000 (GMT) William Heimbigner <icxcnika@mar.tar.cc> wrote:

> This bug occurs in linux-2.6.21-rc7-mm2, and does not occur in 2.6.21-rc7
> ARCH is powerpc
> 
> dmesg output, captured via netconsole:
> [    0.000000] Using PowerMac machine description
> [    0.000000] Total memory = 128MB; using 256kB for hash table (at c7fc0000)
> [    0.000000] Linux version 2.6.21-rc7-mm2 (root@console) (gcc version 4.1.1 (Gentoo 4.1.1-r3)) #3 SMP PREEMPT Sat Apr 28 14:29:54 CDT 2007
> [    0.000000] Found UniNorth memory controller & host bridge @ 0xf8000000 revision: 0xc0
> [    0.000000] Mapped at 0xfdfc0000
> [    0.000000] Found a Pangea mac-io controller, rev: 0, mapped at 0xfdf40000
> [    0.000000] PowerMac motherboard: iMac "Flower Power"

It ran OK on my G5.  Can you send the config please?

> ...
> [   27.030444] input: PMU as /class/input/input4
> [   27.052675] ReiserFS: hda4: found reiserfs format "3.6" with standard journal
> [   27.058960] ReiserFS: hda4: using ordered data mode
> [   27.078108] ReiserFS: hda4: journal params: device hda4, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
> [   27.099024] ReiserFS: hda4: checking transaction log (hda4)
> [   27.195147] ReiserFS: hda4: Using r5 hash to sort names
> [   27.201477] VFS: Mounted root (reiserfs filesystem) readonly.
> [   27.207715] Freeing unused kernel memory: 248k init
> [  156.166766] Oops: Kernel access of bad area, sig: 11 [#1]
> [  156.167014] PREEMPT SMP NR_CPUS=2 DEBUG_PAGEALLOC PowerMac
> [  156.167267] Modules linked in: nfsd exportfs pmac_zilog serial_core ohci1394 ieee1394 uninorth_agp
> [  156.167711] NIP: c0068ce4 LR: c0068cdc CTR: 00000000
> [  156.167892] REGS: c0583a40 TRAP: 0300   Not tainted  (2.6.21-rc7-mm2)
> [  156.168118] MSR: 00001032 <ME,IR,DR>  CR: 42202022  XER: 00000000
> [  156.168467] DAR: 00000000, DSISR: 42000000
> [  156.168617] TASK = c0550260[0] 'swapper' THREAD: c0582000 CPU: 0
> [  156.168840] GPR00: 00000000 c0583af0 c0550260 00000783 c059bc88 00000001 c0488ec0 c059bc80 
> [  156.169272] GPR08: c0460713 c0488e77 00000000 c0488b70 00003da3 00000000 0023f96c c0590000 
> [  156.169705] GPR16: c0590000 0023f964 c0590000 00000000 00001032 00000000 c0583eb0 c0590000 
> [  156.170145] GPR24: c0583b18 00000000 00000000 00000000 c0583b28 c000a1e4 c0583b2c c059bc80 
> [  156.170594] NIP [c0068ce4] kallsyms_lookup+0x64/0xa4
> [  156.170806] LR [c0068cdc] kallsyms_lookup+0x5c/0xa4
> [  156.170997] Call Trace:
> [  156.171093] [c0583af0] [c0068cb4] kallsyms_lookup+0x34/0xa4 (unreliable)
> [  156.171384] --- Exception: c0583bb0 at 0xc0583ba0
> [  156.171578]     LR = draw_byte+0x34/0x1d0
> [  156.171723] [c0583b10] [c002ebd0] xmon_show_stack+0x2b8/0x330 (unreliable)
> [  156.172017] [c0583c10] [c003053c] cmds+0xa20/0x1600
> [  156.172235] [c0583ca0] [c0031448] xmon_core+0x32c/0x734
> [  156.172452] [c0583d60] [c00319fc] xmon+0x2c/0x68
> [  156.172647] [c0583e20] [c0031b40] xmon_irq+0x50/0x6c
> [  156.172856] [c0583e40] [c0073828] handle_IRQ_event+0x5c/0xb0
> [  156.173090] [c0583e60] [c00755dc] handle_fasteoi_irq+0xac/0x174
> [  156.173333] [c0583e80] [c0006be4] do_IRQ+0xec/0x130
> [  156.179644] [c0583ea0] [c0014fe8] ret_from_except+0x0/0x14
> [  156.185827] --- Exception: 501 at cpu_idle<hand copied begins here>+0xfc/0x1dc
>                     LR = cpu_idle+0xfc/0x1dc
>                 [c0583f60] [c000a24c] cpu_idle+0x164/0x1dc (unreliable)
>                 [c0583f80] [c0003cc4] rest_init+0x74/0x88
>                 [c0583fa0] [c050fb68] start_kernel+0x310/0x394
>                 [c0583ff0] [000037b4] 0x37b4
> 
> This occurs after pressing the programmer switch to generate an NMI.

Can you expand on this?  Do you mean that hitting the NMI switch is what
caused this crash?


Does a G5 have a programmer switch?  If so, how does this programmer
switch it?

If you compiled with CONFIG_DEBUG_INFO could you please do

gdb vmlinux
(gdb) l *0xc0068ce4



Patches which touch kallsyms.c in -mm are:

extend-print_symbol-capability
simplify-module_get_kallsym-by-dropping-length-arg
simplify-kallsyms_lookup
fix-race-between-rmmod-and-cat-proc-kallsyms
fix-race-between-cat-proc-wchan-and-rmmod-et-al
fix-race-between-cat-proc-slab_allocators-and-rmmod
kallsyms-cleanup-use-seq_release_private-where-appropriate



