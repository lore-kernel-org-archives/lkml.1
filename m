Return-Path: <linux-kernel-owner+w=401wt.eu-S1422951AbXBAVMB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422951AbXBAVMB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 16:12:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423009AbXBAVMB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 16:12:01 -0500
Received: from aa014msr.fastwebnet.it ([85.18.95.74]:36791 "EHLO
	aa014msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422951AbXBAVL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 16:11:59 -0500
Date: Thu, 1 Feb 2007 22:11:37 +0100
From: Mattia Dongili <malattia@linux.it>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       mingo@redhat.com
Subject: Re: 2.6.20-rc6-mm3
Message-ID: <20070201211137.GA2830@inferi.kami.home>
Mail-Followup-To: Thomas Gleixner <tglx@linutronix.de>,
	Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
	mingo@redhat.com
References: <20070129204528.eb8d695e.akpm@osdl.org> <20070131215241.GB2890@inferi.kami.home> <20070131232130.GC4137@inferi.kami.home> <1170358572.29240.292.camel@localhost.localdomain> <1170360101.29240.297.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1170360101.29240.297.camel@localhost.localdomain>
X-Message-Flag: Cranky? Try Free Software instead!
X-Operating-System: Linux 2.6.20-rc6-mm3-2 i686
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

dmesg is below. I need to say that the printk times are bogus wrt the
actual time passing and at one point I was sick waiting and killed all
tasks. Ah, I have Ingo's resume-fix patch applied here.

I also played a little with (date; sleep 1; date):
Thu Feb  1 21:56:16 CET 2007
Thu Feb  1 21:56:17 CET 2007

Thu Feb  1 21:57:01 CET 2007
Thu Feb  1 21:57:05 CET 2007

Thu Feb  1 21:57:11 CET 2007
Thu Feb  1 21:57:15 CET 2007

Thu Feb  1 21:57:21 CET 2007
Thu Feb  1 21:57:25 CET 2007

dmesg:

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
[    0.000000] Detected 1833.684 MHz processor.
[   12.860547] Built 1 zonelists.  Total pages: 259700
[   12.860552] Kernel command line: root=/dev/sda3 ro vga=extended resume=/dev/sda5
[   12.860833] mapped APIC to ffffd000 (fee00000)
[   12.860837] mapped IOAPIC to ffffc000 (fec00000)
[   12.860842] Enabling fast FPU save and restore... done.
[   12.860846] Enabling unmasked SIMD FPU exception support... done.
[   12.860855] Initializing CPU#0
[   12.860921] PID hash table entries: 4096 (order: 12, 16384 bytes)
[   12.866401] Console: colour VGA+ 80x50
[   12.872547] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[   12.873043] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[   12.910547] Memory: 1034188k/1046976k available (1864k kernel code, 12244k reserved, 687k data, 212k init, 129472k highmem)
[   12.910661] virtual kernel memory layout:
[   12.910663]     fixmap  : 0xfff9d000 - 0xfffff000   ( 392 kB)
[   12.910665]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[   12.910667]     vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
[   12.910669]     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
[   12.910671]       .init : 0xc0384000 - 0xc03b9000   ( 212 kB)
[   12.910673]       .data : 0xc02d23c1 - 0xc037dff4   ( 687 kB)
[   12.910675]       .text : 0xc0100000 - 0xc02d23c1   (1864 kB)
[   12.911309] Checking if this processor honours the WP bit even in supervisor mode... Ok.
[   12.991557] Calibrating delay using timer specific routine.. 3671.96 BogoMIPS (lpj=7343936)
[   12.991768] Security Framework v1.0.0 initialized
[   12.991854] Capability LSM initialized
[   12.991949] Mount-cache hash table entries: 512
[   12.992156] CPU: After generic identify, caps: bfebfbff 20100000 00000000 00000000 0000e3bd 00000000 00000001
[   12.992168] monitor/mwait feature present.
[   12.992248] using mwait in idle threads.
[   12.992330] CPU: L1 I cache: 32K, L1 D cache: 32K
[   12.992473] CPU: L2 cache: 2048K
[   12.992553] CPU: Physical Processor ID: 0
[   12.992632] CPU: Processor Core ID: 0
[   12.992712] CPU: After all inits, caps: bfebfbff 20100000 00000000 00003940 0000e3bd 00000000 00000001
[   12.992723] Intel machine check architecture supported.
[   12.992807] Intel machine check reporting enabled on CPU#0.
[   12.992892] Compat vDSO mapped to ffffe000.
[   12.992985] Checking 'hlt' instruction... OK.
[   13.007710] SMP alternatives: switching to UP code
[   13.008036] ACPI: Core revision 20070126
[   13.019260] Parsing all Control Methods:
[   13.019649] Table [DSDT](id 0001) - 923 Objects with 104 Devices 193 Methods 29 Regions
[   13.020057] Parsing all Control Methods:
[   13.020357] Table [SSDT](id 0002) - 13 Objects with 3 Devices 4 Methods 0 Regions
[   13.020770] Parsing all Control Methods:
[   13.021069] Table [SSDT](id 0003) - 14 Objects with 3 Devices 5 Methods 0 Regions
[   13.021485] Parsing all Control Methods:
[   13.021786] Table [SSDT](id 0004) - 13 Objects with 0 Devices 4 Methods 0 Regions
[   13.021954]  tbxface-0586 [02] tb_load_namespace     : ACPI Tables successfully acquired
[   13.026221] evxfevnt-0091 [02] enable                : Transition to ACPI mode successful
[   13.026469] CPU0: Intel(R) Core(TM)2 CPU         T5600  @ 1.83GHz stepping 06
[   13.026695] SMP alternatives: switching to SMP code
[   13.026804] Booting processor 1/1 eip 3000
[   13.037543] Initializing CPU#1
[   13.115447] Calibrating delay using timer specific routine.. 3667.23 BogoMIPS (lpj=7334471)
[   13.115456] CPU: After generic identify, caps: bfebfbff 20100000 00000000 00000000 0000e3bd 00000000 00000001
[   13.115465] monitor/mwait feature present.
[   13.115469] CPU: L1 I cache: 32K, L1 D cache: 32K
[   13.115473] CPU: L2 cache: 2048K
[   13.115476] CPU: Physical Processor ID: 0
[   13.115478] CPU: Processor Core ID: 1
[   13.115481] CPU: After all inits, caps: bfebfbff 20100000 00000000 00003940 0000e3bd 00000000 00000001
[   13.115489] Intel machine check architecture supported.
[   13.115495] Intel machine check reporting enabled on CPU#1.
[   13.116151] CPU1: Intel(R) Core(TM)2 CPU         T5600  @ 1.83GHz stepping 06
[   13.117084] Total of 2 processors activated (7339.20 BogoMIPS).
[   13.117372] ENABLING IO-APIC IRQs
[   13.117670] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
[   13.391218] APIC calibration not consistent with PM Timer: 228ms instead of 100ms
[   13.391315] APIC delta adjusted to PM-Timer: 1041737 (2375299)
[   13.499488] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[   13.519636] Brought up 2 CPUs
[   13.680727] migration_cost=41
[   13.681201] NET: Registered protocol family 16
[   13.681406] ACPI: bus type pci registered
[   13.681497] PCI: Using MMCONFIG
[   13.682561] Setting up standard PCI resources
[   13.689516] evgpeblk-0952 [04] ev_create_gpe_block   : GPE 00 to 1F [_GPE] 4 regs on int 0x9
[   13.691115] evgpeblk-1049 [03] ev_initialize_gpe_bloc: Found 8 Wake, Enabled 5 Runtime GPEs in this block
[   13.692639] Completing Region/Field/Buffer/Package initialization:.........................................................................
[   13.700140] Initialized 29/29 Regions 4/4 Fields 29/29 Buffers 11/38 Packages (972 nodes)
[   13.700311] Initializing Device/Processor/Thermal objects by executing _INI methods:...
[   13.702433] Executed 3 _INI methods requiring 2 _STA executions (examined 117 objects)
[   13.702630] ACPI: Interpreter enabled
[   13.702709] ACPI: Using IOAPIC for interrupt routing
[   13.702941] Found System \ [ffffffff]
[   13.703039] Found Processor \_PR_.CPU0 [c1907dd8]
[   13.703120] Found Processor \_PR_.CPU1 [c1907dc4]
[   13.703245] Found Device \_SB_ [c19073c4]
[   13.703349] Found Device \_SB_.LID0 [c190da40]
[   13.703465] Found Device \_SB_.PWRB [c190da04]
[   13.703578] Found Device \_SB_.PCI0 [c190d9a0]
[   13.703700] Found Device \_SB_.PCI0.PDRC [c190d7c0]
[   13.703814] Found Device \_SB_.PCI0.PEGP [c190dfcc]
[   13.703932] Found Device \_SB_.PCI0.GFX0 [c190df90]
[   13.704059] Found Device \_SB_.PCI0.HDEF [c190df68]
[   13.704172] Found Device \_SB_.PCI0.RP01 [c190df04]
[   13.704297] Found Device \_SB_.PCI0.RP01.S1F0 [c190de50]
[   13.704425] Found Device \_SB_.PCI0.RP01.S1F1 [c190ddec]
[   13.704547] Found Device \_SB_.PCI0.RP01.S1F2 [c190dd88]
[   13.704681] Found Device \_SB_.PCI0.RP01.S1F3 [c190dd24]
[   13.704804] Found Device \_SB_.PCI0.RP01.S1F4 [c190dcc0]
[   13.704927] Found Device \_SB_.PCI0.RP01.S1F5 [c190dc5c]
[   13.705052] Found Device \_SB_.PCI0.RP01.S1F6 [c190f748]
[   13.705179] Found Device \_SB_.PCI0.RP01.S1F7 [c190f6e4]
[   13.705297] Found Device \_SB_.PCI0.RP02 [c190f66c]
[   13.705610] Found Device \_SB_.PCI0.RP02.WLAN [c190f5b8]
[   13.705730] Found Device \_SB_.PCI0.RP03 [c190f52c]
[   13.705855] Found Device \_SB_.PCI0.RP03.TLAN [c190f464]
[   13.705969] Found Device \_SB_.PCI0.RP04 [c190f414]
[   13.706094] Found Device \_SB_.PCI0.RP04.DLAN [c190f34c]
[   13.706206] Found Device \_SB_.PCI0.RP04.S4F1 [c190f2e8]
[   13.706323] Found Device \_SB_.PCI0.RP04.S4F2 [c190fc0c]
[   13.706437] Found Device \_SB_.PCI0.RP04.S4F3 [c190fbd0]
[   13.706549] Found Device \_SB_.PCI0.RP04.S4F4 [c190fb94]
[   13.706661] Found Device \_SB_.PCI0.RP04.S4F5 [c190fb58]
[   13.706774] Found Device \_SB_.PCI0.RP04.S4F6 [c190fb1c]
[   13.706887] Found Device \_SB_.PCI0.RP04.S4F7 [c190fae0]
[   13.707010] Found Device \_SB_.PCI0.RP05 [c190faa4]
[   13.707123] Found Device \_SB_.PCI0.RP05.EX2P [c190f9dc]
[   13.707263] Found Device \_SB_.PCI0.RP05.S5F1 [c190f978]
[   13.707373] Found Device \_SB_.PCI0.RP05.S5F2 [c190f93c]
[   13.707483] Found Device \_SB_.PCI0.RP05.S5F3 [c190f900]
[   13.707593] Found Device \_SB_.PCI0.RP05.S5F4 [c190f8c4]
[   13.707707] Found Device \_SB_.PCI0.RP05.S5F5 [c190f888]
[   13.707816] Found Device \_SB_.PCI0.RP05.S5F6 [c190f84c]
[   13.707927] Found Device \_SB_.PCI0.RP05.S5F7 [c190f810]
[   13.708039] Found Device \_SB_.PCI0.RP06 [c190f7d4]
[   13.708167] Found Device \_SB_.PCI0.RP06.S6F0 [c190ffa4]
[   13.708291] Found Device \_SB_.PCI0.RP06.S6F1 [c190ff40]
[   13.708421] Found Device \_SB_.PCI0.RP06.S6F2 [c190fedc]
[   13.708543] Found Device \_SB_.PCI0.RP06.S6F3 [c190fe78]
[   13.708665] Found Device \_SB_.PCI0.RP06.S6F4 [c190fe14]
[   13.708787] Found Device \_SB_.PCI0.RP06.S6F5 [c190fdb0]
[   13.708910] Found Device \_SB_.PCI0.RP06.S6F6 [c190fd4c]
[   13.709032] Found Device \_SB_.PCI0.RP06.S6F7 [c190fce8]
[   13.709168] Found Device \_SB_.PCI0.USB1 [c190fc70]
[   13.709294] Found Device \_SB_.PCI0.USB2 [c1910748]
[   13.709420] Found Device \_SB_.PCI0.USB3 [c19106d0]
[   13.709548] Found Device \_SB_.PCI0.USB4 [c1910658]
[   13.709676] Found Device \_SB_.PCI0.USB7 [c19105e0]
[   13.709790] Found Device \_SB_.PCI0.USB7.HUB7 [c19105b8]
[   13.709908] Found Device \_SB_.PCI0.USB7.HUB7.PRT1 [c1910590]
[   13.710020] Found Device \_SB_.PCI0.USB7.HUB7.PRT2 [c1910568]
[   13.710138] Found Device \_SB_.PCI0.USB7.HUB7.PRT3 [c1910540]
[   13.710251] Found Device \_SB_.PCI0.USB7.HUB7.PRT4 [c1910518]
[   13.710367] Found Device \_SB_.PCI0.USB7.HUB7.PRT5 [c19104f0]
[   13.710480] Found Device \_SB_.PCI0.USB7.HUB7.PRT6 [c19104c8]
[   13.710599] Found Device \_SB_.PCI0.USB7.HUB7.PRT7 [c19104a0]
[   13.710714] Found Device \_SB_.PCI0.USB7.HUB7.PRT8 [c1910478]
[   13.710833] Found Device \_SB_.PCI0.PCIB [c191043c]
[   13.710959] Found Device \_SB_.PCI0.PCIB.SLT0 [c1910414]
[   13.711086] Found Device \_SB_.PCI0.PCIB.LANC [c19103d8]
[   13.711405] Found Device \_SB_.PCI0.PCIB.CRD2 [c191039c]
[   13.711534] Found Device \_SB_.PCI0.PCIB.S294 [c19102c0]
[   13.711647] Found Device \_SB_.PCI0.PCIB.MST2 [c1910bf8]
[   13.711954] Found Device \_SB_.PCI0.PCIB.CRD0 [c1910bd0]
[   13.712076] Found Device \_SB_.PCI0.PCIB.SD94 [c1910af4]
[   13.712193] Found Device \_SB_.PCI0.PCIB.MMST [c1910acc]
[   13.712313] Found Device \_SB_.PCI0.AUD0 [c1910a90]
[   13.712431] Found Device \_SB_.PCI0.MODM [c1910a68]
[   13.712550] Found Device \_SB_.PCI0.LPCB [c1910a40]
[   13.712938] Found Device \_SB_.PCI0.LPCB.LNKA [c19108ec]
[   13.713297] Found Device \_SB_.PCI0.LPCB.LNKB [c191084c]
[   13.713654] Found Device \_SB_.PCI0.LPCB.LNKC [c19107ac]
[   13.714009] Found Device \_SB_.PCI0.LPCB.LNKD [c1910f90]
[   13.714372] Found Device \_SB_.PCI0.LPCB.LNKE [c1910ef0]
[   13.714729] Found Device \_SB_.PCI0.LPCB.LNKF [c1910e50]
[   13.715087] Found Device \_SB_.PCI0.LPCB.LNKG [c1910db0]
[   13.715470] Found Device \_SB_.PCI0.LPCB.LNKH [c1910d10]
[   13.715604] Found Device \_SB_.PCI0.LPCB.EC0_ [c1910c70]
[   13.720373] Found Device \_SB_.PCI0.LPCB.EC0_.BAT1 [c1911a18]
[   13.720665] Found Device \_SB_.PCI0.LPCB.EC0_.ACAD [c1911950]
[   13.720775] Found Device \_SB_.PCI0.LPCB.DMAC [c19118ec]
[   13.720886] Found Device \_SB_.PCI0.LPCB.FWHD [c19118b0]
[   13.721169] Found Device \_SB_.PCI0.LPCB.IPIC [c19117fc]
[   13.721277] Found Device \_SB_.PCI0.LPCB.MATH [c19117c0]
[   13.721386] Found Device \_SB_.PCI0.LPCB.LDRC [c1911784]
[   13.721503] Found Device \_SB_.PCI0.LPCB.RTC_ [c1911f90]
[   13.721612] Found Device \_SB_.PCI0.LPCB.TIMR [c1911f54]
[   13.721945] Found Device \_SB_.PCI0.LPCB.TPM_ [c1911f18]
[   13.726532] Found Device \_SB_.PCI0.LPCB.SPIC [c1911ea0]
[   13.726651] Found Device \_SB_.PCI0.LPCB.SNC_ [c1911dd8]
[   13.726770] Found Device \_SB_.PCI0.LPCB.PS2K [c1913748]
[   13.726886] Found Device \_SB_.PCI0.LPCB.PS2M [c191370c]
[   13.727022] Found Device \_SB_.PCI0.PATA [c19136bc]
[   13.727180] Found Device \_SB_.PCI0.PATA.PRID [c19135a4]
[   13.727296] Found Device \_SB_.PCI0.PATA.PRID.P_D0 [c1913554]
[   13.727409] Found Device \_SB_.PCI0.PATA.PRID.P_D1 [c1913518]
[   13.727562] Found Device \_SB_.PCI0.SATA [c191348c]
[   13.727695] Found Device \_SB_.PCI0.SATA.PRID [c19139dc]
[   13.727809] Found Device \_SB_.PCI0.SATA.PRID.P_D0 [c191398c]
[   13.727922] Found Device \_SB_.PCI0.SATA.PRID.P_D1 [c1913950]
[   13.728039] Found Device \_SB_.PCI0.SATA.SECD [c19138d8]
[   13.728155] Found Device \_SB_.PCI0.SATA.SECD.S_D0 [c1913888]
[   13.728270] Found Device \_SB_.PCI0.SATA.SECD.S_D1 [c1913838]
[   13.728394] Found Device \_SB_.PCI0.SBUS [c1913310]
[   13.730742] Found Thermal Zone \_TZ_ [c190739c]
[   13.730830] Found Thermal Zone \_TZ_.ATF0 [c190d4a0]
[   13.730919] Found Thermal Zone \_TZ_.DTS0 [c190d3ec]
[   13.731002] Found Thermal Zone \_TZ_.DTS1 [c190d34c]
[   13.731623] ACPI: PCI Root Bridge [PCI0] (0000:00)
[   13.732447] PCI quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
[   13.732533] PCI quirk: region 1180-11bf claimed by ICH6 GPIO
[   13.732909] Boot video device is 0000:01:00.0
[   13.734152] PCI: Transparent bridge - 0000:00:1e.0
[   13.734332] PCI: Bus #0a (-#0d) is hidden behind transparent bridge #09 (-#0a) (try 'pci=assign-busses')
[   13.738627] Please report the result to linux-kernel to fix this permanently
[   13.738801] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[   13.739824] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEGP._PRT]
[   13.740273] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[   13.740729] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[   13.741160] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
[   13.741590] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP04._PRT]
[   13.742082] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
[   13.754709] ACPI: PCI Interrupt Link [LNKA] (IRQs 10) *5
[   13.755351] ACPI: PCI Interrupt Link [LNKB] (IRQs *10)
[   13.755921] ACPI: PCI Interrupt Link [LNKC] (IRQs *10)
[   13.756494] ACPI: PCI Interrupt Link [LNKD] (IRQs *10)
[   13.757063] ACPI: PCI Interrupt Link [LNKE] (IRQs 10) *0, disabled.
[   13.757761] ACPI: PCI Interrupt Link [LNKF] (IRQs *10)
[   13.758330] ACPI: PCI Interrupt Link [LNKG] (IRQs *10)
[   13.758900] ACPI: PCI Interrupt Link [LNKH] (IRQs *10)
[   13.759426] Linux Plug and Play Support v0.97 (c) Adam Belay
[   13.759523] pnp: PnP ACPI init
[   13.765452] pnp: PnP ACPI: found 11 devices
[   13.765538] PnPBIOS: Disabled by ACPI PNP
[   13.765816] SCSI subsystem initialized
[   13.765948] libata version 2.00 loaded.
[   13.766043] PCI: Using ACPI for IRQ routing
[   13.766125] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[   13.766405] NET: Registered protocol family 8
[   13.766486] NET: Registered protocol family 20
[   13.766632] pnp: 00:01: iomem range 0xe0000000-0xefffffff could not be reserved
[   13.766730] pnp: 00:01: iomem range 0xfed14000-0xfed17fff could not be reserved
[   13.766826] pnp: 00:01: iomem range 0xfed18000-0xfed18fff could not be reserved
[   13.766923] pnp: 00:01: iomem range 0xfed19000-0xfed19fff could not be reserved
[   13.767477] PCI: Failed to allocate mem resource #6:20000@d0000000 for 0000:01:00.0
[   13.767574] PCI: Bridge: 0000:00:01.0
[   13.767653]   IO window: disabled.
[   13.767734]   MEM window: dc000000-ddffffff
[   13.767815]   PREFETCH window: c0000000-cfffffff
[   13.767897] PCI: Bridge: 0000:00:1c.0
[   13.767978]   IO window: 2000-2fff
[   13.768061]   MEM window: d6000000-d7ffffff
[   13.768145]   PREFETCH window: d0000000-d1ffffff
[   13.768230] PCI: Bridge: 0000:00:1c.1
[   13.768308]   IO window: disabled.
[   13.768392]   MEM window: de100000-de1fffff
[   13.768474]   PREFETCH window: disabled.
[   13.768558] PCI: Bridge: 0000:00:1c.2
[   13.768639]   IO window: 3000-3fff
[   13.768723]   MEM window: d8000000-d9ffffff
[   13.768806]   PREFETCH window: d2000000-d3ffffff
[   13.768890] PCI: Bridge: 0000:00:1c.3
[   13.768970]   IO window: 4000-4fff
[   13.769054]   MEM window: da000000-dbffffff
[   13.769136]   PREFETCH window: d4000000-d5ffffff
[   13.769229] PCI: Bus 10, cardbus bridge: 0000:09:04.0
[   13.769311]   IO window: 00005000-000050ff
[   13.769395]   IO window: 00005400-000054ff
[   13.770145]   PREFETCH window: 50000000-53ffffff
[   13.770230]   MEM window: 54000000-57ffffff
[   13.770313] PCI: Bridge: 0000:00:1e.0
[   13.770395]   IO window: 5000-5fff
[   13.770478]   MEM window: de000000-de0fffff
[   13.770561]   PREFETCH window: 50000000-53ffffff
[   13.770656] ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level, low) -> IRQ 16
[   13.770817] PCI: Setting latency timer of device 0000:00:01.0 to 64
[   13.770840] ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level, low) -> IRQ 16
[   13.771002] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[   13.771028] ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 17 (level, low) -> IRQ 17
[   13.771194] PCI: Setting latency timer of device 0000:00:1c.1 to 64
[   13.771219] ACPI: PCI Interrupt 0000:00:1c.2[C] -> GSI 18 (level, low) -> IRQ 18
[   13.771381] PCI: Setting latency timer of device 0000:00:1c.2 to 64
[   13.771407] ACPI: PCI Interrupt 0000:00:1c.3[D] -> GSI 19 (level, low) -> IRQ 19
[   13.771568] PCI: Setting latency timer of device 0000:00:1c.3 to 64
[   13.771583] PCI: Setting latency timer of device 0000:00:1e.0 to 64
[   13.771613] ACPI: PCI Interrupt 0000:09:04.0[A] -> GSI 20 (level, low) -> IRQ 20
[   13.771810] NET: Registered protocol family 2
[   13.815073] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[   13.815252] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[   13.816032] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[   13.816454] TCP: Hash tables configured (established 131072 bind 65536)
[   13.816538] TCP reno registered
[   13.827346] Simple Boot Flag at 0x37 set to 0x1
[   13.828100] audit: initializing netlink socket (disabled)
[   13.828197] audit(1170362897.500:1): initialized
[   13.828389] highmem bounce pool size: 64 pages
[   13.828657] JFS: nTxBlock = 8080, nTxLock = 64646
[   13.832640] io scheduler noop registered
[   13.832789] io scheduler anticipatory registered
[   13.832932] io scheduler deadline registered
[   13.833091] io scheduler cfq registered (default)
[   13.833680] PCI: Setting latency timer of device 0000:00:01.0 to 64
[   13.833707] assign_interrupt_mode Found MSI capability
[   13.833822] Allocate Port Service[0000:00:01.0:pcie00]
[   13.833882] Allocate Port Service[0000:00:01.0:pcie03]
[   13.833975] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[   13.834035] assign_interrupt_mode Found MSI capability
[   13.834158] Allocate Port Service[0000:00:1c.0:pcie00]
[   13.834210] Allocate Port Service[0000:00:1c.0:pcie02]
[   13.834257] Allocate Port Service[0000:00:1c.0:pcie03]
[   13.834400] PCI: Setting latency timer of device 0000:00:1c.1 to 64
[   13.834459] assign_interrupt_mode Found MSI capability
[   13.834582] Allocate Port Service[0000:00:1c.1:pcie00]
[   13.834637] Allocate Port Service[0000:00:1c.1:pcie02]
[   13.834685] Allocate Port Service[0000:00:1c.1:pcie03]
[   13.834825] PCI: Setting latency timer of device 0000:00:1c.2 to 64
[   13.834885] assign_interrupt_mode Found MSI capability
[   13.835007] Allocate Port Service[0000:00:1c.2:pcie00]
[   13.835061] Allocate Port Service[0000:00:1c.2:pcie02]
[   13.835109] Allocate Port Service[0000:00:1c.2:pcie03]
[   13.835253] PCI: Setting latency timer of device 0000:00:1c.3 to 64
[   13.835312] assign_interrupt_mode Found MSI capability
[   13.835444] Allocate Port Service[0000:00:1c.3:pcie00]
[   13.835498] Allocate Port Service[0000:00:1c.3:pcie02]
[   13.835544] Allocate Port Service[0000:00:1c.3:pcie03]
[   13.836956] ACPI: SSDT @ 0x3fe76cb5/0x01A8 (v001   Sony       N0 0x20060710 PTL  0x20050624)
[   13.837296] Parsing all Control Methods:
[   13.837698] Table [SSDT](id 0075) - 5 Objects with 0 Devices 3 Methods 0 Regions
[   13.838228] ACPI: SSDT @ 0x3fe76a19/0x0217 (v001   Sony       N0 0x20060710 PTL  0x20050624)
[   13.838497] Parsing all Control Methods:
[   13.838890] Table [SSDT](id 0076) - 1 Objects with 0 Devices 1 Methods 0 Regions
[   13.840519] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[   13.840857] ACPI: Processor [CPU0] (supports 8 throttling states)
[   13.842100] ACPI: SSDT @ 0x3fe76e5d/0x0089 (v001   Sony       N0 0x20060710 PTL  0x20050624)
[   13.842400] Parsing all Control Methods:
[   13.842796] Table [SSDT](id 007B) - 3 Objects with 0 Devices 3 Methods 0 Regions
[   13.843323] ACPI: SSDT @ 0x3fe76c30/0x0085 (v001   Sony       N0 0x20060710 PTL  0x20050624)
[   13.843593] Parsing all Control Methods:
[   13.843986] Table [SSDT](id 007C) - 1 Objects with 0 Devices 1 Methods 0 Regions
[   13.845266] ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
[   13.845602] ACPI: Processor [CPU1] (supports 8 throttling states)
[   13.851205] isapnp: Scanning for PnP cards...
[   14.205898] isapnp: No Plug & Play device found
[   14.212395] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
[   14.214908] RAMDISK driver initialized: 16 RAM disks of 8192K size 1024 blocksize
[   14.215158] Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
[   14.215244] ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
[   14.215381] ICH7: IDE controller at PCI slot 0000:00:1f.1
[   14.215476] ACPI: PCI Interrupt 0000:00:1f.1[B] -> GSI 22 (level, low) -> IRQ 21
[   14.215640] ICH7: chipset revision 2
[   14.215719] ICH7: not 100% native mode: will probe irqs later
[   14.215810]     ide0: BM-DMA at 0x1880-0x1887, BIOS settings: hda:DMA, hdb:pio
[   14.216042] Probing IDE interface ide0...
[   14.247273] hda: MATSHITADVD-RAM UJ-842S, ATAPI CD/DVD-ROM drive
[   14.257478] hda: selected mode 0x42
[   14.257838] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[   14.259143] ata_piix 0000:00:1f.2: version 2.00ac7
[   14.259152] ata_piix 0000:00:1f.2: MAP [ P0 P2 XX XX ]
[   14.259546] ata_piix 0000:00:1f.2: invalid MAP value 0
[   14.268138] ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 22 (level, low) -> IRQ 21
[   14.268319] PCI: Setting latency timer of device 0000:00:1f.2 to 64
[   14.268399] ata1: SATA max UDMA/133 cmd 0x18C8 ctl 0x18AE bmdma 0x18B0 irq 21
[   14.268517] ata2: SATA max UDMA/133 cmd 0x18C0 ctl 0x18AA bmdma 0x18B8 irq 21
[   14.268617] scsi0 : ata_piix
[   14.291044] ata1.00: ATA-6, max UDMA/100, 195371568 sectors: LBA48 NCQ (depth 0/32)
[   14.291144] ata1.00: ata1: dev 0 multi count 16
[   14.308400] ata1.00: configured for UDMA/100
[   14.308493] scsi1 : ata_piix
[   14.324766] ATA: abnormal status 0x7F on port 0x18C7
[   14.325004] scsi 0:0:0:0: Direct-Access     ATA      TOSHIBA MK1032GS AS02 PQ: 0 ANSI: 5
[   14.325349] SCSI device sda: 195371568 512-byte hdwr sectors (100030 MB)
[   14.325446] sda: Write Protect is off
[   14.325526] sda: Mode Sense: 00 3a 00 00
[   14.325552] SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   14.325707] SCSI device sda: 195371568 512-byte hdwr sectors (100030 MB)
[   14.325803] sda: Write Protect is off
[   14.330056] sda: Mode Sense: 00 3a 00 00
[   14.330082] SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   14.330180]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 >
[   14.413802] sd 0:0:0:0: Attached scsi disk sda
[   14.414191] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[   14.416962] serio: i8042 KBD port at 0x60,0x64 irq 1
[   14.417047] serio: i8042 AUX port at 0x60,0x64 irq 12
[   14.417257] mice: PS/2 mouse device common for all mice
[   14.447550] TCP bic registered
[   14.447651] NET: Registered protocol family 1
[   14.447735] NET: Registered protocol family 17
[   14.447954] Starting balanced_irq
[   14.448041] Using IPI No-Shortcut mode
[   14.448611] ACPI: (supports S0 S3 S4 S5)
[   14.449145] Time: acpi_pm clocksource has been installed.
[   14.449254] Switched to NOHz mode on CPU #1
[   14.449258] Switched to NOHz mode on CPU #0
[   14.454580] input: AT Translated Set 2 keyboard as /class/input/input0
[   14.551764] VFS: Mounted root (jfs filesystem) readonly.
[   14.551963] Freeing unused kernel memory: 212k freed
[   16.949719] usbcore: registered new interface driver usbfs
[   16.949847] usbcore: registered new interface driver hub
[   16.950005] usbcore: registered new device driver usb
[   17.025582] USB Universal Host Controller Interface driver v3.0
[   17.025734] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 19 (level, low) -> IRQ 19
[   17.025907] PCI: Setting latency timer of device 0000:00:1d.0 to 64
[   17.025913] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[   17.026136] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
[   17.026270] uhci_hcd 0000:00:1d.0: irq 19, io base 0x00001800
[   17.026410] usb usb1: new device found, idVendor=0000, idProduct=0000
[   17.026496] usb usb1: new device strings: Mfr=3, Product=2, SerialNumber=1
[   17.026582] usb usb1: Product: UHCI Host Controller
[   17.026665] usb usb1: Manufacturer: Linux 2.6.20-rc6-mm3-1 uhci_hcd
[   17.026752] usb usb1: SerialNumber: 0000:00:1d.0
[   17.026934] usb usb1: configuration #1 chosen from 1 choice
[   17.027052] hub 1-0:1.0: USB hub found
[   17.027138] hub 1-0:1.0: 2 ports detected
[   17.133199] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 19
[   17.133376] PCI: Setting latency timer of device 0000:00:1d.1 to 64
[   17.133382] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[   17.133499] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
[   17.133632] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00001820
[   17.133774] usb usb2: new device found, idVendor=0000, idProduct=0000
[   17.133861] usb usb2: new device strings: Mfr=3, Product=2, SerialNumber=1
[   17.133949] usb usb2: Product: UHCI Host Controller
[   17.134035] usb usb2: Manufacturer: Linux 2.6.20-rc6-mm3-1 uhci_hcd
[   17.134120] usb usb2: SerialNumber: 0000:00:1d.1
[   17.134309] usb usb2: configuration #1 chosen from 1 choice
[   17.134439] hub 2-0:1.0: USB hub found
[   17.134528] hub 2-0:1.0: 2 ports detected
[   17.169098] input: PS/2 Mouse as /class/input/input1
[   17.182324] Clocksource tsc unstable (delta = -244624983 ns)
[   17.182432] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 19 (level, low) -> IRQ 19
[   17.182640] PCI: Setting latency timer of device 0000:00:1d.2 to 64
[   17.182646] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   17.182757] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 3
[   17.182885] uhci_hcd 0000:00:1d.2: irq 19, io base 0x00001840
[   17.183021] usb usb3: new device found, idVendor=0000, idProduct=0000
[   17.183109] usb usb3: new device strings: Mfr=3, Product=2, SerialNumber=1
[   17.183192] usb usb3: Product: UHCI Host Controller
[   17.183278] usb usb3: Manufacturer: Linux 2.6.20-rc6-mm3-1 uhci_hcd
[   17.183363] usb usb3: SerialNumber: 0000:00:1d.2
[   17.183524] usb usb3: configuration #1 chosen from 1 choice
[   17.183642] hub 3-0:1.0: USB hub found
[   17.183729] hub 3-0:1.0: 2 ports detected
[   17.184537] input: AlpsPS/2 ALPS GlidePoint as /class/input/input2
[   17.201923] input: PC Speaker as /class/input/input3
[   17.351947] ACPI: PCI Interrupt 0000:00:1d.3[A] -> GSI 19 (level, low) -> IRQ 19
[   17.352123] PCI: Setting latency timer of device 0000:00:1d.3 to 64
[   17.352129] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[   17.352292] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 4
[   17.352420] uhci_hcd 0000:00:1d.3: irq 19, io base 0x00001860
[   17.352558] usb usb4: new device found, idVendor=0000, idProduct=0000
[   17.352643] usb usb4: new device strings: Mfr=3, Product=2, SerialNumber=1
[   17.352728] usb usb4: Product: UHCI Host Controller
[   17.352810] usb usb4: Manufacturer: Linux 2.6.20-rc6-mm3-1 uhci_hcd
[   17.352893] usb usb4: SerialNumber: 0000:00:1d.3
[   17.353055] usb usb4: configuration #1 chosen from 1 choice
[   17.353174] hub 4-0:1.0: USB hub found
[   17.353261] hub 4-0:1.0: 2 ports detected
[   17.365615] Linux agpgart interface v0.102 (c) Dave Jones
[   17.421624] usb 2-2: new full speed USB device using uhci_hcd and address 2
[   17.625824] agpgart: Detected an Intel 945GM Chipset.
[   17.646833] agpgart: AGP aperture is 256M @ 0x0
[   17.678432] usb 2-2: new device found, idVendor=054c, idProduct=0281
[   17.678521] usb 2-2: new device strings: Mfr=1, Product=2, SerialNumber=3
[   17.678606] usb 2-2: Product: UMH-U09
[   17.678685] usb 2-2: Manufacturer: Sony
[   17.678765] usb 2-2: SerialNumber: F000001C9B3A
[   17.678951] usb 2-2: configuration #1 chosen from 1 choice
[   17.701690] ACPI: PCI Interrupt 0000:07:00.0[A] -> GSI 18 (level, low) -> IRQ 18
[   17.701874] PCI: Setting latency timer of device 0000:07:00.0 to 64
[   17.701936] sky2 v1.10 addr 0xd8000000 irq 18 Yukon-FE (0xb7) rev 1
[   17.702173] sky2 eth0: addr 00:13:a9:41:76:84
[   17.707673] ACPI: PCI Interrupt 0000:09:04.2[C] -> GSI 22 (level, low) -> IRQ 21
[   17.729071] Yenta: CardBus bridge found at 0000:09:04.0 [104d:81e6]
[   17.729181] Yenta: Using CSCINT to route CSC interrupts to PCI
[   17.729263] Yenta: Routing CardBus interrupts to PCI
[   17.729349] Yenta TI: socket 0000:09:04.0, mfunc 0x01a21b22, devctl 0x64
[   17.738441] Real Time Clock Driver v1.12ac
[   17.798450] ACPI: PCI Interrupt 0000:00:1d.7[D] -> GSI 23 (level, low) -> IRQ 22
[   17.798629] PCI: Setting latency timer of device 0000:00:1d.7 to 64
[   17.798635] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[   17.798751] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 5
[   17.798884] ehci_hcd 0000:00:1d.7: debug port 1
[   17.798970] PCI: cache line size of 32 is not supported by device 0000:00:1d.7
[   17.798985] ehci_hcd 0000:00:1d.7: irq 22, io mem 0xde404000
[   17.802953] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[   17.803072] usb usb5: new device found, idVendor=0000, idProduct=0000
[   17.803156] usb usb5: new device strings: Mfr=3, Product=2, SerialNumber=1
[   17.803240] usb usb5: Product: EHCI Host Controller
[   17.803321] usb usb5: Manufacturer: Linux 2.6.20-rc6-mm3-1 ehci_hcd
[   17.803403] usb usb5: SerialNumber: 0000:00:1d.7
[   17.803578] usb usb5: configuration #1 chosen from 1 choice
[   17.803706] hub 5-0:1.0: USB hub found
[   17.803792] hub 5-0:1.0: 8 ports detected
[   17.852077] tpm_inf_pnp 00:07: Found TPM with ID IFX0102
[   17.852233] tpm_inf_pnp 00:07: TPM found: config base 0x2e, io base 0x1670, chip version 0x000b, vendor id 0x15d1 (Infineon), product id 0x000b (SLB 9635 TT 1.2)
[   17.886026] hda: ATAPI 24X DVD-ROM DVD-R-RAM CD-R/RW drive, 2048kB Cache, UDMA(33)
[   17.886635] Uniform CD-ROM driver Revision: 3.20
[   17.937681] Initializing USB Mass Storage driver...
[   17.950206] Yenta: ISA IRQ mask 0x0cf8, PCI irq 20
[   17.950292] Socket status: 30000006
[   17.950373] Yenta: Raising subordinate bus# of parent bus (#09) from #0a to #0d
[   17.950473] pcmcia: parent PCI bridge I/O window: 0x5000 - 0x5fff
[   17.950558] cs: IO port probe 0x5000-0x5fff: clean.
[   17.951186] pcmcia: parent PCI bridge Memory window: 0xde000000 - 0xde0fffff
[   17.951271] pcmcia: parent PCI bridge Memory window: 0x50000000 - 0x53ffffff
[   18.146142] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 21 (level, low) -> IRQ 23
[   18.146330] PCI: Setting latency timer of device 0000:00:1b.0 to 64
[   18.226954] scsi2 : SCSI emulation for USB Mass Storage devices
[   18.227112] usb-storage: device found at 2
[   18.227115] usb-storage: waiting for device to settle before scanning
[   18.265723] cs: IO port probe 0x100-0x3af: clean.
[   18.268345] cs: IO port probe 0x3e0-0x4ff: excluding 0x4d0-0x4d7
[   18.269811] cs: IO port probe 0x820-0x8ff: clean.
[   18.270818] cs: IO port probe 0xc00-0xcf7: clean.
[   18.272086] cs: IO port probe 0xa00-0xaff: clean.
[   18.335076] usb 5-4: new high speed USB device using ehci_hcd and address 2
[   18.465179] usb 5-4: new device found, idVendor=054c, idProduct=0281
[   18.469499] usb 5-4: new device strings: Mfr=1, Product=2, SerialNumber=3
[   18.469633] usb 5-4: Product: UMH-U09
[   18.469713] usb 5-4: Manufacturer: Sony
[   18.469792] usb 5-4: SerialNumber: F000001C9B3A
[   18.469990] usb 5-4: configuration #1 chosen from 1 choice
[   18.509769] usb 5-6: new high speed USB device using ehci_hcd and address 4
[   18.549637] usb 5-6: new device found, idVendor=05ca, idProduct=1830
[   18.549724] usb 5-6: new device strings: Mfr=0, Product=0, SerialNumber=0
[   18.549919] usb 5-6: configuration #1 chosen from 1 choice
[   18.599659] usb 2-2: USB disconnect, address 2
[   18.599752] scsi3 : SCSI emulation for USB Mass Storage devices
[   18.599965] usbcore: registered new interface driver usb-storage
[   18.600054] USB Mass Storage support registered.
[   18.600587] usb-storage: device found at 2
[   18.600590] usb-storage: waiting for device to settle before scanning
[   18.709644] usb 4-1: new low speed USB device using uhci_hcd and address 2
[   18.715800] usb 4-1: new device found, idVendor=054c, idProduct=01bb
[   18.715887] usb 4-1: new device strings: Mfr=0, Product=0, SerialNumber=0
[   18.716080] usb 4-1: configuration #1 chosen from 1 choice
[   18.956557] usb 4-2: new full speed USB device using uhci_hcd and address 3
[   18.981016] usb 4-2: new device found, idVendor=044e, idProduct=300c
[   18.981105] usb 4-2: new device strings: Mfr=1, Product=2, SerialNumber=0
[   18.981189] usb 4-2: Product: UGX
[   18.981268] usb 4-2: Manufacturer: ALPS
[   18.981463] usb 4-2: configuration #1 chosen from 1 choice
[   19.056548] Bluetooth: Core ver 2.11
[   19.056693] NET: Registered protocol family 31
[   19.056775] Bluetooth: HCI device and connection manager initialized
[   19.056862] Bluetooth: HCI socket layer initialized
[   19.079288] Adding 979924k swap on /dev/sda5.  Priority:-1 extents:1 across:979924k
[   19.093130] Bluetooth: HCI USB driver ver 2.9
[   19.220257] usb 3-1: new full speed USB device using uhci_hcd and address 2
[   19.391588] usb 3-1: new device found, idVendor=0483, idProduct=2016
[   19.391676] usb 3-1: new device strings: Mfr=1, Product=2, SerialNumber=0
[   19.391761] usb 3-1: Product: Biometric Coprocessor
[   19.391842] usb 3-1: Manufacturer: STMicroelectronics
[   19.392043] usb 3-1: configuration #1 chosen from 1 choice
[   19.396691] usbcore: registered new interface driver hci_usb
[   20.184587] loop: loaded (max 8 devices)
[   20.252540] ACPI Sony Notebook Control Driver v0.3 successfully installed
[   20.265908] sonypi: Sony Programmable I/O Controller Driver v1.26.
[   20.266119] sonypi: detected type3 model, verbose = 0, fnkeyinit = off, camera = off, compat = off, mask = 0xffffffff, useinput = on, acpi = on
[   20.266225] sonypi: enabled at irq=11, port1=0x1080, port2=0x1084
[   20.266310] sonypi: device allocated minor is 63
[   20.266456] input: Sony Vaio Jogdial as /class/input/input4
[   20.266639] input: Sony Vaio Keys as /class/input/input5
[   20.397172] device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
[   20.885170] scsi 3:0:0:0: Direct-Access     Sony     USB   HS-CARD    4.52 PQ: 0 ANSI: 0
[   20.935927] sd 3:0:0:0: Attached scsi removable disk sdb
[   20.937884] usb-storage: device scan complete
[   22.644599] SysRq : Show Pending Timers
[   22.644753] Timer List Version: v0.3
[   22.644833] HRTIMER_MAX_CLOCK_BASES: 2
[   22.644913] now at 21927904003 nsecs
[   22.644992] 
[   22.644993] cpu: 0
[   22.645144]  clock 0:
[   22.645221]   .index:      0
[   22.645300]   .resolution: 4000250 nsecs
[   22.645378]   .get_time:   ktime_get_real
[   22.645587] active timers:
[   22.645665]  clock 1:
[   22.645742]   .index:      1
[   22.645821]   .resolution: 4000250 nsecs
[   22.645900]   .get_time:   ktime_get
[   22.646105] active timers:
[   22.646183]   .nohz_mode      : 1
[   22.646263]   .idle_tick      : 21909194500 nsecs
[   22.646343]   .tick_stopped   : 1
[   22.646422]   .idle_jiffies   : 4294897772
[   22.646502]   .idle_calls     : 5623
[   22.646581]   .idle_sleeps    : 2067
[   22.646661]   .idle_entrytime : 21924531594 nsecs
[   22.646742]   .idle_sleeptime : 16263844796 nsecs
[   22.646823]   .last_jiffies   : 4294897777
[   22.646903]   .next_jiffies   : 4294897996
[   22.646984]   .idle_expires   : 22800000000 nsecs
[   22.647065] jiffies: 4294897777
[   22.647143] 
[   22.647144] cpu: 1
[   22.647294]  clock 0:
[   22.647371]   .index:      0
[   22.647449]   .resolution: 4000250 nsecs
[   22.647529]   .get_time:   ktime_get_real
[   22.647735] active timers:
[   22.647813]  clock 1:
[   22.647890]   .index:      1
[   22.647968]   .resolution: 4000250 nsecs
[   22.648047]   .get_time:   ktime_get
[   22.648252] active timers:
[   22.648330]  #0: <c037fd9c>, hrtimer_wakeup, S:01
[   22.648738]  # expires at 16066999784 nsecs [in -5860904219 nsecs]
[   22.648821]  #1: <c037fd9c>, hrtimer_wakeup, S:01
[   22.649218]  # expires at 16325154918 nsecs [in -5602749085 nsecs]
[   22.649301]   .nohz_mode      : 1
[   22.649380]   .idle_tick      : 15324783000 nsecs
[   22.649461]   .tick_stopped   : 1
[   22.649540]   .idle_jiffies   : 4294896127
[   22.649619]   .idle_calls     : 2080
[   22.649698]   .idle_sleeps    : 363
[   22.649778]   .idle_entrytime : 15325159667 nsecs
[   22.649858]   .idle_sleeptime : 10015150422 nsecs
[   22.649940]   .last_jiffies   : 4294896127
[   22.650020]   .next_jiffies   : 4294896189
[   22.650100]   .idle_expires   : 15572000000 nsecs
[   22.650181] jiffies: 4294897777
[   22.650259] 
[   22.650335] 
[   22.650336] Tick Device: mode:     1
[   22.650488] Clock Event Device: pit
[   22.650630]  max_delta_ns:   27461866
[   22.650710]  min_delta_ns:   4000250
[   22.650789]  mult:           5124677
[   22.650868]  shift:          32
[   22.655112]  mode:           3
[   22.655191]  next_event:     21940398000 nsecs
[   22.655271]  set_next_event: pit_next_event
[   22.655478]  set_mode:       init_pit_timer
[   22.655685]  event_handler:  tick_handle_oneshot_broadcast
[   22.655894] tick_broadcast_mask: 00000003
[   22.655974] tick_broadcast_oneshot_mask: 00000003
[   22.656054] 
[   22.656130] 
[   22.656131] Tick Device: mode:     1
[   22.656284] Clock Event Device: lapic
[   22.656427]  max_delta_ns:   805302234
[   22.656506]  min_delta_ns:   4000250
[   22.656585]  mult:           44739467
[   22.656664]  shift:          32
[   22.656742]  mode:           1
[   22.656821]  next_event:     22800000000 nsecs
[   22.656900]  set_next_event: lapic_next_event
[   22.657108]  set_mode:       lapic_timer_setup
[   22.657313]  event_handler:  tick_nohz_handler
[   22.657520] 
[   22.657521] Tick Device: mode:     1
[   22.657675] Clock Event Device: lapic
[   22.657817]  max_delta_ns:   805302234
[   22.657896]  min_delta_ns:   4000250
[   22.657975]  mult:           44739467
[   22.658054]  shift:          32
[   22.658132]  mode:           1
[   22.658211]  next_event:     21940398000 nsecs
[   22.658290]  set_next_event: lapic_next_event
[   22.658498]  set_mode:       lapic_timer_setup
[   22.658704]  event_handler:  tick_nohz_handler
[   22.658911] 
[   24.960910] sky2 eth0: enabling interface
[   24.963185] sky2 eth0: ram buffer 4K
[   25.631447] SysRq : HELP : loglevel0-8 reBoot Crashdump tErm Full kIll saK showMem Nice powerOff showPc show-all-timers(Q) unRaw Sync showTasks Unmount shoW-blocked-tasks 
[   25.658195] SysRq : HELP : loglevel0-8 reBoot Crashdump tErm Full kIll saK showMem Nice powerOff showPc show-all-timers(Q) unRaw Sync showTasks Unmount shoW-blocked-tasks 
[   28.109737] ip_tables: (C) 2000-2006 Netfilter Core Team
[   28.254608] SysRq : Show Pending Timers
[   28.254763] Timer List Version: v0.3
[   28.254843] HRTIMER_MAX_CLOCK_BASES: 2
[   28.254923] now at 84748407269 nsecs
[   28.255002] 
[   28.255003] cpu: 0
[   28.255153]  clock 0:
[   28.255230]   .index:      0
[   28.255308]   .resolution: 4000250 nsecs
[   28.255387]   .get_time:   ktime_get_real
[   28.255596] active timers:
[   28.255673]  clock 1:
[   28.255751]   .index:      1
[   28.255829]   .resolution: 4000250 nsecs
[   28.255908]   .get_time:   ktime_get
[   28.256113] active timers:
[   28.256191]   .nohz_mode      : 1
[   28.256271]   .idle_tick      : 84745121500 nsecs
[   28.256351]   .tick_stopped   : 1
[   28.256430]   .idle_jiffies   : 4294913481
[   28.256510]   .idle_calls     : 18743
[   28.256590]   .idle_sleeps    : 7028
[   28.256669]   .idle_entrytime : 84743152948 nsecs
[   28.256750]   .idle_sleeptime : 78231207829 nsecs
[   28.256831]   .last_jiffies   : 4294913481
[   28.256911]   .next_jiffies   : 4294913568
[   28.256991]   .idle_expires   : 85088000000 nsecs
[   28.257072] jiffies: 4294913483
[   28.257150] 
[   28.257151] cpu: 1
[   28.257302]  clock 0:
[   28.257380]   .index:      0
[   28.257459]   .resolution: 4000250 nsecs
[   28.257538]   .get_time:   ktime_get_real
[   28.257744] active timers:
[   28.257822]  clock 1:
[   28.257899]   .index:      1
[   28.257977]   .resolution: 4000250 nsecs
[   28.258057]   .get_time:   ktime_get
[   28.258262] active timers:
[   28.258340]   .nohz_mode      : 1
[   28.258419]   .idle_tick      : 82853003250 nsecs
[   28.258500]   .tick_stopped   : 1
[   28.258579]   .idle_jiffies   : 4294913009
[   28.258659]   .idle_calls     : 2225
[   28.258738]   .idle_sleeps    : 502
[   28.258817]   .idle_entrytime : 82852308274 nsecs
[   28.258898]   .idle_sleeptime : 64942227277 nsecs
[   28.258979]   .last_jiffies   : 4294913009
[   28.259059]   .next_jiffies   : 4294913072
[   28.259139]   .idle_expires   : 83104000000 nsecs
[   28.259220] jiffies: 4294913483
[   28.259298] 
[   28.259374] 
[   28.259375] Tick Device: mode:     1
[   28.259528] Clock Event Device: pit
[   28.259670]  max_delta_ns:   27461866
[   28.259750]  min_delta_ns:   4000250
[   28.259829]  mult:           5124677
[   28.259907]  shift:          32
[   28.259985]  mode:           3
[   28.260064]  next_event:     84752103000 nsecs
[   28.260144]  set_next_event: pit_next_event
[   28.260352]  set_mode:       init_pit_timer
[   28.260558]  event_handler:  tick_handle_oneshot_broadcast
[   28.260768] tick_broadcast_mask: 00000003
[   28.260847] tick_broadcast_oneshot_mask: 00000003
[   28.260927] 
[   28.261004] 
[   28.261005] Tick Device: mode:     1
[   28.261158] Clock Event Device: lapic
[   28.261300]  max_delta_ns:   805302234
[   28.261380]  min_delta_ns:   4000250
[   28.261459]  mult:           44739467
[   28.261538]  shift:          32
[   28.261616]  mode:           1
[   28.261695]  next_event:     85088000000 nsecs
[   28.261775]  set_next_event: lapic_next_event
[   28.261982]  set_mode:       lapic_timer_setup
[   28.262188]  event_handler:  tick_nohz_handler
[   28.262396] 
[   28.262397] Tick Device: mode:     1
[   28.262549] Clock Event Device: lapic
[   28.262692]  max_delta_ns:   805302234
[   28.262771]  min_delta_ns:   4000250
[   28.262850]  mult:           44739467
[   28.262929]  shift:          32
[   28.263007]  mode:           1
[   28.263086]  next_event:     84752103000 nsecs
[   28.263166]  set_next_event: lapic_next_event
[   28.263372]  set_mode:       lapic_timer_setup
[   28.263580]  event_handler:  tick_nohz_handler
[   28.263786] 
[   29.909054] NET: Registered protocol family 10
[   29.909350] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   31.186106] SysRq : HELP : loglevel0-8 reBoot Crashdump tErm Full kIll saK showMem Nice powerOff showPc show-all-timers(Q) unRaw Sync showTasks Unmount shoW-blocked-tasks 
[   32.590766] Netfilter messages via NETLINK v0.30.
[   32.600430] nf_conntrack version 0.5.0 (8179 buckets, 65432 max)
[   33.941705] SysRq : Kill All Tasks
[   34.586457] BUG: soft lockup detected on CPU#1!
[   34.586544]  [<c0104dac>] show_trace_log_lvl+0x1a/0x2f
[   34.586694]  [<c010540b>] show_trace+0x12/0x14
[   34.586839]  [<c010548f>] dump_stack+0x16/0x18
[   34.586984]  [<c0146e38>] softlockup_tick+0xa7/0xb6
[   34.587131]  [<c01286c0>] run_local_timers+0x12/0x14
[   34.587279]  [<c0128a61>] update_process_times+0x3e/0x63
[   34.587426]  [<c01374ad>] tick_nohz_handler+0x7d/0xe3
[   34.587574]  [<c01137c2>] smp_apic_timer_interrupt+0x71/0x83
[   34.587722]  [<c01048f4>] apic_timer_interrupt+0x28/0x30
[   34.587868]  =======================
[   43.170040] can't load conntrack support for proto=2
[   64.504432] ieee80211_crypt: registered algorithm 'NULL'
[   64.506781] ieee80211: 802.11 data/management/control stack, git-1.1.13
[   64.506870] ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
[   64.518715] ipw3945: Intel(R) PRO/Wireless 3945 Network Connection driver for Linux, 1.2.0dmpr
[   64.518831] ipw3945: Copyright(c) 2003-2006 Intel Corporation
[   64.519096] ACPI: PCI Interrupt 0000:06:00.0[A] -> GSI 17 (level, low) -> IRQ 17
[   64.519309] PCI: Setting latency timer of device 0000:06:00.0 to 64
[   64.519534] ipw3945: Detected Intel PRO/Wireless 3945ABG Network Connection
[   66.818471] BUG: soft lockup detected on CPU#1!
[   66.818476]  [<c0104dac>] show_trace_log_lvl+0x1a/0x2f
[   66.818485]  [<c010540b>] show_trace+0x12/0x14
[   66.818491]  [<c010548f>] dump_stack+0x16/0x18
[   66.818496]  [<c0146e38>] softlockup_tick+0xa7/0xb6
[   66.818503]  [<c01286c0>] run_local_timers+0x12/0x14
[   66.818510]  [<c0128a61>] update_process_times+0x3e/0x63
[   66.818516]  [<c01374ad>] tick_nohz_handler+0x7d/0xe3
[   66.818522]  [<c01137c2>] smp_apic_timer_interrupt+0x71/0x83
[   66.818529]  [<c01048f4>] apic_timer_interrupt+0x28/0x30
[   66.818535]  [<c01e5876>] vgacon_set_cursor_size+0xc9/0xd1
[   66.818541]  [<c01e6c98>] vgacon_cursor+0x176/0x18e
[   66.818546]  [<c022e439>] hide_cursor+0x24/0x61
[   66.818553]  [<c023005d>] do_con_write+0xdf/0x14f5
[   66.818559]  [<c02314ae>] con_write+0xc/0x1b
[   66.818563]  [<c022719a>] write_chan+0x1c6/0x291
[   66.818569]  [<c0224cc0>] tty_write+0x147/0x1c9
[   66.818574]  [<c0163ddf>] vfs_write+0xaf/0x163
[   66.818580]  [<c016441f>] sys_write+0x3d/0x61
[   66.818585]  [<c0103e28>] sysenter_past_esp+0x5d/0x81
[   66.818591]  =======================
[   67.266186] ipw3945: ipw3945.ucode load failed: Reason -2
[   67.266190] ipw3945: Could not read microcode: -2
[   67.266976] ACPI: PCI interrupt for device 0000:06:00.0 disabled
[   67.267069] ipw3945: probe of 0000:06:00.0 failed with error -2

-- 
mattia
:wq!
