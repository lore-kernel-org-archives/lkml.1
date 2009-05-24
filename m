Return-Path: <linux-kernel-owner+w=401wt.eu-S1754702AbZEXTVQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702AbZEXTVQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 15:21:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751179AbZEXTU7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 15:20:59 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:44148 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133AbZEXTU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 15:20:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=oLH/HeHAKgDHWYWHcjzZgTPpidlNaQQiJ9ilI9KsoOpjPtJyxl86vyf8lmiq3DCWmV
         01AisPWEzItLq4YYW5YwnAReQTuAQglGCRWOku8OIXrrUTEaXykVID2wwyLgdMW9GL4W
         SsPQjyaYc/rKWbPRe7gBBG2ayX/zGLHA7b33Y=
Message-ID: <4A199E18.70803@gmail.com>
Date: Sun, 24 May 2009 13:20:56 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Mikael Pettersson <mikpe@it.uu.se>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       arjan@linux.intel.com
Subject: Re: [2.6.30-rc7 regression] kernel/async.c broke pata_legacy.c
References: <18969.29245.610133.834819@pilspetsen.it.uu.se>
In-Reply-To: <18969.29245.610133.834819@pilspetsen.it.uu.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikael Pettersson wrote:
> I tried booting 2.6.30-rc7 on my old '486, but it fails miserably
> during libata/pata_legacy's device scan:
> 
> Linux version 2.6.30-rc7 (mikpe@brewer) (gcc version 4.3.4 20090517 (prerelease) (GCC) ) #1 Sun May 24 16:05:18 CEST 2009
> KERNEL supported cpus:
>   Intel GenuineIntel
> BIOS-provided physical RAM map:
>  BIOS-88: 0000000000000000 - 000000000009f000 (usable)
>  BIOS-88: 0000000000100000 - 0000000001c00000 (usable)
> last_pfn = 0x1c00 max_arch_pfn = 0x100000
> init_memory_mapping: 0000000000000000-0000000001c00000
> RAMDISK: 01abb000 - 01bef86b
> 28MB LOWMEM available.
>   mapped low ram: 0 - 01c00000
>   low ram: 0 - 01c00000
>   node 0 low ram: 00000000 - 01c00000
>   node 0 bootmap 00001000 - 00001380
> (7 early reservations) ==> bootmem [0000000000 - 0001c00000]
>   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
>   #1 [0000100000 - 000031d1ec]    TEXT DATA BSS ==> [0000100000 - 000031d1ec]
>   #2 [0001abb000 - 0001bef86b]          RAMDISK ==> [0001abb000 - 0001bef86b]
>   #3 [000009f000 - 0000100000]    BIOS reserved ==> [000009f000 - 0000100000]
>   #4 [000031e000 - 0000320000]              BRK ==> [000031e000 - 0000320000]
>   #5 [0000007000 - 000000c000]          PGTABLE ==> [0000007000 - 000000c000]
>   #6 [0000001000 - 0000002000]          BOOTMAP ==> [0000001000 - 0000002000]
> Zone PFN ranges:
>   DMA      0x00000000 -> 0x00001000
>   Normal   0x00001000 -> 0x00001c00
> Movable zone start PFN for each node
> early_node_map[2] active PFN ranges
>     0: 0x00000000 -> 0x0000009f
>     0: 0x00000100 -> 0x00001c00
> Allocating PCI resources starting at 10000000 (gap: 1c00000:fe400000)
> Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 7015
> Kernel command line: ro root=LABEL=/ console=ttyS1,115200
> Initializing CPU#0
> NR_IRQS:16
> PID hash table entries: 128 (order: 7, 512 bytes)
> Console: colour VGA+ 80x25
> console [ttyS1] enabled
> Dentry cache hash table entries: 4096 (order: 2, 16384 bytes)
> Inode-cache hash table entries: 2048 (order: 1, 8192 bytes)
> Memory: 24592k/28672k available (1467k kernel code, 3688k reserved, 465k data, 132k init, 0k highmem)
> virtual kernel memory layout:
>     fixmap  : 0xfffeb000 - 0xfffff000   (  80 kB)
>     vmalloc : 0xc2400000 - 0xfffe9000   ( 987 MB)
>     lowmem  : 0xc0000000 - 0xc1c00000   (  28 MB)
>       .init : 0xc02e6000 - 0xc0307000   ( 132 kB)
>       .data : 0xc026eef0 - 0xc02e34f8   ( 465 kB)
>       .text : 0xc0100000 - 0xc026eef0   (1467 kB)
> Checking if this processor honours the WP bit even in supervisor mode...Ok.
> Calibrating delay loop... 49.66 BogoMIPS (lpj=248320)
> Mount-cache hash table entries: 512
> 
> CPU: Intel 486 DX/4 stepping 00
> Checking 'hlt' instruction... OK.
> net_namespace: 296 bytes
> NET: Registered protocol family 16
> bio: create slab <bio-0> at 0
> SCSI subsystem initialized
> NET: Registered protocol family 2
> IP route cache hash table entries: 1024 (order: 0, 4096 bytes)
> TCP established hash table entries: 1024 (order: 1, 8192 bytes)
> TCP bind hash table entries: 1024 (order: 0, 4096 bytes)
> TCP: Hash tables configured (established 1024 bind 1024)
> TCP reno registered
> NET: Registered protocol family 1
> Unpacking initramfs...
> Freeing initrd memory: 1234k freed
> platform rtc_cmos: registered platform RTC device (no PNP device found)
> msgmni has been set to 50
> io scheduler noop registered
> io scheduler anticipatory registered (default)
> io scheduler deadline registered
> io scheduler cfq registered
> Real Time Clock Driver v1.12b
> Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
> serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
> Driver 'sd' needs updating - please use bus_type methods
> scsi0 : pata_legacy
> ata1: PATA max PIO4 cmd 0x1f0 ctl 0x3f6 irq 14
> ------------[ cut here ]------------
> WARNING: at drivers/ata/libata-core.c:6222 ata_host_detach+0x75/0x90()
> Modules linked in:
> Pid: 1, comm: swapper Not tainted 2.6.30-rc7 #1
> Call Trace:
>  [<c01fbb05>] ? ata_host_detach+0x75/0x90
>  [<c01fbb05>] ? ata_host_detach+0x75/0x90
>  [<c01139b5>] ? warn_slowpath_common+0x45/0x80
>  [<c01139fa>] ? warn_slowpath_null+0xa/0x10
>  [<c01fbb05>] ? ata_host_detach+0x75/0x90
>  [<c02f40e0>] ? legacy_init+0x44e/0x87f
>  [<c02f3c92>] ? legacy_init+0x0/0x87f
>  [<c0101021>] ? _stext+0x21/0x140
>  [<c01890ff>] ? proc_register+0x2f/0x190
>  [<c018938c>] ? create_proc_entry+0x5c/0xc0
>  [<c0135ebe>] ? register_irq_proc+0x6e/0x90
>  [<c02e6484>] ? kernel_init+0x6e/0xbf
>  [<c02e6416>] ? kernel_init+0x0/0xbf
>  [<c01031d7>] ? kernel_thread_helper+0x7/0x10
> ---[ end trace ef1ee36e873ae3a0 ]---
> scsi1 : pata_legacy
> ata2: PATA max PIO4 cmd 0x170 ctl 0x376 irq 15
> ------------[ cut here ]------------
> WARNING: at drivers/ata/libata-core.c:6222 ata_host_detach+0x75/0x90()
> Modules linked in:
> Pid: 1, comm: swapper Tainted: G        W  2.6.30-rc7 #1
> Call Trace:
>  [<c01fbb05>] ? ata_host_detach+0x75/0x90
>  [<c01fbb05>] ? ata_host_detach+0x75/0x90
>  [<c01139b5>] ? warn_slowpath_common+0x45/0x80
>  [<c01139fa>] ? warn_slowpath_null+0xa/0x10
>  [<c01fbb05>] ? ata_host_detach+0x75/0x90
>  [<c02f40e0>] ? legacy_init+0x44e/0x87f
>  [<c02f3c92>] ? legacy_init+0x0/0x87f
>  [<c0101021>] ? _stext+0x21/0x140
>  [<c01890ff>] ? proc_register+0x2f/0x190
>  [<c018938c>] ? create_proc_entry+0x5c/0xc0
>  [<c0135ebe>] ? register_irq_proc+0x6e/0x90
>  [<c02e6484>] ? kernel_init+0x6e/0xbf
>  [<c02e6416>] ? kernel_init+0x0/0xbf
>  [<c01031d7>] ? kernel_thread_helper+0x7/0x10
> ---[ end trace ef1ee36e873ae3a1 ]---
> scsi2 : pata_legacy
> ata3: PATA max PIO4 cmd 0x1e8 ctl 0x3ee irq 11
> ------------[ cut here ]------------
> WARNING: at drivers/ata/libata-core.c:6222 ata_host_detach+0x75/0x90()
> Modules linked in:
> Pid: 1, comm: swapper Tainted: G        W  2.6.30-rc7 #1
> Call Trace:
>  [<c01fbb05>] ? ata_host_detach+0x75/0x90
>  [<c01fbb05>] ? ata_host_detach+0x75/0x90
>  [<c01139b5>] ? warn_slowpath_common+0x45/0x80
>  [<c01139fa>] ? warn_slowpath_null+0xa/0x10
>  [<c01fbb05>] ? ata_host_detach+0x75/0x90
>  [<c02f40e0>] ? legacy_init+0x44e/0x87f
>  [<c02f3c92>] ? legacy_init+0x0/0x87f
>  [<c0101021>] ? _stext+0x21/0x140
>  [<c01890ff>] ? proc_register+0x2f/0x190
>  [<c018938c>] ? create_proc_entry+0x5c/0xc0
>  [<c0135ebe>] ? register_irq_proc+0x6e/0x90
>  [<c02e6484>] ? kernel_init+0x6e/0xbf
>  [<c02e6416>] ? kernel_init+0x0/0xbf
>  [<c01031d7>] ? kernel_thread_helper+0x7/0x10
> ---[ end trace ef1ee36e873ae3a2 ]---
> scsi3 : pata_legacy
> ata4: PATA max PIO4 cmd 0x168 ctl 0x36e irq 10
> ------------[ cut here ]------------
> WARNING: at drivers/ata/libata-core.c:6222 ata_host_detach+0x75/0x90()
> Modules linked in:
> Pid: 1, comm: swapper Tainted: G        W  2.6.30-rc7 #1
> Call Trace:
>  [<c01fbb05>] ? ata_host_detach+0x75/0x90
>  [<c01fbb05>] ? ata_host_detach+0x75/0x90
>  [<c01139b5>] ? warn_slowpath_common+0x45/0x80
>  [<c01139fa>] ? warn_slowpath_null+0xa/0x10
>  [<c01fbb05>] ? ata_host_detach+0x75/0x90
>  [<c02f40e0>] ? legacy_init+0x44e/0x87f
>  [<c02f3c92>] ? legacy_init+0x0/0x87f
>  [<c0101021>] ? _stext+0x21/0x140
>  [<c01890ff>] ? proc_register+0x2f/0x190
>  [<c018938c>] ? create_proc_entry+0x5c/0xc0
>  [<c0135ebe>] ? register_irq_proc+0x6e/0x90
>  [<c02e6484>] ? kernel_init+0x6e/0xbf
>  [<c02e6416>] ? kernel_init+0x0/0xbf
>  [<c01031d7>] ? kernel_thread_helper+0x7/0x10
> ---[ end trace ef1ee36e873ae3a3 ]---
> scsi4 : pata_legacy
> ata5: PATA max PIO4 cmd 0x160 ctl 0x366 irq 12
> ------------[ cut here ]------------
> WARNING: at drivers/ata/libata-core.c:6222 ata_host_detach+0x75/0x90()
> Modules linked in:
> Pid: 1, comm: swapper Tainted: G        W  2.6.30-rc7 #1
> Call Trace:
>  [<c01fbb05>] ? ata_host_detach+0x75/0x90
>  [<c01fbb05>] ? ata_host_detach+0x75/0x90
>  [<c01139b5>] ? warn_slowpath_common+0x45/0x80
>  [<c01139fa>] ? warn_slowpath_null+0xa/0x10
>  [<c01fbb05>] ? ata_host_detach+0x75/0x90
>  [<c02f40e0>] ? legacy_init+0x44e/0x87f
>  [<c02f3c92>] ? legacy_init+0x0/0x87f
>  [<c0101021>] ? _stext+0x21/0x140
>  [<c01890ff>] ? proc_register+0x2f/0x190
>  [<c018938c>] ? create_proc_entry+0x5c/0xc0
>  [<c0135ebe>] ? register_irq_proc+0x6e/0x90
>  [<c02e6484>] ? kernel_init+0x6e/0xbf
>  [<c02e6416>] ? kernel_init+0x0/0xbf
>  [<c01031d7>] ? kernel_thread_helper+0x7/0x10
> ---[ end trace ef1ee36e873ae3a4 ]---
> serio: i8042 KBD port at 0x60,0x64 irq 1
> serio: i8042 AUX port at 0x60,0x64 irq 12
> mice: PS/2 mouse device common for all mice
> input: PC Speaker as /class/input/input0
> TCP cubic registered
> input: AT Translated Set 2 keyboard as /class/input/input1
> 
> At this point the kernel hangs until I flip the power switch.
> This is 100% reproducible.
> 
> 2.6.29 worked Ok. A bug hunt showed that 2.6.29-git3 was the last kernel
> to boot Ok on this machine, and every single one since 2.6.29-git4 hang.
> 
> 2.6.29-git4 was when Arjan removed the "async is off by default" code,
> in commit 9710794383ee5008d67f1a6613a4717bf6de47bc. Reverting that
> from 2.6.30-rc7 gives me a working kernel again.
> 
> I haven't had any async problems on my other machines, so presumably
> the bug is in pata_legacy, or due to the machine being so insanely slow.

Well, it looks like pata_legacy is doing some different things than 
other drivers, in that it needs to attach to potential host addresses to 
tell if there is a controller/device there and if it turns out not to 
be, needs to detach the host entry it just created. This detach is 
what's triggering the problem. It looks like somehow error handling 
completes without setting the UNLOADED flag.

I suspect the bug is not actually in pata_legacy though.

> 
> (I just saw James Bottomley's "[PATCH] async: make sure independent async
> domains can't accidentally entangle". Unfortunately that patch makes no
> difference to this machine's async-related boot failure.)
> 
> /Mikael
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ide" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

