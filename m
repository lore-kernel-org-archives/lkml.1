Return-Path: <linux-kernel-owner+w=401wt.eu-S1761835AbXGXXPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761835AbXGXXPW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 19:15:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758513AbXGXXOu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 19:14:50 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:61515 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758905AbXGXXOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 19:14:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Is1OcY2+MFGbzkHFRDizUN1QpTKpXLNxXNyrRPOybYoscVlPAizbtQyWv2KaEFAQlCAegr8SB9badb024BdegmPI7MQi5mQJx4aGjOGnjGnLFmoZ7KmiwgISnrGF/JW+TCAoeXop+2qSy4zQKOOMPDu/KYDi5TKgISOf159rN+I=
Message-ID: <6bffcb0e0707241614s7b563b5bu114d2ecb227b1557@mail.gmail.com>
Date: Wed, 25 Jul 2007 01:14:41 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Eric Sesterhenn / Snakebyte" <snakebyte@gmx.de>
Subject: Re: Time Problems with 2.6.23-rc1-gf695baf2
Cc: linux-kernel@vger.kernel.org,
       "IDE/ATA development list" <linux-ide@vger.kernel.org>,
       "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>
In-Reply-To: <20070723221630.GA28951@alice>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070723221630.GA28951@alice>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 24/07/07, Eric Sesterhenn / Snakebyte <snakebyte@gmx.de> wrote:
> hi,
>
> seems like the clock got screwed or something similar. During bootup the
> computer hangs (no response on keyboard leds when pressing caps lock),
> the only way to make sure it resumes booting is by repeatedly pressing
> the power switch,

:)

> see second 13 to 510, after pressing it about ten
> times, it continues booting.

Probing IDE interface...

[   13.867939] VP_IDE: VIA vt82c686a (rev 22) IDE UDMA66 controller on
pci0000:00:04.1
[   13.868062]     ide0: BM-DMA at 0xd800-0xd807, BIOS settings:
hda:DMA, hdb:pio
[   13.868268]     ide1: BM-DMA at 0xd808-0xd80f, BIOS settings:
hdc:DMA, hdd:DMA
[   13.868574] Probing IDE interface ide0...
[  387.279576] Clocksource tsc unstable (delta = 370195339890 ns)
[  496.200082] hda: ST340823A, ATA DISK drive
[  510.264511] hda: selected mode 0x44
[  510.264826] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14

Could you please try to revert these commits

commit 4099d14322149c7a467e4997b87be4ba8eb78697
commit 6a824c92db4d606c324272c4eed366fb71672440
commit a5d8c5c834d3cabf4b7b477c3f6ee923c25026fc

Bart, any suggestions?

> See for dmesg, lspci, cpuinfo, gcc version and .config below.
>
> Greetings, Eric
>
>
> [    0.000000] Linux version 2.6.23-rc1-gf695baf2 (root@snakebyte-desktop) (gcc version 4.1.2 (Ubuntu 4.1.2-0ubuntu4)) #1 PREEMPT Mon Jul 23 23:04:38 CEST 2007
> [    0.000000] BIOS-provided physical RAM map:
> [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
> [    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
> [    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
> [    0.000000]  BIOS-e820: 0000000000100000 - 000000000fffc000 (usable)
> [    0.000000]  BIOS-e820: 000000000fffc000 - 000000000ffff000 (ACPI data)
> [    0.000000]  BIOS-e820: 000000000ffff000 - 0000000010000000 (ACPI NVS)
> [    0.000000]  BIOS-e820: 00000000ffff0000 - 0000000100000000 (reserved)
> [    0.000000] 0MB HIGHMEM available.
> [    0.000000] 255MB LOWMEM available.
> [    0.000000] Entering add_active_range(0, 0, 65532) 0 entries of 256 used
> [    0.000000] Zone PFN ranges:
> [    0.000000]   DMA             0 ->     4096
> [    0.000000]   Normal       4096 ->    65532
> [    0.000000]   HighMem     65532 ->    65532
> [    0.000000] Movable zone start PFN for each node
> [    0.000000] early_node_map[1] active PFN ranges
> [    0.000000]     0:        0 ->    65532
> [    0.000000] On node 0 totalpages: 65532
> [    0.000000]   DMA zone: 32 pages used for memmap
> [    0.000000]   DMA zone: 0 pages reserved
> [    0.000000]   DMA zone: 4064 pages, LIFO batch:0
> [    0.000000]   Normal zone: 479 pages used for memmap
> [    0.000000]   Normal zone: 60957 pages, LIFO batch:15
> [    0.000000]   HighMem zone: 0 pages used for memmap
> [    0.000000]   Movable zone: 0 pages used for memmap
> [    0.000000] DMI 2.3 present.
> [    0.000000] ACPI: RSDP 000F5EB0, 0014 (r0 ASUS  )
> [    0.000000] ACPI: RSDT 0FFFC000, 002C (r1 ASUS   MED_2001 30303031 MSFT 31313031)
> [    0.000000] ACPI: FACP 0FFFC080, 0074 (r1 ASUS   MED_2001 30303031 MSFT 31313031)
> [    0.000000] ACPI: DSDT 0FFFC100, 2253 (r1   ASUS MED_2001     1000 MSFT  100000B)
> [    0.000000] ACPI: FACS 0FFFF000, 0040
> [    0.000000] ACPI: BOOT 0FFFC040, 0028 (r1 ASUS   MED_2001 30303031 MSFT 31313031)
> [    0.000000] ACPI: PM-Timer IO Port: 0xe408
> [    0.000000] Allocating PCI resources starting at 20000000 (gap: 10000000:efff0000)
> [    0.000000] Built 1 zonelists in Zone order.  Total pages: 65021
> [    0.000000] Kernel command line: root=/dev/hda1 ro
> [    0.000000] Enabling fast FPU save and restore... done.
> [    0.000000] Enabling unmasked SIMD FPU exception support... done.
> [    0.000000] Initializing CPU#0
> [    0.000000] CPU 0 irqstacks, hard=c0782000 soft=c0781000
> [    0.000000] PID hash table entries: 1024 (order: 10, 4096 bytes)
> [    0.000000] Detected 902.090 MHz processor.
> [   12.914452] Console: colour VGA+ 80x25
> [   12.914484] console [tty0] enabled
> [   12.916923] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
> [   12.917031] ... MAX_LOCKDEP_SUBCLASSES:    8
> [   12.917105] ... MAX_LOCK_DEPTH:          30
> [   12.917178] ... MAX_LOCKDEP_KEYS:        2048
> [   12.917251] ... CLASSHASH_SIZE:           1024
> [   12.917326] ... MAX_LOCKDEP_ENTRIES:     8192
> [   12.917400] ... MAX_LOCKDEP_CHAINS:      16384
> [   12.917473] ... CHAINHASH_SIZE:          8192
> [   12.917547]  memory used by lock dependency info: 992 kB
> [   12.917621]  per task-struct memory footprint: 1200 bytes
> [   12.917697] ------------------------
> [   12.917769] | Locking API testsuite:
> [   12.917842] ----------------------------------------------------------------------------
> [   12.917948]                                  | spin |wlock |rlock |mutex | wsem | rsem |
> [   12.918055]   --------------------------------------------------------------------------
> [   12.918179]                      A-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [   12.920725]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [   12.923085]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [   12.925279]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [   12.927656]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [   12.929899]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [   12.932143]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [   12.934576]                     double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [   12.936693]                   initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [   12.938802]                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [   12.941137]   --------------------------------------------------------------------------
> [   12.941244]               recursive read-lock:             |  ok  |             |  ok  |
> [   12.942123]            recursive read-lock #2:             |  ok  |             |  ok  |
> [   12.943000]             mixed read-write-lock:             |  ok  |             |  ok  |
> [   12.943877]             mixed write-read-lock:             |  ok  |             |  ok  |
> [   12.944757]   --------------------------------------------------------------------------
> [   12.944865]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
> [   12.946157]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
> [   12.947265]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
> [   12.948367]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
> [   12.949468]        sirq-safe-A => hirqs-on/12:  ok  |  ok  |  ok  |
> [   12.950570]        sirq-safe-A => hirqs-on/21:  ok  |  ok  |  ok  |
> [   12.951857]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
> [   12.952959]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
> [   12.954062]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
> [   12.955161]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
> [   12.956266]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
> [   12.957579]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
> [   12.958702]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
> [   12.959823]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
> [   12.960945]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
> [   12.962066]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
> [   12.963189]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
> [   12.964493]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
> [   12.965614]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
> [   12.966720]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
> [   12.967830]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
> [   12.968946]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
> [   12.970249]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
> [   12.971370]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
> [   12.972494]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
> [   12.973614]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
> [   12.974740]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
> [   12.976048]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
> [   12.977173]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
> [   12.978290]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
> [   12.979412]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
> [   12.980530]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
> [   12.981839]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
> [   12.982955]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
> [   12.984077]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
> [   12.985199]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
> [   12.986327]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
> [   12.987633]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
> [   12.988760]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
> [   12.989881]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
> [   12.991007]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
> [   12.992125]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
> [   12.993248]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
> [   12.994554]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
> [   12.995681]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
> [   12.996800]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
> [   12.997923]       hard-irq read-recursion/123:  ok  |
> [   12.998372]       soft-irq read-recursion/123:  ok  |
> [   12.998822]       hard-irq read-recursion/132:  ok  |
> [   12.999455]       soft-irq read-recursion/132:  ok  |
> [   12.999906]       hard-irq read-recursion/213:  ok  |
> [   13.000354]       soft-irq read-recursion/213:  ok  |
> [   13.000805]       hard-irq read-recursion/231:  ok  |
> [   13.001253]       soft-irq read-recursion/231:  ok  |
> [   13.001705]       hard-irq read-recursion/312:  ok  |
> [   13.002154]       soft-irq read-recursion/312:  ok  |
> [   13.002603]       hard-irq read-recursion/321:  ok  |
> [   13.003053]       soft-irq read-recursion/321:  ok  |
> [   13.003504] -------------------------------------------------------
> [   13.003582] Good, all 218 testcases passed! |
> [   13.003657] ---------------------------------
> [   13.004015] Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
> [   13.004459] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
> [   13.034104] Memory: 249852k/262128k available (4784k kernel code, 11732k reserved, 1604k data, 252k init, 0k highmem)
> [   13.034240] virtual kernel memory layout:
> [   13.034243]     fixmap  : 0xfffdb000 - 0xfffff000   ( 144 kB)
> [   13.034247]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
> [   13.034251]     vmalloc : 0xd0800000 - 0xff7fe000   ( 751 MB)
> [   13.034254]     lowmem  : 0xc0000000 - 0xcfffc000   ( 255 MB)
> [   13.034258]       .init : 0xc073f000 - 0xc077e000   ( 252 kB)
> [   13.034262]       .data : 0xc05ac33e - 0xc073d3c0   (1604 kB)
> [   13.034265]       .text : 0xc0100000 - 0xc05ac33e   (4784 kB)
> [   13.034841] Checking if this processor honours the WP bit even in supervisor mode... Ok.
> [   13.035136] SLUB: Genslabs=22, HWalign=32, Order=0-1, MinObjects=4, CPUs=1, Nodes=1
> [   13.095465] Calibrating delay using timer specific routine.. 1806.73 BogoMIPS (lpj=903367)
> [   13.095804] Mount-cache hash table entries: 512
> [   13.096921] CPU: After generic identify, caps: 0383f9ff 00000000 00000000 00000000 00000000 00000000 00000000 00000000
> [   13.096953] CPU: L1 I cache: 16K, L1 D cache: 16K
> [   13.097071] CPU: L2 cache: 256K
> [   13.097148] CPU: After all inits, caps: 0383f9ff 00000000 00000000 00000040 00000000 00000000 00000000 00000000
> [   13.097167] Intel machine check architecture supported.
> [   13.097245] Intel machine check reporting enabled on CPU#0.
> [   13.097330] Compat vDSO mapped to ffffe000.
> [   13.097436] CPU: Intel Pentium III (Coppermine) stepping 06
> [   13.097656] Checking 'hlt' instruction... OK.
> [   13.102156] ACPI: Core revision 20070126
> [   13.120747] ACPI: setting ELCR to 0200 (from 0c20)
> [   13.123945] NET: Registered protocol family 16
> [   13.126706] ACPI: bus type pci registered
> [   13.129343] PCI: PCI BIOS revision 2.10 entry at 0xf0900, last bus=1
> [   13.129433] PCI: Using configuration type 1
> [   13.129630] Setting up standard PCI resources
> [   13.189087] ACPI: Interpreter enabled
> [   13.189186] ACPI: (supports S0 S1 S4 S5)
> [   13.189811] ACPI: Using PIC for interrupt routing
> [   13.246624] ACPI: PCI Root Bridge [PCI0] (0000:00)
> [   13.248175] PCI quirk: region e400-e4ff claimed by vt82c586 ACPI
> [   13.248270] PCI quirk: region e800-e80f claimed by vt82c686 SMB
> [   13.249584] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
> [   13.252334] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
> [   13.268557] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
> [   13.270014] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
> [   13.271371] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
> [   13.272651] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
> [   13.275126] Linux Plug and Play Support v0.97 (c) Adam Belay
> [   13.275916] pnp: PnP ACPI init
> [   13.276075] ACPI: bus type pnp registered
> [   13.307022] pnp: PnP ACPI: found 13 devices
> [   13.307115] ACPI: ACPI bus type pnp unregistered
> [   13.309799] SCSI subsystem initialized
> [   13.311628] usbcore: registered new interface driver usbfs
> [   13.312164] usbcore: registered new interface driver hub
> [   13.312829] usbcore: registered new device driver usb
> [   13.314421] PCI: Using ACPI for IRQ routing
> [   13.314506] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
> [   13.321722] ACPI: RTC can wake from S4
> [   13.322387] Time: tsc clocksource has been installed.
> [   13.324939] pnp: 00:00: iomem range 0x0-0x9ffff could not be reserved
> [   13.325032] pnp: 00:00: iomem range 0xf0000-0xfffff could not be reserved
> [   13.325122] pnp: 00:00: iomem range 0x100000-0xfffffff could not be reserved
> [   13.325213] pnp: 00:00: iomem range 0xfffe0000-0xffffffff could not be reserved
> [   13.325429] pnp: 00:03: ioport range 0xe400-0xe47f has been reserved
> [   13.325514] pnp: 00:03: ioport range 0xe800-0xe80f has been reserved
> [   13.360600] PCI: Bridge: 0000:00:01.0
> [   13.360684]   IO window: disabled.
> [   13.360767]   MEM window: ee000000-efefffff
> [   13.360848]   PREFETCH window: eff00000-fbffffff
> [   13.360965] PCI: Setting latency timer of device 0000:00:01.0 to 64
> [   13.361048] NET: Registered protocol family 2
> [   13.370572] IP route cache hash table entries: 2048 (order: 1, 8192 bytes)
> [   13.371345] TCP established hash table entries: 8192 (order: 6, 262144 bytes)
> [   13.373832] TCP bind hash table entries: 8192 (order: 6, 262144 bytes)
> [   13.376416] TCP: Hash tables configured (established 8192 bind 8192)
> [   13.376592] TCP reno registered
> [   13.384141] Simple Boot Flag at 0x3a set to 0x1
> [   13.385031] Machine check exception polling timer started.
> [   13.387707] IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
> [   13.395022] Initializing RT-Tester: OK
> [   13.395769] Total HugeTLB memory allocated, 0
> [   13.454285] DLM (built Jul 23 2007 22:32:52) installed
> [   13.467487] NTFS driver 2.1.28 [Flags: R/W].
> [   13.474471] JFS: nTxBlock = 1953, nTxLock = 15625
> [   13.480206] SGI XFS with ACLs, security attributes, realtime, large block numbers, no debug enabled
> [   13.492844] SGI XFS Quota Management subsystem
> [   13.496580] GFS2 (built Jul 23 2007 22:35:24) installed
> [   13.496702] Lock_Nolock (built Jul 23 2007 22:36:07) installed
> [   13.497998] Lock_DLM (built Jul 23 2007 22:36:01) installed
> [   13.499520] io scheduler noop registered
> [   13.501003] io scheduler cfq registered (default)
> [   13.501136] PCI: VIA PCI bridge detected. Disabling DAC.
> [   13.501270] Boot video device is 0000:01:00.0
> [   13.503717] input: Power Button (FF) as /class/input/input0
> [   13.503852] ACPI: Power Button (FF) [PWRF]
> [   13.504737] input: Power Button (CM) as /class/input/input1
> [   13.504826] ACPI: Power Button (CM) [PWRB]
> [   13.506890] ACPI Exception (processor_throttling-0084): AE_NOT_FOUND, Evaluating _PTC [20070126]
> [   13.507101] ACPI Exception (processor_throttling-0147): AE_NOT_FOUND, Evaluating _TSS [20070126]
> [   13.507490] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
> [   13.507728] ACPI: Processor [CPU0] (supports 16 throttling states)
> [   13.813357] Real Time Clock Driver v1.12ac
> [   13.813506] Linux agpgart interface v0.102
> [   13.815078] agpgart: Detected VIA Apollo Pro 133 chipset
> [   13.818566] agpgart: AGP aperture is 32M @ 0xfc000000
> [   13.818735] Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 60 seconds).
> [   13.818846] Hangcheck: Using get_cycles().
> [   13.818926] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
> [   13.824437] 00:0a: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> [   13.826338] 00:0b: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
> [   13.827955] Floppy drive(s): fd0 is 1.44M
> [   13.838208] Marking TSC unstable due to: possible TSC halt in C2.
> [   13.838302] Time: acpi_pm clocksource has been installed.
> [   13.838423] Switched to high resolution mode on CPU 0
> [   13.842458] FDC 0 is a post-1991 82077
> [   13.853010] RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
> [   13.857470] loop: module loaded
> [   13.859445] 8139cp: 10/100 PCI Ethernet driver v1.3 (Mar 22, 2004)
> [   13.859538] 8139cp 0000:00:09.0: This (id 10ec:8139 rev 10) is not an 8139C+ compatible chip
> [   13.859648] 8139cp 0000:00:09.0: Try the "8139too" driver instead.
> [   13.860300] 8139too Fast Ethernet driver 0.9.28
> [   13.863209] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 5
> [   13.863294] PCI: setting IRQ 5 as level-triggered
> [   13.863303] ACPI: PCI Interrupt 0000:00:09.0[A] -> Link [LNKD] -> GSI 5 (level, low) -> IRQ 5
> [   13.864877] eth0: RealTek RTL8139 at 0xb400, 00:e0:7d:b5:7e:1b, IRQ 5
> [   13.864963] eth0:  Identified 8139 chip type 'RTL-8139C'
> [   13.865100] ipddp.c:v0.01 8/28/97 Bradford W. Johnson <johns393@maroon.tc.umn.edu>
> [   13.866118] ipddp0: Appletalk-IP Encap. mode by Bradford W. Johnson <johns393@maroon.tc.umn.edu>
> [   13.866844] netconsole: not configured, aborting
> [   13.866925] Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
> [   13.867007] ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
> [   13.867618] VP_IDE: IDE controller at PCI slot 0000:00:04.1
> [   13.867757] VP_IDE: chipset revision 16
> [   13.867833] VP_IDE: not 100% native mode: will probe irqs later
> [   13.867939] VP_IDE: VIA vt82c686a (rev 22) IDE UDMA66 controller on pci0000:00:04.1
> [   13.868062]     ide0: BM-DMA at 0xd800-0xd807, BIOS settings: hda:DMA, hdb:pio
> [   13.868268]     ide1: BM-DMA at 0xd808-0xd80f, BIOS settings: hdc:DMA, hdd:DMA
> [   13.868574] Probing IDE interface ide0...
> [  387.279576] Clocksource tsc unstable (delta = 370195339890 ns)
> [  496.200082] hda: ST340823A, ATA DISK drive
> [  510.264511] hda: selected mode 0x44
> [  510.264826] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
> [  510.265720] Probing IDE interface ide1...
> [  511.510073] hdc: LITE-ON LTR-24102B, ATAPI CD/DVD-ROM drive
> [  514.021371] hdd: SAMSUNG DVD-ROM SD-616T, ATAPI CD/DVD-ROM drive
> [  514.072457] hdc: selected mode 0x42
> [  514.072636] hdd: selected mode 0x42
> [  514.072934] ide1 at 0x170-0x177,0x376 on irq 15
> [  514.075446] hda: max request size: 128KiB
> [  514.075538] hda: 78165360 sectors (40020 MB) w/1024KiB Cache, CHS=65535/16/63, UDMA(66)
> [  514.075803] hda: cache flushes not supported
> [  514.076373]  hda: hda1 hda2 < hda5 >
> [  514.143826] hdc: ATAPI 40X CD-ROM CD-R/RW drive, 2048kB Cache, UDMA(33)
> [  514.144221] Uniform CD-ROM driver Revision: 3.20
> [  514.146611] hdd: ATAPI 48X DVD-ROM drive, 512kB Cache, UDMA(33)
> [  514.154101] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
> [  514.154597] USB Universal Host Controller Interface driver v3.0
> [  514.159777] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 10
> [  514.159870] PCI: setting IRQ 10 as level-triggered
> [  514.159879] ACPI: PCI Interrupt 0000:00:04.2[D] -> Link [LNKC] -> GSI 10 (level, low) -> IRQ 10
> [  514.160097] uhci_hcd 0000:00:04.2: UHCI Host Controller
> [  514.161927] uhci_hcd 0000:00:04.2: new USB bus registered, assigned bus number 1
> [  514.162121] uhci_hcd 0000:00:04.2: irq 10, io base 0x0000d400
> [  514.164702] usb usb1: configuration #1 chosen from 1 choice
> [  514.165397] hub 1-0:1.0: USB hub found
> [  514.165553] hub 1-0:1.0: 2 ports detected
> [  514.267427] ACPI: PCI Interrupt 0000:00:04.3[D] -> Link [LNKC] -> GSI 10 (level, low) -> IRQ 10
> [  514.267651] uhci_hcd 0000:00:04.3: UHCI Host Controller
> [  514.268915] uhci_hcd 0000:00:04.3: new USB bus registered, assigned bus number 2
> [  514.269113] uhci_hcd 0000:00:04.3: irq 10, io base 0x0000d000
> [  514.270913] usb usb2: configuration #1 chosen from 1 choice
> [  514.271675] hub 2-0:1.0: USB hub found
> [  514.271800] hub 2-0:1.0: 2 ports detected
> [  514.784191] usb 2-2: new low speed USB device using uhci_hcd and address 2
> [  514.929521] usb 2-2: configuration #1 chosen from 1 choice
> [  514.933534] usbcore: registered new interface driver usblp
> [  514.933629] Initializing USB Mass Storage driver...
> [  514.934268] usbcore: registered new interface driver usb-storage
> [  514.934359] USB Mass Storage support registered.
> [  514.935394] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
> [  514.935480] PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
> [  514.936393] serio: i8042 KBD port at 0x60,0x64 irq 1
> [  514.938176] mice: PS/2 mouse device common for all mice
> [  514.963347] input: AT Translated Set 2 keyboard as /class/input/input2
> [  514.965351] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
> [  514.966442] rtc_cmos: probe of 00:05 failed with error -16
> [  514.968494] device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
> [  514.983718] input: HID 062a:0000 as /class/input/input3
> [  514.984787] input: USB HID v1.10 Mouse [HID 062a:0000] on usb-0000:00:04.3-2
> [  514.985036] usbcore: registered new interface driver usbhid
> [  514.985201] drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
> [  514.986033] Netfilter messages via NETLINK v0.30.
> [  514.986404] nf_conntrack version 0.5.0 (4096 buckets, 16384 max)
> [  514.987974] ctnetlink v0.93: registering with nfnetlink.
> [  514.993780] IPv4 over IPv4 tunneling driver
> [  514.995060] GRE over IPv4 tunneling driver
> [  514.996542] ip_tables: (C) 2000-2006 Netfilter Core Team
> [  514.996859] TCP bic registered
> [  514.996936] TCP cubic registered
> [  514.997011] TCP westwood registered
> [  514.997087] TCP htcp registered
> [  514.998007] NET: Registered protocol family 1
> [  515.001899] NET: Registered protocol family 10
> [  515.004514] lo: Disabled Privacy Extensions
> [  515.005026] tunl0: Disabled Privacy Extensions
> [  515.006454] Mobile IPv6
> [  515.006576] ip6_tables: (C) 2000-2006 Netfilter Core Team
> [  515.006812] IPv6 over IPv4 tunneling driver
> [  515.007977] sit0: Disabled Privacy Extensions
> [  515.009326] NET: Registered protocol family 17
> [  515.010267] NET: Registered protocol family 4
> [  515.013225] NET: Registered protocol family 5
> [  515.032880] CCID: Registered CCID 3 (ccid3)
> [  515.035023] CCID: Registered CCID 2 (ccid2)
> [  515.038457] SCTP: Hash tables configured (established 2048 bind 2048)
> [  515.046066] TIPC: Activated (version 1.6.2 compiled Jul 23 2007 23:02:40)
> [  515.054444] NET: Registered protocol family 30
> [  515.054537] TIPC: Started in single node mode
> [  515.054615] Using IPI Shortcut mode
> [  515.055660] drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
> [  515.109118] kjournald starting.  Commit interval 5 seconds
> [  515.109488] EXT3-fs: mounted filesystem with ordered data mode.
> [  515.109711] VFS: Mounted root (ext3 filesystem) readonly.
> [  515.110584] Freeing unused kernel memory: 252k freed
> [  515.111103] Write protecting the kernel text: 4788k
> [  515.111469] Write protecting the kernel read-only data: 1326k
> [  526.109882] eth0: link up, 100Mbps, full-duplex, lpa 0x41E1
> [  533.639626] Adding 746980k swap on /dev/disk/by-uuid/98a494e2-5a11-496d-a6cf-d0970698151a.  Priority:-1 extents:1 across:746980k
> [  533.925876] EXT3 FS on hda1, internal journal
> [  536.470700] eth0: no IPv6 routers present
> [  676.487595] Hangcheck: hangcheck value past margin!
>
>
> 00:00.0 Host bridge: VIA Technologies, Inc. VT82C693A/694x [Apollo PRO133x] (rev c4)
> 00:01.0 PCI bridge: VIA Technologies, Inc. VT82C598/694x [Apollo MVP3/Pro133x AGP]
> 00:04.0 ISA bridge: VIA Technologies, Inc. VT82C686 [Apollo Super South] (rev 22)
> 00:04.1 IDE interface: VIA Technologies, Inc. VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE (rev 10)
> 00:04.2 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev 10)
> 00:04.3 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev 10)
> 00:04.4 Host bridge: VIA Technologies, Inc. VT82C686 [Apollo Super ACPI] (rev 30)
> 00:05.0 Multimedia audio controller: Ensoniq ES1371 [AudioPCI-97] (rev 07)
> 00:09.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8139/8139C/8139C+ (rev 10)
> 01:00.0 VGA compatible controller: nVidia Corporation NV11 [GeForce2 MX/MX 400] (rev a1)
>
>
> processor       : 0
> vendor_id       : GenuineIntel
> cpu family      : 6
> model           : 8
> model name      : Pentium III (Coppermine)
> stepping        : 6
> cpu MHz         : 902.090
> cache size      : 256 KB
> fdiv_bug        : no
> hlt_bug         : no
> f00f_bug        : no
> coma_bug        : no
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 2
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 sep mtrr pge mca cmov pat pse36 mmx fxsr sse
> bogomips        : 1806.73
> clflush size    : 32
>
>
> Using built-in specs.
> Target: i486-linux-gnu
> Configured with: ../src/configure -v --enable-languages=c,c++,fortran,objc,obj-c++,treelang --prefix=/usr --enable-shared --with-system-zlib --libexecdir=/usr/lib --without-included-gettext --enable-threads=posix --enable-nls --program-suffix=-4.1 --enable-__cxa_atexit --enable-clocale=gnu --enable-libstdcxx-debug --enable-mpfr --enable-checking=release i486-linux-gnu
> Thread model: posix
> gcc version 4.1.2 (Ubuntu 4.1.2-0ubuntu4)
>
>
> #
> # Automatically generated make config: don't edit
> # Linux kernel version: 2.6.23-rc1
> # Mon Jul 23 22:25:47 2007
> #
> CONFIG_X86_32=y
> CONFIG_GENERIC_TIME=y
> CONFIG_GENERIC_CMOS_UPDATE=y
> CONFIG_CLOCKSOURCE_WATCHDOG=y
> CONFIG_GENERIC_CLOCKEVENTS=y
> CONFIG_LOCKDEP_SUPPORT=y
> CONFIG_STACKTRACE_SUPPORT=y
> CONFIG_SEMAPHORE_SLEEPERS=y
> CONFIG_X86=y
> CONFIG_MMU=y
> CONFIG_ZONE_DMA=y
> CONFIG_QUICKLIST=y
> CONFIG_GENERIC_ISA_DMA=y
> CONFIG_GENERIC_IOMAP=y
> CONFIG_GENERIC_BUG=y
> CONFIG_GENERIC_HWEIGHT=y
> CONFIG_ARCH_MAY_HAVE_PC_FDC=y
> CONFIG_DMI=y
> CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
>
> #
> # Code maturity level options
> #
> CONFIG_EXPERIMENTAL=y
> CONFIG_BROKEN_ON_SMP=y
> CONFIG_LOCK_KERNEL=y
> CONFIG_INIT_ENV_ARG_LIMIT=32
>
> #
> # General setup
> #
> CONFIG_LOCALVERSION=""
> CONFIG_LOCALVERSION_AUTO=y
> CONFIG_SWAP=y
> CONFIG_SYSVIPC=y
> CONFIG_SYSVIPC_SYSCTL=y
> CONFIG_POSIX_MQUEUE=y
> # CONFIG_BSD_PROCESS_ACCT is not set
> # CONFIG_TASKSTATS is not set
> # CONFIG_USER_NS is not set
> # CONFIG_AUDIT is not set
> CONFIG_IKCONFIG=y
> CONFIG_IKCONFIG_PROC=y
> CONFIG_LOG_BUF_SHIFT=18
> CONFIG_SYSFS_DEPRECATED=y
> # CONFIG_RELAY is not set
> CONFIG_BLK_DEV_INITRD=y
> CONFIG_INITRAMFS_SOURCE=""
> # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
> CONFIG_SYSCTL=y
> # CONFIG_EMBEDDED is not set
> CONFIG_UID16=y
> CONFIG_SYSCTL_SYSCALL=y
> CONFIG_KALLSYMS=y
> CONFIG_KALLSYMS_ALL=y
> # CONFIG_KALLSYMS_EXTRA_PASS is not set
> CONFIG_HOTPLUG=y
> CONFIG_PRINTK=y
> CONFIG_BUG=y
> CONFIG_ELF_CORE=y
> CONFIG_BASE_FULL=y
> CONFIG_FUTEX=y
> CONFIG_ANON_INODES=y
> CONFIG_EPOLL=y
> CONFIG_SIGNALFD=y
> CONFIG_TIMERFD=y
> CONFIG_EVENTFD=y
> CONFIG_SHMEM=y
> CONFIG_VM_EVENT_COUNTERS=y
> CONFIG_SLUB_DEBUG=y
> # CONFIG_SLAB is not set
> CONFIG_SLUB=y
> # CONFIG_SLOB is not set
> CONFIG_RT_MUTEXES=y
> # CONFIG_TINY_SHMEM is not set
> CONFIG_BASE_SMALL=0
> CONFIG_MODULES=y
> CONFIG_MODULE_UNLOAD=y
> CONFIG_MODULE_FORCE_UNLOAD=y
> # CONFIG_MODVERSIONS is not set
> # CONFIG_MODULE_SRCVERSION_ALL is not set
> # CONFIG_KMOD is not set
> CONFIG_BLOCK=y
> CONFIG_LBD=y
> # CONFIG_BLK_DEV_IO_TRACE is not set
> # CONFIG_LSF is not set
> # CONFIG_BLK_DEV_BSG is not set
>
> #
> # IO Schedulers
> #
> CONFIG_IOSCHED_NOOP=y
> # CONFIG_IOSCHED_AS is not set
> # CONFIG_IOSCHED_DEADLINE is not set
> CONFIG_IOSCHED_CFQ=y
> # CONFIG_DEFAULT_AS is not set
> # CONFIG_DEFAULT_DEADLINE is not set
> CONFIG_DEFAULT_CFQ=y
> # CONFIG_DEFAULT_NOOP is not set
> CONFIG_DEFAULT_IOSCHED="cfq"
>
> #
> # Processor type and features
> #
> CONFIG_TICK_ONESHOT=y
> CONFIG_NO_HZ=y
> CONFIG_HIGH_RES_TIMERS=y
> # CONFIG_SMP is not set
> CONFIG_X86_PC=y
> # CONFIG_X86_ELAN is not set
> # CONFIG_X86_VOYAGER is not set
> # CONFIG_X86_NUMAQ is not set
> # CONFIG_X86_SUMMIT is not set
> # CONFIG_X86_BIGSMP is not set
> # CONFIG_X86_VISWS is not set
> # CONFIG_X86_GENERICARCH is not set
> # CONFIG_X86_ES7000 is not set
> # CONFIG_PARAVIRT is not set
> # CONFIG_M386 is not set
> # CONFIG_M486 is not set
> # CONFIG_M586 is not set
> # CONFIG_M586TSC is not set
> # CONFIG_M586MMX is not set
> # CONFIG_M686 is not set
> # CONFIG_MPENTIUMII is not set
> CONFIG_MPENTIUMIII=y
> # CONFIG_MPENTIUMM is not set
> # CONFIG_MCORE2 is not set
> # CONFIG_MPENTIUM4 is not set
> # CONFIG_MK6 is not set
> # CONFIG_MK7 is not set
> # CONFIG_MK8 is not set
> # CONFIG_MCRUSOE is not set
> # CONFIG_MEFFICEON is not set
> # CONFIG_MWINCHIPC6 is not set
> # CONFIG_MWINCHIP2 is not set
> # CONFIG_MWINCHIP3D is not set
> # CONFIG_MGEODEGX1 is not set
> # CONFIG_MGEODE_LX is not set
> # CONFIG_MCYRIXIII is not set
> # CONFIG_MVIAC3_2 is not set
> # CONFIG_MVIAC7 is not set
> # CONFIG_X86_GENERIC is not set
> CONFIG_X86_CMPXCHG=y
> CONFIG_X86_L1_CACHE_SHIFT=5
> CONFIG_X86_XADD=y
> CONFIG_RWSEM_XCHGADD_ALGORITHM=y
> # CONFIG_ARCH_HAS_ILOG2_U32 is not set
> # CONFIG_ARCH_HAS_ILOG2_U64 is not set
> CONFIG_GENERIC_CALIBRATE_DELAY=y
> CONFIG_X86_WP_WORKS_OK=y
> CONFIG_X86_INVLPG=y
> CONFIG_X86_BSWAP=y
> CONFIG_X86_POPAD_OK=y
> CONFIG_X86_GOOD_APIC=y
> CONFIG_X86_INTEL_USERCOPY=y
> CONFIG_X86_USE_PPRO_CHECKSUM=y
> CONFIG_X86_TSC=y
> CONFIG_X86_CMOV=y
> CONFIG_X86_MINIMUM_CPU_FAMILY=4
> CONFIG_HPET_TIMER=y
> CONFIG_HPET_EMULATE_RTC=y
> # CONFIG_PREEMPT_NONE is not set
> # CONFIG_PREEMPT_VOLUNTARY is not set
> CONFIG_PREEMPT=y
> CONFIG_PREEMPT_BKL=y
> # CONFIG_X86_UP_APIC is not set
> CONFIG_X86_MCE=y
> CONFIG_X86_MCE_NONFATAL=y
> CONFIG_VM86=y
> # CONFIG_TOSHIBA is not set
> # CONFIG_I8K is not set
> # CONFIG_X86_REBOOTFIXUPS is not set
> CONFIG_MICROCODE=y
> CONFIG_MICROCODE_OLD_INTERFACE=y
> CONFIG_X86_MSR=y
> CONFIG_X86_CPUID=y
>
> #
> # Firmware Drivers
> #
> # CONFIG_EDD is not set
> # CONFIG_DELL_RBU is not set
> # CONFIG_DCDBAS is not set
> CONFIG_DMIID=y
> # CONFIG_NOHIGHMEM is not set
> CONFIG_HIGHMEM4G=y
> # CONFIG_HIGHMEM64G is not set
> CONFIG_PAGE_OFFSET=0xC0000000
> CONFIG_HIGHMEM=y
> CONFIG_ARCH_FLATMEM_ENABLE=y
> CONFIG_ARCH_SPARSEMEM_ENABLE=y
> CONFIG_ARCH_SELECT_MEMORY_MODEL=y
> CONFIG_ARCH_POPULATES_NODE_MAP=y
> CONFIG_SELECT_MEMORY_MODEL=y
> CONFIG_FLATMEM_MANUAL=y
> # CONFIG_DISCONTIGMEM_MANUAL is not set
> # CONFIG_SPARSEMEM_MANUAL is not set
> CONFIG_FLATMEM=y
> CONFIG_FLAT_NODE_MEM_MAP=y
> CONFIG_SPARSEMEM_STATIC=y
> CONFIG_SPLIT_PTLOCK_CPUS=4
> # CONFIG_RESOURCES_64BIT is not set
> CONFIG_ZONE_DMA_FLAG=1
> CONFIG_BOUNCE=y
> CONFIG_NR_QUICK=1
> CONFIG_VIRT_TO_BUS=y
> # CONFIG_HIGHPTE is not set
> # CONFIG_MATH_EMULATION is not set
> CONFIG_MTRR=y
> # CONFIG_EFI is not set
> CONFIG_SECCOMP=y
> # CONFIG_HZ_100 is not set
> # CONFIG_HZ_250 is not set
> # CONFIG_HZ_300 is not set
> CONFIG_HZ_1000=y
> CONFIG_HZ=1000
> CONFIG_KEXEC=y
> # CONFIG_CRASH_DUMP is not set
> CONFIG_PHYSICAL_START=0x100000
> # CONFIG_RELOCATABLE is not set
> CONFIG_PHYSICAL_ALIGN=0x100000
> CONFIG_COMPAT_VDSO=y
> CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
>
> #
> # Power management options (ACPI, APM)
> #
> CONFIG_PM=y
> # CONFIG_PM_LEGACY is not set
> # CONFIG_PM_DEBUG is not set
> # CONFIG_SOFTWARE_SUSPEND is not set
> CONFIG_ACPI=y
> CONFIG_ACPI_SLEEP=y
> CONFIG_ACPI_SLEEP_PROC_FS=y
> # CONFIG_ACPI_SLEEP_PROC_SLEEP is not set
> # CONFIG_ACPI_PROCFS is not set
> CONFIG_ACPI_AC=y
> CONFIG_ACPI_BATTERY=y
> CONFIG_ACPI_BUTTON=y
> CONFIG_ACPI_FAN=y
> # CONFIG_ACPI_DOCK is not set
> CONFIG_ACPI_PROCESSOR=y
> CONFIG_ACPI_THERMAL=y
> # CONFIG_ACPI_ASUS is not set
> # CONFIG_ACPI_TOSHIBA is not set
> CONFIG_ACPI_BLACKLIST_YEAR=0
> # CONFIG_ACPI_DEBUG is not set
> CONFIG_ACPI_EC=y
> CONFIG_ACPI_POWER=y
> CONFIG_ACPI_SYSTEM=y
> CONFIG_X86_PM_TIMER=y
> # CONFIG_ACPI_CONTAINER is not set
> # CONFIG_ACPI_SBS is not set
> # CONFIG_APM is not set
>
> #
> # CPU Frequency scaling
> #
> CONFIG_CPU_FREQ=y
> CONFIG_CPU_FREQ_TABLE=y
> CONFIG_CPU_FREQ_DEBUG=y
> CONFIG_CPU_FREQ_STAT=y
> # CONFIG_CPU_FREQ_STAT_DETAILS is not set
> CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
> # CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
> CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
> # CONFIG_CPU_FREQ_GOV_POWERSAVE is not set
> CONFIG_CPU_FREQ_GOV_USERSPACE=y
> CONFIG_CPU_FREQ_GOV_ONDEMAND=y
> # CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set
>
> #
> # CPUFreq processor drivers
> #
> # CONFIG_X86_ACPI_CPUFREQ is not set
> # CONFIG_X86_POWERNOW_K6 is not set
> # CONFIG_X86_POWERNOW_K7 is not set
> CONFIG_X86_POWERNOW_K8=y
> CONFIG_X86_POWERNOW_K8_ACPI=y
> # CONFIG_X86_GX_SUSPMOD is not set
> # CONFIG_X86_SPEEDSTEP_CENTRINO is not set
> # CONFIG_X86_SPEEDSTEP_ICH is not set
> # CONFIG_X86_SPEEDSTEP_SMI is not set
> # CONFIG_X86_P4_CLOCKMOD is not set
> # CONFIG_X86_CPUFREQ_NFORCE2 is not set
> # CONFIG_X86_LONGRUN is not set
> # CONFIG_X86_LONGHAUL is not set
> # CONFIG_X86_E_POWERSAVER is not set
>
> #
> # shared options
> #
> # CONFIG_X86_ACPI_CPUFREQ_PROC_INTF is not set
> # CONFIG_X86_SPEEDSTEP_LIB is not set
>
> #
> # Bus options (PCI, PCMCIA, EISA, MCA, ISA)
> #
> CONFIG_PCI=y
> # CONFIG_PCI_GOBIOS is not set
> # CONFIG_PCI_GOMMCONFIG is not set
> # CONFIG_PCI_GODIRECT is not set
> CONFIG_PCI_GOANY=y
> CONFIG_PCI_BIOS=y
> CONFIG_PCI_DIRECT=y
> CONFIG_PCI_MMCONFIG=y
> # CONFIG_PCIEPORTBUS is not set
> # CONFIG_ARCH_SUPPORTS_MSI is not set
> # CONFIG_PCI_DEBUG is not set
> CONFIG_ISA_DMA_API=y
> # CONFIG_ISA is not set
> # CONFIG_MCA is not set
> # CONFIG_SCx200 is not set
> CONFIG_K8_NB=y
>
> #
> # PCCARD (PCMCIA/CardBus) support
> #
> # CONFIG_PCCARD is not set
> # CONFIG_HOTPLUG_PCI is not set
>
> #
> # Executable file formats
> #
> CONFIG_BINFMT_ELF=y
> CONFIG_BINFMT_AOUT=y
> # CONFIG_BINFMT_MISC is not set
>
> #
> # Networking
> #
> CONFIG_NET=y
>
> #
> # Networking options
> #
> CONFIG_PACKET=y
> # CONFIG_PACKET_MMAP is not set
> CONFIG_UNIX=y
> CONFIG_XFRM=y
> # CONFIG_XFRM_USER is not set
> # CONFIG_XFRM_SUB_POLICY is not set
> # CONFIG_XFRM_MIGRATE is not set
> # CONFIG_NET_KEY is not set
> CONFIG_INET=y
> CONFIG_IP_MULTICAST=y
> CONFIG_IP_ADVANCED_ROUTER=y
> CONFIG_ASK_IP_FIB_HASH=y
> # CONFIG_IP_FIB_TRIE is not set
> CONFIG_IP_FIB_HASH=y
> CONFIG_IP_MULTIPLE_TABLES=y
> CONFIG_IP_ROUTE_MULTIPATH=y
> CONFIG_IP_ROUTE_VERBOSE=y
> CONFIG_IP_PNP=y
> CONFIG_IP_PNP_DHCP=y
> CONFIG_IP_PNP_BOOTP=y
> CONFIG_IP_PNP_RARP=y
> CONFIG_NET_IPIP=y
> CONFIG_NET_IPGRE=y
> CONFIG_NET_IPGRE_BROADCAST=y
> CONFIG_IP_MROUTE=y
> CONFIG_IP_PIMSM_V1=y
> CONFIG_IP_PIMSM_V2=y
> CONFIG_ARPD=y
> CONFIG_SYN_COOKIES=y
> CONFIG_INET_AH=y
> CONFIG_INET_ESP=y
> CONFIG_INET_IPCOMP=y
> CONFIG_INET_XFRM_TUNNEL=y
> CONFIG_INET_TUNNEL=y
> CONFIG_INET_XFRM_MODE_TRANSPORT=y
> CONFIG_INET_XFRM_MODE_TUNNEL=y
> CONFIG_INET_XFRM_MODE_BEET=y
> CONFIG_INET_DIAG=y
> CONFIG_INET_TCP_DIAG=y
> CONFIG_TCP_CONG_ADVANCED=y
> CONFIG_TCP_CONG_BIC=y
> CONFIG_TCP_CONG_CUBIC=y
> CONFIG_TCP_CONG_WESTWOOD=y
> CONFIG_TCP_CONG_HTCP=y
> # CONFIG_TCP_CONG_HSTCP is not set
> # CONFIG_TCP_CONG_HYBLA is not set
> # CONFIG_TCP_CONG_VEGAS is not set
> # CONFIG_TCP_CONG_SCALABLE is not set
> # CONFIG_TCP_CONG_LP is not set
> # CONFIG_TCP_CONG_VENO is not set
> # CONFIG_TCP_CONG_YEAH is not set
> # CONFIG_TCP_CONG_ILLINOIS is not set
> # CONFIG_DEFAULT_BIC is not set
> CONFIG_DEFAULT_CUBIC=y
> # CONFIG_DEFAULT_HTCP is not set
> # CONFIG_DEFAULT_VEGAS is not set
> # CONFIG_DEFAULT_WESTWOOD is not set
> # CONFIG_DEFAULT_RENO is not set
> CONFIG_DEFAULT_TCP_CONG="cubic"
> CONFIG_TCP_MD5SIG=y
> # CONFIG_IP_VS is not set
> CONFIG_IPV6=y
> CONFIG_IPV6_PRIVACY=y
> CONFIG_IPV6_ROUTER_PREF=y
> CONFIG_IPV6_ROUTE_INFO=y
> # CONFIG_IPV6_OPTIMISTIC_DAD is not set
> CONFIG_INET6_AH=y
> CONFIG_INET6_ESP=y
> CONFIG_INET6_IPCOMP=y
> CONFIG_IPV6_MIP6=y
> CONFIG_INET6_XFRM_TUNNEL=y
> CONFIG_INET6_TUNNEL=y
> CONFIG_INET6_XFRM_MODE_TRANSPORT=y
> CONFIG_INET6_XFRM_MODE_TUNNEL=y
> CONFIG_INET6_XFRM_MODE_BEET=y
> CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=y
> CONFIG_IPV6_SIT=y
> CONFIG_IPV6_TUNNEL=y
> CONFIG_IPV6_MULTIPLE_TABLES=y
> CONFIG_IPV6_SUBTREES=y
> # CONFIG_NETWORK_SECMARK is not set
> CONFIG_NETFILTER=y
> # CONFIG_NETFILTER_DEBUG is not set
>
> #
> # Core Netfilter Configuration
> #
> CONFIG_NETFILTER_NETLINK=y
> CONFIG_NETFILTER_NETLINK_QUEUE=y
> CONFIG_NETFILTER_NETLINK_LOG=y
> CONFIG_NF_CONNTRACK_ENABLED=y
> CONFIG_NF_CONNTRACK=y
> CONFIG_NF_CT_ACCT=y
> CONFIG_NF_CONNTRACK_MARK=y
> CONFIG_NF_CONNTRACK_EVENTS=y
> CONFIG_NF_CT_PROTO_GRE=y
> CONFIG_NF_CT_PROTO_SCTP=y
> # CONFIG_NF_CT_PROTO_UDPLITE is not set
> CONFIG_NF_CONNTRACK_AMANDA=y
> CONFIG_NF_CONNTRACK_FTP=y
> CONFIG_NF_CONNTRACK_H323=y
> CONFIG_NF_CONNTRACK_IRC=y
> CONFIG_NF_CONNTRACK_NETBIOS_NS=y
> CONFIG_NF_CONNTRACK_PPTP=y
> CONFIG_NF_CONNTRACK_SANE=y
> CONFIG_NF_CONNTRACK_SIP=y
> CONFIG_NF_CONNTRACK_TFTP=y
> CONFIG_NF_CT_NETLINK=y
> CONFIG_NETFILTER_XTABLES=y
> CONFIG_NETFILTER_XT_TARGET_CLASSIFY=y
> CONFIG_NETFILTER_XT_TARGET_CONNMARK=y
> CONFIG_NETFILTER_XT_TARGET_DSCP=y
> CONFIG_NETFILTER_XT_TARGET_MARK=y
> CONFIG_NETFILTER_XT_TARGET_NFQUEUE=y
> CONFIG_NETFILTER_XT_TARGET_NFLOG=y
> # CONFIG_NETFILTER_XT_TARGET_NOTRACK is not set
> CONFIG_NETFILTER_XT_TARGET_TRACE=y
> CONFIG_NETFILTER_XT_TARGET_TCPMSS=y
> CONFIG_NETFILTER_XT_MATCH_COMMENT=y
> CONFIG_NETFILTER_XT_MATCH_CONNBYTES=y
> CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=y
> CONFIG_NETFILTER_XT_MATCH_CONNMARK=y
> CONFIG_NETFILTER_XT_MATCH_CONNTRACK=y
> CONFIG_NETFILTER_XT_MATCH_DCCP=y
> CONFIG_NETFILTER_XT_MATCH_DSCP=y
> CONFIG_NETFILTER_XT_MATCH_ESP=y
> # CONFIG_NETFILTER_XT_MATCH_HELPER is not set
> CONFIG_NETFILTER_XT_MATCH_LENGTH=y
> CONFIG_NETFILTER_XT_MATCH_LIMIT=y
> CONFIG_NETFILTER_XT_MATCH_MAC=y
> CONFIG_NETFILTER_XT_MATCH_MARK=y
> CONFIG_NETFILTER_XT_MATCH_POLICY=y
> CONFIG_NETFILTER_XT_MATCH_MULTIPORT=y
> CONFIG_NETFILTER_XT_MATCH_PKTTYPE=y
> CONFIG_NETFILTER_XT_MATCH_QUOTA=y
> CONFIG_NETFILTER_XT_MATCH_REALM=y
> CONFIG_NETFILTER_XT_MATCH_SCTP=y
> # CONFIG_NETFILTER_XT_MATCH_STATE is not set
> CONFIG_NETFILTER_XT_MATCH_STATISTIC=y
> CONFIG_NETFILTER_XT_MATCH_STRING=y
> CONFIG_NETFILTER_XT_MATCH_TCPMSS=y
> CONFIG_NETFILTER_XT_MATCH_U32=y
> CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=y
>
> #
> # IP: Netfilter Configuration
> #
> # CONFIG_NF_CONNTRACK_IPV4 is not set
> # CONFIG_IP_NF_QUEUE is not set
> CONFIG_IP_NF_IPTABLES=y
> CONFIG_IP_NF_MATCH_IPRANGE=y
> CONFIG_IP_NF_MATCH_TOS=y
> CONFIG_IP_NF_MATCH_RECENT=y
> CONFIG_IP_NF_MATCH_ECN=y
> CONFIG_IP_NF_MATCH_AH=y
> CONFIG_IP_NF_MATCH_TTL=y
> CONFIG_IP_NF_MATCH_OWNER=y
> CONFIG_IP_NF_MATCH_ADDRTYPE=y
> CONFIG_IP_NF_FILTER=y
> CONFIG_IP_NF_TARGET_REJECT=y
> CONFIG_IP_NF_TARGET_LOG=y
> CONFIG_IP_NF_TARGET_ULOG=y
> # CONFIG_IP_NF_MANGLE is not set
> # CONFIG_IP_NF_RAW is not set
> # CONFIG_IP_NF_ARPTABLES is not set
>
> #
> # IPv6: Netfilter Configuration (EXPERIMENTAL)
> #
> # CONFIG_NF_CONNTRACK_IPV6 is not set
> # CONFIG_IP6_NF_QUEUE is not set
> CONFIG_IP6_NF_IPTABLES=y
> CONFIG_IP6_NF_MATCH_RT=y
> CONFIG_IP6_NF_MATCH_OPTS=y
> CONFIG_IP6_NF_MATCH_FRAG=y
> CONFIG_IP6_NF_MATCH_HL=y
> CONFIG_IP6_NF_MATCH_OWNER=y
> CONFIG_IP6_NF_MATCH_IPV6HEADER=y
> CONFIG_IP6_NF_MATCH_AH=y
> CONFIG_IP6_NF_MATCH_MH=y
> CONFIG_IP6_NF_MATCH_EUI64=y
> CONFIG_IP6_NF_FILTER=y
> CONFIG_IP6_NF_TARGET_LOG=y
> CONFIG_IP6_NF_TARGET_REJECT=y
> CONFIG_IP6_NF_MANGLE=y
> CONFIG_IP6_NF_TARGET_HL=y
> CONFIG_IP6_NF_RAW=y
> CONFIG_IP_DCCP=y
> CONFIG_INET_DCCP_DIAG=y
> CONFIG_IP_DCCP_ACKVEC=y
>
> #
> # DCCP CCIDs Configuration (EXPERIMENTAL)
> #
> CONFIG_IP_DCCP_CCID2=y
> # CONFIG_IP_DCCP_CCID2_DEBUG is not set
> CONFIG_IP_DCCP_CCID3=y
> CONFIG_IP_DCCP_TFRC_LIB=y
> # CONFIG_IP_DCCP_CCID3_DEBUG is not set
> CONFIG_IP_DCCP_CCID3_RTO=100
>
> #
> # DCCP Kernel Hacking
> #
> # CONFIG_IP_DCCP_DEBUG is not set
> CONFIG_IP_SCTP=y
> # CONFIG_SCTP_DBG_MSG is not set
> CONFIG_SCTP_DBG_OBJCNT=y
> # CONFIG_SCTP_HMAC_NONE is not set
> # CONFIG_SCTP_HMAC_SHA1 is not set
> CONFIG_SCTP_HMAC_MD5=y
> CONFIG_TIPC=y
> CONFIG_TIPC_ADVANCED=y
> CONFIG_TIPC_ZONES=3
> CONFIG_TIPC_CLUSTERS=1
> CONFIG_TIPC_NODES=255
> CONFIG_TIPC_SLAVE_NODES=0
> CONFIG_TIPC_PORTS=8191
> CONFIG_TIPC_LOG=0
> # CONFIG_TIPC_DEBUG is not set
> # CONFIG_ATM is not set
> # CONFIG_BRIDGE is not set
> # CONFIG_VLAN_8021Q is not set
> # CONFIG_DECNET is not set
> CONFIG_LLC=y
> # CONFIG_LLC2 is not set
> CONFIG_IPX=y
> # CONFIG_IPX_INTERN is not set
> CONFIG_ATALK=y
> CONFIG_DEV_APPLETALK=y
> CONFIG_IPDDP=y
> CONFIG_IPDDP_ENCAP=y
> CONFIG_IPDDP_DECAP=y
> # CONFIG_X25 is not set
> # CONFIG_LAPB is not set
> # CONFIG_ECONET is not set
> # CONFIG_WAN_ROUTER is not set
>
> #
> # QoS and/or fair queueing
> #
> # CONFIG_NET_SCHED is not set
> CONFIG_NET_CLS_ROUTE=y
>
> #
> # Network testing
> #
> # CONFIG_NET_PKTGEN is not set
> # CONFIG_HAMRADIO is not set
> # CONFIG_IRDA is not set
> # CONFIG_BT is not set
> # CONFIG_AF_RXRPC is not set
> CONFIG_FIB_RULES=y
>
> #
> # Wireless
> #
> # CONFIG_CFG80211 is not set
> # CONFIG_WIRELESS_EXT is not set
> # CONFIG_MAC80211 is not set
> # CONFIG_IEEE80211 is not set
> # CONFIG_RFKILL is not set
> # CONFIG_NET_9P is not set
>
> #
> # Device Drivers
> #
>
> #
> # Generic Driver Options
> #
> CONFIG_STANDALONE=y
> CONFIG_PREVENT_FIRMWARE_BUILD=y
> CONFIG_FW_LOADER=y
> # CONFIG_DEBUG_DRIVER is not set
> # CONFIG_DEBUG_DEVRES is not set
> # CONFIG_SYS_HYPERVISOR is not set
> # CONFIG_CONNECTOR is not set
> # CONFIG_MTD is not set
> # CONFIG_PARPORT is not set
> CONFIG_PNP=y
> # CONFIG_PNP_DEBUG is not set
>
> #
> # Protocols
> #
> CONFIG_PNPACPI=y
> CONFIG_BLK_DEV=y
> CONFIG_BLK_DEV_FD=y
> # CONFIG_BLK_CPQ_DA is not set
> # CONFIG_BLK_CPQ_CISS_DA is not set
> # CONFIG_BLK_DEV_DAC960 is not set
> # CONFIG_BLK_DEV_UMEM is not set
> # CONFIG_BLK_DEV_COW_COMMON is not set
> CONFIG_BLK_DEV_LOOP=y
> CONFIG_BLK_DEV_CRYPTOLOOP=y
> # CONFIG_BLK_DEV_NBD is not set
> # CONFIG_BLK_DEV_SX8 is not set
> # CONFIG_BLK_DEV_UB is not set
> CONFIG_BLK_DEV_RAM=y
> CONFIG_BLK_DEV_RAM_COUNT=16
> CONFIG_BLK_DEV_RAM_SIZE=4096
> CONFIG_BLK_DEV_RAM_BLOCKSIZE=1024
> # CONFIG_CDROM_PKTCDVD is not set
> # CONFIG_ATA_OVER_ETH is not set
> CONFIG_MISC_DEVICES=y
> # CONFIG_IBM_ASM is not set
> # CONFIG_PHANTOM is not set
> # CONFIG_EEPROM_93CX6 is not set
> # CONFIG_SGI_IOC4 is not set
> # CONFIG_TIFM_CORE is not set
> # CONFIG_SONY_LAPTOP is not set
> # CONFIG_THINKPAD_ACPI is not set
> CONFIG_IDE=y
> CONFIG_BLK_DEV_IDE=y
>
> #
> # Please see Documentation/ide.txt for help/info on IDE drives
> #
> # CONFIG_BLK_DEV_IDE_SATA is not set
> # CONFIG_BLK_DEV_HD_IDE is not set
> CONFIG_BLK_DEV_IDEDISK=y
> CONFIG_IDEDISK_MULTI_MODE=y
> CONFIG_BLK_DEV_IDECD=y
> # CONFIG_BLK_DEV_IDETAPE is not set
> # CONFIG_BLK_DEV_IDEFLOPPY is not set
> # CONFIG_BLK_DEV_IDESCSI is not set
> # CONFIG_BLK_DEV_IDEACPI is not set
> # CONFIG_IDE_TASK_IOCTL is not set
> CONFIG_IDE_PROC_FS=y
>
> #
> # IDE chipset support/bugfixes
> #
> CONFIG_IDE_GENERIC=y
> # CONFIG_BLK_DEV_CMD640 is not set
> # CONFIG_BLK_DEV_IDEPNP is not set
> CONFIG_BLK_DEV_IDEPCI=y
> # CONFIG_IDEPCI_SHARE_IRQ is not set
> CONFIG_IDEPCI_PCIBUS_ORDER=y
> # CONFIG_BLK_DEV_OFFBOARD is not set
> # CONFIG_BLK_DEV_GENERIC is not set
> # CONFIG_BLK_DEV_OPTI621 is not set
> # CONFIG_BLK_DEV_RZ1000 is not set
> CONFIG_BLK_DEV_IDEDMA_PCI=y
> # CONFIG_BLK_DEV_IDEDMA_FORCED is not set
> # CONFIG_IDEDMA_ONLYDISK is not set
> # CONFIG_BLK_DEV_AEC62XX is not set
> # CONFIG_BLK_DEV_ALI15X3 is not set
> # CONFIG_BLK_DEV_AMD74XX is not set
> # CONFIG_BLK_DEV_ATIIXP is not set
> # CONFIG_BLK_DEV_CMD64X is not set
> # CONFIG_BLK_DEV_TRIFLEX is not set
> # CONFIG_BLK_DEV_CY82C693 is not set
> # CONFIG_BLK_DEV_CS5520 is not set
> # CONFIG_BLK_DEV_CS5530 is not set
> # CONFIG_BLK_DEV_CS5535 is not set
> # CONFIG_BLK_DEV_HPT34X is not set
> # CONFIG_BLK_DEV_HPT366 is not set
> # CONFIG_BLK_DEV_JMICRON is not set
> # CONFIG_BLK_DEV_SC1200 is not set
> # CONFIG_BLK_DEV_PIIX is not set
> # CONFIG_BLK_DEV_IT8213 is not set
> # CONFIG_BLK_DEV_IT821X is not set
> # CONFIG_BLK_DEV_NS87415 is not set
> # CONFIG_BLK_DEV_PDC202XX_OLD is not set
> # CONFIG_BLK_DEV_PDC202XX_NEW is not set
> # CONFIG_BLK_DEV_SVWKS is not set
> # CONFIG_BLK_DEV_SIIMAGE is not set
> # CONFIG_BLK_DEV_SIS5513 is not set
> # CONFIG_BLK_DEV_SLC90E66 is not set
> # CONFIG_BLK_DEV_TRM290 is not set
> CONFIG_BLK_DEV_VIA82CXXX=y
> # CONFIG_BLK_DEV_TC86C001 is not set
> # CONFIG_IDE_ARM is not set
> CONFIG_BLK_DEV_IDEDMA=y
> # CONFIG_IDEDMA_IVB is not set
> # CONFIG_BLK_DEV_HD is not set
>
> #
> # SCSI device support
> #
> # CONFIG_RAID_ATTRS is not set
> CONFIG_SCSI=y
> CONFIG_SCSI_DMA=y
> # CONFIG_SCSI_TGT is not set
> CONFIG_SCSI_NETLINK=y
> # CONFIG_SCSI_PROC_FS is not set
>
> #
> # SCSI support type (disk, tape, CD-ROM)
> #
> CONFIG_BLK_DEV_SD=y
> # CONFIG_CHR_DEV_ST is not set
> # CONFIG_CHR_DEV_OSST is not set
> CONFIG_BLK_DEV_SR=y
> # CONFIG_BLK_DEV_SR_VENDOR is not set
> CONFIG_CHR_DEV_SG=y
> # CONFIG_CHR_DEV_SCH is not set
>
> #
> # Some SCSI devices (e.g. CD jukebox) support multiple LUNs
> #
> # CONFIG_SCSI_MULTI_LUN is not set
> # CONFIG_SCSI_CONSTANTS is not set
> # CONFIG_SCSI_LOGGING is not set
> # CONFIG_SCSI_SCAN_ASYNC is not set
> CONFIG_SCSI_WAIT_SCAN=m
>
> #
> # SCSI Transports
> #
> CONFIG_SCSI_SPI_ATTRS=y
> CONFIG_SCSI_FC_ATTRS=y
> # CONFIG_SCSI_ISCSI_ATTRS is not set
> # CONFIG_SCSI_SAS_LIBSAS is not set
> # CONFIG_SCSI_LOWLEVEL is not set
> # CONFIG_ATA is not set
> CONFIG_MD=y
> # CONFIG_BLK_DEV_MD is not set
> CONFIG_BLK_DEV_DM=y
> # CONFIG_DM_DEBUG is not set
> CONFIG_DM_CRYPT=y
> # CONFIG_DM_SNAPSHOT is not set
> # CONFIG_DM_MIRROR is not set
> # CONFIG_DM_ZERO is not set
> # CONFIG_DM_MULTIPATH is not set
> # CONFIG_DM_DELAY is not set
>
> #
> # Fusion MPT device support
> #
> # CONFIG_FUSION is not set
> # CONFIG_FUSION_SPI is not set
> # CONFIG_FUSION_FC is not set
> # CONFIG_FUSION_SAS is not set
>
> #
> # IEEE 1394 (FireWire) support
> #
> # CONFIG_FIREWIRE is not set
> # CONFIG_IEEE1394 is not set
> # CONFIG_I2O is not set
> # CONFIG_MACINTOSH_DRIVERS is not set
> CONFIG_NETDEVICES=y
> # CONFIG_NETDEVICES_MULTIQUEUE is not set
> # CONFIG_DUMMY is not set
> # CONFIG_BONDING is not set
> # CONFIG_MACVLAN is not set
> # CONFIG_EQUALIZER is not set
> # CONFIG_TUN is not set
> # CONFIG_NET_SB1000 is not set
> # CONFIG_ARCNET is not set
> # CONFIG_PHYLIB is not set
> CONFIG_NET_ETHERNET=y
> CONFIG_MII=y
> # CONFIG_HAPPYMEAL is not set
> # CONFIG_SUNGEM is not set
> # CONFIG_CASSINI is not set
> # CONFIG_NET_VENDOR_3COM is not set
> CONFIG_NET_TULIP=y
> # CONFIG_DE2104X is not set
> CONFIG_TULIP=y
> # CONFIG_TULIP_MWI is not set
> # CONFIG_TULIP_MMIO is not set
> # CONFIG_TULIP_NAPI is not set
> # CONFIG_DE4X5 is not set
> # CONFIG_WINBOND_840 is not set
> # CONFIG_DM9102 is not set
> # CONFIG_ULI526X is not set
> # CONFIG_HP100 is not set
> CONFIG_NET_PCI=y
> # CONFIG_PCNET32 is not set
> # CONFIG_AMD8111_ETH is not set
> # CONFIG_ADAPTEC_STARFIRE is not set
> # CONFIG_B44 is not set
> # CONFIG_FORCEDETH is not set
> # CONFIG_DGRS is not set
> # CONFIG_EEPRO100 is not set
> # CONFIG_E100 is not set
> # CONFIG_FEALNX is not set
> # CONFIG_NATSEMI is not set
> # CONFIG_NE2K_PCI is not set
> CONFIG_8139CP=y
> CONFIG_8139TOO=y
> CONFIG_8139TOO_PIO=y
> # CONFIG_8139TOO_TUNE_TWISTER is not set
> # CONFIG_8139TOO_8129 is not set
> # CONFIG_8139_OLD_RX_RESET is not set
> # CONFIG_SIS900 is not set
> # CONFIG_EPIC100 is not set
> # CONFIG_SUNDANCE is not set
> # CONFIG_TLAN is not set
> # CONFIG_VIA_RHINE is not set
> # CONFIG_SC92031 is not set
> # CONFIG_NETDEV_1000 is not set
> # CONFIG_NETDEV_10000 is not set
> # CONFIG_TR is not set
>
> #
> # Wireless LAN
> #
> # CONFIG_WLAN_PRE80211 is not set
> # CONFIG_WLAN_80211 is not set
>
> #
> # USB Network Adapters
> #
> # CONFIG_USB_CATC is not set
> # CONFIG_USB_KAWETH is not set
> # CONFIG_USB_PEGASUS is not set
> # CONFIG_USB_RTL8150 is not set
> # CONFIG_USB_USBNET_MII is not set
> # CONFIG_USB_USBNET is not set
> # CONFIG_WAN is not set
> # CONFIG_FDDI is not set
> # CONFIG_HIPPI is not set
> # CONFIG_PPP is not set
> # CONFIG_SLIP is not set
> # CONFIG_NET_FC is not set
> # CONFIG_SHAPER is not set
> CONFIG_NETCONSOLE=y
> CONFIG_NETPOLL=y
> # CONFIG_NETPOLL_TRAP is not set
> CONFIG_NET_POLL_CONTROLLER=y
> # CONFIG_ISDN is not set
> # CONFIG_PHONE is not set
>
> #
> # Input device support
> #
> CONFIG_INPUT=y
> # CONFIG_INPUT_FF_MEMLESS is not set
> CONFIG_INPUT_POLLDEV=y
>
> #
> # Userland interfaces
> #
> CONFIG_INPUT_MOUSEDEV=y
> CONFIG_INPUT_MOUSEDEV_PSAUX=y
> CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
> CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
> # CONFIG_INPUT_JOYDEV is not set
> # CONFIG_INPUT_TSDEV is not set
> CONFIG_INPUT_EVDEV=y
> # CONFIG_INPUT_EVBUG is not set
>
> #
> # Input Device Drivers
> #
> CONFIG_INPUT_KEYBOARD=y
> CONFIG_KEYBOARD_ATKBD=y
> # CONFIG_KEYBOARD_SUNKBD is not set
> # CONFIG_KEYBOARD_LKKBD is not set
> # CONFIG_KEYBOARD_XTKBD is not set
> # CONFIG_KEYBOARD_NEWTON is not set
> # CONFIG_KEYBOARD_STOWAWAY is not set
> CONFIG_INPUT_MOUSE=y
> CONFIG_MOUSE_PS2=y
> CONFIG_MOUSE_PS2_ALPS=y
> CONFIG_MOUSE_PS2_LOGIPS2PP=y
> CONFIG_MOUSE_PS2_SYNAPTICS=y
> CONFIG_MOUSE_PS2_LIFEBOOK=y
> CONFIG_MOUSE_PS2_TRACKPOINT=y
> # CONFIG_MOUSE_PS2_TOUCHKIT is not set
> # CONFIG_MOUSE_SERIAL is not set
> # CONFIG_MOUSE_APPLETOUCH is not set
> # CONFIG_MOUSE_VSXXXAA is not set
> # CONFIG_INPUT_JOYSTICK is not set
> # CONFIG_INPUT_TABLET is not set
> # CONFIG_INPUT_TOUCHSCREEN is not set
> # CONFIG_INPUT_MISC is not set
>
> #
> # Hardware I/O ports
> #
> CONFIG_SERIO=y
> CONFIG_SERIO_I8042=y
> # CONFIG_SERIO_SERPORT is not set
> # CONFIG_SERIO_CT82C710 is not set
> # CONFIG_SERIO_PCIPS2 is not set
> CONFIG_SERIO_LIBPS2=y
> # CONFIG_SERIO_RAW is not set
> # CONFIG_GAMEPORT is not set
>
> #
> # Character devices
> #
> CONFIG_VT=y
> CONFIG_VT_CONSOLE=y
> CONFIG_HW_CONSOLE=y
> # CONFIG_VT_HW_CONSOLE_BINDING is not set
> # CONFIG_SERIAL_NONSTANDARD is not set
>
> #
> # Serial drivers
> #
> CONFIG_SERIAL_8250=y
> CONFIG_SERIAL_8250_CONSOLE=y
> CONFIG_FIX_EARLYCON_MEM=y
> CONFIG_SERIAL_8250_PCI=y
> CONFIG_SERIAL_8250_PNP=y
> CONFIG_SERIAL_8250_NR_UARTS=4
> CONFIG_SERIAL_8250_RUNTIME_UARTS=4
> # CONFIG_SERIAL_8250_EXTENDED is not set
>
> #
> # Non-8250 serial port support
> #
> CONFIG_SERIAL_CORE=y
> CONFIG_SERIAL_CORE_CONSOLE=y
> # CONFIG_SERIAL_JSM is not set
> CONFIG_UNIX98_PTYS=y
> CONFIG_LEGACY_PTYS=y
> CONFIG_LEGACY_PTY_COUNT=256
> # CONFIG_IPMI_HANDLER is not set
> # CONFIG_WATCHDOG is not set
> CONFIG_HW_RANDOM=y
> CONFIG_HW_RANDOM_INTEL=y
> CONFIG_HW_RANDOM_AMD=y
> CONFIG_HW_RANDOM_GEODE=y
> CONFIG_HW_RANDOM_VIA=y
> # CONFIG_NVRAM is not set
> CONFIG_RTC=y
> # CONFIG_R3964 is not set
> # CONFIG_APPLICOM is not set
> # CONFIG_SONYPI is not set
> CONFIG_AGP=y
> # CONFIG_AGP_ALI is not set
> # CONFIG_AGP_ATI is not set
> # CONFIG_AGP_AMD is not set
> CONFIG_AGP_AMD64=y
> CONFIG_AGP_INTEL=y
> # CONFIG_AGP_NVIDIA is not set
> # CONFIG_AGP_SIS is not set
> # CONFIG_AGP_SWORKS is not set
> CONFIG_AGP_VIA=y
> # CONFIG_AGP_EFFICEON is not set
> # CONFIG_DRM is not set
> # CONFIG_MWAVE is not set
> # CONFIG_PC8736x_GPIO is not set
> # CONFIG_NSC_GPIO is not set
> # CONFIG_CS5535_GPIO is not set
> CONFIG_RAW_DRIVER=y
> CONFIG_MAX_RAW_DEVS=256
> # CONFIG_HPET is not set
> CONFIG_HANGCHECK_TIMER=y
> # CONFIG_TCG_TPM is not set
> # CONFIG_TELCLOCK is not set
> CONFIG_DEVPORT=y
> # CONFIG_I2C is not set
>
> #
> # SPI support
> #
> # CONFIG_SPI is not set
> # CONFIG_SPI_MASTER is not set
> # CONFIG_W1 is not set
> # CONFIG_POWER_SUPPLY is not set
> # CONFIG_HWMON is not set
>
> #
> # Multifunction device drivers
> #
> # CONFIG_MFD_SM501 is not set
>
> #
> # Multimedia devices
> #
> # CONFIG_VIDEO_DEV is not set
> # CONFIG_DVB_CORE is not set
> # CONFIG_DAB is not set
>
> #
> # Graphics support
> #
> # CONFIG_BACKLIGHT_LCD_SUPPORT is not set
>
> #
> # Display device support
> #
> # CONFIG_DISPLAY_SUPPORT is not set
> # CONFIG_VGASTATE is not set
> # CONFIG_VIDEO_OUTPUT_CONTROL is not set
> # CONFIG_FB is not set
>
> #
> # Console display driver support
> #
> CONFIG_VGA_CONSOLE=y
> CONFIG_VGACON_SOFT_SCROLLBACK=y
> CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=128
> CONFIG_VIDEO_SELECT=y
> CONFIG_DUMMY_CONSOLE=y
>
> #
> # Sound
> #
> # CONFIG_SOUND is not set
> CONFIG_HID_SUPPORT=y
> CONFIG_HID=y
> # CONFIG_HID_DEBUG is not set
>
> #
> # USB Input Devices
> #
> CONFIG_USB_HID=y
> # CONFIG_USB_HIDINPUT_POWERBOOK is not set
> # CONFIG_HID_FF is not set
> # CONFIG_USB_HIDDEV is not set
> CONFIG_USB_SUPPORT=y
> CONFIG_USB_ARCH_HAS_HCD=y
> CONFIG_USB_ARCH_HAS_OHCI=y
> CONFIG_USB_ARCH_HAS_EHCI=y
> CONFIG_USB=y
> # CONFIG_USB_DEBUG is not set
>
> #
> # Miscellaneous USB options
> #
> CONFIG_USB_DEVICEFS=y
> # CONFIG_USB_DEVICE_CLASS is not set
> # CONFIG_USB_DYNAMIC_MINORS is not set
> # CONFIG_USB_SUSPEND is not set
> CONFIG_USB_PERSIST=y
> # CONFIG_USB_OTG is not set
>
> #
> # USB Host Controller Drivers
> #
> CONFIG_USB_EHCI_HCD=y
> # CONFIG_USB_EHCI_SPLIT_ISO is not set
> # CONFIG_USB_EHCI_ROOT_HUB_TT is not set
> # CONFIG_USB_EHCI_TT_NEWSCHED is not set
> # CONFIG_USB_ISP116X_HCD is not set
> CONFIG_USB_OHCI_HCD=y
> # CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
> # CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
> CONFIG_USB_OHCI_LITTLE_ENDIAN=y
> CONFIG_USB_UHCI_HCD=y
> # CONFIG_USB_SL811_HCD is not set
> # CONFIG_USB_R8A66597_HCD is not set
>
> #
> # USB Device Class drivers
> #
> # CONFIG_USB_ACM is not set
> CONFIG_USB_PRINTER=y
>
> #
> # NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
> #
>
> #
> # may also be needed; see USB_STORAGE Help for more information
> #
> CONFIG_USB_STORAGE=y
> # CONFIG_USB_STORAGE_DEBUG is not set
> # CONFIG_USB_STORAGE_DATAFAB is not set
> # CONFIG_USB_STORAGE_FREECOM is not set
> # CONFIG_USB_STORAGE_ISD200 is not set
> # CONFIG_USB_STORAGE_DPCM is not set
> # CONFIG_USB_STORAGE_USBAT is not set
> # CONFIG_USB_STORAGE_SDDR09 is not set
> # CONFIG_USB_STORAGE_SDDR55 is not set
> # CONFIG_USB_STORAGE_JUMPSHOT is not set
> # CONFIG_USB_STORAGE_ALAUDA is not set
> # CONFIG_USB_STORAGE_KARMA is not set
> # CONFIG_USB_LIBUSUAL is not set
>
> #
> # USB Imaging devices
> #
> # CONFIG_USB_MDC800 is not set
> # CONFIG_USB_MICROTEK is not set
> CONFIG_USB_MON=y
>
> #
> # USB port drivers
> #
>
> #
> # USB Serial Converter support
> #
> # CONFIG_USB_SERIAL is not set
>
> #
> # USB Miscellaneous drivers
> #
> # CONFIG_USB_EMI62 is not set
> # CONFIG_USB_EMI26 is not set
> # CONFIG_USB_ADUTUX is not set
> # CONFIG_USB_AUERSWALD is not set
> # CONFIG_USB_RIO500 is not set
> # CONFIG_USB_LEGOTOWER is not set
> # CONFIG_USB_LCD is not set
> # CONFIG_USB_BERRY_CHARGE is not set
> # CONFIG_USB_LED is not set
> # CONFIG_USB_CYPRESS_CY7C63 is not set
> # CONFIG_USB_CYTHERM is not set
> # CONFIG_USB_PHIDGET is not set
> # CONFIG_USB_IDMOUSE is not set
> # CONFIG_USB_FTDI_ELAN is not set
> # CONFIG_USB_APPLEDISPLAY is not set
> # CONFIG_USB_SISUSBVGA is not set
> # CONFIG_USB_LD is not set
> # CONFIG_USB_TRANCEVIBRATOR is not set
> # CONFIG_USB_IOWARRIOR is not set
> # CONFIG_USB_TEST is not set
>
> #
> # USB DSL modem support
> #
>
> #
> # USB Gadget Support
> #
> # CONFIG_USB_GADGET is not set
> # CONFIG_MMC is not set
> # CONFIG_NEW_LEDS is not set
> # CONFIG_INFINIBAND is not set
> # CONFIG_EDAC is not set
>
> #
> # Real Time Clock
> #
> CONFIG_RTC_LIB=y
> CONFIG_RTC_CLASS=y
> CONFIG_RTC_HCTOSYS=y
> CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
> # CONFIG_RTC_DEBUG is not set
>
> #
> # RTC interfaces
> #
> CONFIG_RTC_INTF_SYSFS=y
> CONFIG_RTC_INTF_PROC=y
> CONFIG_RTC_INTF_DEV=y
> # CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
> # CONFIG_RTC_DRV_TEST is not set
>
> #
> # Platform RTC drivers
> #
> CONFIG_RTC_DRV_CMOS=y
> # CONFIG_RTC_DRV_DS1553 is not set
> # CONFIG_RTC_DRV_STK17TA8 is not set
> # CONFIG_RTC_DRV_DS1742 is not set
> # CONFIG_RTC_DRV_M48T86 is not set
> # CONFIG_RTC_DRV_M48T59 is not set
> # CONFIG_RTC_DRV_V3020 is not set
>
> #
> # on-CPU RTC drivers
> #
>
> #
> # DMA Engine support
> #
> # CONFIG_DMA_ENGINE is not set
>
> #
> # DMA Clients
> #
>
> #
> # DMA Devices
> #
> # CONFIG_VIRTUALIZATION is not set
>
> #
> # Userspace I/O
> #
> # CONFIG_UIO is not set
>
> #
> # File systems
> #
> CONFIG_EXT2_FS=y
> CONFIG_EXT2_FS_XATTR=y
> CONFIG_EXT2_FS_POSIX_ACL=y
> # CONFIG_EXT2_FS_SECURITY is not set
> # CONFIG_EXT2_FS_XIP is not set
> CONFIG_EXT3_FS=y
> CONFIG_EXT3_FS_XATTR=y
> CONFIG_EXT3_FS_POSIX_ACL=y
> # CONFIG_EXT3_FS_SECURITY is not set
> CONFIG_EXT4DEV_FS=y
> CONFIG_EXT4DEV_FS_XATTR=y
> CONFIG_EXT4DEV_FS_POSIX_ACL=y
> CONFIG_EXT4DEV_FS_SECURITY=y
> CONFIG_JBD=y
> # CONFIG_JBD_DEBUG is not set
> CONFIG_JBD2=y
> # CONFIG_JBD2_DEBUG is not set
> CONFIG_FS_MBCACHE=y
> CONFIG_REISERFS_FS=y
> # CONFIG_REISERFS_CHECK is not set
> # CONFIG_REISERFS_PROC_INFO is not set
> CONFIG_REISERFS_FS_XATTR=y
> CONFIG_REISERFS_FS_POSIX_ACL=y
> # CONFIG_REISERFS_FS_SECURITY is not set
> CONFIG_JFS_FS=y
> CONFIG_JFS_POSIX_ACL=y
> CONFIG_JFS_SECURITY=y
> # CONFIG_JFS_DEBUG is not set
> CONFIG_JFS_STATISTICS=y
> CONFIG_FS_POSIX_ACL=y
> CONFIG_XFS_FS=y
> CONFIG_XFS_QUOTA=y
> CONFIG_XFS_SECURITY=y
> CONFIG_XFS_POSIX_ACL=y
> CONFIG_XFS_RT=y
> CONFIG_GFS2_FS=y
> CONFIG_GFS2_FS_LOCKING_NOLOCK=y
> CONFIG_GFS2_FS_LOCKING_DLM=y
> # CONFIG_OCFS2_FS is not set
> CONFIG_MINIX_FS=y
> CONFIG_ROMFS_FS=y
> CONFIG_INOTIFY=y
> CONFIG_INOTIFY_USER=y
> # CONFIG_QUOTA is not set
> CONFIG_QUOTACTL=y
> CONFIG_DNOTIFY=y
> # CONFIG_AUTOFS_FS is not set
> CONFIG_AUTOFS4_FS=y
> # CONFIG_FUSE_FS is not set
> CONFIG_GENERIC_ACL=y
>
> #
> # CD-ROM/DVD Filesystems
> #
> CONFIG_ISO9660_FS=y
> CONFIG_JOLIET=y
> CONFIG_ZISOFS=y
> CONFIG_UDF_FS=y
> CONFIG_UDF_NLS=y
>
> #
> # DOS/FAT/NT Filesystems
> #
> CONFIG_FAT_FS=y
> CONFIG_MSDOS_FS=y
> CONFIG_VFAT_FS=y
> CONFIG_FAT_DEFAULT_CODEPAGE=437
> CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
> CONFIG_NTFS_FS=y
> # CONFIG_NTFS_DEBUG is not set
> CONFIG_NTFS_RW=y
>
> #
> # Pseudo filesystems
> #
> CONFIG_PROC_FS=y
> CONFIG_PROC_KCORE=y
> CONFIG_PROC_SYSCTL=y
> CONFIG_SYSFS=y
> CONFIG_TMPFS=y
> CONFIG_TMPFS_POSIX_ACL=y
> CONFIG_HUGETLBFS=y
> CONFIG_HUGETLB_PAGE=y
> CONFIG_RAMFS=y
> CONFIG_CONFIGFS_FS=y
>
> #
> # Miscellaneous filesystems
> #
> CONFIG_ADFS_FS=y
> CONFIG_ADFS_FS_RW=y
> # CONFIG_AFFS_FS is not set
> # CONFIG_HFS_FS is not set
> # CONFIG_HFSPLUS_FS is not set
> # CONFIG_BEFS_FS is not set
> # CONFIG_BFS_FS is not set
> # CONFIG_EFS_FS is not set
> # CONFIG_CRAMFS is not set
> # CONFIG_VXFS_FS is not set
> # CONFIG_HPFS_FS is not set
> # CONFIG_QNX4FS_FS is not set
> # CONFIG_SYSV_FS is not set
> CONFIG_UFS_FS=y
> CONFIG_UFS_FS_WRITE=y
> # CONFIG_UFS_DEBUG is not set
>
> #
> # Network File Systems
> #
> # CONFIG_NFS_FS is not set
> # CONFIG_NFSD is not set
> # CONFIG_SMB_FS is not set
> # CONFIG_CIFS is not set
> # CONFIG_NCP_FS is not set
> # CONFIG_CODA_FS is not set
> # CONFIG_AFS_FS is not set
>
> #
> # Partition Types
> #
> # CONFIG_PARTITION_ADVANCED is not set
> CONFIG_MSDOS_PARTITION=y
>
> #
> # Native Language Support
> #
> CONFIG_NLS=y
> CONFIG_NLS_DEFAULT="iso8859-1"
> CONFIG_NLS_CODEPAGE_437=y
> # CONFIG_NLS_CODEPAGE_737 is not set
> # CONFIG_NLS_CODEPAGE_775 is not set
> # CONFIG_NLS_CODEPAGE_850 is not set
> # CONFIG_NLS_CODEPAGE_852 is not set
> # CONFIG_NLS_CODEPAGE_855 is not set
> # CONFIG_NLS_CODEPAGE_857 is not set
> # CONFIG_NLS_CODEPAGE_860 is not set
> # CONFIG_NLS_CODEPAGE_861 is not set
> # CONFIG_NLS_CODEPAGE_862 is not set
> # CONFIG_NLS_CODEPAGE_863 is not set
> # CONFIG_NLS_CODEPAGE_864 is not set
> # CONFIG_NLS_CODEPAGE_865 is not set
> # CONFIG_NLS_CODEPAGE_866 is not set
> # CONFIG_NLS_CODEPAGE_869 is not set
> # CONFIG_NLS_CODEPAGE_936 is not set
> # CONFIG_NLS_CODEPAGE_950 is not set
> # CONFIG_NLS_CODEPAGE_932 is not set
> # CONFIG_NLS_CODEPAGE_949 is not set
> # CONFIG_NLS_CODEPAGE_874 is not set
> # CONFIG_NLS_ISO8859_8 is not set
> # CONFIG_NLS_CODEPAGE_1250 is not set
> # CONFIG_NLS_CODEPAGE_1251 is not set
> CONFIG_NLS_ASCII=y
> CONFIG_NLS_ISO8859_1=y
> # CONFIG_NLS_ISO8859_2 is not set
> # CONFIG_NLS_ISO8859_3 is not set
> # CONFIG_NLS_ISO8859_4 is not set
> # CONFIG_NLS_ISO8859_5 is not set
> # CONFIG_NLS_ISO8859_6 is not set
> # CONFIG_NLS_ISO8859_7 is not set
> # CONFIG_NLS_ISO8859_9 is not set
> # CONFIG_NLS_ISO8859_13 is not set
> # CONFIG_NLS_ISO8859_14 is not set
> CONFIG_NLS_ISO8859_15=y
> # CONFIG_NLS_KOI8_R is not set
> # CONFIG_NLS_KOI8_U is not set
> CONFIG_NLS_UTF8=y
>
> #
> # Distributed Lock Manager
> #
> CONFIG_DLM=y
> # CONFIG_DLM_DEBUG is not set
> # CONFIG_INSTRUMENTATION is not set
>
> #
> # Kernel hacking
> #
> CONFIG_TRACE_IRQFLAGS_SUPPORT=y
> CONFIG_PRINTK_TIME=y
> CONFIG_ENABLE_MUST_CHECK=y
> CONFIG_MAGIC_SYSRQ=y
> CONFIG_UNUSED_SYMBOLS=y
> CONFIG_DEBUG_FS=y
> CONFIG_HEADERS_CHECK=y
> CONFIG_DEBUG_KERNEL=y
> CONFIG_DEBUG_SHIRQ=y
> CONFIG_DETECT_SOFTLOCKUP=y
> # CONFIG_SCHED_DEBUG is not set
> # CONFIG_SCHEDSTATS is not set
> # CONFIG_TIMER_STATS is not set
> CONFIG_SLUB_DEBUG_ON=y
> CONFIG_DEBUG_PREEMPT=y
> CONFIG_DEBUG_RT_MUTEXES=y
> CONFIG_DEBUG_PI_LIST=y
> CONFIG_RT_MUTEX_TESTER=y
> CONFIG_DEBUG_SPINLOCK=y
> CONFIG_DEBUG_MUTEXES=y
> CONFIG_DEBUG_LOCK_ALLOC=y
> CONFIG_PROVE_LOCKING=y
> CONFIG_LOCKDEP=y
> # CONFIG_LOCK_STAT is not set
> CONFIG_DEBUG_LOCKDEP=y
> CONFIG_TRACE_IRQFLAGS=y
> CONFIG_DEBUG_SPINLOCK_SLEEP=y
> CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
> CONFIG_STACKTRACE=y
> # CONFIG_DEBUG_KOBJECT is not set
> CONFIG_DEBUG_HIGHMEM=y
> CONFIG_DEBUG_BUGVERBOSE=y
> CONFIG_DEBUG_INFO=y
> CONFIG_DEBUG_VM=y
> CONFIG_DEBUG_LIST=y
> CONFIG_FRAME_POINTER=y
> # CONFIG_FORCED_INLINING is not set
> # CONFIG_RCU_TORTURE_TEST is not set
> CONFIG_FAULT_INJECTION=y
> CONFIG_FAILSLAB=y
> CONFIG_FAIL_PAGE_ALLOC=y
> CONFIG_FAIL_MAKE_REQUEST=y
> CONFIG_FAULT_INJECTION_DEBUG_FS=y
> # CONFIG_FAULT_INJECTION_STACKTRACE_FILTER is not set
> CONFIG_EARLY_PRINTK=y
> CONFIG_DEBUG_STACKOVERFLOW=y
> # CONFIG_DEBUG_STACK_USAGE is not set
> CONFIG_DEBUG_RODATA=y
> CONFIG_4KSTACKS=y
> CONFIG_DOUBLEFAULT=y
>
> #
> # Security options
> #
> # CONFIG_KEYS is not set
> # CONFIG_SECURITY is not set
> CONFIG_CRYPTO=y
> CONFIG_CRYPTO_ALGAPI=y
> CONFIG_CRYPTO_ABLKCIPHER=y
> CONFIG_CRYPTO_BLKCIPHER=y
> CONFIG_CRYPTO_HASH=y
> CONFIG_CRYPTO_MANAGER=y
> CONFIG_CRYPTO_HMAC=y
> CONFIG_CRYPTO_XCBC=y
> CONFIG_CRYPTO_NULL=y
> CONFIG_CRYPTO_MD4=y
> CONFIG_CRYPTO_MD5=y
> CONFIG_CRYPTO_SHA1=y
> CONFIG_CRYPTO_SHA256=y
> CONFIG_CRYPTO_SHA512=y
> CONFIG_CRYPTO_WP512=y
> CONFIG_CRYPTO_TGR192=y
> CONFIG_CRYPTO_GF128MUL=y
> CONFIG_CRYPTO_ECB=y
> CONFIG_CRYPTO_CBC=y
> CONFIG_CRYPTO_PCBC=y
> CONFIG_CRYPTO_LRW=y
> CONFIG_CRYPTO_CRYPTD=y
> CONFIG_CRYPTO_DES=y
> CONFIG_CRYPTO_FCRYPT=y
> CONFIG_CRYPTO_BLOWFISH=y
> CONFIG_CRYPTO_TWOFISH=y
> CONFIG_CRYPTO_TWOFISH_COMMON=y
> CONFIG_CRYPTO_TWOFISH_586=y
> CONFIG_CRYPTO_SERPENT=y
> CONFIG_CRYPTO_AES=y
> CONFIG_CRYPTO_AES_586=y
> CONFIG_CRYPTO_CAST5=y
> CONFIG_CRYPTO_CAST6=y
> CONFIG_CRYPTO_TEA=y
> CONFIG_CRYPTO_ARC4=y
> CONFIG_CRYPTO_KHAZAD=y
> CONFIG_CRYPTO_ANUBIS=y
> CONFIG_CRYPTO_DEFLATE=y
> CONFIG_CRYPTO_MICHAEL_MIC=y
> CONFIG_CRYPTO_CRC32C=y
> CONFIG_CRYPTO_CAMELLIA=y
> # CONFIG_CRYPTO_TEST is not set
> # CONFIG_CRYPTO_HW is not set
>
> #
> # Library routines
> #
> CONFIG_BITREVERSE=y
> CONFIG_CRC_CCITT=y
> CONFIG_CRC16=y
> CONFIG_CRC_ITU_T=y
> CONFIG_CRC32=y
> CONFIG_CRC7=y
> CONFIG_LIBCRC32C=y
> CONFIG_ZLIB_INFLATE=y
> CONFIG_ZLIB_DEFLATE=y
> CONFIG_TEXTSEARCH=y
> CONFIG_TEXTSEARCH_KMP=y
> CONFIG_TEXTSEARCH_BM=y
> CONFIG_TEXTSEARCH_FSM=y
> CONFIG_PLIST=y
> CONFIG_HAS_IOMEM=y
> CONFIG_HAS_IOPORT=y
> CONFIG_HAS_DMA=y
> CONFIG_GENERIC_HARDIRQS=y
> CONFIG_GENERIC_IRQ_PROBE=y
> CONFIG_X86_BIOS_REBOOT=y
> CONFIG_KTIME_SCALAR=y
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
