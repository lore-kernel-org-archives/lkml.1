Return-Path: <linux-kernel-owner+w=401wt.eu-S1755569Ab0AFTMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569Ab0AFTMm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 14:12:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754698Ab0AFTMm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 14:12:42 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:55330 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754565Ab0AFTMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 14:12:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nmGF/iF8lgXQpua4uy51favliUvKkzVmA4w2w/+wk5EEppFD+2QaTwVRH38W6AEwE9
         vo+sRd3auyCYk9SgXzKOxEEzbpUkECYaxpIZEzjZfuivl7saJIT6VzidD4f59t/tMbbe
         h8QZ3J7ygIyqo+wP/s+YAN4ynhxn7UsddLtUI=
Date: Wed, 6 Jan 2010 20:12:34 +0100
From: Johan Hovold <jhovold@gmail.com>
To: James Simmons <jsimmons@infradead.org>
Cc: Dave Airlie <airlied@redhat.com>, dri-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm/kms: fix fbdev blanking regression
Message-ID: <20100106191234.GE10442@localhost>
References: <1262797226-9593-1-git-send-email-jhovold@gmail.com>
 <1262797226-9593-2-git-send-email-jhovold@gmail.com>
 <alpine.LFD.2.00.1001061710510.5372@casper.infradead.org>
 <20100106180950.GD10442@localhost>
 <alpine.LFD.2.00.1001061814360.5372@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1001061814360.5372@casper.infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yeap. The fix uncovered a bug in your driver. I haven't heard of problems 
> with the other drm drivers.
>  
> > The backlight is handled via the DRI driver I assume. At least
> > i9xx_crtc_dpms is called on powerdown.
> 
> Can you post your dmesg and kernel config.

<...>
able entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (000377fe:0007dc00)
[    0.000000] Memory: 2027844k/2060288k available (3604k kernel code, 28216k reserved, 1725k data, 424k init, 1148192k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff91000 - 0xfffff000   ( 440 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
[    0.000000]       .init : 0xc1535000 - 0xc159f000   ( 424 kB)
[    0.000000]       .data : 0xc1385261 - 0xc1534788   (1725 kB)
[    0.000000]       .text : 0xc1000000 - 0xc1385261   (3604 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:320
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 3567 kB
[    0.000000]  per task-struct memory footprint: 1152 bytes
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 1994.630 MHz processor.
[    0.001020] Calibrating delay loop (skipped), value calculated using timer frequency.. 3989.26 BogoMIPS (lpj=1994630)
[    0.002118] Mount-cache hash table entries: 512
[    0.003434] CPU: Physical Processor ID: 0
[    0.003436] CPU: Processor Core ID: 0
[    0.003440] mce: CPU supports 6 MCE banks
[    0.003449] CPU0: Thermal monitoring enabled (TM2)
[    0.003453] using mwait in idle threads.
[    0.003460] Performance Events: Core2 events, Intel PMU driver.
[    0.003484] ... version:                2
[    0.003486] ... bit width:              40
[    0.003488] ... generic registers:      2
[    0.003491] ... value mask:             000000ffffffffff
[    0.003493] ... max period:             000000007fffffff
[    0.003495] ... fixed-purpose events:   3
[    0.003497] ... event mask:             0000000700000003
[    0.003504] Checking 'hlt' instruction... OK.
[    0.007633] ACPI: Core revision 20091214
[    0.024012] ftrace: converting mcount calls to 0f 1f 44 00 00
[    0.024019] ftrace: allocating 14787 entries in 29 pages
[    0.026232] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.036241] CPU0: Intel(R) Core(TM)2 Duo CPU     T5870  @ 2.00GHz stepping 0d
[    0.042015] lockdep: fixing up alternatives.
[    0.042187] Booting Node   0, Processors  #1 Ok.
[    0.001999] Initializing CPU#1
[    0.114078] Brought up 2 CPUs
[    0.114081] Total of 2 processors activated (7979.06 BogoMIPS).
[    0.117635] NET: Registered protocol family 16
[    0.118112] ACPI: bus type pci registered
[    0.118126] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.118130] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.118132] PCI: Using MMCONFIG for extended config space
[    0.118135] PCI: Using configuration type 1 for base access
[    0.124233] bio: create slab <bio-0> at 0
[    0.131191] ACPI: EC: Look up EC in DSDT
[    0.142257] ACPI: BIOS _OSI(Linux) query ignored
[    0.148588] ACPI: SSDT 7db1ac20 002A7 (v01  PmRef  Cpu0Ist 00003000 INTL 20050624)
[    0.165198] ACPI: SSDT 7db18620 00568 (v01  PmRef  Cpu0Cst 00003001 INTL 20050624)
[    0.167641] ACPI: SSDT 7db19ca0 001CF (v01  PmRef    ApIst 00003000 INTL 20050624)
[    0.169249] ACPI: SSDT 7db19f20 0008D (v01  PmRef    ApCst 00003000 INTL 20050624)
[    0.172797] ACPI: Interpreter enabled
[    0.172805] ACPI: (supports S0 S3 S4 S5)
[    0.172872] ACPI: Using IOAPIC for interrupt routing
[    0.358616] ACPI: EC: GPE = 0x1c, I/O: command/status = 0x66, data = 0x62
[    0.359609] ACPI: No dock devices found.
[    0.360665] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.360784] pci_root PNP0A08:00: ignoring host bridge windows from ACPI; boot with "pci=use_crs" to use them
[    0.362530] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    0.362534] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    0.362538] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    0.362543] pci_root PNP0A08:00: host bridge window [mem 0x000d4000-0x000d7fff] (ignored)
[    0.362547] pci_root PNP0A08:00: host bridge window [mem 0x80000000-0xdfffffff] (ignored)
[    0.362552] pci_root PNP0A08:00: host bridge window [mem 0xf0000000-0xfebfffff] (ignored)
[    0.362730] pci 0000:00:02.0: reg 10: [mem 0xf6800000-0xf6bfffff 64bit]
[    0.362743] pci 0000:00:02.0: reg 18: [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.362750] pci 0000:00:02.0: reg 20: [io  0x1800-0x1807]
[    0.362814] pci 0000:00:02.1: reg 10: [mem 0xf6100000-0xf61fffff 64bit]
[    0.362989] pci 0000:00:1a.0: reg 20: [io  0x1820-0x183f]
[    0.363116] pci 0000:00:1a.1: reg 20: [io  0x1840-0x185f]
[    0.363236] pci 0000:00:1a.2: reg 20: [io  0x1860-0x187f]
[    0.363351] pci 0000:00:1a.7: reg 10: [mem 0xf6504800-0xf6504bff]
[    0.363444] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.363452] pci 0000:00:1a.7: PME# disabled
[    0.363515] pci 0000:00:1b.0: reg 10: [mem 0xf6500000-0xf6503fff 64bit]
[    0.363598] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.363605] pci 0000:00:1b.0: PME# disabled
[    0.363737] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.363743] pci 0000:00:1c.0: PME# disabled
[    0.363877] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.363884] pci 0000:00:1c.1: PME# disabled
[    0.364022] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.364029] pci 0000:00:1c.2: PME# disabled
[    0.364163] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.364169] pci 0000:00:1c.3: PME# disabled
[    0.364305] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.364312] pci 0000:00:1c.4: PME# disabled
[    0.364445] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    0.364452] pci 0000:00:1c.5: PME# disabled
[    0.364545] pci 0000:00:1d.0: reg 20: [io  0x1880-0x189f]
[    0.364665] pci 0000:00:1d.1: reg 20: [io  0x18a0-0x18bf]
[    0.364787] pci 0000:00:1d.2: reg 20: [io  0x18c0-0x18df]
[    0.364901] pci 0000:00:1d.7: reg 10: [mem 0xf6504c00-0xf6504fff]
[    0.364994] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.365005] pci 0000:00:1d.7: PME# disabled
[    0.365319] pci 0000:00:1f.2: reg 10: [io  0x1818-0x181f]
[    0.365330] pci 0000:00:1f.2: reg 14: [io  0x180c-0x180f]
[    0.365341] pci 0000:00:1f.2: reg 18: [io  0x1810-0x1817]
[    0.365351] pci 0000:00:1f.2: reg 1c: [io  0x1808-0x180b]
[    0.365362] pci 0000:00:1f.2: reg 20: [io  0x18e0-0x18ff]
[    0.365372] pci 0000:00:1f.2: reg 24: [mem 0xf6504000-0xf65047ff]
[    0.365438] pci 0000:00:1f.2: PME# supported from D3hot
[    0.365445] pci 0000:00:1f.2: PME# disabled
[    0.365499] pci 0000:00:1f.3: reg 10: [mem 0x00000000-0x000000ff 64bit]
[    0.365525] pci 0000:00:1f.3: reg 20: [io  0x1c00-0x1c1f]
[    0.365645] pci 0000:00:1c.0: PCI bridge to [bus 02-03]
[    0.365651] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.365658] pci 0000:00:1c.0:   bridge window [mem 0xf8000000-0xf9ffffff]
[    0.365669] pci 0000:00:1c.0:   bridge window [mem 0xf0000000-0xf1ffffff 64bit pref]
[    0.365732] pci 0000:08:00.0: reg 10: [io  0x3000-0x30ff]
[    0.365766] pci 0000:08:00.0: reg 18: [mem 0xf6004000-0xf6004fff 64bit pref]
[    0.365789] pci 0000:08:00.0: reg 20: [mem 0xf6000000-0xf6003fff 64bit pref]
[    0.365803] pci 0000:08:00.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    0.365872] pci 0000:08:00.0: supports D1 D2
[    0.365874] pci 0000:08:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.365882] pci 0000:08:00.0: PME# disabled
[    0.365989] pci 0000:00:1c.1: PCI bridge to [bus 08-08]
[    0.365996] pci 0000:00:1c.1:   bridge window [io  0x3000-0x3fff]
[    0.366015] pci 0000:00:1c.1:   bridge window [mem 0xf6000000-0xf60fffff 64bit pref]
[    0.366103] pci 0000:0e:00.0: reg 10: [mem 0xfa000000-0xfa001fff 64bit]
[    0.366243] pci 0000:0e:00.0: PME# supported from D0 D3hot D3cold
[    0.366253] pci 0000:0e:00.0: PME# disabled
[    0.366357] pci 0000:00:1c.2: PCI bridge to [bus 0e-0f]
[    0.366363] pci 0000:00:1c.2:   bridge window [io  0x4000-0x4fff]
[    0.366370] pci 0000:00:1c.2:   bridge window [mem 0xfa000000-0xfbffffff]
[    0.366381] pci 0000:00:1c.2:   bridge window [mem 0xf2000000-0xf3ffffff 64bit pref]
[    0.366465] pci 0000:00:1c.3: PCI bridge to [bus 14-15]
[    0.366471] pci 0000:00:1c.3:   bridge window [io  0x5000-0x5fff]
[    0.366478] pci 0000:00:1c.3:   bridge window [mem 0xfc000000-0xfdffffff]
[    0.366489] pci 0000:00:1c.3:   bridge window [mem 0xf4000000-0xf5ffffff 64bit pref]
[    0.366600] pci 0000:1a:00.0: reg 10: [mem 0xf6200000-0xf6200fff]
[    0.366627] pci 0000:1a:00.0: reg 14: [mem 0xf6202000-0xf62027ff]
[    0.366848] pci 0000:1a:00.0: supports D1 D2
[    0.366851] pci 0000:1a:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.366865] pci 0000:1a:00.0: PME# disabled
[    0.367015] pci 0000:1a:00.1: reg 10: [mem 0xf6203800-0xf62038ff]
[    0.367259] pci 0000:1a:00.1: supports D1 D2
[    0.367261] pci 0000:1a:00.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.367276] pci 0000:1a:00.1: PME# disabled
[    0.367410] pci 0000:1a:00.2: reg 10: [mem 0xf6201000-0xf6201fff]
[    0.367437] pci 0000:1a:00.2: reg 14: [mem 0xf6203000-0xf62037ff]
[    0.367463] pci 0000:1a:00.2: reg 18: [mem 0xf6202800-0xf6202fff]
[    0.367660] pci 0000:1a:00.2: supports D1 D2
[    0.367663] pci 0000:1a:00.2: PME# supported from D0 D1 D2 D3hot D3cold
[    0.367677] pci 0000:1a:00.2: PME# disabled
[    0.367814] pci 0000:00:1c.4: PCI bridge to [bus 1a-1a]
[    0.367825] pci 0000:00:1c.4:   bridge window [mem 0xf6200000-0xf62fffff]
[    0.367919] pci 0000:00:1c.5: PCI bridge to [bus 20-20]
[    0.368032] pci 0000:00:1e.0: PCI bridge to [bus 26-26] (subtractive decode)
[    0.368107] pci_bus 0000:00: on NUMA node 0
[    0.368114] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.368440] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.368611] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    0.368727] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    0.368843] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
[    0.368959] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP04._PRT]
[    0.369080] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP05._PRT]
[    0.369196] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP06._PRT]
[    0.397171] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
[    0.397329] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 *11 12 14 15)
[    0.397483] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 *5 6 7 10 12 14 15)
[    0.397636] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 *5 6 7 11 12 14 15)
[    0.397790] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
[    0.397945] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 *7 11 12 14 15)
[    0.398118] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 *5 6 7 10 12 14 15)
[    0.398297] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 *11 12 14 15)
[    0.398386] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.399008] vgaarb: loaded
[    0.399187] SCSI subsystem initialized
[    0.401015] libata version 3.00 loaded.
[    0.401076] usbcore: registered new interface driver usbfs
[    0.401076] usbcore: registered new interface driver hub
[    0.401076] usbcore: registered new device driver usb
[    0.401191] PCI: Using ACPI for IRQ routing
[    0.401191] PCI: pci_cache_line_size set to 64 bytes
[    0.402408] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.402408] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.404005] Switching to clocksource tsc
[    0.432174] pnp: PnP ACPI init
[    0.432222] ACPI: bus type pnp registered
[    0.500286] pnp 00:08: disabling [mem 0xf6203900-0xf6203bff] because it overlaps 0000:00:1c.4 BAR 8 [mem 0xf6200000-0xf62fffff]
[    0.501459] pnp: PnP ACPI: found 10 devices
[    0.501462] ACPI: ACPI bus type pnp unregistered
[    0.501482] system 00:02: [mem 0xfed00000-0xfed003ff] has been reserved
[    0.501494] system 00:04: [io  0x0480-0x048f] has been reserved
[    0.501498] system 00:04: [io  0xffff] has been reserved
[    0.501502] system 00:04: [io  0xffff] has been reserved
[    0.501505] system 00:04: [io  0x0400-0x047f] has been reserved
[    0.501509] system 00:04: [io  0x1180-0x11ff] has been reserved
[    0.501513] system 00:04: [io  0xfe00] has been reserved
[    0.501517] system 00:04: [io  0xff2c-0xff7f] has been reserved
[    0.501536] system 00:09: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.501540] system 00:09: [mem 0xfed10000-0xfed13fff] has been reserved
[    0.501543] system 00:09: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.501547] system 00:09: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.501551] system 00:09: [mem 0xe0000000-0xefffffff] has been reserved
[    0.501555] system 00:09: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.501559] system 00:09: [mem 0xfed40000-0xfed44fff] has been reserved
[    0.501563] system 00:09: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.538512] pci 0000:00:1c.1: BAR 8: assigned [mem 0x80000000-0x803fffff]
[    0.538518] pci 0000:00:1c.4: BAR 9: assigned [mem 0x80400000-0x805fffff 64bit pref]
[    0.538522] pci 0000:00:1c.5: BAR 8: assigned [mem 0x80600000-0x807fffff]
[    0.538526] pci 0000:00:1c.5: BAR 9: assigned [mem 0x80800000-0x809fffff 64bit pref]
[    0.538531] pci 0000:00:1c.4: BAR 7: assigned [io  0x6000-0x6fff]
[    0.538534] pci 0000:00:1c.5: BAR 7: assigned [io  0x7000-0x7fff]
[    0.538539] pci 0000:00:1f.3: BAR 0: assigned [mem 0x80a00000-0x80a000ff 64bit]
[    0.538551] pci 0000:00:1f.3: BAR 0: set to [mem 0x80a00000-0x80a000ff 64bit] (PCI address [0x80a00000-0x80a000ff]
[    0.538554] pci 0000:00:1c.0: PCI bridge to [bus 02-03]
[    0.538559] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.538568] pci 0000:00:1c.0:   bridge window [mem 0xf8000000-0xf9ffffff]
[    0.538575] pci 0000:00:1c.0:   bridge window [mem 0xf0000000-0xf1ffffff 64bit pref]
[    0.538586] pci 0000:08:00.0: BAR 6: assigned [mem 0xf6020000-0xf603ffff pref]
[    0.538589] pci 0000:00:1c.1: PCI bridge to [bus 08-08]
[    0.538594] pci 0000:00:1c.1:   bridge window [io  0x3000-0x3fff]
[    0.538603] pci 0000:00:1c.1:   bridge window [mem 0x80000000-0x803fffff]
[    0.538610] pci 0000:00:1c.1:   bridge window [mem 0xf6000000-0xf60fffff 64bit pref]
[    0.538620] pci 0000:00:1c.2: PCI bridge to [bus 0e-0f]
[    0.538625] pci 0000:00:1c.2:   bridge window [io  0x4000-0x4fff]
[    0.538633] pci 0000:00:1c.2:   bridge window [mem 0xfa000000-0xfbffffff]
[    0.538640] pci 0000:00:1c.2:   bridge window [mem 0xf2000000-0xf3ffffff 64bit pref]
[    0.538651] pci 0000:00:1c.3: PCI bridge to [bus 14-15]
[    0.538655] pci 0000:00:1c.3:   bridge window [io  0x5000-0x5fff]
[    0.538664] pci 0000:00:1c.3:   bridge window [mem 0xfc000000-0xfdffffff]
[    0.538671] pci 0000:00:1c.3:   bridge window [mem 0xf4000000-0xf5ffffff 64bit pref]
[    0.538681] pci 0000:00:1c.4: PCI bridge to [bus 1a-1a]
[    0.538686] pci 0000:00:1c.4:   bridge window [io  0x6000-0x6fff]
[    0.538695] pci 0000:00:1c.4:   bridge window [mem 0xf6200000-0xf62fffff]
[    0.538701] pci 0000:00:1c.4:   bridge window [mem 0x80400000-0x805fffff 64bit pref]
[    0.538712] pci 0000:00:1c.5: PCI bridge to [bus 20-20]
[    0.538716] pci 0000:00:1c.5:   bridge window [io  0x7000-0x7fff]
[    0.538725] pci 0000:00:1c.5:   bridge window [mem 0x80600000-0x807fffff]
[    0.538732] pci 0000:00:1c.5:   bridge window [mem 0x80800000-0x809fffff 64bit pref]
[    0.538742] pci 0000:00:1e.0: PCI bridge to [bus 26-26]
[    0.538744] pci 0000:00:1e.0:   bridge window [io  disabled]
[    0.538752] pci 0000:00:1e.0:   bridge window [mem disabled]
[    0.538758] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    0.538786] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.538793] pci 0000:00:1c.0: setting latency timer to 64
[    0.538814] pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    0.538821] pci 0000:00:1c.1: setting latency timer to 64
[    0.538838] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.538844] pci 0000:00:1c.2: setting latency timer to 64
[    0.538860] pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    0.538867] pci 0000:00:1c.3: setting latency timer to 64
[    0.538881] pci 0000:00:1c.4: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.538888] pci 0000:00:1c.4: setting latency timer to 64
[    0.538902] pci 0000:00:1c.5: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    0.538909] pci 0000:00:1c.5: setting latency timer to 64
[    0.538920] pci 0000:00:1e.0: setting latency timer to 64
[    0.538926] pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
[    0.538929] pci_bus 0000:00: resource 1 [mem 0x00000000-0xffffffff]
[    0.538932] pci_bus 0000:02: resource 0 [io  0x2000-0x2fff]
[    0.538935] pci_bus 0000:02: resource 1 [mem 0xf8000000-0xf9ffffff]
[    0.538938] pci_bus 0000:02: resource 2 [mem 0xf0000000-0xf1ffffff 64bit pref]
[    0.538941] pci_bus 0000:08: resource 0 [io  0x3000-0x3fff]
[    0.538944] pci_bus 0000:08: resource 1 [mem 0x80000000-0x803fffff]
[    0.538947] pci_bus 0000:08: resource 2 [mem 0xf6000000-0xf60fffff 64bit pref]
[    0.538950] pci_bus 0000:0e: resource 0 [io  0x4000-0x4fff]
[    0.538953] pci_bus 0000:0e: resource 1 [mem 0xfa000000-0xfbffffff]
[    0.538956] pci_bus 0000:0e: resource 2 [mem 0xf2000000-0xf3ffffff 64bit pref]
[    0.538959] pci_bus 0000:14: resource 0 [io  0x5000-0x5fff]
[    0.538962] pci_bus 0000:14: resource 1 [mem 0xfc000000-0xfdffffff]
[    0.538965] pci_bus 0000:14: resource 2 [mem 0xf4000000-0xf5ffffff 64bit pref]
[    0.538968] pci_bus 0000:1a: resource 0 [io  0x6000-0x6fff]
[    0.538971] pci_bus 0000:1a: resource 1 [mem 0xf6200000-0xf62fffff]
[    0.538974] pci_bus 0000:1a: resource 2 [mem 0x80400000-0x805fffff 64bit pref]
[    0.538977] pci_bus 0000:20: resource 0 [io  0x7000-0x7fff]
[    0.538980] pci_bus 0000:20: resource 1 [mem 0x80600000-0x807fffff]
[    0.538983] pci_bus 0000:20: resource 2 [mem 0x80800000-0x809fffff 64bit pref]
[    0.538986] pci_bus 0000:26: resource 3 [io  0x0000-0xffff]
[    0.538989] pci_bus 0000:26: resource 4 [mem 0x00000000-0xffffffff]
[    0.539069] NET: Registered protocol family 2
[    0.539254] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.539712] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.540211] TCP bind hash table entries: 65536 (order: 9, 2097152 bytes)
[    0.546082] TCP: Hash tables configured (established 131072 bind 65536)
[    0.546141] TCP reno registered
[    0.546153] UDP hash table entries: 512 (order: 3, 40960 bytes)
[    0.546251] UDP-Lite hash table entries: 512 (order: 3, 40960 bytes)
[    0.546506] NET: Registered protocol family 1
[    0.546948] RPC: Registered udp transport module.
[    0.546951] RPC: Registered tcp transport module.
[    0.546954] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.546975] pci 0000:00:02.0: Boot video device
[    0.547251] PCI: CLS 64 bytes, default 64
[    0.547602] Simple Boot Flag at 0x36 set to 0x1
[    0.549538] highmem bounce pool size: 64 pages
[    0.550616] msgmni has been set to 1720
[    0.550655] io scheduler noop registered
[    0.550658] io scheduler deadline registered
[    0.550683] io scheduler cfq registered (default)
[    0.550956] pcieport 0000:00:1c.0: setting latency timer to 64
[    0.551260] pcieport 0000:00:1c.1: setting latency timer to 64
[    0.551527] pcieport 0000:00:1c.2: setting latency timer to 64
[    0.551964] pcieport 0000:00:1c.3: setting latency timer to 64
[    0.552236] pcieport 0000:00:1c.4: setting latency timer to 64
[    0.552497] pcieport 0000:00:1c.5: setting latency timer to 64
[    0.613993] ACPI: AC Adapter [ACAD] (on-line)
[    0.614485] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input0
[    0.614615] ACPI: Lid Switch [LID0]
[    0.614743] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input1
[    0.614747] ACPI: Power Button [PWRB]
[    0.614871] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input2
[    0.614876] ACPI: Sleep Button [SLPB]
[    0.614996] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[    0.615000] ACPI: Power Button [PWRF]
[    0.620830] Monitor-Mwait will be used to enter C-1 state
[    0.621829] Monitor-Mwait will be used to enter C-2 state
[    0.621837] Marking TSC unstable due to TSC halts in idle
[    0.622353] Switching to clocksource hpet
[    0.703485] Real Time Clock Driver v1.12b
[    1.034514] ACPI: Battery Slot [BAT1] (battery present)
[    1.045386] i8k: unable to get SMM Dell signature
[    1.045389] Linux agpgart interface v0.103
[    1.045416] agpgart-intel 0000:00:00.0: Intel GM45 Chipset
[    1.046325] agpgart-intel 0000:00:00.0: detected 32764K stolen memory
[    1.073070] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    1.073273] [drm] Initialized drm 1.1.0 20060810
[    1.073307] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.073313] i915 0000:00:02.0: setting latency timer to 64
[    1.081339] [drm] set up 31M of stolen space
[    1.856093] [drm] LVDS-8: set mode 1440x900 c
[    2.249754] Console: switching to colour frame buffer device 180x56
[    2.255579] fb0: inteldrmfb frame buffer device
[    2.255581] registered panic notifier
[    2.271513] acpi device:05: registered as cooling_device2
[    2.272151] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:01/input/input4
[    2.272160] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[    2.272250] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    2.272394] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    2.274000] ahci 0000:00:1f.2: version 3.0
[    2.274019] ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    2.274131] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 4 ports 3 Gbps 0x3 impl SATA mode
[    2.274136] ahci 0000:00:1f.2: flags: 64bit ncq sntf led clo pmp pio slum part ccc sxs 
[    2.274143] ahci 0000:00:1f.2: setting latency timer to 64
[    2.274374] scsi0 : ahci
[    2.274850] scsi1 : ahci
[    2.275059] scsi2 : ahci
[    2.275286] scsi3 : ahci
[    2.275468] ata1: SATA max UDMA/133 irq_stat 0x00400040 irq 19, connection status changed
[    2.275473] ata2: SATA max UDMA/133 irq_stat 0x00000040, connection status changed
[    2.275476] ata3: DUMMY
[    2.275478] ata4: DUMMY
[    2.275600] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    2.275625] r8169 0000:08:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    2.275672] r8169 0000:08:00.0: setting latency timer to 64
[    2.275687] r8169 0000:08:00.0: no MSI. Back to INTx.
[    2.275976] eth0: RTL8168d/8111d at 0xf805a000, 00:24:e8:c1:2c:ce, XID 081000c0 IRQ 17
[    2.319888] netconsole: local port 6665
[    2.319891] netconsole: local IP 192.168.1.176
[    2.319894] netconsole: interface eth0
[    2.319896] netconsole: remote port 6666
[    2.319898] netconsole: remote IP 192.168.1.1
[    2.319901] netconsole: remote ethernet address 00:19:d1:71:2e:e2
[    2.319905] netconsole: device eth0 not up yet, forcing it
[    2.320515] r8169: eth0: link down
[    2.320612] r8169: eth0: link down
[    2.998038] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.998087] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.999226] ata2.00: ATAPI: HL-DT-ST DVD+/-RW GT10N, A106, max UDMA/100
[    3.000717] ata2.00: configured for UDMA/100
[    3.358510] ata1.00: ATA-8: WDC WD1600BEVT-75ZCT2, 11.01A11, max UDMA/133
[    3.358514] ata1.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    3.359914] ata1.00: configured for UDMA/133
[    3.360784] scsi 0:0:0:0: Direct-Access     ATA      WDC WD1600BEVT-7 11.0 PQ: 0 ANSI: 5
[    3.362025] sd 0:0:0:0: [sda] 312581808 512-byte logical blocks: (160 GB/149 GiB)
[    3.362136] sd 0:0:0:0: [sda] Write Protect is off
[    3.362139] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.362184] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.362824]  sda:
[    3.363232] scsi 1:0:0:0: CD-ROM            HL-DT-ST DVD+-RW GT10N    A106 PQ: 0 ANSI: 5
[    3.370463]  sda1 sda2 sda3 sda4 < sda5 >
[    3.387281] sd 0:0:0:0: [sda] Attached SCSI disk
[    5.021104] r8169: eth0: link up
[    5.027694] console [netcon0] enabled
[    5.027699] netconsole: network logging started
[    5.027703] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    5.027751] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 19 (level, low) -> IRQ 19
[    5.027775] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    5.027780] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    5.027974] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    5.028035] ehci_hcd 0000:00:1a.7: debug port 1
[    5.031927] ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
[    5.031937] ehci_hcd 0000:00:1a.7: irq 19, io mem 0xf6504800
[    5.041048] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    5.042554] hub 1-0:1.0: USB hub found
[    5.042565] hub 1-0:1.0: 6 ports detected
[    5.043040] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    5.043057] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    5.043063] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    5.043082] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    5.043156] ehci_hcd 0000:00:1d.7: debug port 1
[    5.047061] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    5.047085] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xf6504c00
[    5.056026] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    5.056353] hub 2-0:1.0: USB hub found
[    5.056364] hub 2-0:1.0: 6 ports detected
[    5.056547] uhci_hcd: USB Universal Host Controller Interface driver
[    5.056586] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    5.056604] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    5.056609] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    5.056620] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    5.056664] uhci_hcd 0000:00:1a.0: irq 16, io base 0x00001820
[    5.056961] hub 3-0:1.0: USB hub found
[    5.057057] hub 3-0:1.0: 2 ports detected
[    5.057204] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    5.057221] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    5.057226] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    5.057237] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[    5.057305] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00001840
[    5.057603] hub 4-0:1.0: USB hub found
[    5.057613] hub 4-0:1.0: 2 ports detected
[    5.057719] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 19 (level, low) -> IRQ 19
[    5.057729] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    5.057735] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    5.057754] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
[    5.057791] uhci_hcd 0000:00:1a.2: irq 19, io base 0x00001860
[    5.058094] hub 5-0:1.0: USB hub found
[    5.058104] hub 5-0:1.0: 2 ports detected
[    5.058215] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    5.058225] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    5.058233] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    5.058261] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
[    5.058299] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00001880
[    5.058635] hub 6-0:1.0: USB hub found
[    5.058648] hub 6-0:1.0: 2 ports detected
[    5.058799] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    5.058809] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    5.058817] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    5.058835] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
[    5.058869] uhci_hcd 0000:00:1d.1: irq 19, io base 0x000018a0
[    5.059170] hub 7-0:1.0: USB hub found
[    5.059180] hub 7-0:1.0: 2 ports detected
[    5.059293] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    5.059304] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    5.059311] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    5.059357] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
[    5.059406] uhci_hcd 0000:00:1d.2: irq 18, io base 0x000018c0
[    5.059714] hub 8-0:1.0: USB hub found
[    5.059725] hub 8-0:1.0: 2 ports detected
[    5.060059] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    5.095954] serio: i8042 KBD port at 0x60,0x64 irq 1
[    5.096015] serio: i8042 AUX port at 0x60,0x64 irq 12
[    5.096495] mice: PS/2 mouse device common for all mice
[    5.097335] i2c /dev entries driver
[    5.098807] i801_smbus 0000:00:1f.3: PCI INT C -> GSI 19 (level, low) -> IRQ 19
[    5.098815] ACPI: I/O resource 0000:00:1f.3 [0x1c00-0x1c1f] conflicts with ACPI region SMBI [0x1c00-0x1c0f]
[    5.098819] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    5.099317] cpuidle: using governor ladder
[    5.100154] cpuidle: using governor menu
[    5.100203] TCP cubic registered
[    5.100208] NET: Registered protocol family 17
[    5.100250] NET: Registered protocol family 15
[    5.106601] Using IPI No-Shortcut mode
[    5.107340] PM: Resume from disk failed.
[    5.126156] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input5
[    6.613410] IP-Config: Complete:
[    6.613432]      device=eth0, addr=192.168.1.16, mask=255.255.255.0, gw=192.168.1.1,
[    6.613462]      host=nu, domain=, nis-domain=(none),
[    6.613473]      bootserver=255.255.255.255, rootserver=192.168.1.1, rootpath=
[    6.613607] Looking up port of RPC 100003/3 on 192.168.1.1
[    6.618097] Looking up port of RPC 100005/3 on 192.168.1.1
[    6.634489] VFS: Mounted root (nfs filesystem) readonly on device 0:12.
[    6.634612] Freeing unused kernel memory: 424k freed
[    6.635625] Write protecting the kernel text: 3608k
[    6.635948] Write protecting the kernel read-only data: 1344k
[    6.639132] Warning: unable to open an initial console.
[    7.897910] udev: starting version 146

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.33-rc3
# Wed Jan  6 20:02:13 2010
#
# CONFIG_64BIT is not set
CONFIG_X86_32=y
# CONFIG_X86_64 is not set
CONFIG_X86=y
CONFIG_OUTPUT_FORMAT="elf32-i386"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
# CONFIG_RWSEM_GENERIC_SPINLOCK is not set
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
# CONFIG_GENERIC_TIME_VSYSCALL is not set
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
# CONFIG_HAVE_CPUMASK_OF_CPU_MAP is not set
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
# CONFIG_ZONE_DMA32 is not set
CONFIG_ARCH_POPULATES_NODE_MAP=y
# CONFIG_AUDIT_ARCH is not set
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_X86_32_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_TRAMPOLINE=y
CONFIG_X86_32_LAZY_GS=y
CONFIG_KTIME_SCALAR=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=y

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
# CONFIG_POSIX_MQUEUE is not set
CONFIG_BSD_PROCESS_ACCT=y
# CONFIG_BSD_PROCESS_ACCT_V3 is not set
# CONFIG_TASKSTATS is not set
# CONFIG_AUDIT is not set

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_TREE_PREEMPT_RCU is not set
# CONFIG_TINY_RCU is not set
# CONFIG_RCU_TRACE is not set
CONFIG_RCU_FANOUT=32
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=15
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
# CONFIG_GROUP_SCHED is not set
# CONFIG_CGROUPS is not set
# CONFIG_SYSFS_DEPRECATED_V2 is not set
# CONFIG_RELAY is not set
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
# CONFIG_IPC_NS is not set
# CONFIG_USER_NS is not set
# CONFIG_PID_NS is not set
# CONFIG_NET_NS is not set
# CONFIG_BLK_DEV_INITRD is not set
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
# CONFIG_EMBEDDED is not set
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
CONFIG_EVENT_PROFILE=y
# CONFIG_PERF_COUNTERS is not set
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
# CONFIG_COMPAT_BRK is not set
CONFIG_SLAB=y
# CONFIG_SLUB is not set
# CONFIG_SLOB is not set
# CONFIG_PROFILING is not set
CONFIG_TRACEPOINTS=y
CONFIG_HAVE_OPROFILE=y
# CONFIG_KPROBES is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
# CONFIG_SLOW_WORK is not set
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
# CONFIG_LBDAF is not set
# CONFIG_BLK_DEV_BSG is not set
# CONFIG_BLK_DEV_INTEGRITY is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
# CONFIG_INLINE_SPIN_TRYLOCK is not set
# CONFIG_INLINE_SPIN_TRYLOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK is not set
# CONFIG_INLINE_SPIN_LOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK_IRQ is not set
# CONFIG_INLINE_SPIN_LOCK_IRQSAVE is not set
# CONFIG_INLINE_SPIN_UNLOCK is not set
# CONFIG_INLINE_SPIN_UNLOCK_BH is not set
# CONFIG_INLINE_SPIN_UNLOCK_IRQ is not set
# CONFIG_INLINE_SPIN_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_READ_TRYLOCK is not set
# CONFIG_INLINE_READ_LOCK is not set
# CONFIG_INLINE_READ_LOCK_BH is not set
# CONFIG_INLINE_READ_LOCK_IRQ is not set
# CONFIG_INLINE_READ_LOCK_IRQSAVE is not set
# CONFIG_INLINE_READ_UNLOCK is not set
# CONFIG_INLINE_READ_UNLOCK_BH is not set
# CONFIG_INLINE_READ_UNLOCK_IRQ is not set
# CONFIG_INLINE_READ_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_WRITE_TRYLOCK is not set
# CONFIG_INLINE_WRITE_LOCK is not set
# CONFIG_INLINE_WRITE_LOCK_BH is not set
# CONFIG_INLINE_WRITE_LOCK_IRQ is not set
# CONFIG_INLINE_WRITE_LOCK_IRQSAVE is not set
# CONFIG_INLINE_WRITE_UNLOCK is not set
# CONFIG_INLINE_WRITE_UNLOCK_BH is not set
# CONFIG_INLINE_WRITE_UNLOCK_IRQ is not set
# CONFIG_INLINE_WRITE_UNLOCK_IRQRESTORE is not set
# CONFIG_MUTEX_SPIN_ON_OWNER is not set
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_SMP=y
# CONFIG_SPARSE_IRQ is not set
CONFIG_X86_MPPARSE=y
# CONFIG_X86_BIGSMP is not set
# CONFIG_X86_EXTENDED_PLATFORM is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
CONFIG_SCHED_OMIT_FRAME_POINTER=y
# CONFIG_PARAVIRT_GUEST is not set
# CONFIG_MEMTEST is not set
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MPSC is not set
CONFIG_MCORE2=y
# CONFIG_MATOM is not set
# CONFIG_GENERIC_CPU is not set
# CONFIG_X86_GENERIC is not set
CONFIG_X86_CPU=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_XADD=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=5
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_CYRIX_32=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_CPU_SUP_UMC_32=y
# CONFIG_X86_DS is not set
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
# CONFIG_IOMMU_HELPER is not set
# CONFIG_IOMMU_API is not set
CONFIG_NR_CPUS=2
# CONFIG_SCHED_SMT is not set
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y
# CONFIG_X86_ANCIENT_MCE is not set
CONFIG_X86_MCE_THRESHOLD=y
# CONFIG_X86_MCE_INJECT is not set
CONFIG_X86_THERMAL_VECTOR=y
CONFIG_VM86=y
# CONFIG_TOSHIBA is not set
CONFIG_I8K=y
# CONFIG_X86_REBOOTFIXUPS is not set
# CONFIG_MICROCODE is not set
# CONFIG_X86_MSR is not set
CONFIG_X86_CPUID=y
# CONFIG_X86_CPU_DEBUG is not set
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_HIGHMEM=y
# CONFIG_ARCH_PHYS_ADDR_T_64BIT is not set
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_DISCONTIGMEM_MANUAL is not set
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=999999
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_MEMORY_FAILURE is not set
# CONFIG_HIGHPTE is not set
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
# CONFIG_X86_RESERVE_LOW_64K is not set
# CONFIG_MATH_EMULATION is not set
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x100000
CONFIG_HOTPLUG_CPU=y
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
CONFIG_PM=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_VERBOSE is not set
CONFIG_CAN_PM_TRACE=y
# CONFIG_PM_TRACE_RTC is not set
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_SLEEP=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATION_NVS=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
# CONFIG_PM_RUNTIME is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_PROCFS_POWER is not set
CONFIG_ACPI_SYSFS_POWER=y
# CONFIG_ACPI_PROC_EVENT is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=y
# CONFIG_ACPI_FAN is not set
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_SBS is not set
# CONFIG_SFI is not set
# CONFIG_APM is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
# CONFIG_CPU_FREQ_DEBUG is not set
CONFIG_CPU_FREQ_STAT=y
# CONFIG_CPU_FREQ_STAT_DETAILS is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set

#
# CPUFreq processor drivers
#
CONFIG_X86_ACPI_CPUFREQ=y
# CONFIG_X86_POWERNOW_K6 is not set
# CONFIG_X86_POWERNOW_K7 is not set
# CONFIG_X86_POWERNOW_K8 is not set
# CONFIG_X86_GX_SUSPMOD is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
# CONFIG_X86_SPEEDSTEP_ICH is not set
# CONFIG_X86_SPEEDSTEP_SMI is not set
# CONFIG_X86_P4_CLOCKMOD is not set
# CONFIG_X86_CPUFREQ_NFORCE2 is not set
# CONFIG_X86_LONGRUN is not set
# CONFIG_X86_LONGHAUL is not set
# CONFIG_X86_E_POWERSAVER is not set

#
# shared options
#
# CONFIG_X86_SPEEDSTEP_LIB is not set
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
# CONFIG_PCI_GOOLPC is not set
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCIEPORTBUS=y
CONFIG_PCIEAER=y
# CONFIG_PCIE_ECRC is not set
# CONFIG_PCIEAER_INJECT is not set
# CONFIG_PCIEASPM is not set
CONFIG_ARCH_SUPPORTS_MSI=y
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_LEGACY is not set
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_STUB is not set
CONFIG_HT_IRQ=y
# CONFIG_PCI_IOV is not set
CONFIG_PCI_IOAPIC=y
CONFIG_ISA_DMA_API=y
# CONFIG_ISA is not set
# CONFIG_MCA is not set
# CONFIG_SCx200 is not set
# CONFIG_OLPC is not set
# CONFIG_PCCARD is not set
# CONFIG_HOTPLUG_PCI is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
CONFIG_HAVE_AOUT=y
# CONFIG_BINFMT_AOUT is not set
# CONFIG_BINFMT_MISC is not set
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=y
CONFIG_XFRM=y
# CONFIG_XFRM_USER is not set
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
# CONFIG_XFRM_STATISTICS is not set
CONFIG_NET_KEY=y
# CONFIG_NET_KEY_MIGRATE is not set
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_FIB_HASH=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
# CONFIG_IP_PNP_BOOTP is not set
# CONFIG_IP_PNP_RARP is not set
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE is not set
# CONFIG_ARPD is not set
# CONFIG_SYN_COOKIES is not set
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
# CONFIG_INET_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_BEET is not set
CONFIG_INET_LRO=y
# CONFIG_INET_DIAG is not set
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
# CONFIG_IPV6 is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETFILTER is not set
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
# CONFIG_RDS is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_BRIDGE is not set
# CONFIG_NET_DSA is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_NET_DROP_MONITOR is not set
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
# CONFIG_AF_RXRPC is not set
# CONFIG_WIRELESS is not set
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
# CONFIG_NET_9P is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
# CONFIG_DEVTMPFS is not set
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_CONNECTOR is not set
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_PNPACPI=y
# CONFIG_BLK_DEV is not set
# CONFIG_MISC_DEVICES is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
# CONFIG_SCSI_NETLINK is not set
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
# CONFIG_BLK_DEV_SR is not set
# CONFIG_CHR_DEV_SG is not set
# CONFIG_CHR_DEV_SCH is not set
# CONFIG_SCSI_MULTI_LUN is not set
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set
# CONFIG_SCSI_SCAN_ASYNC is not set
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
# CONFIG_SCSI_SPI_ATTRS is not set
# CONFIG_SCSI_FC_ATTRS is not set
# CONFIG_SCSI_ISCSI_ATTRS is not set
# CONFIG_SCSI_SAS_LIBSAS is not set
# CONFIG_SCSI_SRP_ATTRS is not set
# CONFIG_SCSI_LOWLEVEL is not set
# CONFIG_SCSI_DH is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_ACPI=y
# CONFIG_SATA_PMP is not set
CONFIG_SATA_AHCI=y
# CONFIG_SATA_SIL24 is not set
# CONFIG_ATA_SFF is not set
# CONFIG_MD is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#

#
# You can enable one or both FireWire driver stacks.
#

#
# The newer stack is recommended.
#
# CONFIG_FIREWIRE is not set
# CONFIG_IEEE1394 is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
# CONFIG_DUMMY is not set
# CONFIG_BONDING is not set
# CONFIG_MACVLAN is not set
# CONFIG_EQUALIZER is not set
# CONFIG_TUN is not set
# CONFIG_VETH is not set
# CONFIG_NET_SB1000 is not set
# CONFIG_ARCNET is not set
# CONFIG_NET_ETHERNET is not set
CONFIG_MII=y
CONFIG_NETDEV_1000=y
# CONFIG_ACENIC is not set
# CONFIG_DL2K is not set
# CONFIG_E1000 is not set
# CONFIG_E1000E is not set
# CONFIG_IP1000 is not set
# CONFIG_IGB is not set
# CONFIG_IGBVF is not set
# CONFIG_NS83820 is not set
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
CONFIG_R8169=y
# CONFIG_SIS190 is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
# CONFIG_VIA_VELOCITY is not set
# CONFIG_TIGON3 is not set
# CONFIG_BNX2 is not set
# CONFIG_CNIC is not set
# CONFIG_QLA3XXX is not set
# CONFIG_ATL1 is not set
# CONFIG_ATL1E is not set
# CONFIG_ATL1C is not set
# CONFIG_JME is not set
# CONFIG_NETDEV_10000 is not set
# CONFIG_TR is not set
# CONFIG_WLAN is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
# CONFIG_USB_USBNET is not set
# CONFIG_WAN is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set
# CONFIG_NET_FC is not set
CONFIG_NETCONSOLE=y
# CONFIG_NETCONSOLE_DYNAMIC is not set
CONFIG_NETPOLL=y
# CONFIG_NETPOLL_TRAP is not set
CONFIG_NET_POLL_CONTROLLER=y
# CONFIG_VMXNET3 is not set
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
# CONFIG_INPUT_POLLDEV is not set
# CONFIG_INPUT_SPARSEKMAP is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1280
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=1024
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5588 is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_QT2160 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_INPUT_MOUSE is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
# CONFIG_SERIO_SERPORT is not set
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_SERIO_ALTERA_PS2 is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
# CONFIG_VT_HW_CONSOLE_BINDING is not set
# CONFIG_DEVKMEM is not set
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
# CONFIG_SERIAL_8250_CONSOLE is not set
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
# CONFIG_LEGACY_PTYS is not set
# CONFIG_IPMI_HANDLER is not set
# CONFIG_HW_RANDOM is not set
# CONFIG_NVRAM is not set
CONFIG_RTC=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
# CONFIG_NSC_GPIO is not set
# CONFIG_CS5535_GPIO is not set
# CONFIG_RAW_DRIVER is not set
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
# CONFIG_HANGCHECK_TIMER is not set
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_COMPAT is not set
CONFIG_I2C_CHARDEV=y
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_ALGOBIT=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
CONFIG_I2C_I801=y
# CONFIG_I2C_ISCH is not set
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_SIMTEC is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_STUB is not set
# CONFIG_SCx200_ACB is not set

#
# Miscellaneous I2C Chip support
#
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_I2C_DEBUG_CHIP is not set
# CONFIG_SPI is not set

#
# PPS support
#
# CONFIG_PPS is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
# CONFIG_GPIOLIB is not set
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_BATTERY_DS2760 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_HWMON is not set
CONFIG_THERMAL=y
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
# CONFIG_SSB is not set

#
# Multifunction device drivers
#
# CONFIG_MFD_CORE is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM831X is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_AB3100_CORE is not set
# CONFIG_MFD_88PM8607 is not set
# CONFIG_REGULATOR is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
CONFIG_AGP=y
# CONFIG_AGP_ALI is not set
# CONFIG_AGP_ATI is not set
# CONFIG_AGP_AMD is not set
# CONFIG_AGP_AMD64 is not set
CONFIG_AGP_INTEL=y
# CONFIG_AGP_NVIDIA is not set
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_SWORKS is not set
# CONFIG_AGP_VIA is not set
# CONFIG_AGP_EFFICEON is not set
CONFIG_VGA_ARB=y
CONFIG_DRM=y
CONFIG_DRM_KMS_HELPER=y
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_I810 is not set
# CONFIG_DRM_I830 is not set
CONFIG_DRM_I915=y
CONFIG_DRM_I915_KMS=y
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_SIS is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
# CONFIG_FB_DDC is not set
# CONFIG_FB_BOOT_VESA_SUPPORT is not set
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
# CONFIG_FB_SYS_FILLRECT is not set
# CONFIG_FB_SYS_COPYAREA is not set
# CONFIG_FB_SYS_IMAGEBLIT is not set
# CONFIG_FB_FOREIGN_ENDIAN is not set
# CONFIG_FB_SYS_FOPS is not set
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
# CONFIG_FB_MODE_HELPERS is not set
# CONFIG_FB_TILEBLITTING is not set

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_VESA is not set
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I810 is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_GEODE is not set
# CONFIG_FB_VIRTUAL is not set
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_GENERIC is not set
# CONFIG_BACKLIGHT_PROGEAR is not set
# CONFIG_BACKLIGHT_MBP_NVIDIA is not set
# CONFIG_BACKLIGHT_SAHARA is not set

#
# Display device support
#
# CONFIG_DISPLAY_SUPPORT is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
# CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY is not set
# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
CONFIG_FONTS=y
# CONFIG_FONT_8x8 is not set
CONFIG_FONT_8x16=y
# CONFIG_FONT_6x11 is not set
# CONFIG_FONT_7x14 is not set
# CONFIG_FONT_PEARL_8x8 is not set
# CONFIG_FONT_ACORN_8x8 is not set
# CONFIG_FONT_MINI_4x6 is not set
CONFIG_FONT_SUN8x16=y
CONFIG_FONT_SUN12x22=y
CONFIG_FONT_10x18=y
# CONFIG_LOGO is not set
# CONFIG_SOUND is not set
# CONFIG_HID_SUPPORT is not set
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
# CONFIG_USB_DEVICEFS is not set
# CONFIG_USB_DEVICE_CLASS is not set
# CONFIG_USB_DYNAMIC_MINORS is not set
CONFIG_USB_SUSPEND=y
# CONFIG_USB_OTG is not set
# CONFIG_USB_MON is not set
# CONFIG_USB_WUSB is not set
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
# CONFIG_USB_XHCI_HCD is not set
CONFIG_USB_EHCI_HCD=y
# CONFIG_USB_EHCI_ROOT_HUB_TT is not set
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
# CONFIG_USB_ISP1362_HCD is not set
# CONFIG_USB_OHCI_HCD is not set
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_WHCI_HCD is not set
# CONFIG_USB_HWA_HCD is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
# CONFIG_USB_PRINTER is not set
# CONFIG_USB_WDM is not set
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
# CONFIG_USB_STORAGE is not set
# CONFIG_USB_LIBUSUAL is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set

#
# USB port drivers
#
CONFIG_USB_SERIAL=m
CONFIG_USB_EZUSB=y
CONFIG_USB_SERIAL_GENERIC=y
# CONFIG_USB_SERIAL_AIRCABLE is not set
# CONFIG_USB_SERIAL_ARK3116 is not set
# CONFIG_USB_SERIAL_BELKIN is not set
# CONFIG_USB_SERIAL_CH341 is not set
# CONFIG_USB_SERIAL_WHITEHEAT is not set
# CONFIG_USB_SERIAL_DIGI_ACCELEPORT is not set
CONFIG_USB_SERIAL_CP210X=m
# CONFIG_USB_SERIAL_CYPRESS_M8 is not set
# CONFIG_USB_SERIAL_EMPEG is not set
CONFIG_USB_SERIAL_FTDI_SIO=m
# CONFIG_USB_SERIAL_FUNSOFT is not set
# CONFIG_USB_SERIAL_VISOR is not set
# CONFIG_USB_SERIAL_IPAQ is not set
# CONFIG_USB_SERIAL_IR is not set
# CONFIG_USB_SERIAL_EDGEPORT is not set
# CONFIG_USB_SERIAL_EDGEPORT_TI is not set
# CONFIG_USB_SERIAL_GARMIN is not set
# CONFIG_USB_SERIAL_IPW is not set
# CONFIG_USB_SERIAL_IUU is not set
# CONFIG_USB_SERIAL_KEYSPAN_PDA is not set
# CONFIG_USB_SERIAL_KEYSPAN is not set
# CONFIG_USB_SERIAL_KLSI is not set
# CONFIG_USB_SERIAL_KOBIL_SCT is not set
# CONFIG_USB_SERIAL_MCT_U232 is not set
# CONFIG_USB_SERIAL_MOS7720 is not set
# CONFIG_USB_SERIAL_MOS7840 is not set
# CONFIG_USB_SERIAL_MOTOROLA is not set
# CONFIG_USB_SERIAL_NAVMAN is not set
CONFIG_USB_SERIAL_PL2303=m
# CONFIG_USB_SERIAL_OTI6858 is not set
# CONFIG_USB_SERIAL_QUALCOMM is not set
# CONFIG_USB_SERIAL_SPCP8X5 is not set
# CONFIG_USB_SERIAL_HP4X is not set
# CONFIG_USB_SERIAL_SAFE is not set
# CONFIG_USB_SERIAL_SIEMENS_MPI is not set
# CONFIG_USB_SERIAL_SIERRAWIRELESS is not set
# CONFIG_USB_SERIAL_SYMBOL is not set
# CONFIG_USB_SERIAL_TI is not set
# CONFIG_USB_SERIAL_CYBERJACK is not set
# CONFIG_USB_SERIAL_XIRCOM is not set
# CONFIG_USB_SERIAL_OPTION is not set
# CONFIG_USB_SERIAL_OMNINET is not set
# CONFIG_USB_SERIAL_OPTICON is not set
CONFIG_USB_SERIAL_DEBUG=m

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_SEVSEG is not set
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_BERRY_CHARGE is not set
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_VST is not set
# CONFIG_USB_GADGET is not set

#
# OTG and related infrastructure
#
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_UWB is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
# CONFIG_NEW_LEDS is not set
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
# CONFIG_RTC_CLASS is not set
# CONFIG_DMADEVICES is not set
# CONFIG_AUXDISPLAY is not set
# CONFIG_UIO is not set

#
# TI VLYNQ
#
# CONFIG_STAGING is not set
# CONFIG_X86_PLATFORM_DEVICES is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
# CONFIG_DMIID is not set
# CONFIG_ISCSI_IBFT_FIND is not set

#
# File systems
#
CONFIG_EXT2_FS=y
# CONFIG_EXT2_FS_XATTR is not set
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=y
# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
CONFIG_EXT3_FS_XATTR=y
# CONFIG_EXT3_FS_POSIX_ACL is not set
# CONFIG_EXT3_FS_SECURITY is not set
# CONFIG_EXT4_FS is not set
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
# CONFIG_FS_POSIX_ACL is not set
# CONFIG_XFS_FS is not set
# CONFIG_OCFS2_FS is not set
# CONFIG_BTRFS_FS is not set
# CONFIG_NILFS2_FS is not set
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
# CONFIG_INOTIFY is not set
CONFIG_INOTIFY_USER=y
# CONFIG_QUOTA is not set
# CONFIG_AUTOFS_FS is not set
# CONFIG_AUTOFS4_FS is not set
# CONFIG_FUSE_FS is not set

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# CD-ROM/DVD Filesystems
#
# CONFIG_ISO9660_FS is not set
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
# CONFIG_MSDOS_FS is not set
# CONFIG_VFAT_FS is not set
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=y
# CONFIG_MISC_FILESYSTEMS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
CONFIG_NFS_V3=y
# CONFIG_NFS_V3_ACL is not set
# CONFIG_NFS_V4 is not set
CONFIG_ROOT_NFS=y
# CONFIG_NFSD is not set
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
# CONFIG_RPCSEC_GSS_KRB5 is not set
# CONFIG_RPCSEC_GSS_SPKM3 is not set
# CONFIG_SMB_FS is not set
# CONFIG_CIFS is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="utf8"
CONFIG_NLS_CODEPAGE_437=y
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
CONFIG_NLS_CODEPAGE_850=y
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
# CONFIG_NLS_ISO8859_15 is not set
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_UTF8=y
# CONFIG_DLM is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_ENABLE_WARN_DEPRECATED=y
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=1024
# CONFIG_MAGIC_SYSRQ is not set
# CONFIG_STRIP_ASM_SYMS is not set
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
CONFIG_DETECT_SOFTLOCKUP=y
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
CONFIG_DETECT_HUNG_TASK=y
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
CONFIG_SCHED_DEBUG=y
# CONFIG_SCHEDSTATS is not set
# CONFIG_TIMER_STATS is not set
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_DEBUG_SLAB is not set
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_PREEMPT=y
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_TRACE_IRQFLAGS=y
CONFIG_DEBUG_SPINLOCK_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
# CONFIG_DEBUG_HIGHMEM is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_INFO is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_RCU_CPU_STALL_DETECTOR is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# CONFIG_FAULT_INJECTION is not set
# CONFIG_LATENCYTOP is not set
# CONFIG_SYSCTL_SYSCALL_CHECK is not set
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FTRACE_NMI_ENTER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_RING_BUFFER=y
CONFIG_FTRACE_NMI_ENTER=y
CONFIG_EVENT_TRACING=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
CONFIG_FUNCTION_TRACER=y
CONFIG_FUNCTION_GRAPH_TRACER=y
# CONFIG_IRQSOFF_TRACER is not set
# CONFIG_PREEMPT_TRACER is not set
# CONFIG_SYSPROF_TRACER is not set
# CONFIG_SCHED_TRACER is not set
CONFIG_FTRACE_SYSCALLS=y
CONFIG_BOOT_TRACER=y
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
# CONFIG_POWER_TRACER is not set
# CONFIG_KSYM_TRACER is not set
# CONFIG_STACK_TRACER is not set
# CONFIG_KMEMTRACE is not set
# CONFIG_WORKQUEUE_TRACER is not set
# CONFIG_BLK_DEV_IO_TRACE is not set
CONFIG_DYNAMIC_FTRACE=y
CONFIG_FUNCTION_PROFILER=y
CONFIG_FTRACE_MCOUNT_RECORD=y
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_MMIOTRACE is not set
# CONFIG_RING_BUFFER_BENCHMARK is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DYNAMIC_DEBUG is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_DEBUG_STACKOVERFLOW is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_PER_CPU_MAPS is not set
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
# CONFIG_DEBUG_NX_TEST is not set
# CONFIG_4KSTACKS is not set
CONFIG_DOUBLEFAULT=y
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set

#
# Security options
#
# CONFIG_KEYS is not set
# CONFIG_SECURITY is not set
# CONFIG_SECURITYFS is not set
# CONFIG_DEFAULT_SECURITY_SELINUX is not set
# CONFIG_DEFAULT_SECURITY_SMACK is not set
# CONFIG_DEFAULT_SECURITY_TOMOYO is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
# CONFIG_CRYPTO_MANAGER is not set
# CONFIG_CRYPTO_MANAGER2 is not set
# CONFIG_CRYPTO_GF128MUL is not set
# CONFIG_CRYPTO_NULL is not set
# CONFIG_CRYPTO_CRYPTD is not set
# CONFIG_CRYPTO_AUTHENC is not set
# CONFIG_CRYPTO_TEST is not set

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
# CONFIG_CRYPTO_GCM is not set
# CONFIG_CRYPTO_SEQIV is not set

#
# Block modes
#
# CONFIG_CRYPTO_CBC is not set
# CONFIG_CRYPTO_CTR is not set
# CONFIG_CRYPTO_CTS is not set
# CONFIG_CRYPTO_ECB is not set
# CONFIG_CRYPTO_LRW is not set
# CONFIG_CRYPTO_PCBC is not set
# CONFIG_CRYPTO_XTS is not set

#
# Hash modes
#
# CONFIG_CRYPTO_HMAC is not set
# CONFIG_CRYPTO_XCBC is not set
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
# CONFIG_CRYPTO_CRC32C is not set
# CONFIG_CRYPTO_CRC32C_INTEL is not set
# CONFIG_CRYPTO_GHASH is not set
# CONFIG_CRYPTO_MD4 is not set
# CONFIG_CRYPTO_MD5 is not set
# CONFIG_CRYPTO_MICHAEL_MIC is not set
# CONFIG_CRYPTO_RMD128 is not set
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
# CONFIG_CRYPTO_SHA1 is not set
# CONFIG_CRYPTO_SHA256 is not set
# CONFIG_CRYPTO_SHA512 is not set
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_WP512 is not set

#
# Ciphers
#
# CONFIG_CRYPTO_AES is not set
# CONFIG_CRYPTO_AES_586 is not set
# CONFIG_CRYPTO_ANUBIS is not set
# CONFIG_CRYPTO_ARC4 is not set
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_CAMELLIA is not set
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST6 is not set
# CONFIG_CRYPTO_DES is not set
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SALSA20_586 is not set
# CONFIG_CRYPTO_SEED is not set
# CONFIG_CRYPTO_SERPENT is not set
# CONFIG_CRYPTO_TEA is not set
# CONFIG_CRYPTO_TWOFISH is not set
# CONFIG_CRYPTO_TWOFISH_586 is not set

#
# Compression
#
# CONFIG_CRYPTO_DEFLATE is not set
# CONFIG_CRYPTO_ZLIB is not set
# CONFIG_CRYPTO_LZO is not set

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
# CONFIG_CRYPTO_HW is not set
CONFIG_HAVE_KVM=y
# CONFIG_VIRTUALIZATION is not set
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
CONFIG_GENERIC_FIND_LAST_BIT=y
# CONFIG_CRC_CCITT is not set
# CONFIG_CRC16 is not set
# CONFIG_CRC_T10DIF is not set
# CONFIG_CRC_ITU_T is not set
CONFIG_CRC32=y
# CONFIG_CRC7 is not set
# CONFIG_LIBCRC32C is not set
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_NLATTR=y
