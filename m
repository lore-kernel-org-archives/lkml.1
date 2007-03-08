Return-Path: <linux-kernel-owner+w=401wt.eu-S1751615AbXCHMbd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751615AbXCHMbd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 07:31:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751644AbXCHMbd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 07:31:33 -0500
Received: from p02c11o146.mxlogic.net ([208.65.145.69]:38537 "EHLO
	p02c11o146.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615AbXCHMb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 07:31:29 -0500
Date: Thu, 8 Mar 2007 14:31:43 +0200
From: "Michael S. Tsirkin" <mst@mellanox.co.il>
To: Adrian Bunk <bunk@stusta.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Jeff Chua <jeff.chua.linux@gmail.com>, pavel@suse.cz,
       linux-pm@lists.osdl.org, lenb@kernel.org, linux-acpi@vger.kernel.org,
       luming.yu@intel.com, Arkadiusz Miskiewicz <arekm@maven.pl>,
       Konstantin Karasyov <konstantin.a.karasyov@intel.com>, greg@kroah.com,
       linux-usb-devel@lists.sourceforge.net, Thomas Meyer <thomas.mey@web.de>,
       Meelis Roos <mroos@linux.ee>,
       Alexey Starikovskiy <alexey.y.starikovskiy@linux.intel.com>,
       Janosch Machowinski <jmachowinski@gmx.de>, vladimir.p.lebedev@intel.com,
       Ash Milsted <thatistosayiseenem@gawab.com>, dmitry.torokhov@gmail.com,
       linux-input@atrey.karlin.mff.cuni.cz
Subject: Re: [2/6] 2.6.21-rc2: known regressions
Message-ID: <20070308123143.GF5149@mellanox.co.il>
Reply-To: "Michael S. Tsirkin" <mst@mellanox.co.il>
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org> <20070305015034.GG3441@stusta.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="JP+T4n/bALQSJXh8"
Content-Disposition: inline
In-Reply-To: <20070305015034.GG3441@stusta.de>
User-Agent: Mutt/1.5.11
X-OriginalArrivalTime: 08 Mar 2007 12:33:51.0259 (UTC) FILETIME=[06E1E6B0:01C7617E]
X-TM-AS-Product-Ver: SMEX-7.0.0.1526-3.6.1039-15040.003
X-TM-AS-Result: No--9.711300-4.000000-31
X-Spam: [F=0.5001707539; S=0.500(2007030701)]
X-MAIL-FROM: <mst@mellanox.co.il>
X-SOURCE-IP: [194.90.237.34]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



--JP+T4n/bALQSJXh8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

> Quoting Adrian Bunk <bunk@stusta.de>:
> Subject: [2/6] 2.6.21-rc2: known regressions
> 
> Subject    : ThinkPad T60: no screen after suspend to RAM
> References : http://lkml.org/lkml/2007/2/22/391
> Submitter  : Michael S. Tsirkin <mst@mellanox.co.il>
> Status     : unknown

Here's the status with -rc3: better, but still does not work as well as 2.6.20.

1. Switching to console VT, and running s2ram, I am able to resume to console
   (I have not tested with echo mem > /sys/power/state yet, both work OK
    with 2.6.20)
   This seems to take about as long as with 2.6.20.
   During this time, I see some messages on console (see attached log)

2. First disk access after resume takes a couple of minutes
   (seemed instant with 2.6.20) during this time no new messages show on console

3. When I switch to X (CTRL-ALT-F7), X hangs after drawing a couple of windows
   after waiting for some 10 min, I rebooted.
   no new messages showed up in /var/log/messages

log attached
   
-- 
MST


--JP+T4n/bALQSJXh8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=newlog

Mar  8 08:47:20 localhost kernel: Inspecting /boot/System.map-2.6.21-rc3-work
Mar  8 08:47:20 localhost kernel: Loaded 31265 symbols from /boot/System.map-2.6.21-rc3-work.
Mar  8 08:47:20 localhost kernel: Symbols match kernel version 2.6.21.
Mar  8 08:47:20 localhost kernel: No module symbols loaded - kernel modules not enabled. 
Mar  8 08:47:20 localhost kernel: 1
Mar  8 08:47:20 localhost kernel: [   15.317823] ata2: SATA link down (SStatus 0 SControl 0)
Mar  8 08:47:20 localhost kernel: [   15.317897] scsi2 : ahci
Mar  8 08:47:20 localhost kernel: [   15.379836] ata3: SATA link down (SStatus 0 SControl 0)
Mar  8 08:47:20 localhost kernel: [   15.379909] scsi3 : ahci
Mar  8 08:47:20 localhost kernel: [   15.441854] ata4: SATA link down (SStatus 0 SControl 0)
Mar  8 08:47:20 localhost kernel: [   15.441999] scsi 0:0:0:0: Direct-Access     ATA      HTS541080G9SA00  MB4I PQ: 0 ANSI: 5
Mar  8 08:47:20 localhost kernel: [   15.442216] SCSI device sda: 156301488 512-byte hdwr sectors (80026 MB)
Mar  8 08:47:20 localhost kernel: [   15.442292] sda: Write Protect is off
Mar  8 08:47:20 localhost kernel: [   15.443138] SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Mar  8 08:47:20 localhost kernel: [   15.443256] SCSI device sda: 156301488 512-byte hdwr sectors (80026 MB)
Mar  8 08:47:20 localhost kernel: [   15.443330] sda: Write Protect is off
Mar  8 08:47:20 localhost kernel: [   15.443406] SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Mar  8 08:47:20 localhost kernel: [   15.443490]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
Mar  8 08:47:20 localhost kernel: [   15.845145] sd 0:0:0:0: Attached scsi disk sda
Mar  8 08:47:20 localhost kernel: [   15.845290] sd 0:0:0:0: Attached scsi generic sg0 type 0
Mar  8 08:47:20 localhost kernel: [   15.845797] ACPI: PCI Interrupt 0000:00:1d.7[D] -> GSI 19 (level, low) -> IRQ 21
Mar  8 08:47:20 localhost kernel: [   15.845946] ehci_hcd 0000:00:1d.7: EHCI Host Controller
Mar  8 08:47:20 localhost kernel: [   15.846106] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
Mar  8 08:47:20 localhost kernel: [   15.846229] ehci_hcd 0000:00:1d.7: debug port 1
Mar  8 08:47:20 localhost kernel: [   15.846315] ehci_hcd 0000:00:1d.7: irq 21, io mem 0xee444000
Mar  8 08:47:20 localhost kernel: [   15.850269] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
Mar  8 08:47:20 localhost kernel: [   15.850508] usb usb1: configuration #1 chosen from 1 choice
Mar  8 08:47:20 localhost kernel: [   15.850630] hub 1-0:1.0: USB hub found
Mar  8 08:47:20 localhost kernel: [   15.850697] hub 1-0:1.0: 8 ports detected
Mar  8 08:47:20 localhost kernel: [   15.862005] USB Universal Host Controller Interface driver v3.0
Mar  8 08:47:20 localhost kernel: [   15.862135] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 16 (level, low) -> IRQ 20
Mar  8 08:47:20 localhost kernel: [   15.862268] uhci_hcd 0000:00:1d.0: UHCI Host Controller
Mar  8 08:47:20 localhost kernel: [   15.862381] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
Mar  8 08:47:20 localhost kernel: [   15.862484] uhci_hcd 0000:00:1d.0: irq 20, io base 0x00001820
Mar  8 08:47:20 localhost kernel: [   15.862702] usb usb2: configuration #1 chosen from 1 choice
Mar  8 08:47:20 localhost kernel: [   15.862821] hub 2-0:1.0: USB hub found
Mar  8 08:47:20 localhost kernel: [   15.862887] hub 2-0:1.0: 2 ports detected
Mar  8 08:47:20 localhost kernel: [   15.892543] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 17 (level, low) -> IRQ 22
Mar  8 08:47:20 localhost kernel: [   15.892676] uhci_hcd 0000:00:1d.1: UHCI Host Controller
Mar  8 08:47:20 localhost kernel: [   15.892789] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
Mar  8 08:47:20 localhost kernel: [   15.892894] uhci_hcd 0000:00:1d.1: irq 22, io base 0x00001840
Mar  8 08:47:20 localhost kernel: [   15.893113] usb usb3: configuration #1 chosen from 1 choice
Mar  8 08:47:20 localhost kernel: [   15.893229] hub 3-0:1.0: USB hub found
Mar  8 08:47:20 localhost kernel: [   15.893296] hub 3-0:1.0: 2 ports detected
Mar  8 08:47:20 localhost kernel: [   15.933182] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 23
Mar  8 08:47:20 localhost kernel: [   15.933314] uhci_hcd 0000:00:1d.2: UHCI Host Controller
Mar  8 08:47:20 localhost kernel: [   15.933427] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
Mar  8 08:47:20 localhost kernel: [   15.933577] uhci_hcd 0000:00:1d.2: irq 23, io base 0x00001860
Mar  8 08:47:20 localhost kernel: [   15.933797] usb usb4: configuration #1 chosen from 1 choice
Mar  8 08:47:20 localhost kernel: [   15.933915] hub 4-0:1.0: USB hub found
Mar  8 08:47:20 localhost kernel: [   15.933981] hub 4-0:1.0: 2 ports detected
Mar  8 08:47:20 localhost kernel: [   15.976494] ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 19 (level, low) -> IRQ 21
Mar  8 08:47:20 localhost kernel: [   15.976627] uhci_hcd 0000:00:1d.3: UHCI Host Controller
Mar  8 08:47:20 localhost kernel: [   15.976740] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
Mar  8 08:47:20 localhost kernel: [   15.976843] uhci_hcd 0000:00:1d.3: irq 21, io base 0x00001880
Mar  8 08:47:20 localhost kernel: [   15.977060] usb usb5: configuration #1 chosen from 1 choice
Mar  8 08:47:20 localhost kernel: [   15.977196] hub 5-0:1.0: USB hub found
Mar  8 08:47:20 localhost kernel: [   15.977263] hub 5-0:1.0: 2 ports detected
Mar  8 08:47:20 localhost kernel: [   16.040824] Initializing USB Mass Storage driver...
Mar  8 08:47:20 localhost kernel: [   16.157808] usb 5-2: new full speed USB device using uhci_hcd and address 2
Mar  8 08:47:20 localhost kernel: [   16.221329] usb 5-2: configuration #1 chosen from 1 choice
Mar  8 08:47:20 localhost kernel: [   16.224625] usbcore: registered new interface driver usb-storage
Mar  8 08:47:20 localhost kernel: [   16.224692] USB Mass Storage support registered.
Mar  8 08:47:20 localhost kernel: [   16.224886] PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
Mar  8 08:47:20 localhost kernel: [   16.233142] serio: i8042 KBD port at 0x60,0x64 irq 1
Mar  8 08:47:20 localhost kernel: [   16.233211] serio: i8042 AUX port at 0x60,0x64 irq 12
Mar  8 08:47:20 localhost kernel: [   16.233366] mice: PS/2 mouse device common for all mice
Mar  8 08:47:20 localhost kernel: [   16.233716] Advanced Linux Sound Architecture Driver Version 1.0.14rc3 (Tue Mar 06 13:10:00 2007 UTC).
Mar  8 08:47:20 localhost kernel: [   16.234221] ACPI: PCI Interrupt 0000:00:1b.0[B] -> GSI 17 (level, low) -> IRQ 22
Mar  8 08:47:20 localhost kernel: [   16.236937] input: AT Translated Set 2 keyboard as /class/input/input3
Mar  8 08:47:20 localhost kernel: [   16.444361] ALSA device list:
Mar  8 08:47:20 localhost kernel: [   16.444428]   #0: HDA Intel at 0xee240000 irq 22
Mar  8 08:47:20 localhost kernel: [   16.444525] nf_conntrack version 0.5.0 (7168 buckets, 57344 max)
Mar  8 08:47:20 localhost kernel: [   16.444736] ip_tables: (C) 2000-2006 Netfilter Core Team
Mar  8 08:47:20 localhost kernel: [   16.444809] TCP cubic registered
Mar  8 08:47:20 localhost kernel: [   16.444887] NET: Registered protocol family 1
Mar  8 08:47:20 localhost kernel: [   16.444953] NET: Registered protocol family 17
Mar  8 08:47:20 localhost kernel: [   16.445019] ieee80211: 802.11 data/management/control stack, git-1.1.13
Mar  8 08:47:20 localhost kernel: [   16.445087] ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
Mar  8 08:47:20 localhost kernel: [   16.445185] Starting balanced_irq
Mar  8 08:47:20 localhost kernel: [   16.445254] Using IPI No-Shortcut mode
Mar  8 08:47:20 localhost kernel: [   16.472663] kjournald starting.  Commit interval 5 seconds
Mar  8 08:47:20 localhost kernel: [   16.472735] EXT3-fs: mounted filesystem with ordered data mode.
Mar  8 08:47:20 localhost kernel: [   16.472864] VFS: Mounted root (ext3 filesystem) readonly.
Mar  8 08:47:20 localhost kernel: [   16.473029] Freeing unused kernel memory: 184k freed
Mar  8 08:47:20 localhost kernel: [   16.473122] Write protecting the kernel read-only data: 902k
Mar  8 08:47:20 localhost kernel: [   24.658491] Intel(R) PRO/1000 Network Driver - version 7.3.20-k2
Mar  8 08:47:20 localhost kernel: [   24.658576] Copyright (c) 1999-2006 Intel Corporation.
Mar  8 08:47:20 localhost kernel: [   24.658761] ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 16 (level, low) -> IRQ 20
Mar  8 08:47:20 localhost kernel: [   24.733801] e1000: 0000:02:00.0: e1000_probe: (PCI Express:2.5Gb/s:Width x1) 00:16:41:54:6c:47
Mar  8 08:47:20 localhost kernel: [   24.815441] e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
Mar  8 08:47:20 localhost kernel: [   25.282292] Adding 1951824k swap on /dev/sda6.  Priority:-1 extents:1 across:1951824k
Mar  8 08:47:20 localhost kernel: [   25.343370] EXT3 FS on sda3, internal journal
Mar  8 08:47:20 localhost kernel: [   25.697608] Synaptics Touchpad, model: 1, fw: 6.2, id: 0x81a0b1, caps: 0xa04793/0x300000
Mar  8 08:47:20 localhost kernel: [   25.697710] serio: Synaptics pass-through port at isa0060/serio1/input0
Mar  8 08:47:20 localhost kernel: [   25.742946] input: SynPS/2 Synaptics TouchPad as /class/input/input4
Mar  8 08:47:20 localhost kernel: [   30.419349] NTFS volume version 3.1.
Mar  8 08:47:20 localhost kernel: [   31.156204] IBM TrackPoint firmware: 0x0e, buttons: 3/3
Mar  8 08:47:20 localhost kernel: [   31.426442] input: TPPS/2 IBM TrackPoint as /class/input/input5
Mar  8 08:47:22 localhost hpiod: 0.9.7 accepting connections at 50899... 
Mar  8 08:47:26 localhost kernel: [   39.389386] [drm] Initialized i915 1.6.0 20060119 on minor 0
Mar  8 08:48:07 localhost kernel: <1] pcieport-driver 0000:00:1c.3: LATE suspend
Mar  8 08:48:07 localhost kernel: [    2.183443] Intel machine check architecture supported.
Mar  8 08:48:07 localhost kernel: [    2.183451] Intel machine check reporting enabled on CPU#0.
Mar  8 08:48:07 localhost kernel: [    2.183982] Enabling non-boot CPUs ...
Mar  8 08:48:07 localhost kernel: [    2.321035] SMP alternatives: switching to SMP code
Mar  8 08:48:07 localhost kernel: [    2.321241] Booting processor 1/1 eip 3000
Mar  8 08:48:07 localhost kernel: [    2.332199] Initializing CPU#1
Mar  8 08:48:07 localhost kernel: [    3.143727] Calibrating delay using timer specific routine.. 20089.15 BogoMIPS (lpj=100445793)
Mar  8 08:48:07 localhost kernel: [    3.143746] monitor/mwait feature present.
Mar  8 08:48:07 localhost kernel: [    3.143751] CPU: L1 I cache: 32K, L1 D cache: 32K
Mar  8 08:48:07 localhost kernel: [    3.143755] CPU: L2 cache: 2048K
Mar  8 08:48:07 localhost kernel: [    3.143759] CPU: Physical Processor ID: 0
Mar  8 08:48:07 localhost kernel: [    3.143761] CPU: Processor Core ID: 1
Mar  8 08:48:07 localhost kernel: [    3.143774] Intel machine check architecture supported.
Mar  8 08:48:07 localhost kernel: [    3.143783] Intel machine check reporting enabled on CPU#1.
Mar  8 08:48:07 localhost kernel: [    3.144104] CPU1: Intel Genuine Intel(R) CPU           T2400  @ 1.83GHz stepping 08
Mar  8 08:48:07 localhost kernel: [    3.144892] speedstep-centrino with X86_SPEEDSTEP_CENTRINO_ACPI config is deprecated.
Mar  8 08:48:07 localhost kernel: [    3.144896]  Use X86_ACPI_CPUFREQ (acpi-cpufreq) instead.
Mar  8 08:48:07 localhost kernel: [    3.144936] CPU1 is up
Mar  8 08:48:07 localhost kernel: [    3.440273] ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 20
Mar  8 08:48:07 localhost kernel: [    3.527272] ACPI: PCI Interrupt 0000:00:1b.0[B] -> GSI 17 (level, low) -> IRQ 22
Mar  8 08:48:07 localhost kernel: [    3.912917] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 16 (level, low) -> IRQ 20
Mar  8 08:48:07 localhost kernel: [    3.912966] usb usb2: root hub lost power or was reset
Mar  8 08:48:07 localhost kernel: [    3.912988] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 17 (level, low) -> IRQ 22
Mar  8 08:48:07 localhost kernel: [    3.913036] usb usb3: root hub lost power or was reset
Mar  8 08:48:07 localhost kernel: [    3.913055] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 23
Mar  8 08:48:07 localhost kernel: [    3.913102] usb usb4: root hub lost power or was reset
Mar  8 08:48:07 localhost kernel: [    3.913120] ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 19 (level, low) -> IRQ 21
Mar  8 08:48:07 localhost kernel: [    3.913168] usb usb5: root hub lost power or was reset
Mar  8 08:48:07 localhost kernel: [    3.914015] ACPI: PCI Interrupt 0000:00:1d.7[D] -> GSI 19 (level, low) -> IRQ 21
Mar  8 08:48:07 localhost kernel: [    3.914205] ACPI: PCI Interrupt 0000:00:1f.1[C] -> GSI 16 (level, low) -> IRQ 20
Mar  8 08:48:07 localhost kernel: [    3.914407] ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 16 (level, low) -> IRQ 20
Mar  8 08:48:07 localhost kernel: [    3.922880] ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 16 (level, low) -> IRQ 20
Mar  8 08:48:07 localhost kernel: [    3.928614] ACPI: PCI Interrupt 0000:15:00.0[A] -> GSI 16 (level, low) -> IRQ 20
Mar  8 08:48:07 localhost kernel: [    3.928638] pnp: Device 00:08 does not support activation.
Mar  8 08:48:07 localhost kernel: [    3.928641] pnp: Device 00:09 does not support activation.
Mar  8 08:48:07 localhost kernel: [    4.209165] ata2: SATA link down (SStatus 0 SControl 0)
Mar  8 08:48:07 localhost kernel: [    4.209179] ata3: SATA link down (SStatus 0 SControl 0)
Mar  8 08:48:07 localhost kernel: [    4.209191] ata4: SATA link down (SStatus 0 SControl 0)
Mar  8 08:48:07 localhost kernel: [    4.849894] atkbd.c: Unknown key released (translated set 2, code 0xe0 on isa0060/serio0).
Mar  8 08:48:07 localhost kernel: [    4.849896] atkbd.c: Use 'setkeycodes e060 <keycode>' to make it known.
Mar  8 08:48:07 localhost kernel: [    4.850297] atkbd.c: Unknown key pressed (translated set 2, code 0x63 on isa0060/serio0).
Mar  8 08:48:07 localhost kernel: [    4.850300] atkbd.c: Use 'setkeycodes 63 <keycode>' to make it known.
Mar  8 08:48:07 localhost kernel: [    5.826771] Restarting tasks ... <6>usb 5-2: USB disconnect, address 2
Mar  8 08:48:07 localhost kernel: [    5.839206] done.
Mar  8 08:48:07 localhost kernel: [    6.702776] ata1: waiting for device to spin up (7 secs)
Mar  8 08:48:07 localhost kernel: [    6.775788] usb 5-2: new full speed USB device using uhci_hcd and address 3
Mar  8 08:48:07 localhost kernel: [    6.866806] usb 5-2: configuration #1 chosen from 1 choice
Mar  8 08:48:07 localhost kernel: [   11.334773] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Mar  8 08:48:07 localhost kernel: [   11.673734] ata1.00: configured for UDMA/100
Mar  8 08:48:07 localhost kernel: [   11.696311] SCSI device sda: 156301488 512-byte hdwr sectors (80026 MB)
Mar  8 08:48:07 localhost kernel: [   11.697691] sda: Write Protect is off
Mar  8 08:48:07 localhost kernel: [   11.708467] SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Mar  8 08:48:16 localhost kernel: <>[   19.841599] button button_power:00: suspend
Mar  8 08:48:16 localhost kernel: [   19.841607] Disabling non-boot CPUs ...
Mar  8 08:48:16 localhost kernel: [   19.847811] Breaking affinity for irq 12
Mar  8 08:48:16 localhost kernel: [   20.444974] CPU 1 is now offline
Mar  8 08:48:16 localhost kernel: [   20.444980] SMP alternatives: switching to UP code
Mar  8 08:48:16 localhost kernel: [   20.445823] CPU1 is down
Mar  8 08:48:16 localhost kernel: [    2.423903] Intel machine check architecture supported.
Mar  8 08:48:16 localhost kernel: [    2.423911] Intel machine check reporting enabled on CPU#0.
Mar  8 08:48:16 localhost kernel: [    2.424444] Enabling non-boot CPUs ...
Mar  8 08:48:16 localhost kernel: [    2.534642] SMP alternatives: switching to SMP code
Mar  8 08:48:16 localhost kernel: [    2.534847] Booting processor 1/1 eip 3000
Mar  8 08:48:16 localhost kernel: [    2.545805] Initializing CPU#1
Mar  8 08:48:16 localhost kernel: [    3.357337] Calibrating delay using timer specific routine.. 20089.13 BogoMIPS (lpj=100445659)
Mar  8 08:48:16 localhost kernel: [    3.357357] monitor/mwait feature present.
Mar  8 08:48:16 localhost kernel: [    3.357362] CPU: L1 I cache: 32K, L1 D cache: 32K
Mar  8 08:48:16 localhost kernel: [    3.357365] CPU: L2 cache: 2048K
Mar  8 08:48:16 localhost kernel: [    3.357369] CPU: Physical Processor ID: 0
Mar  8 08:48:16 localhost kernel: [    3.357372] CPU: Processor Core ID: 1
Mar  8 08:48:16 localhost kernel: [    3.357384] Intel machine check architecture supported.
Mar  8 08:48:16 localhost kernel: [    3.357394] Intel machine check reporting enabled on CPU#1.
Mar  8 08:48:16 localhost kernel: [    3.357711] CPU1: Intel Genuine Intel(R) CPU           T2400  @ 1.83GHz stepping 08
Mar  8 08:48:16 localhost kernel: [    3.358503] speedstep-centrino with X86_SPEEDSTEP_CENTRINO_ACPI config is deprecated.
Mar  8 08:48:16 localhost kernel: [    3.358507]  Use X86_ACPI_CPUFREQ (acpi-cpufreq) instead.
Mar  8 08:48:16 localhost kernel: [    3.358548] CPU1 is up
Mar  8 08:48:16 localhost kernel: [    3.653795] ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 20
Mar  8 08:48:16 localhost kernel: [    3.740900] ACPI: PCI Interrupt 0000:00:1b.0[B] -> GSI 17 (level, low) -> IRQ 22
Mar  8 08:48:16 localhost kernel: [    4.126569] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 16 (level, low) -> IRQ 20
Mar  8 08:48:16 localhost kernel: [    4.126619] usb usb2: root hub lost power or was reset
Mar  8 08:48:16 localhost kernel: [    4.126639] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 17 (level, low) -> IRQ 22
Mar  8 08:48:16 localhost kernel: [    4.126686] usb usb3: root hub lost power or was reset
Mar  8 08:48:16 localhost kernel: [    4.126705] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 23
Mar  8 08:48:16 localhost kernel: [    4.126752] usb usb4: root hub lost power or was reset
Mar  8 08:48:16 localhost kernel: [    4.126772] ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 19 (level, low) -> IRQ 21
Mar  8 08:48:16 localhost kernel: [    4.126819] usb usb5: root hub lost power or was reset
Mar  8 08:48:16 localhost kernel: [    4.127659] ACPI: PCI Interrupt 0000:00:1d.7[D] -> GSI 19 (level, low) -> IRQ 21
Mar  8 08:48:16 localhost kernel: [    4.127848] ACPI: PCI Interrupt 0000:00:1f.1[C] -> GSI 16 (level, low) -> IRQ 20
Mar  8 08:48:16 localhost kernel: [    4.128049] ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 16 (level, low) -> IRQ 20
Mar  8 08:48:16 localhost kernel: [    4.136510] ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 16 (level, low) -> IRQ 20
Mar  8 08:48:16 localhost kernel: [    4.142247] ACPI: PCI Interrupt 0000:15:00.0[A] -> GSI 16 (level, low) -> IRQ 20
Mar  8 08:48:16 localhost kernel: [    4.142271] pnp: Device 00:08 does not support activation.
Mar  8 08:48:16 localhost kernel: [    4.142274] pnp: Device 00:09 does not support activation.
Mar  8 08:48:16 localhost kernel: [    4.421975] ata2: SATA link down (SStatus 0 SControl 0)
Mar  8 08:48:16 localhost kernel: [    4.421989] ata3: SATA link down (SStatus 0 SControl 0)
Mar  8 08:48:16 localhost kernel: [    4.422001] ata4: SATA link down (SStatus 0 SControl 0)
Mar  8 08:48:16 localhost kernel: [    5.971047] Restarting tasks ... done.
Mar  8 08:48:16 localhost kernel: [    6.012513] usb 5-2: USB disconnect, address 3
Mar  8 08:48:16 localhost kernel: [    6.891677] ata1: waiting for device to spin up (7 secs)
Mar  8 08:48:16 localhost kernel: [    6.958587] usb 5-2: new full speed USB device using uhci_hcd and address 4
Mar  8 08:48:16 localhost kernel: [    7.049506] usb 5-2: configuration #1 chosen from 1 choice
Mar  8 08:48:16 localhost kernel: [   11.547844] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Mar  8 08:48:16 localhost kernel: [   11.885459] ata1.00: configured for UDMA/100
Mar  8 08:48:16 localhost kernel: [   11.913910] SCSI device sda: 156301488 512-byte hdwr sectors (80026 MB)
Mar  8 08:48:16 localhost kernel: [   11.914575] sda: Write Protect is off
Mar  8 08:48:16 localhost kernel: [   11.914868] SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Mar  8 08:48:16 localhost shutdown[4092]: shutting down for system halt


--JP+T4n/bALQSJXh8--
