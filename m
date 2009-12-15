Return-Path: <linux-kernel-owner+w=401wt.eu-S1751804AbZLOFkL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751804AbZLOFkL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 00:40:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751556AbZLOFkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 00:40:09 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:1087 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbZLOFkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 00:40:06 -0500
Date: Mon, 14 Dec 2009 22:40:04 -0700
From: Alex Chiang <achiang@hp.com>
To: Xiaotian Feng <xtfeng@gmail.com>
Cc: Dave Airlie <airlied@redhat.com>, rjw@sisk.pl,
       linux-kernel <linux-kernel@vger.kernel.org>,
       dri-devel@lists.sourceforge.net
Subject: Re: radeon 4830 corruption after resume
Message-ID: <20091215054004.GF587@ldl.fc.hp.com>
References: <20091214023051.GA29591@ldl.fc.hp.com> <1260759123.3391.0.camel@localhost> <20091214031127.GB29591@ldl.fc.hp.com> <7b6bb4a50912132128r68dbd8b3p9304920e3080b5e1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="vtzGhvizbBRQ85DL"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7b6bb4a50912132128r68dbd8b3p9304920e3080b5e1@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vtzGhvizbBRQ85DL
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Adding dri-devel to cc as I should have done in the first place.

Full thread for context here: http://lkml.org/lkml/2009/12/13/321

More responses below.

* Xiaotian Feng <xtfeng@gmail.com>:
> On Mon, Dec 14, 2009 at 11:11 AM, Alex Chiang <achiang@hp.com> wrote:
> > * Dave Airlie <airlied@redhat.com>:
> >> On Sun, 2009-12-13 at 19:30 -0700, Alex Chiang wrote:
> >> > Hi Dave, Rafael,
> >> >
> >> > I can successfully suspend/resume my HP Envy, but upon resume,
> >> > the screen is corrupted.
> >> >
> >> > I used the gnome screenshot utility to capture this:
> >> >
> >> >     http://chizang.net/alex/tmp/radeon-4830-corruption.png
> >> >
> >> > But that screenshot leads you to believe the corruption was
> >> > 100%, when in reality, the text in my xterms was at least
> >> > readable, but ugly.
> >> >
> >> > Kernel is latest upstream pulled today. Userspace is Ubuntu Karmic.
> >>
> >> Has it ever worked? can you suspend/resume without X running at all?
> >
> > Hm, define "worked"?
> >
> > The machine responds to keyboard, mouse, network input, etc. It's
> > just that the screen is garbled.
> >
> > Unless I'm not understanding what you're asking?
> >
> >> Its quite possibly a userspace problem but its hard to know, we
> >> haven't changed the user modesetting pieces in the kernel at all in
> >> quite a while.
> >
> > Ok, I'm just looking for where/how to start debugging. Any advice
> > on where to look next would be fine too.
> 
> Then how about ssh to your machine, and get dmesg output?

The machine is actually useable. Wireless networking even works.
It's just that the screen is garbled.

Here's a much better idea of the type of corruption that I'm
seeing. Huge file alert, it's like a 5MB jpg.

	http://chizang.net/alex/tmp/corrupt-radeon2.jpg

I'm attaching full dmesg and pm-suspend.log.

The suspend happens some time around time 400 and the resume is
the huge jump in time afterwards.

Thanks,
/ac


--vtzGhvizbBRQ85DL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-corrupt.txt"

Dec 14 22:07:55 dre kernel: [    0.000000] Initializing cgroup subsys cpuset
Dec 14 22:07:55 dre kernel: [    0.000000] Initializing cgroup subsys cpu
Dec 14 22:07:55 dre kernel: [    0.000000] Linux version 2.6.32 (achiang@dre) (gcc version 4.4.1 (Ubuntu 4.4.1-4ubuntu8) ) #6 SMP Mon Dec 14 20:19:19 MST 2009
Dec 14 22:07:55 dre kernel: [    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-2.6.32 root=UUID=002d7dd4-cbb2-44be-aaad-25190d2057e1 ro ignore_loglvl acpi.debug_layer=0x20800000 acpi.debug_level=0x4
Dec 14 22:07:55 dre kernel: [    0.000000] BIOS-provided physical RAM map:
Dec 14 22:07:55 dre kernel: [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009bc00 (usable)
Dec 14 22:07:55 dre kernel: [    0.000000]  BIOS-e820: 000000000009bc00 - 00000000000a0000 (reserved)
Dec 14 22:07:55 dre kernel: [    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
Dec 14 22:07:55 dre kernel: [    0.000000]  BIOS-e820: 0000000000100000 - 00000000bf682000 (usable)
Dec 14 22:07:55 dre kernel: [    0.000000]  BIOS-e820: 00000000bf682000 - 00000000bf6bf000 (reserved)
Dec 14 22:07:55 dre kernel: [    0.000000]  BIOS-e820: 00000000bf6bf000 - 00000000bf75c000 (usable)
Dec 14 22:07:55 dre kernel: [    0.000000]  BIOS-e820: 00000000bf75c000 - 00000000bf7bf000 (ACPI NVS)
Dec 14 22:07:55 dre kernel: [    0.000000]  BIOS-e820: 00000000bf7bf000 - 00000000bf7e3000 (usable)
Dec 14 22:07:55 dre kernel: [    0.000000]  BIOS-e820: 00000000bf7e3000 - 00000000bf7ff000 (ACPI data)
Dec 14 22:07:55 dre kernel: [    0.000000]  BIOS-e820: 00000000bf7ff000 - 00000000bf800000 (usable)
Dec 14 22:07:55 dre kernel: [    0.000000]  BIOS-e820: 00000000bf800000 - 00000000c0000000 (reserved)
Dec 14 22:07:55 dre kernel: [    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
Dec 14 22:07:55 dre kernel: [    0.000000]  BIOS-e820: 00000000feb00000 - 00000000feb04000 (reserved)
Dec 14 22:07:55 dre kernel: [    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
Dec 14 22:07:55 dre kernel: [    0.000000]  BIOS-e820: 00000000fed10000 - 00000000fed14000 (reserved)
Dec 14 22:07:55 dre kernel: [    0.000000]  BIOS-e820: 00000000fed18000 - 00000000fed1a000 (reserved)
Dec 14 22:07:55 dre kernel: [    0.000000]  BIOS-e820: 00000000fed1b000 - 00000000fed20000 (reserved)
Dec 14 22:07:55 dre kernel: [    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
Dec 14 22:07:55 dre kernel: [    0.000000]  BIOS-e820: 00000000ffe80000 - 0000000100000000 (reserved)
Dec 14 22:07:55 dre kernel: [    0.000000]  BIOS-e820: 0000000100000000 - 0000000240000000 (usable)
Dec 14 22:07:55 dre kernel: [    0.000000] NX (Execute Disable) protection: active
Dec 14 22:07:55 dre kernel: [    0.000000] DMI 2.6 present.
Dec 14 22:07:55 dre kernel: [    0.000000] last_pfn = 0x240000 max_arch_pfn = 0x400000000
Dec 14 22:07:55 dre kernel: [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
Dec 14 22:07:55 dre kernel: [    0.000000] last_pfn = 0xbf800 max_arch_pfn = 0x400000000
Dec 14 22:07:55 dre kernel: [    0.000000] Scanning 1 areas for low memory corruption
Dec 14 22:07:55 dre kernel: [    0.000000] modified physical RAM map:
Dec 14 22:07:55 dre kernel: [    0.000000]  modified: 0000000000000000 - 0000000000001000 (usable)
Dec 14 22:07:55 dre kernel: [    0.000000]  modified: 0000000000001000 - 0000000000006000 (reserved)
Dec 14 22:07:55 dre kernel: [    0.000000]  modified: 0000000000006000 - 000000000009bc00 (usable)
Dec 14 22:07:55 dre kernel: [    0.000000]  modified: 000000000009bc00 - 00000000000a0000 (reserved)
Dec 14 22:07:55 dre kernel: [    0.000000]  modified: 00000000000e0000 - 0000000000100000 (reserved)
Dec 14 22:07:55 dre kernel: [    0.000000]  modified: 0000000000100000 - 00000000bf682000 (usable)
Dec 14 22:07:55 dre kernel: [    0.000000]  modified: 00000000bf682000 - 00000000bf6bf000 (reserved)
Dec 14 22:07:55 dre kernel: [    0.000000]  modified: 00000000bf6bf000 - 00000000bf75c000 (usable)
Dec 14 22:07:55 dre kernel: [    0.000000]  modified: 00000000bf75c000 - 00000000bf7bf000 (ACPI NVS)
Dec 14 22:07:55 dre kernel: [    0.000000]  modified: 00000000bf7bf000 - 00000000bf7e3000 (usable)
Dec 14 22:07:55 dre kernel: [    0.000000]  modified: 00000000bf7e3000 - 00000000bf7ff000 (ACPI data)
Dec 14 22:07:55 dre kernel: [    0.000000]  modified: 00000000bf7ff000 - 00000000bf800000 (usable)
Dec 14 22:07:55 dre kernel: [    0.000000]  modified: 00000000bf800000 - 00000000c0000000 (reserved)
Dec 14 22:07:55 dre kernel: [    0.000000]  modified: 00000000e0000000 - 00000000f0000000 (reserved)
Dec 14 22:07:55 dre kernel: [    0.000000]  modified: 00000000feb00000 - 00000000feb04000 (reserved)
Dec 14 22:07:55 dre kernel: [    0.000000]  modified: 00000000fec00000 - 00000000fec01000 (reserved)
Dec 14 22:07:55 dre kernel: [    0.000000]  modified: 00000000fed10000 - 00000000fed14000 (reserved)
Dec 14 22:07:55 dre kernel: [    0.000000]  modified: 00000000fed18000 - 00000000fed1a000 (reserved)
Dec 14 22:07:55 dre kernel: [    0.000000]  modified: 00000000fed1b000 - 00000000fed20000 (reserved)
Dec 14 22:07:55 dre kernel: [    0.000000]  modified: 00000000fee00000 - 00000000fee01000 (reserved)
Dec 14 22:07:55 dre kernel: [    0.000000]  modified: 00000000ffe80000 - 0000000100000000 (reserved)
Dec 14 22:07:55 dre kernel: [    0.000000]  modified: 0000000100000000 - 0000000240000000 (usable)
Dec 14 22:07:55 dre kernel: [    0.000000] init_memory_mapping: 0000000000000000-00000000bf800000
Dec 14 22:07:55 dre kernel: [    0.000000] init_memory_mapping: 0000000100000000-0000000240000000
Dec 14 22:07:55 dre kernel: [    0.000000] RAMDISK: 34b76000 - 37fef7d2
Dec 14 22:07:55 dre kernel: [    0.000000] ACPI: RSDP 00000000000fe020 00024 (v02 HP    )
Dec 14 22:07:55 dre kernel: [    0.000000] ACPI: XSDT 00000000bf7fe120 0009C (v01 HPQOEM SLIC-MPC 00000001      01000013)
Dec 14 22:07:55 dre kernel: [    0.000000] ACPI: FACP 00000000bf7fb000 000F4 (v04 HP     SLIC-MPC 00000001 MSFT 01000013)
Dec 14 22:07:55 dre kernel: [    0.000000] ACPI: DSDT 00000000bf7ec000 0B1DF (v02 HP     SLIC-MPC 00000001 MSFT 01000013)
Dec 14 22:07:55 dre kernel: [    0.000000] ACPI: FACS 00000000bf76e000 00040
Dec 14 22:07:55 dre kernel: [    0.000000] ACPI: DMAR 00000000bf7fd000 00060 (v01 INTEL  CP_FIELD 00000001 INTL 00000001)
Dec 14 22:07:55 dre kernel: [    0.000000] ACPI: ASF! 00000000bf7fc000 000A5 (v32 HPQOEM SLIC-MPC 00000001 MSFT 01000013)
Dec 14 22:07:55 dre kernel: [    0.000000] ACPI: HPET 00000000bf7fa000 00038 (v01 HPQOEM SLIC-MPC 00000001 MSFT 01000013)
Dec 14 22:07:55 dre kernel: [    0.000000] ACPI: APIC 00000000bf7f9000 0008C (v02 HPQOEM SLIC-MPC 00000001 MSFT 01000013)
Dec 14 22:07:55 dre kernel: [    0.000000] ACPI: MCFG 00000000bf7f8000 0003C (v01 HPQOEM SLIC-MPC 00000001 MSFT 01000013)
Dec 14 22:07:55 dre kernel: [    0.000000] ACPI: SLIC 00000000bf7eb000 00176 (v01 HPQOEM SLIC-MPC 00000001 MSFT 01000013)
Dec 14 22:07:55 dre kernel: [    0.000000] ACPI: SSDT 00000000bf7ea000 0073D (v01 TrmRef PtidDevc 00001000 INTL 20051117)
Dec 14 22:07:55 dre kernel: [    0.000000] ACPI: SSDT 00000000bf7e9000 00172 (v01  VaRef  Va_Acpi 00003000 INTL 20051117)
Dec 14 22:07:55 dre kernel: [    0.000000] ACPI: BOOT 00000000bf7e8000 00028 (v01 HPQOEM SLIC-MPC 00000001 MSFT 01000013)
Dec 14 22:07:55 dre kernel: [    0.000000] ACPI: SSDT 00000000bf7e7000 00C39 (v01 INTEL   SataPri 00001000 INTL 20051117)
Dec 14 22:07:55 dre kernel: [    0.000000] ACPI: SSDT 00000000bf7e6000 006C5 (v01 INTEL   SataSec 00001000 INTL 20051117)
Dec 14 22:07:55 dre kernel: [    0.000000] ACPI: SPCR 00000000bf7e5000 00050 (v01 HPQOEM SLIC-MPC 00000000 MSFT 01000013)
Dec 14 22:07:55 dre kernel: [    0.000000] ACPI: ASPT 00000000bf7e4000 00034 (v04 HPQOEM SLIC-MPC 00000001 MSFT 01000013)
Dec 14 22:07:55 dre kernel: [    0.000000] ACPI: SSDT 00000000bf7e3000 009F1 (v01  PmRef    CpuPm 00003000 INTL 20051117)
Dec 14 22:07:55 dre kernel: [    0.000000] No NUMA configuration found
Dec 14 22:07:55 dre kernel: [    0.000000] Faking a node at 0000000000000000-0000000240000000
Dec 14 22:07:55 dre kernel: [    0.000000] Bootmem setup node 0 0000000000000000-0000000240000000
Dec 14 22:07:55 dre kernel: [    0.000000]   NODE_DATA [0000000000013000 - 0000000000017fff]
Dec 14 22:07:55 dre kernel: [    0.000000]   bootmap [0000000000018000 -  000000000005ffff] pages 48
Dec 14 22:07:55 dre kernel: [    0.000000] (9 early reservations) ==> bootmem [0000000000 - 0240000000]
Dec 14 22:07:55 dre kernel: [    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
Dec 14 22:07:55 dre kernel: [    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
Dec 14 22:07:55 dre kernel: [    0.000000]   #2 [0001000000 - 0001c71794]    TEXT DATA BSS ==> [0001000000 - 0001c71794]
Dec 14 22:07:55 dre kernel: [    0.000000]   #3 [0034b76000 - 0037fef7d2]          RAMDISK ==> [0034b76000 - 0037fef7d2]
Dec 14 22:07:55 dre kernel: [    0.000000]   #4 [000009bc00 - 0000100000]    BIOS reserved ==> [000009bc00 - 0000100000]
Dec 14 22:07:55 dre kernel: [    0.000000]   #5 [0001c72000 - 0001c72260]              BRK ==> [0001c72000 - 0001c72260]
Dec 14 22:07:55 dre kernel: [    0.000000]   #6 [0000008000 - 000000c000]      ACPI WAKEUP ==> [0000008000 - 000000c000]
Dec 14 22:07:55 dre kernel: [    0.000000]   #7 [000000c000 - 000000e000]          PGTABLE ==> [000000c000 - 000000e000]
Dec 14 22:07:55 dre kernel: [    0.000000]   #8 [000000e000 - 0000013000]          PGTABLE ==> [000000e000 - 0000013000]
Dec 14 22:07:55 dre kernel: [    0.000000] Zone PFN ranges:
Dec 14 22:07:55 dre kernel: [    0.000000]   DMA      0x00000000 -> 0x00001000
Dec 14 22:07:55 dre kernel: [    0.000000]   DMA32    0x00001000 -> 0x00100000
Dec 14 22:07:55 dre kernel: [    0.000000]   Normal   0x00100000 -> 0x00240000
Dec 14 22:07:55 dre kernel: [    0.000000] Movable zone start PFN for each node
Dec 14 22:07:55 dre kernel: [    0.000000] early_node_map[7] active PFN ranges
Dec 14 22:07:55 dre kernel: [    0.000000]     0: 0x00000000 -> 0x00000001
Dec 14 22:07:55 dre kernel: [    0.000000]     0: 0x00000006 -> 0x0000009b
Dec 14 22:07:55 dre kernel: [    0.000000]     0: 0x00000100 -> 0x000bf682
Dec 14 22:07:55 dre kernel: [    0.000000]     0: 0x000bf6bf -> 0x000bf75c
Dec 14 22:07:55 dre kernel: [    0.000000]     0: 0x000bf7bf -> 0x000bf7e3
Dec 14 22:07:55 dre kernel: [    0.000000]     0: 0x000bf7ff -> 0x000bf800
Dec 14 22:07:55 dre kernel: [    0.000000]     0: 0x00100000 -> 0x00240000
Dec 14 22:07:55 dre kernel: [    0.000000] ACPI: PM-Timer IO Port: 0x408
Dec 14 22:07:55 dre kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Dec 14 22:07:55 dre kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Dec 14 22:07:55 dre kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
Dec 14 22:07:55 dre kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
Dec 14 22:07:55 dre kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x04] enabled)
Dec 14 22:07:55 dre kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x05] enabled)
Dec 14 22:07:55 dre kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x06] enabled)
Dec 14 22:07:55 dre kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x07] enabled)
Dec 14 22:07:55 dre kernel: [    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
Dec 14 22:07:55 dre kernel: [    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
Dec 14 22:07:55 dre kernel: [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
Dec 14 22:07:55 dre kernel: [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
Dec 14 22:07:55 dre kernel: [    0.000000] Using ACPI (MADT) for SMP configuration information
Dec 14 22:07:55 dre kernel: [    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
Dec 14 22:07:55 dre kernel: [    0.000000] SMP: Allowing 8 CPUs, 0 hotplug CPUs
Dec 14 22:07:55 dre kernel: [    0.000000] PM: Registered nosave memory: 0000000000001000 - 0000000000006000
Dec 14 22:07:55 dre kernel: [    0.000000] PM: Registered nosave memory: 000000000009b000 - 000000000009c000
Dec 14 22:07:55 dre kernel: [    0.000000] PM: Registered nosave memory: 000000000009c000 - 00000000000a0000
Dec 14 22:07:55 dre kernel: [    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
Dec 14 22:07:55 dre kernel: [    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
Dec 14 22:07:55 dre kernel: [    0.000000] PM: Registered nosave memory: 00000000bf682000 - 00000000bf6bf000
Dec 14 22:07:55 dre kernel: [    0.000000] PM: Registered nosave memory: 00000000bf75c000 - 00000000bf7bf000
Dec 14 22:07:55 dre kernel: [    0.000000] PM: Registered nosave memory: 00000000bf7e3000 - 00000000bf7ff000
Dec 14 22:07:55 dre kernel: [    0.000000] PM: Registered nosave memory: 00000000bf800000 - 00000000c0000000
Dec 14 22:07:55 dre kernel: [    0.000000] PM: Registered nosave memory: 00000000c0000000 - 00000000e0000000
Dec 14 22:07:55 dre kernel: [    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
Dec 14 22:07:55 dre kernel: [    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000feb00000
Dec 14 22:07:55 dre kernel: [    0.000000] PM: Registered nosave memory: 00000000feb00000 - 00000000feb04000
Dec 14 22:07:55 dre kernel: [    0.000000] PM: Registered nosave memory: 00000000feb04000 - 00000000fec00000
Dec 14 22:07:55 dre kernel: [    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec01000
Dec 14 22:07:55 dre kernel: [    0.000000] PM: Registered nosave memory: 00000000fec01000 - 00000000fed10000
Dec 14 22:07:55 dre kernel: [    0.000000] PM: Registered nosave memory: 00000000fed10000 - 00000000fed14000
Dec 14 22:07:55 dre kernel: [    0.000000] PM: Registered nosave memory: 00000000fed14000 - 00000000fed18000
Dec 14 22:07:55 dre kernel: [    0.000000] PM: Registered nosave memory: 00000000fed18000 - 00000000fed1a000
Dec 14 22:07:55 dre kernel: [    0.000000] PM: Registered nosave memory: 00000000fed1a000 - 00000000fed1b000
Dec 14 22:07:55 dre kernel: [    0.000000] PM: Registered nosave memory: 00000000fed1b000 - 00000000fed20000
Dec 14 22:07:55 dre kernel: [    0.000000] PM: Registered nosave memory: 00000000fed20000 - 00000000fee00000
Dec 14 22:07:55 dre kernel: [    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
Dec 14 22:07:55 dre kernel: [    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ffe80000
Dec 14 22:07:55 dre kernel: [    0.000000] PM: Registered nosave memory: 00000000ffe80000 - 0000000100000000
Dec 14 22:07:55 dre kernel: [    0.000000] Allocating PCI resources starting at c0000000 (gap: c0000000:20000000)
Dec 14 22:07:55 dre kernel: [    0.000000] Booting paravirtualized kernel on bare hardware
Dec 14 22:07:55 dre kernel: [    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:8 nr_node_ids:1
Dec 14 22:07:55 dre kernel: [    0.000000] PERCPU: Embedded 29 pages/cpu @ffff880028200000 s89880 r8192 d20712 u262144
Dec 14 22:07:55 dre kernel: [    0.000000] pcpu-alloc: s89880 r8192 d20712 u262144 alloc=1*2097152
Dec 14 22:07:55 dre kernel: [    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
Dec 14 22:07:55 dre kernel: [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2062440
Dec 14 22:07:55 dre kernel: [    0.000000] Policy zone: Normal
Dec 14 22:07:55 dre kernel: [    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-2.6.32 root=UUID=002d7dd4-cbb2-44be-aaad-25190d2057e1 ro ignore_loglvl acpi.debug_layer=0x20800000 acpi.debug_level=0x4
Dec 14 22:07:55 dre kernel: [    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
Dec 14 22:07:55 dre kernel: [    0.000000] Initializing CPU#0
Dec 14 22:07:55 dre kernel: [    0.000000] Checking aperture...
Dec 14 22:07:55 dre kernel: [    0.000000] No AGP bridge found
Dec 14 22:07:55 dre kernel: [    0.000000] Memory: 8130844k/9437184k available (4348k kernel code, 1057944k absent, 248396k reserved, 6613k data, 672k init)
Dec 14 22:07:55 dre kernel: [    0.000000] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
Dec 14 22:07:55 dre kernel: [    0.000000] Hierarchical RCU implementation.
Dec 14 22:07:55 dre kernel: [    0.000000] NR_IRQS:4352 nr_irqs:472
Dec 14 22:07:55 dre kernel: [    0.000000] Extended CMOS year: 2000
Dec 14 22:07:55 dre kernel: [    0.000000] Console: colour VGA+ 80x25
Dec 14 22:07:55 dre kernel: [    0.000000] console [tty0] enabled
Dec 14 22:07:55 dre kernel: [    0.000000] allocated 83886080 bytes of page_cgroup
Dec 14 22:07:55 dre kernel: [    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
Dec 14 22:07:55 dre kernel: [    0.000000] Fast TSC calibration using PIT
Dec 14 22:07:55 dre kernel: [    0.010000] Detected 1729.135 MHz processor.
Dec 14 22:07:55 dre kernel: [    0.000003] Calibrating delay loop (skipped), value calculated using timer frequency.. 3458.27 BogoMIPS (lpj=17291350)
Dec 14 22:07:55 dre kernel: [    0.000199] Security Framework initialized
Dec 14 22:07:55 dre kernel: [    0.000291] SELinux:  Disabled at boot.
Dec 14 22:07:55 dre kernel: [    0.001078] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
Dec 14 22:07:55 dre kernel: [    0.003146] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
Dec 14 22:07:55 dre kernel: [    0.004074] Mount-cache hash table entries: 256
Dec 14 22:07:55 dre kernel: [    0.004273] Initializing cgroup subsys ns
Dec 14 22:07:55 dre kernel: [    0.004360] Initializing cgroup subsys cpuacct
Dec 14 22:07:55 dre kernel: [    0.004457] Initializing cgroup subsys memory
Dec 14 22:07:55 dre kernel: [    0.004551] Initializing cgroup subsys freezer
Dec 14 22:07:55 dre kernel: [    0.004648] CPU: Physical Processor ID: 0
Dec 14 22:07:55 dre kernel: [    0.004737] CPU: Processor Core ID: 0
Dec 14 22:07:55 dre kernel: [    0.004831] CPU 0/0x0 -> Node 0
Dec 14 22:07:55 dre kernel: [    0.004921] mce: CPU supports 9 MCE banks
Dec 14 22:07:55 dre kernel: [    0.005016] CPU0: Thermal monitoring enabled (TM1)
Dec 14 22:07:55 dre kernel: [    0.005104] CPU 0 MCA banks CMCI:2 CMCI:3 CMCI:5 CMCI:6 SHD:8
Dec 14 22:07:55 dre kernel: [    0.005700] using mwait in idle threads.
Dec 14 22:07:55 dre kernel: [    0.005782] Performance Events: Nehalem/Corei7 events, Intel PMU driver.
Dec 14 22:07:55 dre kernel: [    0.006047] ... version:                3
Dec 14 22:07:55 dre kernel: [    0.006128] ... bit width:              48
Dec 14 22:07:55 dre kernel: [    0.006210] ... generic registers:      4
Dec 14 22:07:55 dre kernel: [    0.006300] ... value mask:             0000ffffffffffff
Dec 14 22:07:55 dre kernel: [    0.006390] ... max period:             000000007fffffff
Dec 14 22:07:55 dre kernel: [    0.006475] ... fixed-purpose events:   3
Dec 14 22:07:55 dre kernel: [    0.006569] ... event mask:             000000070000000f
Dec 14 22:07:55 dre kernel: [    0.008662] ACPI: Core revision 20091112
Dec 14 22:07:55 dre kernel: [    0.049886] Setting APIC routing to flat
Dec 14 22:07:55 dre kernel: [    0.050355] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
Dec 14 22:07:55 dre kernel: [    0.150415] CPU0: Intel(R) Core(TM) CPU          Q 820  @ 1.73GHz stepping 05
Dec 14 22:07:55 dre kernel: [    0.268202] Booting processor 1 APIC 0x1 ip 0x6000
Dec 14 22:07:55 dre kernel: [    0.278960] Initializing CPU#1
Dec 14 22:07:55 dre kernel: [    0.428021] CPU: Physical Processor ID: 0
Dec 14 22:07:55 dre kernel: [    0.428023] CPU: Processor Core ID: 0
Dec 14 22:07:55 dre kernel: [    0.428027] CPU 1/0x1 -> Node 0
Dec 14 22:07:55 dre kernel: [    0.428040] CPU1: Thermal monitoring enabled (TM1)
Dec 14 22:07:55 dre kernel: [    0.428043] CPU 1 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
Dec 14 22:07:55 dre kernel: [    0.428118] CPU1: Intel(R) Core(TM) CPU          Q 820  @ 1.73GHz stepping 05
Dec 14 22:07:55 dre kernel: [    0.428972] Booting processor 2 APIC 0x2 ip 0x6000
Dec 14 22:07:55 dre kernel: [    0.439446] Initializing CPU#2
Dec 14 22:07:55 dre kernel: [    0.587949] CPU: Physical Processor ID: 0
Dec 14 22:07:55 dre kernel: [    0.587951] CPU: Processor Core ID: 1
Dec 14 22:07:55 dre kernel: [    0.587955] CPU 2/0x2 -> Node 0
Dec 14 22:07:55 dre kernel: [    0.587966] CPU2: Thermal monitoring enabled (TM1)
Dec 14 22:07:55 dre kernel: [    0.587969] CPU 2 MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:8
Dec 14 22:07:55 dre kernel: [    0.588008] CPU2: Intel(R) Core(TM) CPU          Q 820  @ 1.73GHz stepping 05
Dec 14 22:07:55 dre kernel: [    0.588853] Booting processor 3 APIC 0x3 ip 0x6000
Dec 14 22:07:55 dre kernel: [    0.599332] Initializing CPU#3
Dec 14 22:07:55 dre kernel: [    0.747878] CPU: Physical Processor ID: 0
Dec 14 22:07:55 dre kernel: [    0.747879] CPU: Processor Core ID: 1
Dec 14 22:07:55 dre kernel: [    0.747883] CPU 3/0x3 -> Node 0
Dec 14 22:07:55 dre kernel: [    0.747894] CPU3: Thermal monitoring enabled (TM1)
Dec 14 22:07:55 dre kernel: [    0.747897] CPU 3 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
Dec 14 22:07:55 dre kernel: [    0.747993] CPU3: Intel(R) Core(TM) CPU          Q 820  @ 1.73GHz stepping 05
Dec 14 22:07:55 dre kernel: [    0.748847] Booting processor 4 APIC 0x4 ip 0x6000
Dec 14 22:07:55 dre kernel: [    0.759326] Initializing CPU#4
Dec 14 22:07:55 dre kernel: [    0.907807] CPU: Physical Processor ID: 0
Dec 14 22:07:55 dre kernel: [    0.907808] CPU: Processor Core ID: 2
Dec 14 22:07:55 dre kernel: [    0.907812] CPU 4/0x4 -> Node 0
Dec 14 22:07:55 dre kernel: [    0.907823] CPU4: Thermal monitoring enabled (TM1)
Dec 14 22:07:55 dre kernel: [    0.907826] CPU 4 MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:8
Dec 14 22:07:55 dre kernel: [    0.907887] CPU4: Intel(R) Core(TM) CPU          Q 820  @ 1.73GHz stepping 05
Dec 14 22:07:55 dre kernel: [    0.908754] Booting processor 5 APIC 0x5 ip 0x6000
Dec 14 22:07:55 dre kernel: [    0.919226] Initializing CPU#5
Dec 14 22:07:55 dre kernel: [    1.067735] CPU: Physical Processor ID: 0
Dec 14 22:07:55 dre kernel: [    1.067737] CPU: Processor Core ID: 2
Dec 14 22:07:55 dre kernel: [    1.067740] CPU 5/0x5 -> Node 0
Dec 14 22:07:55 dre kernel: [    1.067751] CPU5: Thermal monitoring enabled (TM1)
Dec 14 22:07:55 dre kernel: [    1.067754] CPU 5 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
Dec 14 22:07:55 dre kernel: [    1.067787] CPU5: Intel(R) Core(TM) CPU          Q 820  @ 1.73GHz stepping 05
Dec 14 22:07:55 dre kernel: [    1.068646] Booting processor 6 APIC 0x6 ip 0x6000
Dec 14 22:07:55 dre kernel: [    1.079129] Initializing CPU#6
Dec 14 22:07:55 dre kernel: [    1.227664] CPU: Physical Processor ID: 0
Dec 14 22:07:55 dre kernel: [    1.227666] CPU: Processor Core ID: 3
Dec 14 22:07:55 dre kernel: [    1.227669] CPU 6/0x6 -> Node 0
Dec 14 22:07:55 dre kernel: [    1.227681] CPU6: Thermal monitoring enabled (TM1)
Dec 14 22:07:55 dre kernel: [    1.227684] CPU 6 MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:8
Dec 14 22:07:55 dre kernel: [    1.227790] CPU6: Intel(R) Core(TM) CPU          Q 820  @ 1.73GHz stepping 05
Dec 14 22:07:55 dre kernel: [    1.228648] Booting processor 7 APIC 0x7 ip 0x6000
Dec 14 22:07:55 dre kernel: [    1.239121] Initializing CPU#7
Dec 14 22:07:55 dre kernel: [    1.387593] CPU: Physical Processor ID: 0
Dec 14 22:07:55 dre kernel: [    1.387594] CPU: Processor Core ID: 3
Dec 14 22:07:55 dre kernel: [    1.387598] CPU 7/0x7 -> Node 0
Dec 14 22:07:55 dre kernel: [    1.387609] CPU7: Thermal monitoring enabled (TM1)
Dec 14 22:07:55 dre kernel: [    1.387611] CPU 7 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
Dec 14 22:07:55 dre kernel: [    1.387683] CPU7: Intel(R) Core(TM) CPU          Q 820  @ 1.73GHz stepping 05
Dec 14 22:07:55 dre kernel: [    1.388474] Skipped synchronization checks as TSC is reliable.
Dec 14 22:07:55 dre kernel: [    1.388574] Brought up 8 CPUs
Dec 14 22:07:55 dre kernel: [    1.388664] Total of 8 processors activated (27663.86 BogoMIPS).
Dec 14 22:07:55 dre kernel: [    1.392871] devtmpfs: initialized
Dec 14 22:07:55 dre kernel: [    1.393182] regulator: core version 0.5
Dec 14 22:07:55 dre kernel: [    1.393292] Time: 22:07:49  Date: 12/14/09
Dec 14 22:07:55 dre kernel: [    1.393404] NET: Registered protocol family 16
Dec 14 22:07:55 dre kernel: [    1.393590] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
Dec 14 22:07:55 dre kernel: [    1.393683] ACPI: bus type pci registered
Dec 14 22:07:55 dre kernel: [    1.393853] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
Dec 14 22:07:55 dre kernel: [    1.393948] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
Dec 14 22:07:55 dre kernel: [    1.409390] PCI: Using configuration type 1 for base access
Dec 14 22:07:55 dre kernel: [    1.410365] bio: create slab <bio-0> at 0
Dec 14 22:07:55 dre kernel: [    1.417901] ACPI: Executed 2 blocks of module-level executable AML code
Dec 14 22:07:55 dre kernel: [    1.427778] ACPI: BIOS _OSI(Linux) query ignored
Dec 14 22:07:55 dre kernel: [    1.441917] ACPI Error (psargs-0359): [\_PR_.CPU0._PPC] Namespace lookup failure, AE_NOT_FOUND
Dec 14 22:07:55 dre kernel: [    1.442193] ACPI Error (psparse-0537): Method parse/execution failed [\CPUT] (Node ffff880237057740), AE_NOT_FOUND
Dec 14 22:07:55 dre kernel: [    1.442587] ACPI Error (psparse-0537): Method parse/execution failed [\PSSC] (Node ffff880237057760), AE_NOT_FOUND
Dec 14 22:07:55 dre kernel: [    1.442982] ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.LPCB.EC0_._REG] (Node ffff8802370321c0), AE_NOT_FOUND
Dec 14 22:07:55 dre kernel: [    1.443499] ACPI: Interpreter enabled
Dec 14 22:07:55 dre kernel: [    1.443591] ACPI: (supports S0 S3 S4 S5)
Dec 14 22:07:55 dre kernel: [    1.444055] ACPI: Using IOAPIC for interrupt routing
Dec 14 22:07:55 dre kernel: [    1.461347] ACPI: EC: GPE = 0x16, I/O: command/status = 0x66, data = 0x62
Dec 14 22:07:55 dre kernel: [    1.462708] ACPI: ACPI Dock Station Driver: 1 docks/bays found
Dec 14 22:07:55 dre kernel: [    1.464416] ACPI: PCI Root Bridge [PCI0] (0000:00)
Dec 14 22:07:55 dre kernel: [    1.464561] pci_root PNP0A08:00: ignoring host bridge windows from ACPI; boot with "pci=use_crs" to use them
Dec 14 22:07:55 dre kernel: [    1.468502] pci 0000:00:03.0: PCI bridge to [bus 01-01]
Dec 14 22:07:55 dre kernel: [    1.470354] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
Dec 14 22:07:55 dre kernel: [    1.470676] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
Dec 14 22:07:55 dre kernel: [    1.470845] pci 0000:00:1e.0: PCI bridge to [bus 04-04] (subtractive decode)
Dec 14 22:07:55 dre kernel: [    1.489624] ACPI: PCI Root Bridge [CPBG] (0000:ff)
Dec 14 22:07:55 dre kernel: [    1.489759] pci_root PNP0A03:00: ignoring host bridge windows from ACPI; boot with "pci=use_crs" to use them
Dec 14 22:07:55 dre kernel: [    1.491031] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 *10 12 14 15)
Dec 14 22:07:55 dre kernel: [    1.492371] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
Dec 14 22:07:55 dre kernel: [    1.493784] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
Dec 14 22:07:55 dre kernel: [    1.495307] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 *11 12 14 15)
Dec 14 22:07:55 dre kernel: [    1.496655] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
Dec 14 22:07:55 dre kernel: [    1.498110] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 *11 12 14 15)
Dec 14 22:07:55 dre kernel: [    1.499445] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
Dec 14 22:07:55 dre kernel: [    1.500863] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
Dec 14 22:07:55 dre kernel: [    1.502294] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
Dec 14 22:07:55 dre kernel: [    1.502387] vgaarb: loaded
Dec 14 22:07:55 dre kernel: [    1.502566] SCSI subsystem initialized
Dec 14 22:07:55 dre kernel: [    1.502846] usbcore: registered new interface driver usbfs
Dec 14 22:07:55 dre kernel: [    1.502948] usbcore: registered new interface driver hub
Dec 14 22:07:55 dre kernel: [    1.503062] usbcore: registered new device driver usb
Dec 14 22:07:55 dre kernel: [    1.503320] ACPI: WMI: Mapper loaded
Dec 14 22:07:55 dre kernel: [    1.503410] PCI: Using ACPI for IRQ routing
Dec 14 22:07:55 dre kernel: [    1.503784] Bluetooth: Core ver 2.15
Dec 14 22:07:55 dre kernel: [    1.503899] NET: Registered protocol family 31
Dec 14 22:07:55 dre kernel: [    1.503988] Bluetooth: HCI device and connection manager initialized
Dec 14 22:07:55 dre kernel: [    1.504080] Bluetooth: HCI socket layer initialized
Dec 14 22:07:55 dre kernel: [    1.504245] HPET: 8 timers in total, 5 timers will be used for per-cpu timer
Dec 14 22:07:55 dre kernel: [    1.504333] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 24, 25, 26, 27, 28, 0
Dec 14 22:07:55 dre kernel: [    1.505160] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
Dec 14 22:07:55 dre kernel: [    1.587610] Switching to clocksource tsc
Dec 14 22:07:55 dre kernel: [    1.589471] pnp: PnP ACPI init
Dec 14 22:07:55 dre kernel: [    1.589560] ACPI: bus type pnp registered
Dec 14 22:07:55 dre kernel: [    1.596353] pnp: PnP ACPI: found 12 devices
Dec 14 22:07:55 dre kernel: [    1.596440] ACPI: ACPI bus type pnp unregistered
Dec 14 22:07:55 dre kernel: [    1.596539] system 00:05: [io  0x0680-0x069f] has been reserved
Dec 14 22:07:55 dre kernel: [    1.596630] system 00:05: [io  0x0800-0x080f] has been reserved
Dec 14 22:07:55 dre kernel: [    1.596717] system 00:05: [io  0xffff] has been reserved
Dec 14 22:07:55 dre kernel: [    1.596800] system 00:05: [io  0xffff] has been reserved
Dec 14 22:07:55 dre kernel: [    1.596896] system 00:05: [io  0x0400-0x047f] has been reserved
Dec 14 22:07:55 dre kernel: [    1.596987] system 00:05: [io  0x0500-0x057f] has been reserved
Dec 14 22:07:55 dre kernel: [    1.597079] system 00:05: [io  0x164e-0x164f] has been reserved
Dec 14 22:07:55 dre kernel: [    1.597161] system 00:05: [io  0x0380-0x038e] has been reserved
Dec 14 22:07:55 dre kernel: [    1.597260] system 00:0a: [mem 0xfed1c000-0xfed1ffff] has been reserved
Dec 14 22:07:55 dre kernel: [    1.597349] system 00:0a: [mem 0xfed1b000-0xfed1bfff] has been reserved
Dec 14 22:07:55 dre kernel: [    1.597436] system 00:0a: [mem 0xe0000000-0xefffffff] has been reserved
Dec 14 22:07:55 dre kernel: [    1.597528] system 00:0a: [mem 0xfed20000-0xfed3ffff] has been reserved
Dec 14 22:07:55 dre kernel: [    1.597612] system 00:0a: [mem 0xfed90000-0xfed93fff] has been reserved
Dec 14 22:07:55 dre kernel: [    1.598373] system 00:0a: [mem 0xfed45000-0xfed8ffff] has been reserved
Dec 14 22:07:55 dre kernel: [    1.598470] system 00:0a: [mem 0xff000000-0xffffffff] could not be reserved
Dec 14 22:07:55 dre kernel: [    1.598561] system 00:0a: [mem 0xfee00000-0xfeefffff] could not be reserved
Dec 14 22:07:55 dre kernel: [    1.603484] pci 0000:01:00.0: BAR 6: assigned [mem 0xd4020000-0xd403ffff pref]
Dec 14 22:07:55 dre kernel: [    1.603580] pci 0000:00:03.0: PCI bridge to [bus 01-01]
Dec 14 22:07:55 dre kernel: [    1.603663] pci 0000:00:03.0:   bridge window [io  0x4000-0x4fff]
Dec 14 22:07:55 dre kernel: [    1.603756] pci 0000:00:03.0:   bridge window [mem 0xd4000000-0xd40fffff]
Dec 14 22:07:55 dre kernel: [    1.603844] pci 0000:00:03.0:   bridge window [mem 0xc0000000-0xcfffffff 64bit pref]
Dec 14 22:07:55 dre kernel: [    1.603935] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
Dec 14 22:07:55 dre kernel: [    1.604030] pci 0000:00:1c.0:   bridge window [io  0x3000-0x3fff]
Dec 14 22:07:55 dre kernel: [    1.604124] pci 0000:00:1c.0:   bridge window [mem 0xd3000000-0xd3ffffff]
Dec 14 22:07:55 dre kernel: [    1.604213] pci 0000:00:1c.0:   bridge window [mem 0xd0000000-0xd0ffffff 64bit pref]
Dec 14 22:07:55 dre kernel: [    1.604309] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
Dec 14 22:07:55 dre kernel: [    1.604400] pci 0000:00:1c.1:   bridge window [io  0x2000-0x2fff]
Dec 14 22:07:55 dre kernel: [    1.604493] pci 0000:00:1c.1:   bridge window [mem 0xd2000000-0xd2ffffff]
Dec 14 22:07:55 dre kernel: [    1.604582] pci 0000:00:1c.1:   bridge window [mem 0xd1000000-0xd1ffffff 64bit pref]
Dec 14 22:07:55 dre kernel: [    1.604674] pci 0000:00:1e.0: PCI bridge to [bus 04-04]
Dec 14 22:07:55 dre kernel: [    1.604769] pci 0000:00:1e.0:   bridge window [io  disabled]
Dec 14 22:07:55 dre kernel: [    1.604862] pci 0000:00:1e.0:   bridge window [mem disabled]
Dec 14 22:07:55 dre kernel: [    1.604949] pci 0000:00:1e.0:   bridge window [mem pref disabled]
Dec 14 22:07:55 dre kernel: [    1.605052] pci 0000:00:03.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Dec 14 22:07:55 dre kernel: [    1.605162] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
Dec 14 22:07:55 dre kernel: [    1.605271] pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
Dec 14 22:07:55 dre kernel: [    1.605437] NET: Registered protocol family 2
Dec 14 22:07:55 dre kernel: [    1.605760] IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
Dec 14 22:07:55 dre kernel: [    1.606927] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
Dec 14 22:07:55 dre kernel: [    1.610126] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
Dec 14 22:07:55 dre kernel: [    1.610584] TCP: Hash tables configured (established 524288 bind 65536)
Dec 14 22:07:55 dre kernel: [    1.610664] TCP reno registered
Dec 14 22:07:55 dre kernel: [    1.610768] UDP hash table entries: 4096 (order: 5, 131072 bytes)
Dec 14 22:07:55 dre kernel: [    1.610937] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
Dec 14 22:07:55 dre kernel: [    1.611174] NET: Registered protocol family 1
Dec 14 22:07:55 dre kernel: [    1.638641] Trying to unpack rootfs image as initramfs...
Dec 14 22:07:55 dre kernel: [    2.846706] Freeing initrd memory: 53733k freed
Dec 14 22:07:55 dre kernel: [    2.855452] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
Dec 14 22:07:55 dre kernel: [    2.855551] Placing 64MB software IO TLB between ffff880020000000 - ffff880024000000
Dec 14 22:07:55 dre kernel: [    2.855644] software IO TLB at phys 0x20000000 - 0x24000000
Dec 14 22:07:55 dre kernel: [    2.855777] Simple Boot Flag at 0x44 set to 0x1
Dec 14 22:07:55 dre kernel: [    2.856396] Scanning for low memory corruption every 60 seconds
Dec 14 22:07:55 dre kernel: [    2.856621] audit: initializing netlink socket (disabled)
Dec 14 22:07:55 dre kernel: [    2.856719] type=2000 audit(1260828470.730:1): initialized
Dec 14 22:07:55 dre kernel: [    2.871353] HugeTLB registered 2 MB page size, pre-allocated 0 pages
Dec 14 22:07:55 dre kernel: [    2.872908] VFS: Disk quotas dquot_6.5.2
Dec 14 22:07:55 dre kernel: [    2.873041] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
Dec 14 22:07:55 dre kernel: [    2.873528] fuse init (API version 7.13)
Dec 14 22:07:55 dre kernel: [    2.873694] msgmni has been set to 15985
Dec 14 22:07:55 dre kernel: [    2.874038] alg: No test for stdrng (krng)
Dec 14 22:07:55 dre kernel: [    2.874138] io scheduler noop registered
Dec 14 22:07:55 dre kernel: [    2.874232] io scheduler deadline registered
Dec 14 22:07:55 dre kernel: [    2.874381] io scheduler cfq registered (default)
Dec 14 22:07:55 dre kernel: [    2.875155] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
Dec 14 22:07:55 dre kernel: [    2.876125] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
Dec 14 22:07:55 dre kernel: [    2.876786] ACPI: AC Adapter [ACAD] (on-line)
Dec 14 22:07:55 dre kernel: [    2.876957] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
Dec 14 22:07:55 dre kernel: [    2.877051] ACPI: Power Button [PWRB]
Dec 14 22:07:55 dre kernel: [    2.877181] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input1
Dec 14 22:07:55 dre kernel: [    2.877664] ACPI: Lid Switch [LID0]
Dec 14 22:07:55 dre kernel: [    2.877815] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
Dec 14 22:07:55 dre kernel: [    2.877908] ACPI: Power Button [PWRF]
Dec 14 22:07:55 dre kernel: [    2.880885] ACPI: SSDT 00000000bf691a98 0033A (v01  PmRef  Cpu0Ist 00003000 INTL 20051117)
Dec 14 22:07:55 dre kernel: [    2.882645] ACPI: SSDT 00000000bf690618 005CD (v01  PmRef  Cpu0Cst 00003001 INTL 20051117)
Dec 14 22:07:55 dre kernel: [    2.885605] processor LNXCPU:00: registered as cooling_device0
Dec 14 22:07:55 dre kernel: [    2.887312] ACPI: SSDT 00000000bf691718 00303 (v01  PmRef    ApIst 00003000 INTL 20051117)
Dec 14 22:07:55 dre kernel: [    2.889048] ACPI: SSDT 00000000bf68fd98 00119 (v01  PmRef    ApCst 00003000 INTL 20051117)
Dec 14 22:07:55 dre kernel: [    2.892213] processor LNXCPU:01: registered as cooling_device1
Dec 14 22:07:55 dre kernel: [    2.895705] processor LNXCPU:02: registered as cooling_device2
Dec 14 22:07:55 dre kernel: [    2.899162] processor LNXCPU:03: registered as cooling_device3
Dec 14 22:07:55 dre kernel: [    2.902632] processor LNXCPU:04: registered as cooling_device4
Dec 14 22:07:55 dre kernel: [    2.906093] processor LNXCPU:05: registered as cooling_device5
Dec 14 22:07:55 dre kernel: [    2.909566] processor LNXCPU:06: registered as cooling_device6
Dec 14 22:07:55 dre kernel: [    2.913640] processor LNXCPU:07: registered as cooling_device7
Dec 14 22:07:55 dre kernel: [    2.924995] thermal LNXTHERM:01: registered as thermal_zone0
Dec 14 22:07:55 dre kernel: [    2.925091] ACPI: Thermal Zone [TZ01] (59 C)
Dec 14 22:07:55 dre kernel: [    2.926861] Linux agpgart interface v0.103
Dec 14 22:07:55 dre kernel: [    2.926935] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
Dec 14 22:07:55 dre kernel: [    2.928198] brd: module loaded
Dec 14 22:07:55 dre kernel: [    2.928723] loop: module loaded
Dec 14 22:07:55 dre kernel: [    2.928874] input: Macintosh mouse button emulation as /devices/virtual/input/input3
Dec 14 22:07:55 dre kernel: [    2.929059] ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
Dec 14 22:07:55 dre kernel: [    2.932866] ACPI: Battery Slot [BAT0] (battery present)
Dec 14 22:07:55 dre kernel: [    2.933345] ACPI: Battery Slot [BAT1] (battery absent)
Dec 14 22:07:55 dre kernel: [    2.951784] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 3 Gbps 0x23 impl RAID mode
Dec 14 22:07:55 dre kernel: [    2.951888] ahci 0000:00:1f.2: flags: 64bit ncq sntf ilck pm led clo pio slum part ems sxs apst 
Dec 14 22:07:55 dre kernel: [    2.991807] scsi0 : ahci
Dec 14 22:07:55 dre kernel: [    2.991965] scsi1 : ahci
Dec 14 22:07:55 dre kernel: [    2.992096] scsi2 : ahci
Dec 14 22:07:55 dre kernel: [    2.992227] scsi3 : ahci
Dec 14 22:07:55 dre kernel: [    2.992357] scsi4 : ahci
Dec 14 22:07:55 dre kernel: [    2.992482] scsi5 : ahci
Dec 14 22:07:55 dre kernel: [    2.992924] ata1: SATA max UDMA/133 abar m2048@0xd4105000 port 0xd4105100 irq 32
Dec 14 22:07:55 dre kernel: [    2.993018] ata2: SATA max UDMA/133 abar m2048@0xd4105000 port 0xd4105180 irq 32
Dec 14 22:07:55 dre kernel: [    2.993115] ata3: DUMMY
Dec 14 22:07:55 dre kernel: [    2.993204] ata4: DUMMY
Dec 14 22:07:55 dre kernel: [    2.993296] ata5: DUMMY
Dec 14 22:07:55 dre kernel: [    2.993387] ata6: SATA max UDMA/133 abar m2048@0xd4105000 port 0xd4105380 irq 32
Dec 14 22:07:55 dre kernel: [    2.994257] Fixed MDIO Bus: probed
Dec 14 22:07:55 dre kernel: [    2.994370] PPP generic driver version 2.4.2
Dec 14 22:07:55 dre kernel: [    2.994522] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
Dec 14 22:07:55 dre kernel: [    2.994635] ehci_hcd 0000:00:1d.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
Dec 14 22:07:55 dre kernel: [    2.994747] ehci_hcd 0000:00:1d.0: EHCI Host Controller
Dec 14 22:07:55 dre kernel: [    2.994884] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
Dec 14 22:07:55 dre kernel: [    2.995013] ehci_hcd 0000:00:1d.0: debug port 2
Dec 14 22:07:55 dre kernel: [    2.999008] ehci_hcd 0000:00:1d.0: irq 20, io mem 0xd4105800
Dec 14 22:07:55 dre kernel: [    3.021730] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
Dec 14 22:07:55 dre kernel: [    3.021932] hub 1-0:1.0: USB hub found
Dec 14 22:07:55 dre kernel: [    3.022025] hub 1-0:1.0: 2 ports detected
Dec 14 22:07:55 dre kernel: [    3.022170] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
Dec 14 22:07:55 dre kernel: [    3.022272] uhci_hcd: USB Universal Host Controller Interface driver
Dec 14 22:07:55 dre kernel: [    3.022421] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
Dec 14 22:07:55 dre kernel: [    3.035815] serio: i8042 KBD port at 0x60,0x64 irq 1
Dec 14 22:07:55 dre kernel: [    3.035913] serio: i8042 AUX port at 0x60,0x64 irq 12
Dec 14 22:07:55 dre kernel: [    3.036061] mice: PS/2 mouse device common for all mice
Dec 14 22:07:55 dre kernel: [    3.036230] Driver 'rtc_cmos' needs updating - please use bus_type methods
Dec 14 22:07:55 dre kernel: [    3.036357] rtc_cmos 00:06: RTC can wake from S4
Dec 14 22:07:55 dre kernel: [    3.036481] rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
Dec 14 22:07:55 dre kernel: [    3.036614] rtc0: alarms up to one year, y3k, 242 bytes nvram, hpet irqs
Dec 14 22:07:55 dre kernel: [    3.036814] device-mapper: uevent: version 1.0.3
Dec 14 22:07:55 dre kernel: [    3.037268] device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised: dm-devel@redhat.com
Dec 14 22:07:55 dre kernel: [    3.037469] device-mapper: multipath: version 1.1.0 loaded
Dec 14 22:07:55 dre kernel: [    3.037564] device-mapper: multipath round-robin: version 1.0.0 loaded
Dec 14 22:07:55 dre kernel: [    3.037914] cpuidle: using governor ladder
Dec 14 22:07:55 dre kernel: [    3.037993] cpuidle: using governor menu
Dec 14 22:07:55 dre kernel: [    3.038294] TCP cubic registered
Dec 14 22:07:55 dre kernel: [    3.038517] NET: Registered protocol family 10
Dec 14 22:07:55 dre kernel: [    3.038949] lo: Disabled Privacy Extensions
Dec 14 22:07:55 dre kernel: [    3.039230] NET: Registered protocol family 17
Dec 14 22:07:55 dre kernel: [    3.039324] Bluetooth: L2CAP ver 2.14
Dec 14 22:07:55 dre kernel: [    3.039412] Bluetooth: L2CAP socket layer initialized
Dec 14 22:07:55 dre kernel: [    3.039503] Bluetooth: SCO (Voice Link) ver 0.6
Dec 14 22:07:55 dre kernel: [    3.039593] Bluetooth: SCO socket layer initialized
Dec 14 22:07:55 dre kernel: [    3.039699] Bluetooth: RFCOMM TTY layer initialized
Dec 14 22:07:55 dre kernel: [    3.039791] Bluetooth: RFCOMM socket layer initialized
Dec 14 22:07:55 dre kernel: [    3.039881] Bluetooth: RFCOMM ver 1.11
Dec 14 22:07:55 dre kernel: [    3.074037] registered taskstats version 1
Dec 14 22:07:55 dre kernel: [    3.074450]   Magic number: 5:488:148
Dec 14 22:07:55 dre kernel: [    3.074545] bdi 1:0: hash matches
Dec 14 22:07:55 dre kernel: [    3.074642]  pci0000:ff: hash matches
Dec 14 22:07:55 dre kernel: [    3.074746] acpi device:19: hash matches
Dec 14 22:07:55 dre kernel: [    3.074887] rtc_cmos 00:06: setting system clock to 2009-12-14 22:07:51 UTC (1260828471)
Dec 14 22:07:55 dre kernel: [    3.074981] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
Dec 14 22:07:55 dre kernel: [    3.075071] EDD information not available.
Dec 14 22:07:55 dre kernel: [    3.337256] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Dec 14 22:07:55 dre kernel: [    3.337264] usb 1-1: new high speed USB device using ehci_hcd and address 2
Dec 14 22:07:55 dre kernel: [    3.337304] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Dec 14 22:07:55 dre kernel: [    3.337331] ata6: SATA link down (SStatus 0 SControl 300)
Dec 14 22:07:55 dre kernel: [    3.337474] ata1.00: ATA-7: INTEL SSDSA1MH160G1HP, 045C8781, max UDMA/100
Dec 14 22:07:55 dre kernel: [    3.337476] ata1.00: 312581808 sectors, multi 1: LBA48 NCQ (depth 31)
Dec 14 22:07:55 dre kernel: [    3.337731] ata1.00: configured for UDMA/100
Dec 14 22:07:55 dre kernel: [    3.338294] ata2.00: ATA-8: TOSHIBA MK2529GSG, PS110C, max UDMA/100
Dec 14 22:07:55 dre kernel: [    3.338296] ata2.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
Dec 14 22:07:55 dre kernel: [    3.339130] ata2.00: configured for UDMA/100
Dec 14 22:07:55 dre kernel: [    3.357372] scsi 0:0:0:0: Direct-Access     ATA      INTEL SSDSA1MH16 045C PQ: 0 ANSI: 5
Dec 14 22:07:55 dre kernel: [    3.357573] sd 0:0:0:0: Attached scsi generic sg0 type 0
Dec 14 22:07:55 dre kernel: [    3.357633] sd 0:0:0:0: [sda] 312581808 512-byte logical blocks: (160 GB/149 GiB)
Dec 14 22:07:55 dre kernel: [    3.357757] sd 0:0:0:0: [sda] Write Protect is off
Dec 14 22:07:55 dre kernel: [    3.357824] scsi 1:0:0:0: Direct-Access     ATA      TOSHIBA MK2529GS PS11 PQ: 0 ANSI: 5
Dec 14 22:07:55 dre kernel: [    3.357924] sd 1:0:0:0: Attached scsi generic sg1 type 0
Dec 14 22:07:55 dre kernel: [    3.357933] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Dec 14 22:07:55 dre kernel: [    3.357937] sd 1:0:0:0: [sdb] 488397168 512-byte logical blocks: (250 GB/232 GiB)
Dec 14 22:07:55 dre kernel: [    3.358010] sd 1:0:0:0: [sdb] Write Protect is off
Dec 14 22:07:55 dre kernel: [    3.358045] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Dec 14 22:07:55 dre kernel: [    3.358100]  sda:
Dec 14 22:07:55 dre kernel: [    3.358216]  sdb: sda1 sda2 sda3 sda4
Dec 14 22:07:55 dre kernel: [    3.358634] sd 0:0:0:0: [sda] Attached SCSI disk
Dec 14 22:07:55 dre kernel: [    3.423622]  sdb1 sdb2 < sdb5 sdb6 >
Dec 14 22:07:55 dre kernel: [    3.465812] sd 1:0:0:0: [sdb] Attached SCSI disk
Dec 14 22:07:55 dre kernel: [    3.465899] Freeing unused kernel memory: 672k freed
Dec 14 22:07:55 dre kernel: [    3.466074] Write protecting the kernel read-only data: 10240k
Dec 14 22:07:55 dre kernel: [    3.466436] Freeing unused kernel memory: 1776k freed
Dec 14 22:07:55 dre kernel: [    3.466914] Freeing unused kernel memory: 1816k freed
Dec 14 22:07:55 dre kernel: [    3.497721] hub 1-1:1.0: USB hub found
Dec 14 22:07:55 dre kernel: [    3.497824] hub 1-1:1.0: 8 ports detected
Dec 14 22:07:55 dre kernel: [    3.561425] acpi device:26: registered as cooling_device8
Dec 14 22:07:55 dre kernel: [    3.573535] acpi device:28: registered as cooling_device9
Dec 14 22:07:55 dre kernel: [    3.573866] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:24/LNXVIDEO:01/input/input5
Dec 14 22:07:55 dre kernel: [    3.573992] ACPI: Video Device [VGA] (multi-head: yes  rom: no  post: no)
Dec 14 22:07:55 dre kernel: [    3.797201] usb 1-1.5: new high speed USB device using ehci_hcd and address 3
Dec 14 22:07:55 dre kernel: [    3.990034] PM: Starting manual resume from disk
Dec 14 22:07:55 dre kernel: [    4.049892] EXT4-fs (sdb5): mounted filesystem with ordered data mode
Dec 14 22:07:55 dre kernel: [    5.812992] Adding 4996172k swap on /dev/sdb6.  Priority:-1 extents:1 across:4996172k 
Dec 14 22:07:56 dre kernel: [    7.752024] udev: starting version 147
Dec 14 22:07:57 dre kernel: [    9.352992] lis3lv02d: laptop model unknown, using default axes configuration
Dec 14 22:07:57 dre kernel: [    9.353992] lis3lv02d: 1-byte sensor found
Dec 14 22:07:57 dre kernel: [    9.367404] input: ST LIS3LV02DL Accelerometer as /devices/platform/lis3lv02d/input/input6
Dec 14 22:07:57 dre kernel: [    9.367485] Registered led device: hp::hddprotect
Dec 14 22:07:57 dre kernel: [    9.367500] lis3lv02d driver loaded.
Dec 14 22:07:57 dre kernel: [    9.462637] atl1c 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
Dec 14 22:07:58 dre kernel: [    9.575865] atl1c 0000:03:00.0: version 1.0.0.1-NAPI
Dec 14 22:07:58 dre kernel: [   10.089727] cfg80211: Calling CRDA to update world regulatory domain
Dec 14 22:07:59 dre kernel: [   11.055675] cfg80211: World regulatory domain updated:
Dec 14 22:07:59 dre kernel: [   11.055678]     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Dec 14 22:07:59 dre kernel: [   11.055681]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Dec 14 22:07:59 dre kernel: [   11.055684]     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Dec 14 22:07:59 dre kernel: [   11.055687]     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Dec 14 22:07:59 dre kernel: [   11.055690]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Dec 14 22:07:59 dre kernel: [   11.055692]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Dec 14 22:08:00 dre kernel: [   11.968093] Synaptics Touchpad, model: 1, fw: 7.4, id: 0x1e0b1, caps: 0xd04771/0xe40000
Dec 14 22:08:00 dre kernel: [   11.968098] Synaptics: Clickpad mode enabled
Dec 14 22:08:00 dre kernel: [   12.041939] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input7
Dec 14 22:08:00 dre kernel: [   12.097159] ADDRCONF(NETDEV_UP): eth0: link is not ready
Dec 14 22:08:02 dre kernel: [   13.847244] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, 2.6.32-k
Dec 14 22:08:02 dre kernel: [   13.847246] iwlagn: Copyright(c) 2003-2009 Intel Corporation
Dec 14 22:08:02 dre kernel: [   13.847394] iwlagn 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Dec 14 22:08:02 dre kernel: [   13.847640] iwlagn 0000:02:00.0: Detected Intel Wireless WiFi Link 5100AGN REV=0x54
Dec 14 22:08:04 dre kernel: [   15.634486] iwlagn 0000:02:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
Dec 14 22:08:04 dre kernel: [   15.898345] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
Dec 14 22:08:04 dre kernel: [   15.941232] iwlagn 0000:02:00.0: firmware: requesting iwlwifi-5000-2.ucode
Dec 14 22:08:04 dre kernel: [   16.145648] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input8
Dec 14 22:08:04 dre kernel: [   16.172635] iwlagn 0000:02:00.0: loaded firmware version 8.24.2.12
Dec 14 22:08:04 dre kernel: [   16.175222] input: HDA Intel Mic at Ext Rear Jack as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
Dec 14 22:08:04 dre kernel: [   16.175291] input: HDA Intel HP Out at Ext Rear Jack as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
Dec 14 22:08:04 dre kernel: [   16.176073] HDA Intel 0000:01:00.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
Dec 14 22:08:04 dre kernel: [   16.444453] ADDRCONF(NETDEV_UP): wlan0: link is not ready
Dec 14 22:08:07 dre kernel: [   19.147042] pci 0000:01:00.0: power state changed by ACPI to D0
Dec 14 22:08:07 dre kernel: [   19.147051] pci 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Dec 14 22:08:08 dre kernel: [   19.815630] [drm] Initialized drm 1.1.0 20060810
Dec 14 22:08:08 dre kernel: [   20.439739] [drm] radeon defaulting to userspace modesetting.
Dec 14 22:08:08 dre kernel: [   20.440541] [drm] Initialized radeon 1.31.0 20080528 for 0000:01:00.0 on minor 0
Dec 14 22:08:10 dre kernel: [   21.692317] [drm] Setting GART location based on new memory map
Dec 14 22:08:10 dre kernel: [   21.692564] [drm] Loading RV730 CP Microcode
Dec 14 22:08:10 dre kernel: [   21.692567] platform r600_cp.0: firmware: requesting radeon/RV730_pfp.bin
Dec 14 22:08:10 dre kernel: [   21.725644] platform r600_cp.0: firmware: requesting radeon/RV730_me.bin
Dec 14 22:08:10 dre kernel: [   21.767179] [drm] Resetting GPU
Dec 14 22:08:10 dre kernel: [   21.767239] [drm] writeback test succeeded in 2 usecs
Dec 14 22:08:15 dre kernel: [   27.034280] hda-intel: IRQ timing workaround is activated for card #1. Suggest a bigger bdl_pos_adj.
Dec 14 22:08:22 dre pulseaudio[1664]: ratelimit.c: 5 events suppressed
Dec 14 22:08:25 dre kernel: [   37.288107] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
Dec 14 22:14:27 dre kernel: [  399.381544] [drm] Resetting GPU
Dec 14 22:16:17 dre kernel: [  401.120437] PM: Syncing filesystems ... done.
Dec 14 22:16:17 dre kernel: [  401.330216] Freezing user space processes ... (elapsed 0.02 seconds) done.
Dec 14 22:16:17 dre kernel: [  401.360205] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
Dec 14 22:16:17 dre kernel: [  401.380224] Suspending console(s) (use no_console_suspend to debug)
Dec 14 22:16:17 dre kernel: [  401.560138] sd 1:0:0:0: [sdb] Synchronizing SCSI cache
Dec 14 22:16:17 dre kernel: [  401.560224] sd 1:0:0:0: [sdb] Stopping disk
Dec 14 22:16:17 dre kernel: [  402.333445] sd 0:0:0:0: [sda] Synchronizing SCSI cache
Dec 14 22:16:17 dre kernel: [  402.335171] sd 0:0:0:0: [sda] Stopping disk
Dec 14 22:16:17 dre kernel: [  402.851660] atl1c 0000:03:00.0: PCI INT A disabled
Dec 14 22:16:17 dre kernel: [  402.889720] HDA Intel 0000:01:00.1: PCI INT B disabled
Dec 14 22:16:17 dre kernel: [  402.909668] pci 0000:01:00.0: PCI INT A disabled
Dec 14 22:16:17 dre kernel: [  402.990280] ehci_hcd 0000:00:1d.0: PCI INT A disabled
Dec 14 22:16:17 dre kernel: [  403.099830] HDA Intel 0000:00:1b.0: PCI INT A disabled
Dec 14 22:16:17 dre kernel: [  403.120472] PM: suspend devices took 1.740 seconds
Dec 14 22:16:17 dre kernel: [  403.140021] ACPI: Preparing to enter system sleep state S3
Dec 14 22:16:17 dre kernel: [  403.330140] Disabling non-boot CPUs ...
Dec 14 22:16:17 dre kernel: [  403.490236] Broke affinity for irq 25
Dec 14 22:16:17 dre kernel: [  403.491659] CPU 1 is now offline
Dec 14 22:16:17 dre kernel: [  403.492179] Broke affinity for irq 26
Dec 14 22:16:17 dre kernel: [  403.493324] CPU 2 is now offline
Dec 14 22:16:17 dre kernel: [  403.493804] Broke affinity for irq 27
Dec 14 22:16:17 dre kernel: [  403.494923] CPU 3 is now offline
Dec 14 22:16:17 dre kernel: [  403.495436] Broke affinity for irq 28
Dec 14 22:16:17 dre kernel: [  403.599420] CPU 4 is now offline
Dec 14 22:16:17 dre kernel: [  403.709382] CPU 5 is now offline
Dec 14 22:16:17 dre kernel: [  403.819350] CPU 6 is now offline
Dec 14 22:16:17 dre kernel: [  403.929315] CPU 7 is now offline
Dec 14 22:16:17 dre kernel: [  403.929318] SMP alternatives: switching to UP code
Dec 14 22:16:17 dre kernel: [  403.934640] Extended CMOS year: 2000
Dec 14 22:16:17 dre kernel: [18446744047.461288] CPU0: Thermal monitoring enabled (TM1)
Dec 14 22:16:17 dre kernel: [18446744047.461295] CPU 0 MCA banks CMCI:8
Dec 14 22:16:17 dre kernel: [18446744047.461356] Extended CMOS year: 2000
Dec 14 22:16:17 dre kernel: [18446744047.461406] Enabling non-boot CPUs ...
Dec 14 22:16:17 dre kernel: [18446744047.461638] SMP alternatives: switching to SMP code
Dec 14 22:16:17 dre kernel: [18446744047.469660] Booting processor 1 APIC 0x1 ip 0x6000
Dec 14 22:16:17 dre kernel: [18446744047.480077] Initializing CPU#1
Dec 14 22:16:17 dre kernel: [18446744047.625970] CPU: Physical Processor ID: 0
Dec 14 22:16:17 dre kernel: [18446744047.625973] CPU: Processor Core ID: 0
Dec 14 22:16:17 dre kernel: [18446744047.625979] CPU 1/0x1 -> Node 0
Dec 14 22:16:17 dre kernel: [18446744047.625999] CPU1: Thermal monitoring enabled (TM1)
Dec 14 22:16:17 dre kernel: [18446744047.626005] CPU 1 MCA banks CMCI:2 CMCI:3 CMCI:5 CMCI:6 SHD:8
Dec 14 22:16:17 dre kernel: [18446744047.626024] CPU1: Intel(R) Core(TM) CPU          Q 820  @ 1.73GHz stepping 05
Dec 14 22:16:17 dre kernel: [18446744047.626036] Skipped synchronization checks as TSC is reliable.
Dec 14 22:16:17 dre kernel: [18446744047.705985] CPU1 is up
Dec 14 22:16:17 dre kernel: [18446744047.706207] Booting processor 2 APIC 0x2 ip 0x6000
Dec 14 22:16:17 dre kernel: [18446744047.716615] Initializing CPU#2
Dec 14 22:16:17 dre kernel: [18446744047.865881] CPU: Physical Processor ID: 0
Dec 14 22:16:17 dre kernel: [18446744047.865883] CPU: Processor Core ID: 1
Dec 14 22:16:17 dre kernel: [18446744047.865889] CPU 2/0x2 -> Node 0
Dec 14 22:16:17 dre kernel: [18446744047.865906] CPU2: Thermal monitoring enabled (TM1)
Dec 14 22:16:17 dre kernel: [18446744047.865912] CPU 2 MCA banks SHD:6 SHD:8
Dec 14 22:16:17 dre kernel: [18446744047.865932] CPU2: Intel(R) Core(TM) CPU          Q 820  @ 1.73GHz stepping 05
Dec 14 22:16:17 dre kernel: [18446744047.865945] Skipped synchronization checks as TSC is reliable.
Dec 14 22:16:17 dre kernel: [18446744047.987084] CPU2 is up
Dec 14 22:16:17 dre kernel: [18446744047.987306] Booting processor 3 APIC 0x3 ip 0x6000
Dec 14 22:16:17 dre kernel: [18446744047.997720] Initializing CPU#3
Dec 14 22:16:17 dre kernel: [18446744048.145788] CPU: Physical Processor ID: 0
Dec 14 22:16:17 dre kernel: [18446744048.145790] CPU: Processor Core ID: 1
Dec 14 22:16:17 dre kernel: [18446744048.145795] CPU 3/0x3 -> Node 0
Dec 14 22:16:17 dre kernel: [18446744048.145812] CPU3: Thermal monitoring enabled (TM1)
Dec 14 22:16:17 dre kernel: [18446744048.145817] CPU 3 MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:8
Dec 14 22:16:17 dre kernel: [18446744048.145891] CPU3: Intel(R) Core(TM) CPU          Q 820  @ 1.73GHz stepping 05
Dec 14 22:16:17 dre kernel: [18446744048.145903] Skipped synchronization checks as TSC is reliable.
Dec 14 22:16:17 dre kernel: [18446744048.267151] CPU3 is up
Dec 14 22:16:17 dre kernel: [18446744048.267373] Booting processor 4 APIC 0x4 ip 0x6000
Dec 14 22:16:17 dre kernel: [18446744048.277786] Initializing CPU#4
Dec 14 22:16:17 dre kernel: [18446744048.425692] CPU: Physical Processor ID: 0
Dec 14 22:16:17 dre kernel: [18446744048.425694] CPU: Processor Core ID: 2
Dec 14 22:16:17 dre kernel: [18446744048.425701] CPU 4/0x4 -> Node 0
Dec 14 22:16:17 dre kernel: [18446744048.425717] CPU4: Thermal monitoring enabled (TM1)
Dec 14 22:16:17 dre kernel: [18446744048.425723] CPU 4 MCA banks SHD:6 SHD:8
Dec 14 22:16:17 dre kernel: [18446744048.425795] CPU4: Intel(R) Core(TM) CPU          Q 820  @ 1.73GHz stepping 05
Dec 14 22:16:17 dre kernel: [18446744048.425807] Skipped synchronization checks as TSC is reliable.
Dec 14 22:16:17 dre kernel: [18446744048.547120] CPU4 is up
Dec 14 22:16:17 dre kernel: [18446744048.547338] Booting processor 5 APIC 0x5 ip 0x6000
Dec 14 22:16:17 dre kernel: [18446744048.557753] Initializing CPU#5
Dec 14 22:16:17 dre kernel: [18446744048.705595] CPU: Physical Processor ID: 0
Dec 14 22:16:17 dre kernel: [18446744048.705598] CPU: Processor Core ID: 2
Dec 14 22:16:17 dre kernel: [18446744048.705603] CPU 5/0x5 -> Node 0
Dec 14 22:16:17 dre kernel: [18446744048.705619] CPU5: Thermal monitoring enabled (TM1)
Dec 14 22:16:17 dre kernel: [18446744048.705624] CPU 5 MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:8
Dec 14 22:16:17 dre kernel: [18446744048.705679] CPU5: Intel(R) Core(TM) CPU          Q 820  @ 1.73GHz stepping 05
Dec 14 22:16:17 dre kernel: [18446744048.705691] Skipped synchronization checks as TSC is reliable.
Dec 14 22:16:17 dre kernel: [18446744048.827161] CPU5 is up
Dec 14 22:16:17 dre kernel: [18446744048.827381] Booting processor 6 APIC 0x6 ip 0x6000
Dec 14 22:16:17 dre kernel: [18446744048.837795] Initializing CPU#6
Dec 14 22:16:17 dre kernel: [18446744048.985499] CPU: Physical Processor ID: 0
Dec 14 22:16:17 dre kernel: [18446744048.985501] CPU: Processor Core ID: 3
Dec 14 22:16:17 dre kernel: [18446744048.985507] CPU 6/0x6 -> Node 0
Dec 14 22:16:17 dre kernel: [18446744048.985524] CPU6: Thermal monitoring enabled (TM1)
Dec 14 22:16:17 dre kernel: [18446744048.985530] CPU 6 MCA banks SHD:6 SHD:8
Dec 14 22:16:17 dre kernel: [18446744048.985601] CPU6: Intel(R) Core(TM) CPU          Q 820  @ 1.73GHz stepping 05
Dec 14 22:16:17 dre kernel: [18446744048.985613] Skipped synchronization checks as TSC is reliable.
Dec 14 22:16:17 dre kernel: [18446744049.107118] CPU6 is up
Dec 14 22:16:17 dre kernel: [18446744049.107339] Booting processor 7 APIC 0x7 ip 0x6000
Dec 14 22:16:17 dre kernel: [18446744049.117753] Initializing CPU#7
Dec 14 22:16:17 dre kernel: [18446744049.265402] CPU: Physical Processor ID: 0
Dec 14 22:16:17 dre kernel: [18446744049.265405] CPU: Processor Core ID: 3
Dec 14 22:16:17 dre kernel: [18446744049.265410] CPU 7/0x7 -> Node 0
Dec 14 22:16:17 dre kernel: [18446744049.265426] CPU7: Thermal monitoring enabled (TM1)
Dec 14 22:16:17 dre kernel: [18446744049.265431] CPU 7 MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:8
Dec 14 22:16:17 dre kernel: [18446744049.265486] CPU7: Intel(R) Core(TM) CPU          Q 820  @ 1.73GHz stepping 05
Dec 14 22:16:17 dre kernel: [18446744049.265495] Skipped synchronization checks as TSC is reliable.
Dec 14 22:16:18 dre kernel: [18446744049.387204] CPU7 is up
Dec 14 22:16:18 dre kernel: [18446744049.392569] ACPI: Waking up from system sleep state S3
Dec 14 22:16:18 dre kernel: [18446744049.884125] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
Dec 14 22:16:18 dre kernel: [18446744049.884267] ehci_hcd 0000:00:1d.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
Dec 14 22:16:18 dre kernel: [18446744049.895315] pci 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Dec 14 22:16:18 dre kernel: [18446744049.895331] HDA Intel 0000:01:00.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
Dec 14 22:16:18 dre kernel: [18446744049.895444] iwlagn 0000:02:00.0: RF_KILL bit toggled to enable radio.
Dec 14 22:16:18 dre kernel: [18446744050.139774] sd 0:0:0:0: [sda] Starting disk
Dec 14 22:16:18 dre kernel: [18446744050.245099] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Dec 14 22:16:18 dre kernel: [18446744050.245578] ata1.00: configured for UDMA/100
Dec 14 22:16:18 dre kernel: [18446744050.265091] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Dec 14 22:16:18 dre kernel: [18446744050.265288] sd 1:0:0:0: [sdb] Starting disk
Dec 14 22:16:18 dre kernel: [18446744050.266634] ata2.00: configured for UDMA/100
Dec 14 22:16:18 dre kernel: [18446744050.285076] ata6: SATA link down (SStatus 0 SControl 300)
Dec 14 22:16:18 dre kernel: [18446744050.465010] usb 1-1: reset high speed USB device using ehci_hcd and address 2
Dec 14 22:16:18 dre kernel: [18446744050.914932] usb 1-1.5: reset high speed USB device using ehci_hcd and address 3
Dec 14 22:16:18 dre kernel: [18446744051.027788] PM: resume devices took 1.500 seconds
Dec 14 22:16:18 dre kernel: [18446744051.027874] Restarting tasks ... done.
Dec 14 22:16:19 dre kernel: [18446744052.889513] Synaptics Touchpad, model: 1, fw: 7.4, id: 0x1e0b1, caps: 0xd04771/0xe40000
Dec 14 22:16:19 dre kernel: [18446744052.889516] Synaptics: Clickpad mode enabled
Dec 14 22:16:19 dre kernel: [18446744052.958707] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input11
Dec 14 22:16:21 dre kernel: [18446744054.221434] ADDRCONF(NETDEV_UP): eth0: link is not ready
Dec 14 22:16:21 dre kernel: [18446744054.346332] ADDRCONF(NETDEV_UP): wlan0: link is not ready
Dec 14 22:16:22 dre kernel: [18446744055.559791] [drm] Resetting GPU
Dec 14 22:16:29 dre kernel: [18446744062.599211] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready

--vtzGhvizbBRQ85DL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="pm-suspend.log"

Initial commandline parameters: 
Mon Dec 14 22:14:25 MST 2009: Running hooks for suspend.
/usr/lib/pm-utils/sleep.d/000record suspend suspend: success.
/usr/lib/pm-utils/sleep.d/00auto-quirk suspend suspend: Adding quirks from HAL: --quirk-dpms-on --quirk-dpms-suspend --quirk-vbe-post --quirk-vbemode-restore --quirk-vbestate-restore --quirk-vga-mode-3 
success.
/usr/lib/pm-utils/sleep.d/00logging suspend suspend: Linux dre 2.6.32 #6 SMP Mon Dec 14 20:19:19 MST 2009 x86_64 GNU/Linux
Module                  Size  Used by
radeon                499781  1 
ttm                    52214  1 radeon
drm_kms_helper         25544  1 radeon
drm                   178417  4 radeon,ttm,drm_kms_helper
i2c_algo_bit            4874  1 radeon
binfmt_misc             7203  1 
snd_hda_codec_atihdmi     2591  1 
snd_hda_codec_idt      52903  1 
arc4                    1377  2 
snd_hda_intel          22389  2 
snd_hda_codec          75738  3 snd_hda_codec_atihdmi,snd_hda_codec_idt,snd_hda_intel
snd_hwdep               6078  1 snd_hda_codec
snd_pcm_oss            33674  0 
snd_mixer_oss          13449  1 snd_pcm_oss
snd_pcm                75256  3 snd_hda_intel,snd_hda_codec,snd_pcm_oss
snd_seq_dummy           1638  0 
snd_seq_oss            26156  0 
snd_seq_midi            5154  0 
snd_rawmidi            20204  1 snd_seq_midi
iwlagn                 89334  0 
snd_seq_midi_event      6457  2 snd_seq_oss,snd_seq_midi
iwlcore               109106  1 iwlagn
snd_seq                48369  6 snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_seq_midi_event
snd_timer              19922  2 snd_pcm,snd_seq
snd_seq_device          6070  5 snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_rawmidi,snd_seq
mac80211              164074  2 iwlagn,iwlcore
snd                    60747  16 snd_hda_codec_idt,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm_oss,snd_mixer_oss,snd_pcm,snd_seq_oss,snd_rawmidi,snd_seq,snd_timer,snd_seq_device
psmouse                50700  0 
joydev                  9485  0 
soundcore               6978  1 snd
cfg80211              123216  3 iwlagn,iwlcore,mac80211
atl1c                  26778  0 
hp_accel               11864  0 
serio_raw               4475  0 
lis3lv02d               6831  1 hp_accel
snd_page_alloc          7666  2 snd_hda_intel,snd_pcm
input_polldev           4007  1 lis3lv02d
led_class               3412  1 hp_accel
video                  20532  0 
output                  2247  1 video
             total       used       free     shared    buffers     cached
Mem:       8188844     623668    7565176          0      28428     198408
-/+ buffers/cache:     396832    7792012
Swap:      4996172          0    4996172
success.
/usr/lib/pm-utils/sleep.d/00powersave suspend suspend: success.
/usr/lib/pm-utils/sleep.d/01PulseAudio suspend suspend: success.
/etc/pm/sleep.d/10_grub-common suspend suspend: success.
/etc/pm/sleep.d/10_unattended-upgrades-hibernate suspend suspend: success.
/usr/lib/pm-utils/sleep.d/49bluetooth suspend suspend: not applicable.
/usr/lib/pm-utils/sleep.d/55NetworkManager suspend suspend: success.
/usr/lib/pm-utils/sleep.d/75modules suspend suspend: success.
/usr/lib/pm-utils/sleep.d/90clock suspend suspend: not applicable.
/usr/lib/pm-utils/sleep.d/94cpufreq suspend suspend: success.
/usr/lib/pm-utils/sleep.d/95anacron suspend suspend: stop: Unknown instance: 
success.
/usr/lib/pm-utils/sleep.d/95led suspend suspend: not applicable.
/usr/lib/pm-utils/sleep.d/96laptop-mode suspend suspend: success.
/usr/lib/pm-utils/sleep.d/98smart-kernel-video suspend suspend: not applicable.
/usr/lib/pm-utils/sleep.d/99video suspend suspend: kernel.acpi_video_flags = 0
Allocated buffer at 0x11000 (base is 0x0)
ES: 0x1100 EBX: 0x0000
success.
/etc/pm/sleep.d/action_wpa suspend suspend: success.
Mon Dec 14 22:14:29 MST 2009: performing suspend
Mon Dec 14 22:16:17 MST 2009: Awake.
Mon Dec 14 22:16:17 MST 2009: Running hooks for resume
/etc/pm/sleep.d/action_wpa resume suspend: success.
/usr/lib/pm-utils/sleep.d/99video resume suspend: Function not supported
Function not supported
success.
/usr/lib/pm-utils/sleep.d/98smart-kernel-video resume suspend: success.
/usr/lib/pm-utils/sleep.d/96laptop-mode resume suspend: success.
/usr/lib/pm-utils/sleep.d/95led resume suspend: not applicable.
/usr/lib/pm-utils/sleep.d/95anacron resume suspend: success.
/usr/lib/pm-utils/sleep.d/94cpufreq resume suspend: success.
/usr/lib/pm-utils/sleep.d/90clock resume suspend: not applicable.
/usr/lib/pm-utils/sleep.d/75modules resume suspend: success.
/usr/lib/pm-utils/sleep.d/55NetworkManager resume suspend: success.
/usr/lib/pm-utils/sleep.d/49bluetooth resume suspend: not applicable.
/etc/pm/sleep.d/10_unattended-upgrades-hibernate resume suspend: success.
/etc/pm/sleep.d/10_grub-common resume suspend: success.
/usr/lib/pm-utils/sleep.d/01PulseAudio resume suspend: success.
/usr/lib/pm-utils/sleep.d/00powersave resume suspend: success.
/usr/lib/pm-utils/sleep.d/00logging resume suspend: success.
/usr/lib/pm-utils/sleep.d/00auto-quirk resume suspend: success.
/usr/lib/pm-utils/sleep.d/000record resume suspend: success.
Mon Dec 14 22:16:21 MST 2009: Finished.

--vtzGhvizbBRQ85DL--
