Return-Path: <linux-kernel-owner+w=401wt.eu-S1755281AbYBWQyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281AbYBWQyR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 11:54:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751500AbYBWQyD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 11:54:03 -0500
Received: from www17.your-server.de ([213.133.104.17]:59604 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbYBWQx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 11:53:57 -0500
Message-ID: <47C04F99.6030704@m3y3r.de>
Date: Sat, 23 Feb 2008 17:53:45 +0100
From: Thomas Meyer <thomas@m3y3r.de>
User-Agent: Thunderbird 2.0.0.9 (X11/20080211)
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux1394-devel@lists.sourceforge.net
Subject: Re: 2.6.25-rc2: ohci1394 problem
References: <47BBDB07.80409@m3y3r.de> <47BBF771.40203@s5r6.in-berlin.de> <47BC6918.4000203@m3y3r.de> <47BC6E42.10409@s5r6.in-berlin.de> <47BC6EEC.4020000@s5r6.in-berlin.de>
In-Reply-To: <47BC6EEC.4020000@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter schrieb:
> I wrote:
>   
>>>> Thomas Meyer wrote at LKML:
>>>>         
>>>>> With 2.6.25-rc2 my kernel log consists mainly of:
>>>>>
>>>>> "ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
>>>>>           
>> There are junk interrupt events sent to ohci1394's IRQ handler.
>>     
>
> PS, do you still have the log lines which come from ohci1394's
> initialization?
>   
As requested:

1.) firewire_ohci is already loaded. manually load ohci1394 via insmod:

[  856.789954] ACPI: PCI Interrupt 0000:0c:03.0[A] -> GSI 19 (level, 
low) -> IRQ 19
[  856.790040] ------------[ cut here ]------------
[  856.790044] WARNING: at arch/x86/mm/ioremap.c:137 __ioremap+0xa7/0x16a()
[  856.790048] Modules linked in: ohci1394(+) ieee1394 wlan_wep 
wlan_scan_sta ath_rate_sample ath_pci wlan ath_hal(P) firmware_class 
fuse snd_seq snd_seq_device nls_iso8859_15 nls_cp850 vfat fat usbhid 
appletouch applesmc input_polldev led_class dummy binfmt_misc tun 
pktcdvd loop msr cpuid coretemp hwmon eeprom cpufreq_powersave 
cpufreq_conservative acpi_cpufreq thermal ehci_hcd tpm_infineon i2c_i801 
i2c_core tpm uhci_hcd usbcore tpm_bios processor ac battery sr_mod 
rng_core iTCO_wdt button firewire_ohci firewire_core sg snd_hda_intel 
snd_pcm snd_timer snd soundcore snd_page_alloc evdev intel_agp cdrom 
[last unloaded: microcode]
[  856.790119] Pid: 7140, comm: insmod Tainted: P         2.6.25-rc2 #115
[  856.790125]  [<c011e5ab>] warn_on_slowpath+0x40/0x4f
[  856.790143]  [<c0118045>] __wake_up+0x29/0x39
[  856.790154]  [<c0277305>] netlink_broadcast+0x26e/0x2af
[  856.790169]  [<c01cc36b>] kobject_uevent_env+0x33d/0x361
[  856.790178]  [<c025ef2b>] pci_mmcfg_write+0xc4/0xd5
[  856.790187]  [<c0260157>] raw_pci_write+0x3e/0x46
[  856.790200]  [<c01148f8>] __ioremap+0xa7/0x16a
[  856.790210]  [<f8b14425>] ohci1394_pci_probe+0x20c/0x5a6 [ohci1394]
[  856.790226]  [<c01d63f1>] pci_device_probe+0x36/0x55
[  856.790236]  [<c02226cb>] driver_probe_device+0x9d/0x114
[  856.790246]  [<c0222826>] __driver_attach+0x52/0x87
[  856.790254]  [<c0221d46>] bus_for_each_dev+0x35/0x57
[  856.790265]  [<c022257e>] driver_attach+0x11/0x13
[  856.790270]  [<c02227d4>] __driver_attach+0x0/0x87
[  856.790277]  [<c02223bc>] bus_add_driver+0x91/0x195
[  856.790286]  [<c02229d9>] driver_register+0x45/0x9a
[  856.790297]  [<c01d65a6>] __pci_register_driver+0x32/0x60
[  856.790305]  [<c013aea0>] sys_init_module+0x16b7/0x179f
[  856.790495]  [<c0160bb9>] do_sync_read+0xbe/0x103
[  856.790518]  [<c01549fc>] anon_vma_prepare+0x11/0xa6
[  856.790529]  [<f8b55185>] hpsb_bus_reset+0x0/0xe2 [ieee1394]
[  856.790560]  [<c0171db7>] mntput_no_expire+0x13/0x5d
[  856.790569]  [<c015f6ce>] filp_close+0x4d/0x53
[  856.790578]  [<c01048a2>] sysenter_past_esp+0x5f/0x85
[  856.790595]  =======================
[  856.790598] ---[ end trace 5b0384c17c339107 ]---
[  856.943807] ohci1394: fw-host0: Get PHY Reg timeout 
[0x00008400/0x00000000/100]
[  856.947140] ohci1394: fw-host0: Set PHY Reg timeout 
[0x000044c0/0x00004000/100]
[  856.947261] ohci1394: fw-host0: OHCI-1394 0.35 (PCI): IRQ=[19]  
MMIO=[100000000-1000007ff]  Max Packet=[65536]  IR/IT contexts=[32/32]
[  856.950473] ohci1394: fw-host0: Get PHY Reg timeout 
[0x00008200/0x00000000/100]
[  856.950556] ohci1394: fw-host0: Serial EEPROM has suspicious values, 
attempting to set max_packet_size to 512 bytes
[  857.942972] ohci1394: fw-host0: Get PHY Reg timeout 
[0x00008500/0x00000000/100]
[  857.946305] ohci1394: fw-host0: Set PHY Reg timeout 
[0x00004540/0x00004000/100]


2.) unload both firewire drivers via rmmod. and insmod ohci1394:
[  921.500561] ohci1394: fw-host0: Unrecoverable error!
[  921.500574] ohci1394: fw-host0: Async Rsp Tx Context died: 
ctrl[f0002a00] cmdptr[f0002a00]
[  921.500586] ohci1394: fw-host0: Iso Recv 3 Context died: 
ctrl[d4000d0e] cmdptr[001073d9] match[00000000]
[  921.500594] ohci1394: fw-host0: Iso Recv 17 Context died: 
ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[  921.500601] ohci1394: fw-host0: Iso Recv 18 Context died: 
ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[  921.500607] ohci1394: fw-host0: Iso Recv 19 Context died: 
ctrl[0c047e80] cmdptr[83060246] match[83060846]
[  921.500615] ohci1394: fw-host0: Iso Recv 26 Context died: 
ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[  921.500621] ohci1394: fw-host0: Iso Recv 27 Context died: 
ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[  921.500627] ohci1394: fw-host0: physical posted write error
[  921.500630] ohci1394: fw-host0: isochronous cycle too long
[  921.500636] ohci1394: fw-host0: respTxComplete: dma prg stopped
[  921.500642] ohci1394: fw-host0: SelfID received outside of bus reset 
sequence
[  921.500646] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[  921.501131] ohci1394: fw-host0: Unrecoverable error!
[  921.501139] ohci1394: fw-host0: Async Rsp Tx Context died: 
ctrl[f0002a00] cmdptr[f0002a00]
[  921.501151] ohci1394: fw-host0: Iso Recv 3 Context died: 
ctrl[d4000d0e] cmdptr[001073d9] match[00000000]
[  921.501159] ohci1394: fw-host0: Iso Recv 17 Context died: 
ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[  921.501166] ohci1394: fw-host0: Iso Recv 18 Context died: 
ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[  921.501172] ohci1394: fw-host0: Iso Recv 19 Context died: 
ctrl[0c047e80] cmdptr[83060246] match[83060846]
[  921.501180] ohci1394: fw-host0: Iso Recv 26 Context died: 
ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[  921.501186] ohci1394: fw-host0: Iso Recv 27 Context died: 
ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[  921.501191] ohci1394: fw-host0: physical posted write error
[  921.501195] ohci1394: fw-host0: isochronous cycle too long
[  921.501200] ohci1394: fw-host0: respTxComplete: dma prg stopped
[  921.501205] ohci1394: fw-host0: SelfID received outside of bus reset 
sequence
[  921.501209] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[  921.826439] ohci1394: fw-host0: Unrecoverable error!
[  921.826439] ohci1394: fw-host0: Async Rsp Tx Context died: 
ctrl[f0002a00] cmdptr[f0002a00]
[  921.826439] ohci1394: fw-host0: Iso Recv 3 Context died: 
ctrl[d4000d0e] cmdptr[001073d9] match[00000000]
[  921.826439] ohci1394: fw-host0: Iso Recv 17 Context died: 
ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[  921.826439] ohci1394: fw-host0: Iso Recv 18 Context died: 
ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[  921.826439] ohci1394: fw-host0: Iso Recv 19 Context died: 
ctrl[0c047e80] cmdptr[83060246] match[83060846]
[  921.826439] ohci1394: fw-host0: Iso Recv 26 Context died: 
ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[  921.826439] ohci1394: fw-host0: Iso Recv 27 Context died: 
ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[  921.826439] ohci1394: fw-host0: physical posted write error
[  921.826439] ohci1394: fw-host0: isochronous cycle too long
[  921.826439] ohci1394: fw-host0: respTxComplete: dma prg stopped
[  921.826439] ohci1394: fw-host0: SelfID received outside of bus reset 
sequence
[  921.826439] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[  924.499747] ohci1394: fw-host0: Unrecoverable error!
[  924.499758] ohci1394: fw-host0: Async Rsp Tx Context died: 
ctrl[f0002a00] cmdptr[f0002a00]
[  924.499770] ohci1394: fw-host0: Iso Recv 3 Context died: 
ctrl[d4000d0e] cmdptr[001073d9] match[00000000]
[  924.499778] ohci1394: fw-host0: Iso Recv 17 Context died: 
ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[  924.499785] ohci1394: fw-host0: Iso Recv 18 Context died: 
ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[  924.499792] ohci1394: fw-host0: Iso Recv 19 Context died: 
ctrl[0c047e80] cmdptr[83060246] match[83060846]
[  924.499799] ohci1394: fw-host0: Iso Recv 26 Context died: 
ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[  924.499805] ohci1394: fw-host0: Iso Recv 27 Context died: 
ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[  924.499811] ohci1394: fw-host0: physical posted write error
[  924.499814] ohci1394: fw-host0: isochronous cycle too long
[  924.499820] ohci1394: fw-host0: respTxComplete: dma prg stopped
[  924.499825] ohci1394: fw-host0: SelfID received outside of bus reset 
sequence
[  924.499830] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[  924.500111] ohci1394: fw-host0: Unrecoverable error!
[  924.500117] ohci1394: fw-host0: Async Rsp Tx Context died: 
ctrl[f0002a00] cmdptr[f0002a00]
[  924.500128] ohci1394: fw-host0: Iso Recv 3 Context died: 
ctrl[d4000d0e] cmdptr[001073d9] match[00000000]
[  924.500137] ohci1394: fw-host0: Iso Recv 17 Context died: 
ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[  924.500144] ohci1394: fw-host0: Iso Recv 18 Context died: 
ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[  924.500150] ohci1394: fw-host0: Iso Recv 19 Context died: 
ctrl[0c047e80] cmdptr[83060246] match[83060846]
[  924.500158] ohci1394: fw-host0: Iso Recv 26 Context died: 
ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[  924.500164] ohci1394: fw-host0: Iso Recv 27 Context died: 
ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[  924.500170] ohci1394: fw-host0: physical posted write error
[  924.500173] ohci1394: fw-host0: isochronous cycle too long
[  924.500178] ohci1394: fw-host0: respTxComplete: dma prg stopped
[  924.500183] ohci1394: fw-host0: SelfID received outside of bus reset 
sequence
[  924.500187] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[  924.521645] ohci1394: fw-host0: Unrecoverable error!
[  924.521645] ohci1394: fw-host0: Async Rsp Tx Context died: 
ctrl[f0002a00] cmdptr[f0002a00]
[  924.521645] ohci1394: fw-host0: Iso Recv 3 Context died: 
ctrl[d4000d0e] cmdptr[001073d9] match[00000000]
[  924.521645] ohci1394: fw-host0: Iso Recv 17 Context died: 
ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[  924.521645] ohci1394: fw-host0: Iso Recv 18 Context died: 
ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[  924.521645] ohci1394: fw-host0: Iso Recv 19 Context died: 
ctrl[0c047e80] cmdptr[83060246] match[83060846]
[  924.521645] ohci1394: fw-host0: Iso Recv 26 Context died: 
ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[  924.521645] ohci1394: fw-host0: Iso Recv 27 Context died: 
ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[  924.521645] ohci1394: fw-host0: physical posted write error
[  924.521645] ohci1394: fw-host0: isochronous cycle too long
[  924.521645] ohci1394: fw-host0: respTxComplete: dma prg stopped
[  924.521645] ohci1394: fw-host0: SelfID received outside of bus reset 
sequence
[  924.521645] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[  924.522351] ohci1394: fw-host0: Unrecoverable error!
[  924.522358] ohci1394: fw-host0: Async Rsp Tx Context died: 
ctrl[f0002a00] cmdptr[f0002a00]
[  924.522369] ohci1394: fw-host0: Iso Recv 3 Context died: 
ctrl[d4000d0e] cmdptr[001073d9] match[00000000]
[  924.522377] ohci1394: fw-host0: Iso Recv 17 Context died: 
ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[  924.522384] ohci1394: fw-host0: Iso Recv 18 Context died: 
ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[  924.522391] ohci1394: fw-host0: Iso Recv 19 Context died: 
ctrl[0c047e80] cmdptr[83060246] match[83060846]
[  924.522398] ohci1394: fw-host0: Iso Recv 26 Context died: 
ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[  924.522405] ohci1394: fw-host0: Iso Recv 27 Context died: 
ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[  924.522410] ohci1394: fw-host0: physical posted write error
[  924.522414] ohci1394: fw-host0: isochronous cycle too long
[  924.522418] ohci1394: fw-host0: respTxComplete: dma prg stopped
[  924.522423] ohci1394: fw-host0: SelfID received outside of bus reset 
sequence
[  924.522427] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[  943.644818] ohci1394: fw-host0: Get PHY Reg timeout 
[0x00008400/0x00000000/100]
[  943.648151] ohci1394: fw-host0: Set PHY Reg timeout 
[0x00004400/0x00004000/100]
[  943.651484] ohci1394: fw-host0: Get PHY Reg timeout 
[0x00008100/0x00000000/100]
[  943.654817] ohci1394: fw-host0: Set PHY Reg timeout 
[0x00004140/0x00004000/100]
[  994.468376] ohci1394: fw-host0: Get PHY Reg timeout 
[0x00008400/0x00000000/100]
[  994.471709] ohci1394: fw-host0: Set PHY Reg timeout 
[0x000044c0/0x00004000/100]
[  994.471724] ohci1394: fw-host0: OHCI-1394 0.35 (PCI): IRQ=[19]  
MMIO=[100000000-1000007ff]  Max Packet=[65536]  IR/IT contexts=[32/32]
[  994.475042] ohci1394: fw-host0: Get PHY Reg timeout 
[0x00008200/0x00000000/100]
[  994.475048] ohci1394: fw-host0: Serial EEPROM has suspicious values, 
attempting to set max_packet_size to 512 bytes
[  995.476401] ohci1394: fw-host0: Get PHY Reg timeout 
[0x00008500/0x00000000/100]
[  995.479734] ohci1394: fw-host0: Set PHY Reg timeout 
[0x00004540/0x00004000/100]
[ 1001.867944] ohci1394: fw-host0: Get PHY Reg timeout 
[0x00008400/0x00000000/100]
[ 1001.871277] ohci1394: fw-host0: Set PHY Reg timeout 
[0x00004400/0x00004000/100]
[ 1001.874610] ohci1394: fw-host0: Get PHY Reg timeout 
[0x00008100/0x00000000/100]
[ 1001.877943] ohci1394: fw-host0: Set PHY Reg timeout 
[0x00004140/0x00004000/100]

i did unload ohci1394 here again.


3.) full dmesg output of above session:

[    0.000000] Linux version 2.6.25-rc2 (thomas@hotzenplotz) (gcc 
version 4.2.3 (Gentoo 4.2.3 p1.0)) #115 SMP Sat Feb 23 07:37:51 CET 2008
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000ede00 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007f0c8000 (usable)
[    0.000000]  BIOS-e820: 000000007f0c8000 - 000000007f2c9000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007f2c9000 - 000000007feb9000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007feb9000 - 000000007feef000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007feef000 - 000000007ff00000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007ff00000 - 0000000080000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
[    0.000000] 1136MB HIGHMEM available.
[    0.000000] 896MB LOWMEM available.
[    0.000000] Scan SMP from c0000000 for 1024 bytes.
[    0.000000] Scan SMP from c009fc00 for 1024 bytes.
[    0.000000] Scan SMP from c00f0000 for 65536 bytes.
[    0.000000] Scan SMP from c009fc00 for 1024 bytes.
[    0.000000] Entering add_active_range(0, 0, 520392) 0 entries of 256 used
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->   229376
[    0.000000]   HighMem    229376 ->   520392
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->   520392
[    0.000000] On node 0 totalpages: 520392
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 4064 pages, LIFO batch:0
[    0.000000]   Normal zone: 1760 pages used for memmap
[    0.000000]   Normal zone: 223520 pages, LIFO batch:31
[    0.000000]   HighMem zone: 2273 pages used for memmap
[    0.000000]   HighMem zone: 288743 pages, LIFO batch:31
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] DMI 2.4 present.
[    0.000000] ACPI: RSDP 000FE020, 0024 (r2 APPLE )
[    0.000000] ACPI: XSDT 7FEFD120, 0074 (r1 APPLE   Apple00       
55       1000013)
[    0.000000] ACPI: FACP 7FEFB000, 00F4 (r3 APPLE   Apple00       55 
Loki       5F)
[    0.000000] ACPI: DSDT 7FEF0000, 48C0 (r1 APPLE  MacBookP    10001 
INTL 20050309)
[    0.000000] ACPI: FACS 7FEBB000, 0040
[    0.000000] ACPI: HPET 7FEFA000, 0038 (r1 APPLE   Apple00        1 
Loki       5F)
[    0.000000] ACPI: APIC 7FEF9000, 0068 (r1 APPLE   Apple00        1 
Loki       5F)
[    0.000000] ACPI: MCFG 7FEF8000, 003C (r1 APPLE   Apple00        1 
Loki       5F)
[    0.000000] ACPI: ASF! 7FEF7000, 009C (r32 APPLE   Apple00        1 
Loki       5F)
[    0.000000] ACPI: SBST 7FEF6000, 0030 (r1 APPLE   Apple00        1 
Loki       5F)
[    0.000000] ACPI: ECDT 7FEF5000, 0053 (r1 APPLE   Apple00        1 
Loki       5F)
[    0.000000] ACPI: SSDT 7FEB6000, 064F (r1 APPLE   SataPri     1000 
INTL 20050309)
[    0.000000] ACPI: SSDT 7FEB5000, 069C (r1 APPLE   SataSec     1000 
INTL 20050309)
[    0.000000] ACPI: SSDT 7FEEF000, 04DC (r1 APPLE     CpuPm     3000 
INTL 20050309)
[    0.000000] ACPI: DMI detected: Apple
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] Processor #0 6:14 APIC version 20
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] Processor #1 6:14 APIC version 20
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 
0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at 88000000 (gap: 
80000000:60000000)
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 
00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 
00000000000ee000
[    0.000000] PM: Registered nosave memory: 00000000000ee000 - 
0000000000100000
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  
Total pages: 516327
[    0.000000] Kernel command line: root=/dev/sda3 lapic_timer_c2_ok 
BOOT_IMAGE=bzImage
[    0.000000] mapped APIC to ffffb000 (fee00000)
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] CPU 0 irqstacks, hard=c03ba000 soft=c03b8000
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Detected 1926.801 MHz processor.
[    0.003333] Console: colour VGA+ 80x25
[    0.003333] console [tty0] enabled
[    0.003333] Dentry cache hash table entries: 131072 (order: 7, 524288 
bytes)
[    0.003333] Inode-cache hash table entries: 65536 (order: 6, 262144 
bytes)
[    0.003333] Memory: 2059912k/2081568k available (1784k kernel code, 
20488k reserved, 750k data, 216k init, 1164064k highmem)
[    0.003333] virtual kernel memory layout:
[    0.003333]     fixmap  : 0xfff9b000 - 0xfffff000   ( 400 kB)
[    0.003333]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.003333]     vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
[    0.003333]     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
[    0.003333]       .init : 0xc037f000 - 0xc03b5000   ( 216 kB)
[    0.003333]       .data : 0xc02be1dc - 0xc0379bc0   ( 750 kB)
[    0.003333]       .text : 0xc0100000 - 0xc02be1dc   (1784 kB)
[    0.003333] Checking if this processor honours the WP bit even in 
supervisor mode...Ok.
[    0.003333] CPA: page pool initialized 32 of 32 pages preallocated
[    0.003333] SLUB: Genslabs=12, HWalign=64, Order=0-1, MinObjects=4, 
CPUs=2, Nodes=1
[    0.003333] hpet clockevent registered
[    0.083331] Calibrating delay using timer specific routine.. 3666.77 
BogoMIPS (lpj=6108445)
[    0.083431] Mount-cache hash table entries: 512
[    0.086765] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.086833] CPU: L2 cache: 2048K
[    0.086872] CPU: Physical Processor ID: 0
[    0.086910] CPU: Processor Core ID: 0
[    0.086950] Intel machine check architecture supported.
[    0.086992] Intel machine check reporting enabled on CPU#0.
[    0.087031] using mwait in idle threads.
[    0.087072] Compat vDSO mapped to ffffe000.
[    0.087114] Checking 'hlt' instruction... OK.
[    0.100215] ACPI: Core revision 20070126
[    0.113359] CPU0: Intel Genuine Intel(R) CPU           T2400  @ 
1.83GHz stepping 08
[    0.113505] Booting processor 1/1 ip 4000
[    0.113543] CPU 1 irqstacks, hard=c03bb000 soft=c03b9000
[    0.003333] Initializing CPU#1
[    0.003333] Calibrating delay using timer specific routine.. 3663.39 
BogoMIPS (lpj=6103035)
[    0.003333] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.003333] CPU: L2 cache: 2048K
[    0.003333] CPU: Physical Processor ID: 0
[    0.003333] CPU: Processor Core ID: 1
[    0.003333] Intel machine check architecture supported.
[    0.003333] Intel machine check reporting enabled on CPU#1.
[    0.210370] CPU1: Intel Genuine Intel(R) CPU           T2400  @ 
1.83GHz stepping 08
[    0.210797] Total of 2 processors activated (7329.17 BogoMIPS).
[    0.211019] ENABLING IO-APIC IRQs
[    0.211224] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.246650] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.246655] Brought up 2 CPUs
[    0.246709] CPU0 attaching sched-domain:
[    0.246712]  domain 0: span 3
[    0.246713]   groups: 1 2
[    0.246717] CPU1 attaching sched-domain:
[    0.246719]  domain 0: span 3
[    0.246720]   groups: 2 1
[    0.246934] net_namespace: 452 bytes
[    0.247128] NET: Registered protocol family 16
[    0.247340] ACPI: bus type pci registered
[    0.247455] PCI: Using MMCONFIG for extended config space
[    0.247495] PCI: Fatal: No config space access function found
[    0.247535] Setting up standard PCI resources
[    0.250523] ACPI: EC: EC description table is found, configuring boot EC
[    0.250832] ACPI: EC: non-query interrupt received, switching to 
interrupt mode
[    0.253960] ACPI: BIOS _OSI(Linux) query ignored via DMI
[    0.256749] ACPI: Interpreter enabled
[    0.256788] ACPI: (supports S0 S3 S4 S5)
[    0.256945] ACPI: Using IOAPIC for interrupt routing
[    0.268876] ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
[    0.268918] ACPI: EC: driver started in interrupt mode
[    0.268995] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.269608] pci 0000:00:1f.0: quirk: region 0400-047f claimed by ICH6 
ACPI/GPIO/TCO
[    0.269659] pci 0000:00:1f.0: quirk: region 0500-053f claimed by ICH6 
GPIO
[    0.270580] PCI: Transparent bridge - 0000:00:1e.0
[    0.270651] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.270960] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEGP._PRT]
[    0.271085] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    0.271206] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    0.271325] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
[    0.271454] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
[    0.278455] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12 
14 15) *11
[    0.278943] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 *11 12 
14 15)
[    0.279386] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 12 
14 15) *11
[    0.280038] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 *11 12 
14 15)
[    0.280481] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 
14 15) *0, disabled.
[    0.280996] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 
14 15) *0, disabled.
[    0.281503] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 10 12 
14 15) *11
[    0.281988] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *11 12 14 15)
[    0.282655] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.282723] pnp: PnP ACPI init
[    0.282765] ACPI: bus type pnp registered
[    0.291346] pnp: PnP ACPI: found 10 devices
[    0.291386] ACPI: ACPI bus type pnp unregistered
[    0.291645] SCSI subsystem initialized
[    0.291726] libata version 3.00 loaded.
[    0.291845] PCI: Using ACPI for IRQ routing
[    0.291884] PCI: If a device doesn't work, try "pci=routeirq".  If it 
helps, post a report
[    0.291933] PCI: System does not support PCI
[    0.291972] PCI: System does not support PCI
[    0.296660] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 11
[    0.296811] hpet0: 3 64-bit timers, 14318180 Hz
[    0.299813] Time: tsc clocksource has been installed.
[    0.303326] system 00:01: iomem range 0xe0000000-0xefffffff could not 
be reserved
[    0.303376] system 00:01: iomem range 0xfed14000-0xfed17fff could not 
be reserved
[    0.303424] system 00:01: iomem range 0xfed18000-0xfed18fff could not 
be reserved
[    0.303473] system 00:01: iomem range 0xfed19000-0xfed19fff could not 
be reserved
[    0.303522] system 00:01: iomem range 0xfed1c000-0xfed1ffff could not 
be reserved
[    0.303571] system 00:01: iomem range 0xfed20000-0xfed8ffff has been 
reserved
[    0.304844] system 00:06: iomem range 0xfed00000-0xfed003ff has been 
reserved
[    0.304889] system 00:08: ioport range 0x680-0x6ef has been reserved
[    0.304930] system 00:08: ioport range 0x800-0x80f has been reserved
[    0.304973] system 00:08: ioport range 0x810-0x817 has been reserved
[    0.305014] system 00:08: ioport range 0x400-0x47f has been reserved
[    0.305055] system 00:08: ioport range 0x500-0x53f has been reserved
[    0.305095] system 00:08: ioport range 0x1640-0x164f has been reserved
[    0.335649] PCI: Bridge: 0000:00:01.0
[    0.335688]   IO window: 2000-2fff
[    0.335727]   MEM window: 0x94000000-0x940fffff
[    0.335766]   PREFETCH window: 0x0000000088000000-0x0000000093ffffff
[    0.335818] PCI: Bridge: 0000:00:1c.0
[    0.335857]   IO window: 3000-3fff
[    0.335897]   MEM window: 0x94100000-0x941fffff
[    0.335938]   PREFETCH window: 0x0000000094200000-0x00000000942fffff
[    0.335989] PCI: Bridge: 0000:00:1c.1
[    0.336026]   IO window: disabled.
[    0.336068]   MEM window: 0x94300000-0x943fffff
[    0.336108]   PREFETCH window: disabled.
[    0.336149] PCI: Bridge: 0000:00:1c.2
[    0.336187]   IO window: disabled.
[    0.336228]   MEM window: disabled.
[    0.336267]   PREFETCH window: disabled.
[    0.336311] PCI: Bridge: 0000:00:1e.0
[    0.336349]   IO window: disabled.
[    0.336390]   MEM window: 0x00000000-0x000fffff
[    0.336431]   PREFETCH window: disabled.
[    0.336649] ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level, 
low) -> IRQ 16
[    0.336727] PCI: Setting latency timer of device 0000:00:01.0 to 64
[    0.336744] ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 17 (level, 
low) -> IRQ 17
[    0.336823] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[    0.336840] ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 16 (level, 
low) -> IRQ 16
[    0.336919] PCI: Setting latency timer of device 0000:00:1c.1 to 64
[    0.336936] ACPI: PCI Interrupt 0000:00:1c.2[C] -> GSI 18 (level, 
low) -> IRQ 18
[    0.337015] PCI: Setting latency timer of device 0000:00:1c.2 to 64
[    0.337025] PCI: Setting latency timer of device 0000:00:1e.0 to 64
[    0.337034] NET: Registered protocol family 2
[    0.346685] IP route cache hash table entries: 32768 (order: 5, 
131072 bytes)
[    0.346918] TCP established hash table entries: 131072 (order: 8, 
1048576 bytes)
[    0.347593] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.347947] TCP: Hash tables configured (established 131072 bind 65536)
[    0.347988] TCP reno registered
[    0.105848] Machine check exception polling timer started.
[    0.106306] highmem bounce pool size: 64 pages
[    0.106347] Total HugeTLB memory allocated, 0
[    0.108445] VFS: Disk quotas dquot_6.5.1
[    0.108506] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.109077] Block layer SCSI generic (bsg) driver version 0.4 loaded 
(major 254)
[    0.109127] io scheduler noop registered
[    0.109165] io scheduler anticipatory registered
[    0.109204] io scheduler deadline registered
[    0.109289] io scheduler cfq registered (default)
[    0.109515] pci 0000:01:00.0: Boot video device
[    0.109585] PCI: Setting latency timer of device 0000:00:01.0 to 64
[    0.109600] assign_interrupt_mode Found MSI capability
[    0.109653] Allocate Port Service[0000:00:01.0:pcie00]
[    0.109686] Allocate Port Service[0000:00:01.0:pcie03]
[    0.109742] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[    0.109777] assign_interrupt_mode Found MSI capability
[    0.110017] Allocate Port Service[0000:00:1c.0:pcie00]
[    0.110049] Allocate Port Service[0000:00:1c.0:pcie02]
[    0.110080] Allocate Port Service[0000:00:1c.0:pcie03]
[    0.110159] PCI: Setting latency timer of device 0000:00:1c.1 to 64
[    0.110193] assign_interrupt_mode Found MSI capability
[    0.110264] Allocate Port Service[0000:00:1c.1:pcie00]
[    0.110294] Allocate Port Service[0000:00:1c.1:pcie02]
[    0.110325] Allocate Port Service[0000:00:1c.1:pcie03]
[    0.110404] PCI: Setting latency timer of device 0000:00:1c.2 to 64
[    0.110439] assign_interrupt_mode Found MSI capability
[    0.110509] Allocate Port Service[0000:00:1c.2:pcie00]
[    0.110541] Allocate Port Service[0000:00:1c.2:pcie02]
[    0.110572] Allocate Port Service[0000:00:1c.2:pcie03]
[    0.136806] hpet_resources: 0xfed00000 is busy
[    0.136848] Linux agpgart interface v0.103
[    0.136925] ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 16 (level, 
low) -> IRQ 16
[    0.137009] PCI: Setting latency timer of device 0000:02:00.0 to 64
[    0.137030] sky2 0000:02:00.0: v1.21 addr 0x94100000 irq 16 Yukon-EC 
(0xb6) rev 2
[    0.137433] sky2 eth0: addr 00:16:cb:8c:b2:65
[    0.137519] console [netcon0] enabled
[    0.139993] netconsole: network logging started
[    0.140107] input: Macintosh mouse button emulation as 
/devices/virtual/input/input0
[    0.140199] Driver 'sd' needs updating - please use bus_type methods
[    0.140312] ata_piix 0000:00:1f.1: version 2.12
[    0.140318] ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18 (level, 
low) -> IRQ 18
[    0.140416] PCI: Setting latency timer of device 0000:00:1f.1 to 64
[    0.140481] scsi0 : ata_piix
[    0.140573] scsi1 : ata_piix
[    0.141110] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x10a0 
irq 14
[    0.141152] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x10a8 
irq 15
[    0.246656] Switched to high resolution mode on CPU 1
[    0.503303] Switched to high resolution mode on CPU 0
[    0.513846] ata1.00: ATAPI: MATSHITADVD-R   UJ-857, HAEA, max UDMA/66
[    0.523844] ata1.00: configured for UDMA/66
[    0.249984] scsi 0:0:0:0: CD-ROM            MATSHITA DVD-R   UJ-857   
HAEA PQ: 0 ANSI: 5
[    0.249984] PCI: Enabling device 0000:00:1f.2 (0005 -> 0007)
[    0.249984] ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level, 
low) -> IRQ 19
[    0.249984] ata_piix 0000:00:1f.2: MAP [ P0 P2 -- -- ]
[    0.249996] PCI: Setting latency timer of device 0000:00:1f.2 to 64
[    0.250036] scsi2 : ata_piix
[    0.250133] scsi3 : ata_piix
[    0.253601] ata3: SATA max UDMA/133 cmd 0x10c0 ctl 0x10d0 bmdma 
0x10b0 irq 19
[    0.253644] ata4: SATA max UDMA/133 cmd 0x10c8 ctl 0x10d4 bmdma 
0x10b8 irq 19
[    0.549964] ata3.01: ATA-7: WDC WD1600BEVS-00RST0, 04.01G04, max UDMA/133
[    0.549964] ata3.01: 312581808 sectors, multi 0: LBA48 NCQ (depth 0/32)
[    0.553991] ata3.01: configured for UDMA/133
[    0.279982] scsi 2:0:1:0: Direct-Access     ATA      WDC WD1600BEVS-0 
04.0 PQ: 0 ANSI: 5
[    0.279982] sd 2:0:1:0: [sda] 312581808 512-byte hardware sectors 
(160042 MB)
[    0.279996] sd 2:0:1:0: [sda] Write Protect is off
[    0.280036] sd 2:0:1:0: [sda] Mode Sense: 00 3a 00 00
[    0.280054] sd 2:0:1:0: [sda] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[    0.280151] sd 2:0:1:0: [sda] 312581808 512-byte hardware sectors 
(160042 MB)
[    0.280201] sd 2:0:1:0: [sda] Write Protect is off
[    0.280240] sd 2:0:1:0: [sda] Mode Sense: 00 3a 00 00
[    0.280257] sd 2:0:1:0: [sda] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[    0.281531]  sda: sda1 sda2 sda3 sda4 sda6
[    0.566629] sd 2:0:1:0: [sda] Attached SCSI disk
[    0.566629] PNP: No PS/2 controller found. Probing ports directly.
[    0.566632] i8042.c: No controller found.
[    0.573166] mice: PS/2 mouse device common for all mice
[    0.573316] device-mapper: uevent: version 1.0.3
[    0.573408] device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) 
initialised: dm-devel@redhat.com
[    0.573465] cpuidle: using governor ladder
[    0.573503] cpuidle: using governor menu
[    0.573904] TCP cubic registered
[    0.573949] NET: Registered protocol family 1
[    0.573997] NET: Registered protocol family 17
[    0.574039] Using IPI No-Shortcut mode
[    0.579962] kjournald starting.  Commit interval 5 seconds
[    0.579962] EXT3-fs: mounted filesystem with ordered data mode.
[    0.579962] VFS: Mounted root (ext3 filesystem) readonly.
[    0.579962] Freeing unused kernel memory: 216k freed
[    1.272206] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 22 (level, 
low) -> IRQ 22
[    1.272230] PCI: Setting latency timer of device 0000:00:1b.0 to 64
[    1.291876] scsi 0:0:0:0: Attached scsi generic sg0 type 5
[    1.291896] sd 2:0:1:0: Attached scsi generic sg1 type 0
[    1.301255] hda_codec: STAC922x, Apple subsys_id=106b0200
[    1.326946] ACPI: PCI Interrupt 0000:0c:03.0[A] -> GSI 19 (level, 
low) -> IRQ 19
[    1.326958] firewire_ohci: Failed to remap registers
[    1.326968] ACPI: PCI interrupt for device 0000:0c:03.0 disabled
[    0.919189] input: Power Button (FF) as /devices/virtual/input/input1
[    1.340427] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.02 (26-Jul-2007)
[    1.340486] iTCO_wdt: Found a ICH7-M TCO device (Version=2, 
TCOBASE=0x0460)
[    1.340518] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    0.928280] ACPI: Power Button (FF) [PWRF]
[    0.928337] input: Lid Switch as /devices/virtual/input/input2
[    0.939425] ACPI: Lid Switch [LID0]
[    0.939479] input: Power Button (CM) as /devices/virtual/input/input3
[    1.354047] intel_rng: FWH not detected
[    0.949810] ACPI: Power Button (CM) [PWRB]
[    0.949868] input: Sleep Button (CM) as /devices/virtual/input/input4
[    1.372089] Driver 'sr' needs updating - please use bus_type methods
[    1.374860] sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
[    1.374865] Uniform CD-ROM driver Revision: 3.20
[    1.374923] sr 0:0:0:0: Attached scsi CD-ROM sr0
[    0.962511] ACPI: Sleep Button (CM) [SLPB]
[    1.461777] ACPI: Battery Slot [BAT0] (battery present)
[    1.013269] ACPI: SSDT 7FEB3C90, 022A (r1 APPLE   Cpu0Ist     3000 
INTL 20050309)
[    1.013269] ACPI: SSDT 7FEB2C10, 02C3 (r1 APPLE   Cpu0Cst     3001 
INTL 20050309)
[    1.013269] ACPI: AC Adapter [ADP1] (on-line)
[    1.462861] Monitor-Mwait will be used to enter C-1 state
[    1.462864] Monitor-Mwait will be used to enter C-2 state
[    1.462866] Monitor-Mwait will be used to enter C-3 state
[    1.462920] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[    1.462946] ACPI: ACPI0007:00 is registered as cooling_device0
[    1.462950] ACPI: Processor [CPU0] (supports 8 throttling states)
[    1.463311] ACPI: SSDT 7FEB3F10, 0087 (r1 APPLE   Cpu1Ist     3000 
INTL 20050309)
[    1.463556] ACPI: SSDT 7FEB2F10, 0085 (r1 APPLE   Cpu1Cst     3000 
INTL 20050309)
[    1.013269] ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
[    1.013269] ACPI: ACPI0007:01 is registered as cooling_device1
[    1.013269] ACPI: Processor [CPU1] (supports 8 throttling states)
[    1.464028] Marking TSC unstable due to: TSC halts in idle.
[    1.016602] Time: hpet clocksource has been installed.
[    2.613854] Clocksource tsc unstable (delta = -787997749 ns)
[   30.858779] thermal: gave up waiting for init of module processor.
[   30.858784] thermal: Unknown symbol acpi_processor_set_thermal_limit
[   31.305944] usbcore: registered new interface driver usbfs
[   31.305970] usbcore: registered new interface driver hub
[   31.306011] usbcore: registered new device driver usb
[   31.663981] USB Universal Host Controller Interface driver v3.0
[   31.663981] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, 
low) -> IRQ 23
[   31.663981] PCI: Setting latency timer of device 0000:00:1d.0 to 64
[   31.663981] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[   31.663981] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned 
bus number 1
[   31.663981] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00001000
[   31.663981] usb usb1: configuration #1 chosen from 1 choice
[   31.663981] hub 1-0:1.0: USB hub found
[   31.663981] hub 1-0:1.0: 2 ports detected
[   31.726876] tpm_inf_pnp 00:03: Found TPM with ID IFX0101
[   31.726876] tpm_inf_pnp 00:03: TPM found: config base 0x4e, data base 
0x4700, chip version 0x000b, vendor id 0x15d1 (Infineon), product id 
0x000b (SLB 9635 TT 1.2)
[   31.760413] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, 
low) -> IRQ 19
[   31.760428] PCI: Setting latency timer of device 0000:00:1d.1 to 64
[   31.760433] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[   31.760473] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned 
bus number 2
[   31.760507] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00001020
[   31.760672] usb usb2: configuration #1 chosen from 1 choice
[   31.760694] hub 2-0:1.0: USB hub found
[   31.760700] hub 2-0:1.0: 2 ports detected
[   31.863405] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, 
low) -> IRQ 18
[   31.863420] PCI: Setting latency timer of device 0000:00:1d.2 to 64
[   31.863426] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   31.863465] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned 
bus number 3
[   31.863506] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001040
[   31.863668] usb usb3: configuration #1 chosen from 1 choice
[   31.863690] hub 3-0:1.0: USB hub found
[   31.863696] hub 3-0:1.0: 2 ports detected
[   31.966410] ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 16 (level, 
low) -> IRQ 16
[   31.966424] PCI: Setting latency timer of device 0000:00:1d.3 to 64
[   31.966430] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[   31.966474] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned 
bus number 4
[   31.966515] uhci_hcd 0000:00:1d.3: irq 16, io base 0x00001060
[   31.966672] usb usb4: configuration #1 chosen from 1 choice
[   31.966694] hub 4-0:1.0: USB hub found
[   31.966699] hub 4-0:1.0: 2 ports detected
[   31.986241] usb 1-2: new full speed USB device using uhci_hcd and 
address 2
[   32.069620] ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, 
low) -> IRQ 23
[   32.069631] PCI: Setting latency timer of device 0000:00:1d.7 to 64
[   32.069635] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[   32.069657] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned 
bus number 5
[   32.073542] ehci_hcd 0000:00:1d.7: debug port 1
[   32.073548] PCI: cache line size of 128 is not supported by device 
0000:00:1d.7
[   32.073554] ehci_hcd 0000:00:1d.7: irq 23, io mem 0x94405000
[   32.105606] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 
10 Dec 2004
[   32.105772] usb usb5: configuration #1 chosen from 1 choice
[   32.105816] hub 5-0:1.0: USB hub found
[   32.105826] hub 5-0:1.0: 8 ports detected
[   31.770789] ACPI: PCI Interrupt 0000:00:1f.3[B] -> GSI 19 (level, 
low) -> IRQ 19
[   32.487265] usb 1-2: device not accepting address 2, error -71
[   32.320734] EXT3-fs warning: maximal mount count reached, running 
e2fsck is recommended
[   32.744797] EXT3 FS on sda3, internal journal
[   32.672956] loop: module loaded
[   33.156824] tun: Universal TUN/TAP device driver, 1.6
[   33.156830] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   33.234610] applesmc: Apple MacBook Pro detected:
[   33.234616] applesmc:  - Model with accelerometer
[   33.234619] applesmc:  - Model with light sensors and backlight
[   33.234623] applesmc:  - Model with 12 temperature sensors
[   33.287155] applesmc: device successfully initialized (0xe0, 0x00).
[   33.287161] applesmc: device successfully initialized.
[   33.287367] applesmc: 2 fans found.
[   33.288212] input: applesmc as 
/devices/platform/applesmc.768/input/input5
[   33.289363] Registered led device: smc::kbd_backlight
[   33.289397] applesmc: driver successfully loaded.
[   33.330264] usb 5-4: new high speed USB device using ehci_hcd and 
address 3
[   33.453679] usb 5-4: configuration #1 chosen from 1 choice
[   33.905231] usbcore: registered new interface driver appletouch
[   34.120545] usb 1-2: new full speed USB device using uhci_hcd and 
address 4
[   34.293060] usb 1-2: configuration #1 chosen from 1 choice
[   34.300629] appletouch: Geyser mode initialized.
[   34.300724] input: appletouch as 
/devices/pci0000:00/0000:00:1d.0/usb1/1-2/1-2:1.1/input/input6
[   34.144422] usb 3-2: new full speed USB device using uhci_hcd and 
address 2
[   34.716490] usb 3-2: configuration #1 chosen from 1 choice
[   34.943056] usb 4-1: new full speed USB device using uhci_hcd and 
address 2
[   35.111050] usb 4-1: configuration #1 chosen from 1 choice
[   35.118943] input: Apple Computer Apple Internal Keyboard / Trackpad 
as /devices/pci0000:00/0000:00:1d.0/usb1/1-2/1-2:1.0/input/input7
[   35.141137] input: USB HID v1.11 Keyboard [Apple Computer Apple 
Internal Keyboard / Trackpad] on usb-0000:00:1d.0-2
[   35.144559] input: Apple Computer Apple Internal Keyboard / Trackpad 
as /devices/pci0000:00/0000:00:1d.0/usb1/1-2/1-2:1.2/input/input8
[   35.146068] input: USB HID v1.11 Device [Apple Computer Apple 
Internal Keyboard / Trackpad] on usb-0000:00:1d.0-2
[   35.151666] HID device claimed by neither input, hiddev nor hidraw
[   35.168096] input: HID 05ac:1000 as 
/devices/pci0000:00/0000:00:1d.3/usb4/4-1/4-1:1.0/input/input9
[   35.168096] input: USB HID v1.11 Keyboard [HID 05ac:1000] on 
usb-0000:00:1d.3-1
[   35.185339] input: HID 05ac:1000 as 
/devices/pci0000:00/0000:00:1d.3/usb4/4-1/4-1:1.1/input/input10
[   35.188496] input: USB HID v1.11 Mouse [HID 05ac:1000] on 
usb-0000:00:1d.3-1
[   35.188533] usbcore: registered new interface driver usbhid
[   35.188538] drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
[   41.424832] kjournald starting.  Commit interval 90 seconds
[   41.806213] EXT3-fs warning: mounting fs with errors, running e2fsck 
is recommended
[   41.806412] EXT3 FS on dm-1, internal journal
[   41.806412] EXT3-fs: mounted filesystem with ordered data mode.
[   42.279730] Adding 1214416k swap on /dev/mapper/crypt-swap.  
Priority:-1 extents:1 across:1214416k
[   43.604904] sky2 eth0: enabling interface
[   57.340827] fuse init (API version 7.9)
[   58.030727] IA-32 Microcode Update Driver: v1.14a 
<tigran@aivazian.fsnet.co.uk>
[   58.359223] pktcdvd: writer pktcdvd0 mapped to sr0
[   59.709705] CPU0 attaching NULL sched-domain.
[   59.709715] CPU1 attaching NULL sched-domain.
[   59.711135] CPU0 attaching sched-domain:
[   59.711142]  domain 0: span 3
[   59.711145]   groups: 1 2
[   59.711151]   domain 1: span 3
[   59.711154]    groups: 3
[   59.711159] CPU1 attaching sched-domain:
[   59.711162]  domain 0: span 3
[   59.711165]   groups: 2 1
[   59.711170]   domain 1: span 3
[   59.711173]    groups: 3
[  202.841317] ath_hal: module license 'Proprietary' taints kernel.
[  202.842812] ath_hal: 0.9.30.13 (AR5210, AR5211, AR5212, AR5416, 
RF5111, RF5112, RF2413, RF5413, RF2133)
[  199.341116] wlan: svn r3360
[  199.354709] ath_pci: svn r3360
[  199.354969] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, 
low) -> IRQ 17
[  199.354990] PCI: Setting latency timer of device 0000:03:00.0 to 64
[  199.902312] MadWifi: ath_attach: Switching rfkill capability off
[  199.904493] ath_rate_sample: 1.2 (svn r3360)
[  199.904622] MadWifi: ath_attach: Switching per-packet transmit power 
control off
[  199.905025] wifi0: 11a rates: 6Mbps 9Mbps 12Mbps 18Mbps 24Mbps 36Mbps 
48Mbps 54Mbps
[  199.905034] wifi0: 11b rates: 1Mbps 2Mbps 5.5Mbps 11Mbps
[  199.905038] wifi0: 11g rates: 1Mbps 2Mbps 5.5Mbps 11Mbps 6Mbps 9Mbps 
12Mbps 18Mbps 24Mbps 36Mbps 48Mbps 54Mbps
[  199.905054] wifi0: turboG rates: 6Mbps 12Mbps 18Mbps 24Mbps 36Mbps 
48Mbps 54Mbps
[  199.905060] wifi0: H/W encryption support: WEP AES AES_CCM TKIP
[  199.905068] wifi0: ath_announce: Use hw queue 1 for WME_AC_BE traffic
[  199.905070] wifi0: ath_announce: Use hw queue 0 for WME_AC_BK traffic
[  199.905073] wifi0: ath_announce: Use hw queue 2 for WME_AC_VI traffic
[  199.905075] wifi0: ath_announce: Use hw queue 3 for WME_AC_VO traffic
[  199.905077] wifi0: ath_announce: Use hw queue 8 for CAB traffic
[  199.905079] wifi0: ath_announce: Use hw queue 9 for beacons
[  199.908169] ath_pci: wifi0: Atheros 5424/2424: mem=0x94300000, irq=17
[  847.318678] ohci1394: Unknown symbol hpsb_iso_wake
[  847.318791] ohci1394: Unknown symbol hpsb_resume_host
[  847.318906] ohci1394: Unknown symbol hpsb_disable_irm
[  847.319006] ohci1394: Unknown symbol hpsb_packet_received
[  847.319315] ohci1394: Unknown symbol dma_prog_region_free
[  847.319392] ohci1394: Unknown symbol hpsb_add_host
[  847.319472] ohci1394: Unknown symbol dma_region_sync_for_device
[  847.319550] ohci1394: Unknown symbol dma_prog_region_init
[  847.319650] ohci1394: Unknown symbol dma_prog_region_alloc
[  847.319762] ohci1394: Unknown symbol dma_region_offset_to_bus
[  847.319890] ohci1394: Unknown symbol hpsb_alloc_host
[  847.320009] ohci1394: Unknown symbol hpsb_selfid_complete
[  847.320104] ohci1394: Unknown symbol hpsb_remove_host
[  847.320177] ohci1394: Unknown symbol hpsb_iso_packet_received
[  847.320251] ohci1394: Unknown symbol hpsb_iso_packet_sent
[  847.320328] ohci1394: Unknown symbol hpsb_packet_sent
[  847.320406] ohci1394: Unknown symbol dma_region_sync_for_cpu
[  847.320513] ohci1394: Unknown symbol hpsb_selfid_received
[  847.320586] ohci1394: Unknown symbol hpsb_bus_reset
[  856.789954] ACPI: PCI Interrupt 0000:0c:03.0[A] -> GSI 19 (level, 
low) -> IRQ 19
[  856.790040] ------------[ cut here ]------------
[  856.790044] WARNING: at arch/x86/mm/ioremap.c:137 __ioremap+0xa7/0x16a()
[  856.790048] Modules linked in: ohci1394(+) ieee1394 wlan_wep 
wlan_scan_sta ath_rate_sample ath_pci wlan ath_hal(P) firmware_class 
fuse snd_seq snd_seq_device nls_iso8859_15 nls_cp850 vfat fat usbhid 
appletouch applesmc input_polldev led_class dummy binfmt_misc tun 
pktcdvd loop msr cpuid coretemp hwmon eeprom cpufreq_powersave 
cpufreq_conservative acpi_cpufreq thermal ehci_hcd tpm_infineon i2c_i801 
i2c_core tpm uhci_hcd usbcore tpm_bios processor ac battery sr_mod 
rng_core iTCO_wdt button firewire_ohci firewire_core sg snd_hda_intel 
snd_pcm snd_timer snd soundcore snd_page_alloc evdev intel_agp cdrom 
[last unloaded: microcode]
[  856.790119] Pid: 7140, comm: insmod Tainted: P         2.6.25-rc2 #115
[  856.790125]  [<c011e5ab>] warn_on_slowpath+0x40/0x4f
[  856.790143]  [<c0118045>] __wake_up+0x29/0x39
[  856.790154]  [<c0277305>] netlink_broadcast+0x26e/0x2af
[  856.790169]  [<c01cc36b>] kobject_uevent_env+0x33d/0x361
[  856.790178]  [<c025ef2b>] pci_mmcfg_write+0xc4/0xd5
[  856.790187]  [<c0260157>] raw_pci_write+0x3e/0x46
[  856.790200]  [<c01148f8>] __ioremap+0xa7/0x16a
[  856.790210]  [<f8b14425>] ohci1394_pci_probe+0x20c/0x5a6 [ohci1394]
[  856.790226]  [<c01d63f1>] pci_device_probe+0x36/0x55
[  856.790236]  [<c02226cb>] driver_probe_device+0x9d/0x114
[  856.790246]  [<c0222826>] __driver_attach+0x52/0x87
[  856.790254]  [<c0221d46>] bus_for_each_dev+0x35/0x57
[  856.790265]  [<c022257e>] driver_attach+0x11/0x13
[  856.790270]  [<c02227d4>] __driver_attach+0x0/0x87
[  856.790277]  [<c02223bc>] bus_add_driver+0x91/0x195
[  856.790286]  [<c02229d9>] driver_register+0x45/0x9a
[  856.790297]  [<c01d65a6>] __pci_register_driver+0x32/0x60
[  856.790305]  [<c013aea0>] sys_init_module+0x16b7/0x179f
[  856.790495]  [<c0160bb9>] do_sync_read+0xbe/0x103
[  856.790518]  [<c01549fc>] anon_vma_prepare+0x11/0xa6
[  856.790529]  [<f8b55185>] hpsb_bus_reset+0x0/0xe2 [ieee1394]
[  856.790560]  [<c0171db7>] mntput_no_expire+0x13/0x5d
[  856.790569]  [<c015f6ce>] filp_close+0x4d/0x53
[  856.790578]  [<c01048a2>] sysenter_past_esp+0x5f/0x85
[  856.790595]  =======================
[  856.790598] ---[ end trace 5b0384c17c339107 ]---
[  856.943807] ohci1394: fw-host0: Get PHY Reg timeout 
[0x00008400/0x00000000/100]
[  856.947140] ohci1394: fw-host0: Set PHY Reg timeout 
[0x000044c0/0x00004000/100]
[  856.947261] ohci1394: fw-host0: OHCI-1394 0.35 (PCI): IRQ=[19]  
MMIO=[100000000-1000007ff]  Max Packet=[65536]  IR/IT contexts=[32/32]
[  856.950473] ohci1394: fw-host0: Get PHY Reg timeout 
[0x00008200/0x00000000/100]
[  856.950556] ohci1394: fw-host0: Serial EEPROM has suspicious values, 
attempting to set max_packet_size to 512 bytes
[  857.942972] ohci1394: fw-host0: Get PHY Reg timeout 
[0x00008500/0x00000000/100]
[  857.946305] ohci1394: fw-host0: Set PHY Reg timeout 
[0x00004540/0x00004000/100]
[  921.500561] ohci1394: fw-host0: Unrecoverable error!
[  921.500574] ohci1394: fw-host0: Async Rsp Tx Context died: 
ctrl[f0002a00] cmdptr[f0002a00]
[  921.500586] ohci1394: fw-host0: Iso Recv 3 Context died: 
ctrl[d4000d0e] cmdptr[001073d9] match[00000000]
[  921.500594] ohci1394: fw-host0: Iso Recv 17 Context died: 
ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[  921.500601] ohci1394: fw-host0: Iso Recv 18 Context died: 
ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[  921.500607] ohci1394: fw-host0: Iso Recv 19 Context died: 
ctrl[0c047e80] cmdptr[83060246] match[83060846]
[  921.500615] ohci1394: fw-host0: Iso Recv 26 Context died: 
ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[  921.500621] ohci1394: fw-host0: Iso Recv 27 Context died: 
ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[  921.500627] ohci1394: fw-host0: physical posted write error
[  921.500630] ohci1394: fw-host0: isochronous cycle too long
[  921.500636] ohci1394: fw-host0: respTxComplete: dma prg stopped
[  921.500642] ohci1394: fw-host0: SelfID received outside of bus reset 
sequence
[  921.500646] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[  921.501131] ohci1394: fw-host0: Unrecoverable error!
[  921.501139] ohci1394: fw-host0: Async Rsp Tx Context died: 
ctrl[f0002a00] cmdptr[f0002a00]
[  921.501151] ohci1394: fw-host0: Iso Recv 3 Context died: 
ctrl[d4000d0e] cmdptr[001073d9] match[00000000]
[  921.501159] ohci1394: fw-host0: Iso Recv 17 Context died: 
ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[  921.501166] ohci1394: fw-host0: Iso Recv 18 Context died: 
ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[  921.501172] ohci1394: fw-host0: Iso Recv 19 Context died: 
ctrl[0c047e80] cmdptr[83060246] match[83060846]
[  921.501180] ohci1394: fw-host0: Iso Recv 26 Context died: 
ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[  921.501186] ohci1394: fw-host0: Iso Recv 27 Context died: 
ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[  921.501191] ohci1394: fw-host0: physical posted write error
[  921.501195] ohci1394: fw-host0: isochronous cycle too long
[  921.501200] ohci1394: fw-host0: respTxComplete: dma prg stopped
[  921.501205] ohci1394: fw-host0: SelfID received outside of bus reset 
sequence
[  921.501209] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[  921.826439] ohci1394: fw-host0: Unrecoverable error!
[  921.826439] ohci1394: fw-host0: Async Rsp Tx Context died: 
ctrl[f0002a00] cmdptr[f0002a00]
[  921.826439] ohci1394: fw-host0: Iso Recv 3 Context died: 
ctrl[d4000d0e] cmdptr[001073d9] match[00000000]
[  921.826439] ohci1394: fw-host0: Iso Recv 17 Context died: 
ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[  921.826439] ohci1394: fw-host0: Iso Recv 18 Context died: 
ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[  921.826439] ohci1394: fw-host0: Iso Recv 19 Context died: 
ctrl[0c047e80] cmdptr[83060246] match[83060846]
[  921.826439] ohci1394: fw-host0: Iso Recv 26 Context died: 
ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[  921.826439] ohci1394: fw-host0: Iso Recv 27 Context died: 
ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[  921.826439] ohci1394: fw-host0: physical posted write error
[  921.826439] ohci1394: fw-host0: isochronous cycle too long
[  921.826439] ohci1394: fw-host0: respTxComplete: dma prg stopped
[  921.826439] ohci1394: fw-host0: SelfID received outside of bus reset 
sequence
[  921.826439] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[  924.499747] ohci1394: fw-host0: Unrecoverable error!
[  924.499758] ohci1394: fw-host0: Async Rsp Tx Context died: 
ctrl[f0002a00] cmdptr[f0002a00]
[  924.499770] ohci1394: fw-host0: Iso Recv 3 Context died: 
ctrl[d4000d0e] cmdptr[001073d9] match[00000000]
[  924.499778] ohci1394: fw-host0: Iso Recv 17 Context died: 
ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[  924.499785] ohci1394: fw-host0: Iso Recv 18 Context died: 
ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[  924.499792] ohci1394: fw-host0: Iso Recv 19 Context died: 
ctrl[0c047e80] cmdptr[83060246] match[83060846]
[  924.499799] ohci1394: fw-host0: Iso Recv 26 Context died: 
ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[  924.499805] ohci1394: fw-host0: Iso Recv 27 Context died: 
ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[  924.499811] ohci1394: fw-host0: physical posted write error
[  924.499814] ohci1394: fw-host0: isochronous cycle too long
[  924.499820] ohci1394: fw-host0: respTxComplete: dma prg stopped
[  924.499825] ohci1394: fw-host0: SelfID received outside of bus reset 
sequence
[  924.499830] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[  924.500111] ohci1394: fw-host0: Unrecoverable error!
[  924.500117] ohci1394: fw-host0: Async Rsp Tx Context died: 
ctrl[f0002a00] cmdptr[f0002a00]
[  924.500128] ohci1394: fw-host0: Iso Recv 3 Context died: 
ctrl[d4000d0e] cmdptr[001073d9] match[00000000]
[  924.500137] ohci1394: fw-host0: Iso Recv 17 Context died: 
ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[  924.500144] ohci1394: fw-host0: Iso Recv 18 Context died: 
ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[  924.500150] ohci1394: fw-host0: Iso Recv 19 Context died: 
ctrl[0c047e80] cmdptr[83060246] match[83060846]
[  924.500158] ohci1394: fw-host0: Iso Recv 26 Context died: 
ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[  924.500164] ohci1394: fw-host0: Iso Recv 27 Context died: 
ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[  924.500170] ohci1394: fw-host0: physical posted write error
[  924.500173] ohci1394: fw-host0: isochronous cycle too long
[  924.500178] ohci1394: fw-host0: respTxComplete: dma prg stopped
[  924.500183] ohci1394: fw-host0: SelfID received outside of bus reset 
sequence
[  924.500187] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[  924.521645] ohci1394: fw-host0: Unrecoverable error!
[  924.521645] ohci1394: fw-host0: Async Rsp Tx Context died: 
ctrl[f0002a00] cmdptr[f0002a00]
[  924.521645] ohci1394: fw-host0: Iso Recv 3 Context died: 
ctrl[d4000d0e] cmdptr[001073d9] match[00000000]
[  924.521645] ohci1394: fw-host0: Iso Recv 17 Context died: 
ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[  924.521645] ohci1394: fw-host0: Iso Recv 18 Context died: 
ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[  924.521645] ohci1394: fw-host0: Iso Recv 19 Context died: 
ctrl[0c047e80] cmdptr[83060246] match[83060846]
[  924.521645] ohci1394: fw-host0: Iso Recv 26 Context died: 
ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[  924.521645] ohci1394: fw-host0: Iso Recv 27 Context died: 
ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[  924.521645] ohci1394: fw-host0: physical posted write error
[  924.521645] ohci1394: fw-host0: isochronous cycle too long
[  924.521645] ohci1394: fw-host0: respTxComplete: dma prg stopped
[  924.521645] ohci1394: fw-host0: SelfID received outside of bus reset 
sequence
[  924.521645] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[  924.522351] ohci1394: fw-host0: Unrecoverable error!
[  924.522358] ohci1394: fw-host0: Async Rsp Tx Context died: 
ctrl[f0002a00] cmdptr[f0002a00]
[  924.522369] ohci1394: fw-host0: Iso Recv 3 Context died: 
ctrl[d4000d0e] cmdptr[001073d9] match[00000000]
[  924.522377] ohci1394: fw-host0: Iso Recv 17 Context died: 
ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[  924.522384] ohci1394: fw-host0: Iso Recv 18 Context died: 
ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[  924.522391] ohci1394: fw-host0: Iso Recv 19 Context died: 
ctrl[0c047e80] cmdptr[83060246] match[83060846]
[  924.522398] ohci1394: fw-host0: Iso Recv 26 Context died: 
ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[  924.522405] ohci1394: fw-host0: Iso Recv 27 Context died: 
ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[  924.522410] ohci1394: fw-host0: physical posted write error
[  924.522414] ohci1394: fw-host0: isochronous cycle too long
[  924.522418] ohci1394: fw-host0: respTxComplete: dma prg stopped
[  924.522423] ohci1394: fw-host0: SelfID received outside of bus reset 
sequence
[  924.522427] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[  943.644818] ohci1394: fw-host0: Get PHY Reg timeout 
[0x00008400/0x00000000/100]
[  943.648151] ohci1394: fw-host0: Set PHY Reg timeout 
[0x00004400/0x00004000/100]
[  943.651484] ohci1394: fw-host0: Get PHY Reg timeout 
[0x00008100/0x00000000/100]
[  943.654817] ohci1394: fw-host0: Set PHY Reg timeout 
[0x00004140/0x00004000/100]
[  994.468376] ohci1394: fw-host0: Get PHY Reg timeout 
[0x00008400/0x00000000/100]
[  994.471709] ohci1394: fw-host0: Set PHY Reg timeout 
[0x000044c0/0x00004000/100]
[  994.471724] ohci1394: fw-host0: OHCI-1394 0.35 (PCI): IRQ=[19]  
MMIO=[100000000-1000007ff]  Max Packet=[65536]  IR/IT contexts=[32/32]
[  994.475042] ohci1394: fw-host0: Get PHY Reg timeout 
[0x00008200/0x00000000/100]
[  994.475048] ohci1394: fw-host0: Serial EEPROM has suspicious values, 
attempting to set max_packet_size to 512 bytes
[  995.476401] ohci1394: fw-host0: Get PHY Reg timeout 
[0x00008500/0x00000000/100]
[  995.479734] ohci1394: fw-host0: Set PHY Reg timeout 
[0x00004540/0x00004000/100]
[ 1001.867944] ohci1394: fw-host0: Get PHY Reg timeout 
[0x00008400/0x00000000/100]
[ 1001.871277] ohci1394: fw-host0: Set PHY Reg timeout 
[0x00004400/0x00004000/100]
[ 1001.874610] ohci1394: fw-host0: Get PHY Reg timeout 
[0x00008100/0x00000000/100]
[ 1001.877943] ohci1394: fw-host0: Set PHY Reg timeout 
[0x00004140/0x00004000/100]

