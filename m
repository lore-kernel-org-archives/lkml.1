Return-Path: <linux-kernel-owner+w=401wt.eu-S1750729AbXBAViL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750729AbXBAViL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 16:38:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750886AbXBAViL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 16:38:11 -0500
Received: from aa013msr.fastwebnet.it ([85.18.95.73]:42294 "EHLO
	aa013msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbXBAViI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 16:38:08 -0500
Date: Thu, 1 Feb 2007 22:37:51 +0100
From: Mattia Dongili <malattia@linux.it>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       mingo@redhat.com
Subject: Re: 2.6.20-rc6-mm3
Message-ID: <20070201213751.GA2696@inferi.kami.home>
Mail-Followup-To: Thomas Gleixner <tglx@linutronix.de>,
	Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
	mingo@redhat.com
References: <20070129204528.eb8d695e.akpm@osdl.org> <20070131215241.GB2890@inferi.kami.home> <20070131232130.GC4137@inferi.kami.home> <1170358572.29240.292.camel@localhost.localdomain> <1170360101.29240.297.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1170360101.29240.297.camel@localhost.localdomain>
X-Message-Flag: Cranky? Try Free Software instead!
X-Operating-System: Linux 2.6.20-rc6-mm3-1 i686
X-Editor: Vim http://www.vim.org/
X-Disclaimer: Buh!
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 01, 2007 at 09:01:41PM +0100, Thomas Gleixner wrote:
> On Thu, 2007-02-01 at 20:36 +0100, Thomas Gleixner wrote:
> > On Thu, 2007-02-01 at 00:21 +0100, Mattia Dongili wrote: 
> > > yes, slowness is gone. Any useful information I can provide?
> > 
> > Can you please try with CONFIG_ACPI_PROCESSOR=y instead of =m ? This
> > should make the slowness go away too.
> > 
> > I think I know what happens. I try to reproduce with
> > CONFIG_ACPI_PROCESSOR=m.
> 
> Hmm. Not reproducible on my jinxed Sony. 
> 
> It might be helpful if you could try with your original config again.
> Please enable printk timestamps and SysRq. Once the slowness kicks in
> please issue a SysRq-Q, so we can look at the internal state of the tick
> code.

BTW: booting with clocksource=pmtmr make it proceed a little better but
I still experience stalls:


[    0.000000] Linux version 2.6.20-rc6-mm3-1 (mattia@tadamune) (gcc version 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)) #7 SMP Thu Feb 1 21:44:52 CET 2007
[    0.000000] BIOS-provided physical RAM map:
[    0.000000] sanitize start
[    0.000000] sanitize end
[    0.000000] copy_e820_map() start: 0000000000000000 size: 000000000009f800 end: 000000000009f800 type: 1
[    0.000000] copy_e820_map() type is E820_RAM
[    0.000000] copy_e820_map() start: 000000000009f800 size: 0000000000000800 end: 00000000000a0000 type: 2
[    0.000000] copy_e820_map() start: 00000000000dc000 size: 0000000000024000 end: 0000000000100000 type: 2
[    0.000000] copy_e820_map() start: 0000000000100000 size: 000000003fd70000 end: 000000003fe70000 type: 1
[    0.000000] copy_e820_map() type is E820_RAM
[    0.000000] copy_e820_map() start: 000000003fe70000 size: 0000000000090000 end: 000000003ff00000 type: 4
[    0.000000] copy_e820_map() start: 000000003ff00000 size: 0000000000100000 end: 0000000040000000 type: 2
[    0.000000] copy_e820_map() start: 00000000e0000000 size: 0000000010000000 end: 00000000f0000000 type: 2
[    0.000000] copy_e820_map() start: 00000000fec00000 size: 0000000000010000 end: 00000000fec10000 type: 2
[    0.000000] copy_e820_map() start: 00000000fed14000 size: 0000000000006000 end: 00000000fed1a000 type: 2
[    0.000000] copy_e820_map() start: 00000000fed1c000 size: 0000000000074000 end: 00000000fed90000 type: 2
[    0.000000] copy_e820_map() start: 00000000fee00000 size: 0000000000001000 end: 00000000fee01000 type: 2
[    0.000000] copy_e820_map() start: 00000000ff000000 size: 0000000001000000 end: 0000000100000000 type: 2
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003fe70000 (usable)
[    0.000000]  BIOS-e820: 000000003fe70000 - 000000003ff00000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003ff00000 - 0000000040000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
[    0.000000] 126MB HIGHMEM available.
[    0.000000] 896MB LOWMEM available.
[    0.000000] found SMP MP-table at 000f6480
[    0.000000] Entering add_active_range(0, 0, 261744) 0 entries of 256 used
[    0.000000] sizeof(struct page) = 32
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->   229376
[    0.000000]   HighMem    229376 ->   261744
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->   261744
[    0.000000] On node 0 totalpages: 261744
[    0.000000] Node 0 memmap at 0xc1000000 size 8388608 first pfn 0xc1000000
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 4064 pages, LIFO batch:0
[    0.000000]   Normal zone: 1760 pages used for memmap
[    0.000000]   Normal zone: 223520 pages, LIFO batch:31
[    0.000000]   HighMem zone: 252 pages used for memmap
[    0.000000]   HighMem zone: 32116 pages, LIFO batch:7
[    0.000000] DMI present.
[    0.000000] ACPI: RSDP @ 0x000f63b0/0x0014 (v000 PTLTD )
[    0.000000] ACPI: RSDT @ 0x3fe764ef/0x0048 (v001   Sony       N0 0x20060710 PTL  0x00000000)
[    0.000000] ACPI: FACP @ 0x3fe7ddde/0x0084 (v002   Sony       N0 0x20060710 PTL  0x0000005A)
[    0.000000] ACPI: DSDT @ 0x3fe77e33/0x5FAB (v001   Sony       N0 0x20060710 PTL  0x0100000E)
[    0.000000] ACPI: FACS @ 0x3fe7efc0/0x0040
[    0.000000] ACPI: APIC @ 0x3fe7de62/0x0068 (v001   Sony       N0 0x20060710 PTL  0x0000005A)
[    0.000000] ACPI: BOOT @ 0x3fe7dfd8/0x0028 (v001   Sony       N0 0x20060710 PTL  0x00000001)
[    0.000000] ACPI: MCFG @ 0x3fe7df02/0x003C (v001   Sony       N0 0x20060710 PTL  0x0000005A)
[    0.000000] ACPI: TCPA @ 0x3fe7df3e/0x0032 (v001   Sony       N0 0x20060710 PTL  0x00005A52)
[    0.000000] ACPI: APIC @ 0x3fe7df70/0x0068 (v001   Sony       N0 0x20060710 PTL  0x00000000)
[    0.000000] ACPI: SSDT @ 0x3fe776b1/0x077E (v001   Sony       N0 0x20060710 PTL  0x20050624)
[    0.000000] ACPI: SSDT @ 0x3fe76ee6/0x07CB (v001   Sony       N0 0x20060710 PTL  0x20050624)
[    0.000000] ACPI: SSDT @ 0x3fe76537/0x04E2 (v001   Sony       N0 0x20060710 PTL  0x20050624)
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] Processor #0 6:15 APIC version 20
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] Processor #1 6:15 APIC version 20
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at 50000000 (gap: 40000000:a0000000)
[    0.000000] Detected 1833.715 MHz processor.
[   12.852448] Built 1 zonelists.  Total pages: 259700
[   12.852452] Kernel command line: root=/dev/sda3 ro vga=extended resume=/dev/sda5 clocksource=pmtmr
[   12.852618] mapped APIC to ffffd000 (fee00000)
[   12.852620] mapped IOAPIC to ffffc000 (fec00000)
[   12.852623] Enabling fast FPU save and restore... done.
[   12.852625] Enabling unmasked SIMD FPU exception support... done.
[   12.852632] Initializing CPU#0
[   12.852688] PID hash table entries: 4096 (order: 12, 16384 bytes)
[   12.858053] Console: colour VGA+ 80x50
[   12.863852] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[   12.864198] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[   12.886662] Memory: 1034188k/1046976k available (1864k kernel code, 12244k reserved, 687k data, 212k init, 129472k highmem)
[   12.886766] virtual kernel memory layout:
[   12.886767]     fixmap  : 0xfff9d000 - 0xfffff000   ( 392 kB)
[   12.886768]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[   12.886769]     vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
[   12.886770]     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
[   12.886771]       .init : 0xc0384000 - 0xc03b9000   ( 212 kB)
[   12.886772]       .data : 0xc02d23c1 - 0xc037dff4   ( 687 kB)
[   12.886773]       .text : 0xc0100000 - 0xc02d23c1   (1864 kB)
[   12.887372] Checking if this processor honours the WP bit even in supervisor mode... Ok.
[   12.967554] Calibrating delay using timer specific routine.. 3671.23 BogoMIPS (lpj=7342463)
[   12.967735] Security Framework v1.0.0 initialized
[   12.967814] Capability LSM initialized
[   12.967897] Mount-cache hash table entries: 512
[   12.968053] CPU: After generic identify, caps: bfebfbff 20100000 00000000 00000000 0000e3bd 00000000 00000001
[   12.968059] monitor/mwait feature present.
[   12.968133] using mwait in idle threads.
[   12.968210] CPU: L1 I cache: 32K, L1 D cache: 32K
[   12.968344] CPU: L2 cache: 2048K
[   12.968418] CPU: Physical Processor ID: 0
[   12.968492] CPU: Processor Core ID: 0
[   12.968567] CPU: After all inits, caps: bfebfbff 20100000 00000000 00003940 0000e3bd 00000000 00000001
[   12.968573] Intel machine check architecture supported.
[   12.968650] Intel machine check reporting enabled on CPU#0.
[   12.968729] Compat vDSO mapped to ffffe000.
[   12.968811] Checking 'hlt' instruction... OK.
[   12.983667] SMP alternatives: switching to UP code
[   12.983895] ACPI: Core revision 20070126
[   12.990057] Parsing all Control Methods:
[   12.990288] Table [DSDT](id 0001) - 923 Objects with 104 Devices 193 Methods 29 Regions
[   12.990575] Parsing all Control Methods:
[   12.990762] Table [SSDT](id 0002) - 13 Objects with 3 Devices 4 Methods 0 Regions
[   12.991054] Parsing all Control Methods:
[   12.991245] Table [SSDT](id 0003) - 14 Objects with 3 Devices 5 Methods 0 Regions
[   12.991549] Parsing all Control Methods:
[   12.991743] Table [SSDT](id 0004) - 13 Objects with 0 Devices 4 Methods 0 Regions
[   12.991900]  tbxface-0586 [02] tb_load_namespace     : ACPI Tables successfully acquired
[   12.995677] evxfevnt-0091 [02] enable                : Transition to ACPI mode successful
[   12.995902] CPU0: Intel(R) Core(TM)2 CPU         T5600  @ 1.83GHz stepping 06
[   12.996109] SMP alternatives: switching to SMP code
[   12.996200] Booting processor 1/1 eip 3000
[   13.006792] Initializing CPU#1
[   13.087450] Calibrating delay using timer specific routine.. 3667.18 BogoMIPS (lpj=7334374)
[   13.087455] CPU: After generic identify, caps: bfebfbff 20100000 00000000 00000000 0000e3bd 00000000 00000001
[   13.087460] monitor/mwait feature present.
[   13.087463] CPU: L1 I cache: 32K, L1 D cache: 32K
[   13.087465] CPU: L2 cache: 2048K
[   13.087467] CPU: Physical Processor ID: 0
[   13.087468] CPU: Processor Core ID: 1
[   13.087469] CPU: After all inits, caps: bfebfbff 20100000 00000000 00003940 0000e3bd 00000000 00000001
[   13.087474] Intel machine check architecture supported.
[   13.087477] Intel machine check reporting enabled on CPU#1.
[   13.087854] CPU1: Intel(R) Core(TM)2 CPU         T5600  @ 1.83GHz stepping 06
[   13.088735] Total of 2 processors activated (7338.41 BogoMIPS).
[   13.089010] ENABLING IO-APIC IRQs
[   13.089282] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
[   13.363220] APIC calibration not consistent with PM Timer: 228ms instead of 100ms
[   13.363311] APIC delta adjusted to PM-Timer: 1041739 (2375306)
[   13.471425] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[   13.491558] Brought up 2 CPUs
[   13.680628] migration_cost=59
[   13.680999] NET: Registered protocol family 16
[   13.681152] ACPI: bus type pci registered
[   13.681235] PCI: Using MMCONFIG
[   13.682146] Setting up standard PCI resources
[   13.687025] evgpeblk-0952 [04] ev_create_gpe_block   : GPE 00 to 1F [_GPE] 4 regs on int 0x9
[   13.688004] evgpeblk-1049 [03] ev_initialize_gpe_bloc: Found 8 Wake, Enabled 5 Runtime GPEs in this block
[   13.688919] Completing Region/Field/Buffer/Package initialization:.........................................................................
[   13.694826] Initialized 29/29 Regions 4/4 Fields 29/29 Buffers 11/38 Packages (972 nodes)
[   13.694985] Initializing Device/Processor/Thermal objects by executing _INI methods:...
[   13.696264] Executed 3 _INI methods requiring 2 _STA executions (examined 117 objects)
[   13.696438] ACPI: Interpreter enabled
[   13.696512] ACPI: Using IOAPIC for interrupt routing
[   13.696671] Found System \ [ffffffff]
[   13.696724] Found Processor \_PR_.CPU0 [c1907dd8]
[   13.696769] Found Processor \_PR_.CPU1 [c1907dc4]
[   13.696835] Found Device \_SB_ [c19073c4]
[   13.696892] Found Device \_SB_.LID0 [c190da40]
[   13.696956] Found Device \_SB_.PWRB [c190da04]
[   13.697018] Found Device \_SB_.PCI0 [c190d9a0]
[   13.697086] Found Device \_SB_.PCI0.PDRC [c190d7c0]
[   13.697148] Found Device \_SB_.PCI0.PEGP [c190dfcc]
[   13.697213] Found Device \_SB_.PCI0.GFX0 [c190df90]
[   13.697283] Found Device \_SB_.PCI0.HDEF [c190df68]
[   13.697345] Found Device \_SB_.PCI0.RP01 [c190df04]
[   13.697415] Found Device \_SB_.PCI0.RP01.S1F0 [c190de50]
[   13.697485] Found Device \_SB_.PCI0.RP01.S1F1 [c190ddec]
[   13.697552] Found Device \_SB_.PCI0.RP01.S1F2 [c190dd88]
[   13.697626] Found Device \_SB_.PCI0.RP01.S1F3 [c190dd24]
[   13.697693] Found Device \_SB_.PCI0.RP01.S1F4 [c190dcc0]
[   13.697762] Found Device \_SB_.PCI0.RP01.S1F5 [c190dc5c]
[   13.697831] Found Device \_SB_.PCI0.RP01.S1F6 [c190f748]
[   13.697902] Found Device \_SB_.PCI0.RP01.S1F7 [c190f6e4]
[   13.697967] Found Device \_SB_.PCI0.RP02 [c190f66c]
[   13.698140] Found Device \_SB_.PCI0.RP02.WLAN [c190f5b8]
[   13.698205] Found Device \_SB_.PCI0.RP03 [c190f52c]
[   13.698275] Found Device \_SB_.PCI0.RP03.TLAN [c190f464]
[   13.698339] Found Device \_SB_.PCI0.RP04 [c190f414]
[   13.698407] Found Device \_SB_.PCI0.RP04.DLAN [c190f34c]
[   13.698470] Found Device \_SB_.PCI0.RP04.S4F1 [c190f2e8]
[   13.698534] Found Device \_SB_.PCI0.RP04.S4F2 [c190fc0c]
[   13.698597] Found Device \_SB_.PCI0.RP04.S4F3 [c190fbd0]
[   13.698659] Found Device \_SB_.PCI0.RP04.S4F4 [c190fb94]
[   13.698719] Found Device \_SB_.PCI0.RP04.S4F5 [c190fb58]
[   13.698782] Found Device \_SB_.PCI0.RP04.S4F6 [c190fb1c]
[   13.698845] Found Device \_SB_.PCI0.RP04.S4F7 [c190fae0]
[   13.698913] Found Device \_SB_.PCI0.RP05 [c190faa4]
[   13.698975] Found Device \_SB_.PCI0.RP05.EX2P [c190f9dc]
[   13.699037] Found Device \_SB_.PCI0.RP05.S5F1 [c190f978]
[   13.699100] Found Device \_SB_.PCI0.RP05.S5F2 [c190f93c]
[   13.699166] Found Device \_SB_.PCI0.RP05.S5F3 [c190f900]
[   13.699228] Found Device \_SB_.PCI0.RP05.S5F4 [c190f8c4]
[   13.699294] Found Device \_SB_.PCI0.RP05.S5F5 [c190f888]
[   13.699355] Found Device \_SB_.PCI0.RP05.S5F6 [c190f84c]
[   13.699418] Found Device \_SB_.PCI0.RP05.S5F7 [c190f810]
[   13.699483] Found Device \_SB_.PCI0.RP06 [c190f7d4]
[   13.699559] Found Device \_SB_.PCI0.RP06.S6F0 [c190ffa4]
[   13.699627] Found Device \_SB_.PCI0.RP06.S6F1 [c190ff40]
[   13.699699] Found Device \_SB_.PCI0.RP06.S6F2 [c190fedc]
[   13.699768] Found Device \_SB_.PCI0.RP06.S6F3 [c190fe78]
[   13.699837] Found Device \_SB_.PCI0.RP06.S6F4 [c190fe14]
[   13.699907] Found Device \_SB_.PCI0.RP06.S6F5 [c190fdb0]
[   13.699976] Found Device \_SB_.PCI0.RP06.S6F6 [c190fd4c]
[   13.700045] Found Device \_SB_.PCI0.RP06.S6F7 [c190fce8]
[   13.700119] Found Device \_SB_.PCI0.USB1 [c190fc70]
[   13.700190] Found Device \_SB_.PCI0.USB2 [c1910748]
[   13.700260] Found Device \_SB_.PCI0.USB3 [c19106d0]
[   13.700330] Found Device \_SB_.PCI0.USB4 [c1910658]
[   13.700402] Found Device \_SB_.PCI0.USB7 [c19105e0]
[   13.700464] Found Device \_SB_.PCI0.USB7.HUB7 [c19105b8]
[   13.700531] Found Device \_SB_.PCI0.USB7.HUB7.PRT1 [c1910590]
[   13.700593] Found Device \_SB_.PCI0.USB7.HUB7.PRT2 [c1910568]
[   13.700656] Found Device \_SB_.PCI0.USB7.HUB7.PRT3 [c1910540]
[   13.700719] Found Device \_SB_.PCI0.USB7.HUB7.PRT4 [c1910518]
[   13.700782] Found Device \_SB_.PCI0.USB7.HUB7.PRT5 [c19104f0]
[   13.700844] Found Device \_SB_.PCI0.USB7.HUB7.PRT6 [c19104c8]
[   13.700910] Found Device \_SB_.PCI0.USB7.HUB7.PRT7 [c19104a0]
[   13.700972] Found Device \_SB_.PCI0.USB7.HUB7.PRT8 [c1910478]
[   13.701038] Found Device \_SB_.PCI0.PCIB [c191043c]
[   13.701111] Found Device \_SB_.PCI0.PCIB.SLT0 [c1910414]
[   13.701182] Found Device \_SB_.PCI0.PCIB.LANC [c19103d8]
[   13.701350] Found Device \_SB_.PCI0.PCIB.CRD2 [c191039c]
[   13.701424] Found Device \_SB_.PCI0.PCIB.S294 [c19102c0]
[   13.701487] Found Device \_SB_.PCI0.PCIB.MST2 [c1910bf8]
[   13.701655] Found Device \_SB_.PCI0.PCIB.CRD0 [c1910bd0]
[   13.701724] Found Device \_SB_.PCI0.PCIB.SD94 [c1910af4]
[   13.701788] Found Device \_SB_.PCI0.PCIB.MMST [c1910acc]
[   13.701852] Found Device \_SB_.PCI0.AUD0 [c1910a90]
[   13.701918] Found Device \_SB_.PCI0.MODM [c1910a68]
[   13.701984] Found Device \_SB_.PCI0.LPCB [c1910a40]
[   13.702199] Found Device \_SB_.PCI0.LPCB.LNKA [c19108ec]
[   13.702396] Found Device \_SB_.PCI0.LPCB.LNKB [c191084c]
[   13.702595] Found Device \_SB_.PCI0.LPCB.LNKC [c19107ac]
[   13.702791] Found Device \_SB_.PCI0.LPCB.LNKD [c1910f90]
[   13.702987] Found Device \_SB_.PCI0.LPCB.LNKE [c1910ef0]
[   13.703203] Found Device \_SB_.PCI0.LPCB.LNKF [c1910e50]
[   13.703397] Found Device \_SB_.PCI0.LPCB.LNKG [c1910db0]
[   13.703592] Found Device \_SB_.PCI0.LPCB.LNKH [c1910d10]
[   13.703665] Found Device \_SB_.PCI0.LPCB.EC0_ [c1910c70]
[   13.707695] Found Device \_SB_.PCI0.LPCB.EC0_.BAT1 [c1911a18]
[   13.707856] Found Device \_SB_.PCI0.LPCB.EC0_.ACAD [c1911950]
[   13.707917] Found Device \_SB_.PCI0.LPCB.DMAC [c19118ec]
[   13.707978] Found Device \_SB_.PCI0.LPCB.FWHD [c19118b0]
[   13.708134] Found Device \_SB_.PCI0.LPCB.IPIC [c19117fc]
[   13.708194] Found Device \_SB_.PCI0.LPCB.MATH [c19117c0]
[   13.708253] Found Device \_SB_.PCI0.LPCB.LDRC [c1911784]
[   13.708318] Found Device \_SB_.PCI0.LPCB.RTC_ [c1911f90]
[   13.708377] Found Device \_SB_.PCI0.LPCB.TIMR [c1911f54]
[   13.708559] Found Device \_SB_.PCI0.LPCB.TPM_ [c1911f18]
[   13.712558] Found Device \_SB_.PCI0.LPCB.SPIC [c1911ea0]
[   13.712624] Found Device \_SB_.PCI0.LPCB.SNC_ [c1911dd8]
[   13.712689] Found Device \_SB_.PCI0.LPCB.PS2K [c1913748]
[   13.712754] Found Device \_SB_.PCI0.LPCB.PS2M [c191370c]
[   13.712830] Found Device \_SB_.PCI0.PATA [c19136bc]
[   13.712897] Found Device \_SB_.PCI0.PATA.PRID [c19135a4]
[   13.712961] Found Device \_SB_.PCI0.PATA.PRID.P_D0 [c1913554]
[   13.713023] Found Device \_SB_.PCI0.PATA.PRID.P_D1 [c1913518]
[   13.713089] Found Device \_SB_.PCI0.SATA [c191348c]
[   13.713161] Found Device \_SB_.PCI0.SATA.PRID [c19139dc]
[   13.713223] Found Device \_SB_.PCI0.SATA.PRID.P_D0 [c191398c]
[   13.713285] Found Device \_SB_.PCI0.SATA.PRID.P_D1 [c1913950]
[   13.713349] Found Device \_SB_.PCI0.SATA.SECD [c19138d8]
[   13.713417] Found Device \_SB_.PCI0.SATA.SECD.S_D0 [c1913888]
[   13.713480] Found Device \_SB_.PCI0.SATA.SECD.S_D1 [c1913838]
[   13.713549] Found Device \_SB_.PCI0.SBUS [c1913310]
[   13.715581] Found Thermal Zone \_TZ_ [c190739c]
[   13.715664] Found Thermal Zone \_TZ_.ATF0 [c190d4a0]
[   13.715713] Found Thermal Zone \_TZ_.DTS0 [c190d3ec]
[   13.715759] Found Thermal Zone \_TZ_.DTS1 [c190d34c]
[   13.716098] ACPI: PCI Root Bridge [PCI0] (0000:00)
[   13.716797] PCI quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
[   13.716877] PCI quirk: region 1180-11bf claimed by ICH6 GPIO
[   13.717191] Boot video device is 0000:01:00.0
[   13.718224] PCI: Transparent bridge - 0000:00:1e.0
[   13.718369] PCI: Bus #0a (-#0d) is hidden behind transparent bridge #09 (-#0a) (try 'pci=assign-busses')
[   13.722639] Please report the result to linux-kernel to fix this permanently
[   13.722792] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[   13.723351] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEGP._PRT]
[   13.723596] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[   13.723843] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[   13.724079] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
[   13.724314] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP04._PRT]
[   13.724582] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
[   13.731518] ACPI: PCI Interrupt Link [LNKA] (IRQs 10) *5
[   13.731995] ACPI: PCI Interrupt Link [LNKB] (IRQs *10)
[   13.732413] ACPI: PCI Interrupt Link [LNKC] (IRQs *10)
[   13.732831] ACPI: PCI Interrupt Link [LNKD] (IRQs *10)
[   13.733248] ACPI: PCI Interrupt Link [LNKE] (IRQs 10) *0, disabled.
[   13.733784] ACPI: PCI Interrupt Link [LNKF] (IRQs *10)
[   13.734202] ACPI: PCI Interrupt Link [LNKG] (IRQs *10)
[   13.734619] ACPI: PCI Interrupt Link [LNKH] (IRQs *10)
[   13.735008] Linux Plug and Play Support v0.97 (c) Adam Belay
[   13.735096] pnp: PnP ACPI init
[   13.738478] pnp: PnP ACPI: found 11 devices
[   13.738556] PnPBIOS: Disabled by ACPI PNP
[   13.738747] SCSI subsystem initialized
[   13.738855] libata version 2.00 loaded.
[   13.738908] PCI: Using ACPI for IRQ routing
[   13.738983] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[   13.739241] NET: Registered protocol family 8
[   13.739317] NET: Registered protocol family 20
[   13.739429] pnp: 00:01: iomem range 0xe0000000-0xefffffff could not be reserved
[   13.739519] pnp: 00:01: iomem range 0xfed14000-0xfed17fff could not be reserved
[   13.739609] pnp: 00:01: iomem range 0xfed18000-0xfed18fff could not be reserved
[   13.739699] pnp: 00:01: iomem range 0xfed19000-0xfed19fff could not be reserved
[   13.740061] PCI: Failed to allocate mem resource #6:20000@d0000000 for 0000:01:00.0
[   13.740151] PCI: Bridge: 0000:00:01.0
[   13.740225]   IO window: disabled.
[   13.740300]   MEM window: dc000000-ddffffff
[   13.740375]   PREFETCH window: c0000000-cfffffff
[   13.740451] PCI: Bridge: 0000:00:1c.0
[   13.740526]   IO window: 2000-2fff
[   13.740604]   MEM window: d6000000-d7ffffff
[   13.740682]   PREFETCH window: d0000000-d1ffffff
[   13.740760] PCI: Bridge: 0000:00:1c.1
[   13.740834]   IO window: disabled.
[   13.740912]   MEM window: de100000-de1fffff
[   13.740989]   PREFETCH window: disabled.
[   13.741066] PCI: Bridge: 0000:00:1c.2
[   13.741142]   IO window: 3000-3fff
[   13.741219]   MEM window: d8000000-d9ffffff
[   13.741297]   PREFETCH window: d2000000-d3ffffff
[   13.741376] PCI: Bridge: 0000:00:1c.3
[   13.741451]   IO window: 4000-4fff
[   13.741528]   MEM window: da000000-dbffffff
[   13.741606]   PREFETCH window: d4000000-d5ffffff
[   13.741691] PCI: Bus 10, cardbus bridge: 0000:09:04.0
[   13.741766]   IO window: 00005000-000050ff
[   13.741844]   IO window: 00005400-000054ff
[   13.741923]   PREFETCH window: 50000000-53ffffff
[   13.742002]   MEM window: 54000000-57ffffff
[   13.742079] PCI: Bridge: 0000:00:1e.0
[   13.742155]   IO window: 5000-5fff
[   13.742232]   MEM window: de000000-de0fffff
[   13.742310]   PREFETCH window: 50000000-53ffffff
[   13.742395] ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level, low) -> IRQ 16
[   13.742546] PCI: Setting latency timer of device 0000:00:01.0 to 64
[   13.742565] ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level, low) -> IRQ 16
[   13.742715] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[   13.742736] ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 17 (level, low) -> IRQ 17
[   13.742886] PCI: Setting latency timer of device 0000:00:1c.1 to 64
[   13.742907] ACPI: PCI Interrupt 0000:00:1c.2[C] -> GSI 18 (level, low) -> IRQ 18
[   13.743057] PCI: Setting latency timer of device 0000:00:1c.2 to 64
[   13.743080] ACPI: PCI Interrupt 0000:00:1c.3[D] -> GSI 19 (level, low) -> IRQ 19
[   13.743231] PCI: Setting latency timer of device 0000:00:1c.3 to 64
[   13.743243] PCI: Setting latency timer of device 0000:00:1e.0 to 64
[   13.743265] ACPI: PCI Interrupt 0000:09:04.0[A] -> GSI 20 (level, low) -> IRQ 20
[   13.743437] NET: Registered protocol family 2
[   13.783050] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[   13.783200] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[   13.783750] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[   13.784066] TCP: Hash tables configured (established 131072 bind 65536)
[   13.784144] TCP reno registered
[   13.795233] Simple Boot Flag at 0x37 set to 0x1
[   13.795715] audit: initializing netlink socket (disabled)
[   13.795802] audit(1170365468.500:1): initialized
[   13.795948] highmem bounce pool size: 64 pages
[   13.796142] JFS: nTxBlock = 8080, nTxLock = 64646
[   13.799486] io scheduler noop registered
[   13.799625] io scheduler anticipatory registered
[   13.799759] io scheduler deadline registered
[   13.799902] io scheduler cfq registered (default)
[   13.800382] PCI: Setting latency timer of device 0000:00:01.0 to 64
[   13.800399] assign_interrupt_mode Found MSI capability
[   13.800498] Allocate Port Service[0000:00:01.0:pcie00]
[   13.800534] Allocate Port Service[0000:00:01.0:pcie03]
[   13.800592] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[   13.800644] assign_interrupt_mode Found MSI capability
[   13.800755] Allocate Port Service[0000:00:1c.0:pcie00]
[   13.800784] Allocate Port Service[0000:00:1c.0:pcie02]
[   13.800811] Allocate Port Service[0000:00:1c.0:pcie03]
[   13.800922] PCI: Setting latency timer of device 0000:00:1c.1 to 64
[   13.800973] assign_interrupt_mode Found MSI capability
[   13.801084] Allocate Port Service[0000:00:1c.1:pcie00]
[   13.801116] Allocate Port Service[0000:00:1c.1:pcie02]
[   13.801144] Allocate Port Service[0000:00:1c.1:pcie03]
[   13.801252] PCI: Setting latency timer of device 0000:00:1c.2 to 64
[   13.801303] assign_interrupt_mode Found MSI capability
[   13.801415] Allocate Port Service[0000:00:1c.2:pcie00]
[   13.801444] Allocate Port Service[0000:00:1c.2:pcie02]
[   13.801472] Allocate Port Service[0000:00:1c.2:pcie03]
[   13.801580] PCI: Setting latency timer of device 0000:00:1c.3 to 64
[   13.801632] assign_interrupt_mode Found MSI capability
[   13.801743] Allocate Port Service[0000:00:1c.3:pcie00]
[   13.801775] Allocate Port Service[0000:00:1c.3:pcie02]
[   13.801804] Allocate Port Service[0000:00:1c.3:pcie03]
[   13.802646] ACPI: SSDT @ 0x3fe76cb5/0x01A8 (v001   Sony       N0 0x20060710 PTL  0x20050624)
[   13.802919] Parsing all Control Methods:
[   13.803167] Table [SSDT](id 0075) - 5 Objects with 0 Devices 3 Methods 0 Regions
[   13.803529] ACPI: SSDT @ 0x3fe76a19/0x0217 (v001   Sony       N0 0x20060710 PTL  0x20050624)
[   13.803763] Parsing all Control Methods:
[   13.804003] Table [SSDT](id 0076) - 1 Objects with 0 Devices 1 Methods 0 Regions
[   13.805209] ACPI: CPU0 (power states: C1[C1] C2[C2])
[   13.805462] ACPI: Processor [CPU0] (supports 8 throttling states)
[   13.806224] ACPI: SSDT @ 0x3fe76e5d/0x0089 (v001   Sony       N0 0x20060710 PTL  0x20050624)
[   13.806475] Parsing all Control Methods:
[   13.806717] Table [SSDT](id 007B) - 3 Objects with 0 Devices 3 Methods 0 Regions
[   13.807071] ACPI: SSDT @ 0x3fe76c30/0x0085 (v001   Sony       N0 0x20060710 PTL  0x20050624)
[   13.807304] Parsing all Control Methods:
[   13.807545] Table [SSDT](id 007C) - 1 Objects with 0 Devices 1 Methods 0 Regions
[   13.808555] ACPI: CPU1 (power states: C1[C1] C2[C2])
[   13.808809] ACPI: Processor [CPU1] (supports 8 throttling states)
[   13.812098] isapnp: Scanning for PnP cards...
[   14.166397] isapnp: No Plug & Play device found
[   14.169415] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
[   14.170693] RAMDISK driver initialized: 16 RAM disks of 8192K size 1024 blocksize
[   14.170867] Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
[   14.170946] ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
[   14.171065] ICH7: IDE controller at PCI slot 0000:00:1f.1
[   14.171153] ACPI: PCI Interrupt 0000:00:1f.1[B] -> GSI 22 (level, low) -> IRQ 21
[   14.171305] ICH7: chipset revision 2
[   14.171379] ICH7: not 100% native mode: will probe irqs later
[   14.171463]     ide0: BM-DMA at 0x1880-0x1887, BIOS settings: hda:DMA, hdb:pio
[   14.171678] Probing IDE interface ide0...
[   14.904601] hda: MATSHITADVD-RAM UJ-842S, ATAPI CD/DVD-ROM drive
[   15.240023] hda: selected mode 0x42
[   15.240354] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[   15.242981] ata_piix 0000:00:1f.2: version 2.00ac7
[   15.242986] ata_piix 0000:00:1f.2: MAP [ P0 P2 XX XX ]
[   15.243355] ata_piix 0000:00:1f.2: invalid MAP value 0
[   15.395890] ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 22 (level, low) -> IRQ 21
[   15.396062] PCI: Setting latency timer of device 0000:00:1f.2 to 64
[   15.396120] ata1: SATA max UDMA/133 cmd 0x18C8 ctl 0x18AE bmdma 0x18B0 irq 21
[   15.396235] ata2: SATA max UDMA/133 cmd 0x18C0 ctl 0x18AA bmdma 0x18B8 irq 21
[   15.396323] scsi0 : ata_piix
[   15.570638] ata1.00: ATA-6, max UDMA/100, 195371568 sectors: LBA48 NCQ (depth 0/32)
[   15.570735] ata1.00: ata1: dev 0 multi count 16
[   15.586332] ata1.00: configured for UDMA/100
[   15.586419] scsi1 : ata_piix
[   15.750829] ATA: abnormal status 0x7F on port 0x18C7
[   15.750986] scsi 0:0:0:0: Direct-Access     ATA      TOSHIBA MK1032GS AS02 PQ: 0 ANSI: 5
[   15.751171] SCSI device sda: 195371568 512-byte hdwr sectors (100030 MB)
[   15.751257] sda: Write Protect is off
[   15.751332] sda: Mode Sense: 00 3a 00 00
[   15.751346] SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   15.751470] SCSI device sda: 195371568 512-byte hdwr sectors (100030 MB)
[   15.751554] sda: Write Protect is off
[   15.755800] sda: Mode Sense: 00 3a 00 00
[   15.755814] SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   15.755905]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 >
[   15.835628] sd 0:0:0:0: Attached scsi disk sda
[   15.835840] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[   15.838349] serio: i8042 KBD port at 0x60,0x64 irq 1
[   15.838427] serio: i8042 AUX port at 0x60,0x64 irq 12
[   15.838580] mice: PS/2 mouse device common for all mice
[   15.868749] TCP bic registered
[   15.868832] NET: Registered protocol family 1
[   15.868909] NET: Registered protocol family 17
[   15.869048] Starting balanced_irq
[   15.869128] Using IPI No-Shortcut mode
[   15.869597] ACPI: (supports S0 S3 S4 S5)
[   15.871470] Time: acpi_pm clocksource has been installed.
[   15.871579] Switched to NOHz mode on CPU #1
[   15.871582] Switched to NOHz mode on CPU #0
[   15.875069] input: AT Translated Set 2 keyboard as /class/input/input0
[   16.009205] VFS: Mounted root (jfs filesystem) readonly.
[   16.009432] Freeing unused kernel memory: 212k freed
[   18.431301] usbcore: registered new interface driver usbfs
[   18.431709] usbcore: registered new interface driver hub
[   18.432028] usbcore: registered new device driver usb
[   18.487988] ACPI: PCI Interrupt 0000:00:1d.7[D] -> GSI 23 (level, low) -> IRQ 22
[   18.488154] PCI: Setting latency timer of device 0000:00:1d.7 to 64
[   18.488158] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[   18.488338] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
[   18.488460] ehci_hcd 0000:00:1d.7: debug port 1
[   18.488542] PCI: cache line size of 32 is not supported by device 0000:00:1d.7
[   18.488611] ehci_hcd 0000:00:1d.7: irq 22, io mem 0xde404000
[   18.492564] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[   18.492735] usb usb1: new device found, idVendor=0000, idProduct=0000
[   18.492814] usb usb1: new device strings: Mfr=3, Product=2, SerialNumber=1
[   18.492893] usb usb1: Product: EHCI Host Controller
[   18.492993] usb usb1: Manufacturer: Linux 2.6.20-rc6-mm3-1 ehci_hcd
[   18.493076] usb usb1: SerialNumber: 0000:00:1d.7
[   18.493225] usb usb1: configuration #1 chosen from 1 choice
[   18.493334] hub 1-0:1.0: USB hub found
[   18.493415] hub 1-0:1.0: 8 ports detected
[   18.550196] USB Universal Host Controller Interface driver v3.0
[   18.598964] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 19 (level, low) -> IRQ 19
[   18.599140] PCI: Setting latency timer of device 0000:00:1d.0 to 64
[   18.599144] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[   18.599246] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[   18.599371] uhci_hcd 0000:00:1d.0: irq 19, io base 0x00001800
[   18.599484] usb usb2: new device found, idVendor=0000, idProduct=0000
[   18.599564] usb usb2: new device strings: Mfr=3, Product=2, SerialNumber=1
[   18.599644] usb usb2: Product: UHCI Host Controller
[   18.599723] usb usb2: Manufacturer: Linux 2.6.20-rc6-mm3-1 uhci_hcd
[   18.599812] usb usb2: SerialNumber: 0000:00:1d.0
[   18.599934] usb usb2: configuration #1 chosen from 1 choice
[   18.600034] hub 2-0:1.0: USB hub found
[   18.600115] hub 2-0:1.0: 2 ports detected
[   18.645377] input: PC Speaker as /class/input/input1
[   18.700816] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 19
[   18.700993] PCI: Setting latency timer of device 0000:00:1d.1 to 64
[   18.700997] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[   18.701093] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[   18.701207] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00001820
[   18.701317] usb usb3: new device found, idVendor=0000, idProduct=0000
[   18.701394] usb usb3: new device strings: Mfr=3, Product=2, SerialNumber=1
[   18.701473] usb usb3: Product: UHCI Host Controller
[   18.701549] usb usb3: Manufacturer: Linux 2.6.20-rc6-mm3-1 uhci_hcd
[   18.701627] usb usb3: SerialNumber: 0000:00:1d.1
[   18.701746] usb usb3: configuration #1 chosen from 1 choice
[   18.701842] hub 3-0:1.0: USB hub found
[   18.701919] hub 3-0:1.0: 2 ports detected
[   18.817836] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 19 (level, low) -> IRQ 19
[   18.818011] PCI: Setting latency timer of device 0000:00:1d.2 to 64
[   18.818015] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   18.818109] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[   18.818224] uhci_hcd 0000:00:1d.2: irq 19, io base 0x00001840
[   18.818334] usb usb4: new device found, idVendor=0000, idProduct=0000
[   18.818413] usb usb4: new device strings: Mfr=3, Product=2, SerialNumber=1
[   18.818491] usb usb4: Product: UHCI Host Controller
[   18.818567] usb usb4: Manufacturer: Linux 2.6.20-rc6-mm3-1 uhci_hcd
[   18.818644] usb usb4: SerialNumber: 0000:00:1d.2
[   18.818764] usb usb4: configuration #1 chosen from 1 choice
[   18.818860] hub 4-0:1.0: USB hub found
[   18.818940] hub 4-0:1.0: 2 ports detected
[   18.920594] ACPI: PCI Interrupt 0000:00:1d.3[A] -> GSI 19 (level, low) -> IRQ 19
[   18.920767] PCI: Setting latency timer of device 0000:00:1d.3 to 64
[   18.920771] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[   18.920865] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
[   18.920979] uhci_hcd 0000:00:1d.3: irq 19, io base 0x00001860
[   18.921087] usb usb5: new device found, idVendor=0000, idProduct=0000
[   18.921165] usb usb5: new device strings: Mfr=3, Product=2, SerialNumber=1
[   18.921243] usb usb5: Product: UHCI Host Controller
[   18.921319] usb usb5: Manufacturer: Linux 2.6.20-rc6-mm3-1 uhci_hcd
[   18.921396] usb usb5: SerialNumber: 0000:00:1d.3
[   18.921516] usb usb5: configuration #1 chosen from 1 choice
[   18.921613] hub 5-0:1.0: USB hub found
[   18.921691] hub 5-0:1.0: 2 ports detected
[   18.924138] usb 1-4: new high speed USB device using ehci_hcd and address 2
[   19.204569] input: PS/2 Mouse as /class/input/input2
[   19.217616] input: AlpsPS/2 ALPS GlidePoint as /class/input/input3
[   19.249892] tpm_inf_pnp 00:07: Found TPM with ID IFX0102
[   19.250028] tpm_inf_pnp 00:07: TPM found: config base 0x2e, io base 0x1670, chip version 0x000b, vendor id 0x15d1 (Infineon), product id 0x000b (SLB 9635 TT 1.2)
[   19.274013] Yenta: CardBus bridge found at 0000:09:04.0 [104d:81e6]
[   19.274116] Yenta: Using CSCINT to route CSC interrupts to PCI
[   19.274197] Yenta: Routing CardBus interrupts to PCI
[   19.274277] Yenta TI: socket 0000:09:04.0, mfunc 0x01a21b22, devctl 0x64
[   19.281332] Linux agpgart interface v0.102 (c) Dave Jones
[   19.282803] agpgart: Detected an Intel 945GM Chipset.
[   19.300918] agpgart: AGP aperture is 256M @ 0x0
[   19.301465] Real Time Clock Driver v1.12ac
[   19.355844] usb 1-4: new device found, idVendor=054c, idProduct=0281
[   19.355933] usb 1-4: new device strings: Mfr=1, Product=2, SerialNumber=3
[   19.356018] usb 1-4: Product: UMH-U09
[   19.356097] usb 1-4: Manufacturer: Sony
[   19.356183] usb 1-4: SerialNumber: F000001C9B3A
[   19.356327] usb 1-4: configuration #1 chosen from 1 choice
[   19.386058] hda: ATAPI 24X DVD-ROM DVD-R-RAM CD-R/RW drive, 2048kB Cache, UDMA(33)
[   19.386641] Uniform CD-ROM driver Revision: 3.20
[   19.512694] Yenta: ISA IRQ mask 0x0cf8, PCI irq 20
[   19.512775] Socket status: 30000006
[   19.512850] Yenta: Raising subordinate bus# of parent bus (#09) from #0a to #0d
[   19.512943] pcmcia: parent PCI bridge I/O window: 0x5000 - 0x5fff
[   19.513021] cs: IO port probe 0x5000-0x5fff: clean.
[   19.513421] pcmcia: parent PCI bridge Memory window: 0xde000000 - 0xde0fffff
[   19.513500] pcmcia: parent PCI bridge Memory window: 0x50000000 - 0x53ffffff
[   19.513868] ACPI: PCI Interrupt 0000:07:00.0[A] -> GSI 18 (level, low) -> IRQ 18
[   19.514039] PCI: Setting latency timer of device 0000:07:00.0 to 64
[   19.514098] sky2 v1.10 addr 0xd8000000 irq 18 Yukon-FE (0xb7) rev 1
[   19.514304] sky2 eth0: addr 00:13:a9:41:76:84
[   19.514436] ACPI: PCI Interrupt 0000:09:04.2[C] -> GSI 22 (level, low) -> IRQ 21
[   19.515055] ieee80211_crypt: registered algorithm 'NULL'
[   19.516839] ieee80211: 802.11 data/management/control stack, git-1.1.13
[   19.516924] ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
[   19.733465] Initializing USB Mass Storage driver...
[   19.852213] ipw3945: Intel(R) PRO/Wireless 3945 Network Connection driver for Linux, 1.2.0dmpr
[   19.852308] ipw3945: Copyright(c) 2003-2006 Intel Corporation
[   19.852541] ACPI: PCI Interrupt 0000:06:00.0[A] -> GSI 17 (level, low) -> IRQ 17
[   19.852740] PCI: Setting latency timer of device 0000:06:00.0 to 64
[   19.853087] ipw3945: Detected Intel PRO/Wireless 3945ABG Network Connection
[   19.899161] usb 1-6: new high speed USB device using ehci_hcd and address 4
[   19.958061] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 21 (level, low) -> IRQ 23
[   19.962654] PCI: Setting latency timer of device 0000:00:1b.0 to 64
[   20.039091] usb 1-6: new device found, idVendor=05ca, idProduct=1830
[   20.039179] usb 1-6: new device strings: Mfr=0, Product=0, SerialNumber=0
[   20.039374] usb 1-6: configuration #1 chosen from 1 choice
[   20.078724] cs: IO port probe 0x100-0x3af: clean.
[   20.081112] cs: IO port probe 0x3e0-0x4ff: excluding 0x4d0-0x4d7
[   20.082304] cs: IO port probe 0x820-0x8ff: clean.
[   20.083266] cs: IO port probe 0xc00-0xcf7: clean.
[   20.084346] cs: IO port probe 0xa00-0xaff: clean.
[   20.838620] usb 4-1: new full speed USB device using uhci_hcd and address 2
[   21.017383] usb 4-1: new device found, idVendor=0483, idProduct=2016
[   21.017468] usb 4-1: new device strings: Mfr=1, Product=2, SerialNumber=0
[   21.017552] usb 4-1: Product: Biometric Coprocessor
[   21.017643] usb 4-1: Manufacturer: STMicroelectronics
[   21.017789] usb 4-1: configuration #1 chosen from 1 choice
[   21.386093] usb 5-1: new low speed USB device using uhci_hcd and address 2
[   21.539760] usb 5-1: new device found, idVendor=054c, idProduct=01bb
[   21.539845] usb 5-1: new device strings: Mfr=0, Product=0, SerialNumber=0
[   21.540032] usb 5-1: configuration #1 chosen from 1 choice
[   21.781715] usb 5-2: new full speed USB device using uhci_hcd and address 3
[   21.982357] usb 5-2: new device found, idVendor=044e, idProduct=300c
[   21.982442] usb 5-2: new device strings: Mfr=1, Product=2, SerialNumber=0
[   21.982526] usb 5-2: Product: UGX
[   21.982614] usb 5-2: Manufacturer: ALPS
[   21.982756] usb 5-2: configuration #1 chosen from 1 choice
[   22.036178] scsi2 : SCSI emulation for USB Mass Storage devices
[   22.036303] usb-storage: device found at 2
[   22.036305] usb-storage: waiting for device to settle before scanning
[   22.036333] usbcore: registered new interface driver usb-storage
[   22.036413] USB Mass Storage support registered.
[   22.036651] Bluetooth: Core ver 2.11
[   22.036955] NET: Registered protocol family 31
[   22.037031] Bluetooth: HCI device and connection manager initialized
[   22.037109] Bluetooth: HCI socket layer initialized
[   22.062827] Bluetooth: HCI USB driver ver 2.9
[   22.065919] usbcore: registered new interface driver hci_usb
[   22.536788] Adding 979924k swap on /dev/sda5.  Priority:-1 extents:1 across:979924k
[   23.489142] loop: loaded (max 8 devices)
[   23.536167] ACPI Sony Notebook Control Driver v0.3 successfully installed
[   23.544458] sonypi: Sony Programmable I/O Controller Driver v1.26.
[   23.546117] sonypi: detected type3 model, verbose = 0, fnkeyinit = off, camera = off, compat = off, mask = 0xffffffff, useinput = on, acpi = on
[   23.546216] sonypi: enabled at irq=11, port1=0x1080, port2=0x1084
[   23.546293] sonypi: device allocated minor is 63
[   23.553993] input: Sony Vaio Jogdial as /class/input/input4
[   23.555686] input: Sony Vaio Keys as /class/input/input5
[   23.662494] device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
[   26.591843] ipw3945: Detected geography ABG (13 802.11bg channels, 12 802.11a channels)
[   27.037900] scsi 2:0:0:0: Direct-Access     Sony     USB   HS-CARD    4.52 PQ: 0 ANSI: 0
[   27.087513] sd 2:0:0:0: Attached scsi removable disk sdb
[   27.088639] usb-storage: device scan complete
[   29.304111] sky2 eth0: enabling interface
[   29.306381] sky2 eth0: ram buffer 4K
[   32.401687] ip_tables: (C) 2000-2006 Netfilter Core Team
[   34.259849] NET: Registered protocol family 10
[   34.260039] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   44.611655] eth2: no IPv6 routers present
[   56.974458] Netfilter messages via NETLINK v0.30.
[   56.982635] nf_conntrack version 0.5.0 (8179 buckets, 65432 max)
[   80.371352] SysRq : Show Pending Timers
[   80.371510] Timer List Version: v0.3
[   80.371590] HRTIMER_MAX_CLOCK_BASES: 2
[   80.371678] now at 67306412690 nsecs
[   80.371751] 
[   80.371752] cpu: 0
[   80.371894]  clock 0:
[   80.371966]   .index:      0
[   80.372039]   .resolution: 4000250 nsecs
[   80.372112]   .get_time:   ktime_get_real
[   80.372307] active timers:
[   80.372380]  clock 1:
[   80.372452]   .index:      1
[   80.372525]   .resolution: 4000250 nsecs
[   80.372599]   .get_time:   ktime_get
[   80.372790] active timers:
[   80.372863]   .nohz_mode      : 1
[   80.372937]   .idle_tick      : 67292033750 nsecs
[   80.373012]   .tick_stopped   : 1
[   80.373085]   .idle_jiffies   : 4294909118
[   80.373160]   .idle_calls     : 35728
[   80.373234]   .idle_sleeps    : 5871
[   80.373308]   .idle_entrytime : 67290929947 nsecs
[   80.373384]   .idle_sleeptime : 60614021915 nsecs
[   80.373460]   .last_jiffies   : 4294909118
[   80.373535]   .next_jiffies   : 4294909155
[   80.373609]   .idle_expires   : 67436000000 nsecs
[   80.373684] jiffies: 4294909122
[   80.373758] 
[   80.373758] cpu: 1
[   80.373900]  clock 0:
[   80.373972]   .index:      0
[   80.374045]   .resolution: 4000250 nsecs
[   80.374119]   .get_time:   ktime_get_real
[   80.374310] active timers:
[   80.374383]  clock 1:
[   80.374455]   .index:      1
[   80.374528]   .resolution: 4000250 nsecs
[   80.374602]   .get_time:   ktime_get
[   80.374793] active timers:
[   80.374865]   .nohz_mode      : 1
[   80.374939]   .idle_tick      : 65807941000 nsecs
[   80.375014]   .tick_stopped   : 1
[   80.375088]   .idle_jiffies   : 4294908747
[   80.375162]   .idle_calls     : 1350
[   80.375236]   .idle_sleeps    : 708
[   80.375310]   .idle_entrytime : 65804072320 nsecs
[   80.375386]   .idle_sleeptime : 62278322765 nsecs
[   80.375462]   .last_jiffies   : 4294908747
[   80.375537]   .next_jiffies   : 4294909247
[   80.375611]   .idle_expires   : 67804000000 nsecs
[   80.375687] jiffies: 4294909122
[   80.375760] 
[   80.375831] 
[   80.375831] Tick Device: mode:     1
[   80.375975] Clock Event Device: pit
[   80.376107]  max_delta_ns:   27461866
[   80.376181]  min_delta_ns:   4000250
[   80.376255]  mult:           5124677
[   80.376329]  shift:          32
[   80.376402]  mode:           3
[   80.376475]  next_event:     67436000000 nsecs
[   80.376550]  set_next_event: pit_next_event
[   80.376744]  set_mode:       init_pit_timer
[   80.376936]  event_handler:  tick_handle_oneshot_broadcast
[   80.377131] tick_broadcast_mask: 00000003
[   80.377205] tick_broadcast_oneshot_mask: 00000003
[   80.377281] 
[   80.377352] 
[   80.377352] Tick Device: mode:     1
[   80.377496] Clock Event Device: lapic
[   80.377629]  max_delta_ns:   805300686
[   80.377703]  min_delta_ns:   4000250
[   80.377777]  mult:           44739553
[   80.377851]  shift:          32
[   80.377923]  mode:           1
[   80.377997]  next_event:     67436000000 nsecs
[   80.378071]  set_next_event: lapic_next_event
[   80.378264]  set_mode:       lapic_timer_setup
[   80.378456]  event_handler:  tick_nohz_handler
[   80.378649] 
[   80.378649] Tick Device: mode:     1
[   80.378793] Clock Event Device: lapic
[   80.378926]  max_delta_ns:   805300686
[   80.379000]  min_delta_ns:   4000250
[   80.379073]  mult:           44739553
[   80.379147]  shift:          32
[   80.379221]  mode:           1
[   80.379294]  next_event:     67804000000 nsecs
[   80.379369]  set_next_event: lapic_next_event
[   80.379561]  set_mode:       lapic_timer_setup
[   80.379753]  event_handler:  tick_nohz_handler
[   80.379945] 
[  151.172554] SysRq : Show Pending Timers
[  151.172712] Timer List Version: v0.3
[  151.172792] HRTIMER_MAX_CLOCK_BASES: 2
[  151.172880] now at 138165223812 nsecs
[  151.172954] 
[  151.172954] cpu: 0
[  151.173097]  clock 0:
[  151.173168]   .index:      0
[  151.173241]   .resolution: 4000250 nsecs
[  151.173316]   .get_time:   ktime_get_real
[  151.173510] active timers:
[  151.173583]  clock 1:
[  151.173655]   .index:      1
[  151.173728]   .resolution: 4000250 nsecs
[  151.173802]   .get_time:   ktime_get
[  151.173993] active timers:
[  151.174066]   .nohz_mode      : 1
[  151.174140]   .idle_tick      : 138160462750 nsecs
[  151.174216]   .tick_stopped   : 1
[  151.174289]   .idle_jiffies   : 4294926835
[  151.174364]   .idle_calls     : 58322
[  151.174438]   .idle_sleeps    : 9738
[  151.174512]   .idle_entrytime : 138159968209 nsecs
[  151.174587]   .idle_sleeptime : 131052545358 nsecs
[  151.174663]   .last_jiffies   : 4294926835
[  151.174737]   .next_jiffies   : 4294926856
[  151.174812]   .idle_expires   : 138240000000 nsecs
[  151.174887] jiffies: 4294926837
[  151.174960] 
[  151.174961] cpu: 1
[  151.175102]  clock 0:
[  151.175174]   .index:      0
[  151.175247]   .resolution: 4000250 nsecs
[  151.175321]   .get_time:   ktime_get_real
[  151.175513] active timers:
[  151.175586]  clock 1:
[  151.175658]   .index:      1
[  151.175731]   .resolution: 4000250 nsecs
[  151.175805]   .get_time:   ktime_get
[  151.175996] active timers:
[  151.176069]   .nohz_mode      : 1
[  151.176143]   .idle_tick      : 137804440500 nsecs
[  151.176218]   .tick_stopped   : 1
[  151.176291]   .idle_jiffies   : 4294926747
[  151.176366]   .idle_calls     : 1437
[  151.176440]   .idle_sleeps    : 795
[  151.176514]   .idle_entrytime : 137804068861 nsecs
[  151.176589]   .idle_sleeptime : 134255004466 nsecs
[  151.176665]   .last_jiffies   : 4294926747
[  151.176740]   .next_jiffies   : 4294927247
[  151.180981]   .idle_expires   : 139804000000 nsecs
[  151.181057] jiffies: 4294926837
[  151.181130] 
[  151.181201] 
[  151.181202] Tick Device: mode:     1
[  151.181346] Clock Event Device: pit
[  151.181478]  max_delta_ns:   27461866
[  151.181553]  min_delta_ns:   4000250
[  151.181626]  mult:           5124677
[  151.181700]  shift:          32
[  151.181773]  mode:           3
[  151.181847]  next_event:     138240000000 nsecs
[  151.181921]  set_next_event: pit_next_event
[  151.182114]  set_mode:       init_pit_timer
[  151.182307]  event_handler:  tick_handle_oneshot_broadcast
[  151.182501] tick_broadcast_mask: 00000003
[  151.182576] tick_broadcast_oneshot_mask: 00000003
[  151.182650] 
[  151.182722] 
[  151.182722] Tick Device: mode:     1
[  151.182866] Clock Event Device: lapic
[  151.182998]  max_delta_ns:   805300686
[  151.183073]  min_delta_ns:   4000250
[  151.183147]  mult:           44739553
[  151.183220]  shift:          32
[  151.183293]  mode:           1
[  151.183366]  next_event:     138240000000 nsecs
[  151.183441]  set_next_event: lapic_next_event
[  151.183634]  set_mode:       lapic_timer_setup
[  151.183826]  event_handler:  tick_nohz_handler
[  151.184019] 
[  151.184020] Tick Device: mode:     1
[  151.184163] Clock Event Device: lapic
[  151.184296]  max_delta_ns:   805300686
[  151.184370]  min_delta_ns:   4000250
[  151.184444]  mult:           44739553
[  151.184518]  shift:          32
[  151.184591]  mode:           1
[  151.184664]  next_event:     139804000000 nsecs
[  151.184739]  set_next_event: lapic_next_event
[  151.184931]  set_mode:       lapic_timer_setup
[  151.185124]  event_handler:  tick_nohz_handler
[  151.185316] 
[  164.620705] ACPI: Battery Slot [BAT1] (battery present)
[  164.629377] ACPI: AC Adapter [ACAD] (on-line)
[  164.646695] input: Lid Switch as /class/input/input6
[  164.654108] ACPI: Lid Switch [LID0]
[  164.662080] input: Power Button (CM) as /class/input/input7
[  164.669246] ACPI: Power Button (CM) [PWRB]
[  164.689315] ACPI: Thermal Zone [ATF0] (49 C)
[  164.690545] ACPI: Thermal Zone [DTS0] (50 C)
[  164.691759] ACPI: Thermal Zone [DTS1] (50 C)
[  169.432094] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[  169.523871] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
[  169.524000] NFSD: starting 90-second grace period
[  190.879065] BUG: soft lockup detected on CPU#1!
[  190.879175]  [<c0104dac>] show_trace_log_lvl+0x1a/0x2f
[  190.879339]  [<c010540b>] show_trace+0x12/0x14
[  190.879510]  [<c010548f>] dump_stack+0x16/0x18
[  190.879676]  [<c0146e38>] softlockup_tick+0xa7/0xb6
[  190.879849]  [<c01286c0>] run_local_timers+0x12/0x14
[  190.880022]  [<c0128a61>] update_process_times+0x3e/0x63
[  190.880193]  [<c01374ad>] tick_nohz_handler+0x7d/0xe3
[  190.880367]  [<c01137c2>] smp_apic_timer_interrupt+0x71/0x83
[  190.880539]  [<c01048f4>] apic_timer_interrupt+0x28/0x30
[  190.880710]  [<c0102435>] cpu_idle+0xad/0xd3
[  190.880879]  [<c0112975>] start_secondary+0x32b/0x333
[  190.881052]  [<00000000>] run_init_process+0x3fefed10/0x19
[  190.881224]  =======================
[  193.605480] Bluetooth: L2CAP ver 2.8
[  193.605565] Bluetooth: L2CAP socket layer initialized
[  195.360060] Bluetooth: RFCOMM socket layer initialized
[  195.360146] Bluetooth: RFCOMM TTY layer initialized
[  195.360221] Bluetooth: RFCOMM ver 1.8

-- 
mattia
:wq!
