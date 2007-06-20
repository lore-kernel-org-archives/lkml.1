Return-Path: <linux-kernel-owner+w=401wt.eu-S1758122AbXFTOCt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758122AbXFTOCt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 10:02:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753081AbXFTOCl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 10:02:41 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:65164 "EHLO
	viefep15-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753114AbXFTOCk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 10:02:40 -0400
Date: Wed, 20 Jun 2007 16:02:37 +0200
From: Carlo Wood <carlo@alinoe.com>
To: Wang Zhenyu <zhenyu.z.wang@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
       eric@anholt.net, lethal@linux-sh.org, y-goto@jp.fujitsu.com
Subject: Re: 2.6.22-rc5 regression
Message-ID: <20070620140237.GB5524@alinoe.com>
Mail-Followup-To: Carlo Wood <carlo@alinoe.com>,
	Wang Zhenyu <zhenyu.z.wang@intel.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
	eric@anholt.net, lethal@linux-sh.org, y-goto@jp.fujitsu.com
References: <alpine.LFD.0.98.0706180950130.14121@woody.linux-foundation.org> <20070618181225.GB8054@alinoe.com> <alpine.LFD.0.98.0706181127380.14121@woody.linux-foundation.org> <20070618195415.GA7481@alinoe.com> <alpine.LFD.0.98.0706181332400.3593@woody.linux-foundation.org> <20070618225009.GE13538@alinoe.com> <alpine.LFD.0.98.0706181553450.3593@woody.linux-foundation.org> <20070619233716.GA5779@alinoe.com> <20070620011521.GB2856@zhen-devel.sh.intel.com> <20070620014227.GA4090@zhen-devel.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20070620014227.GA4090@zhen-devel.sh.intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2007 at 09:42:27AM +0800, Wang Zhenyu wrote:
> oops, missing 946G, what a name...
> 
> Signed-off-by: Wang Zhenyu <zhenyu.z.wang@intel.com>
> ---
> diff --git a/drivers/char/agp/intel-agp.c b/drivers/char/agp/intel-agp.c
> index 0439ee9..145b4a1 100644
> --- a/drivers/char/agp/intel-agp.c
> +++ b/drivers/char/agp/intel-agp.c
> @@ -1853,17 +1853,17 @@ static const struct intel_driver_description {
>  	{ PCI_DEVICE_ID_INTEL_82945GM_HB, PCI_DEVICE_ID_INTEL_82945GME_IG, 0, "945GME",
>  		&intel_845_driver, &intel_915_driver },
>  	{ PCI_DEVICE_ID_INTEL_82946GZ_HB, PCI_DEVICE_ID_INTEL_82946GZ_IG, 0, "946GZ",
> -		&intel_845_driver, &intel_i965_driver },
> +		NULL, &intel_i965_driver },
>  	{ PCI_DEVICE_ID_INTEL_82965G_1_HB, PCI_DEVICE_ID_INTEL_82965G_1_IG, 0, "965G",
> -		&intel_845_driver, &intel_i965_driver },
> +		NULL, &intel_i965_driver },
>  	{ PCI_DEVICE_ID_INTEL_82965Q_HB, PCI_DEVICE_ID_INTEL_82965Q_IG, 0, "965Q",
> -		&intel_845_driver, &intel_i965_driver },
> +		NULL, &intel_i965_driver },
>  	{ PCI_DEVICE_ID_INTEL_82965G_HB, PCI_DEVICE_ID_INTEL_82965G_IG, 0, "965G",
> -		&intel_845_driver, &intel_i965_driver },
> +		NULL, &intel_i965_driver },
>  	{ PCI_DEVICE_ID_INTEL_82965GM_HB, PCI_DEVICE_ID_INTEL_82965GM_IG, 1, "965GM",
> -		&intel_845_driver, &intel_i965_driver },
> +		NULL, &intel_i965_driver },
>  	{ PCI_DEVICE_ID_INTEL_82965GM_HB, PCI_DEVICE_ID_INTEL_82965GME_IG, 0, "965GME/GLE",
> -		&intel_845_driver, &intel_i965_driver },
> +		NULL, &intel_i965_driver },
>  	{ PCI_DEVICE_ID_INTEL_7505_0, 0, 0, "E7505", &intel_7505_driver, NULL },
>  	{ PCI_DEVICE_ID_INTEL_7205_0, 0, 0, "E7205", &intel_7505_driver, NULL },
>  	{ PCI_DEVICE_ID_INTEL_G33_HB, PCI_DEVICE_ID_INTEL_G33_IG, 0, "G33",
> @@ -1917,6 +1917,7 @@ static int __devinit agp_intel_probe(struct pci_dev *pdev,
>  	}
>  
>  	if (bridge->driver == NULL) {
> +		/* The bridge has no AGP or no gfx device */
>  		printk(KERN_WARNING PFX "Failed to find bridge device "
>  			"(chip_id: %04x)\n", intel_agp_chipsets[i].gmch_chip_id);
>  		agp_put_bridge(bridge);
> ---

This patch causes 2.6.22-rc5 to boot :).

However, the resulting dmesg is:

==snip======================================
^MPress any key to continue.
^MPress any key to continue.
^[[H^[[J
    GNU GRUB  version 0.97  (635K lower / 2095680K upper memory)

^[[m^[[4;2H+-------------------------------------------------------------------------+^[[5;2H|^[[5;76H|^[[6;2H|^[[6;76H|^[[7;2H|^[[7;76H|^[[8;2H|^[[8;76H|^[[9;2H|^[[9;76H|^[[10;2H|^[[10;76H|^[[11;2H|^[[11;76H|^[[12;2H|^[[12;76H|^[[13;2H|^[[13;76H|^[[14;2H|^[[14;76H|^[[15;2H|^[[15;76H|^[[16;2H|^[[16;76H|^[[17;2H+-------------------------------------------------------------------------+^[[m
    Use the ^ and v keys to select which entry is highlighted.
    Press enter to boot the selected OS, 'e' to edit the
    commands before booting, or 'c' for a command-line.^[[5;78H ^[[m^[[7m^[[5;3H Debian GNU/Linux, kernel 2.6.22-rc5-agp0-188e1f81ba31af1b65a2f3611df4>  ^[[5;75H^[[m^[[m^[[6;3H Debian GNU/Linux, kernel 2.6.22-rc5-agp0-188e1f81ba31af1b65a2f3611df4>  ^[[6;75H^[[m^[[m^[[7;3H Debian GNU/Linux, kernel 2.6.22-rc5-agp0-188e1f81ba31af1b65a2f3611df4>  ^[[7;75H^[[m^[[m^[[8;3H Debian GNU/Linux, kernel 2.6.22-rc5-master-188e1f81ba31af1b65a2f3611d>  ^[[8;75H^[[m^[[m^[[9;3H Debian GNU/Linux, kernel 2.6.22-rc5-master-188e1f81ba31af1b65a2f3611d>  ^[[9;75H^[[m^[[m^[[10;3H Debian GNU/Linux, kernel 2.6.22-rc5-master-188e1f81ba31af1b65a2f3611d>  ^[[10;75H^[[m^[[m^[[11;3H Debian GNU/Linux, kernel 2.6.22-rc4-hikaru-amd64                        ^[[11;75H^[[m^[[m^[[12;3H Debian GNU/Linux, kernel 2.6.22-rc4-hikaru-amd64 (single-user mode)     ^[[12;75H^[[m^[[m^[[13;3H Debian GNU/Linux, kernel 2.6.22-rc4-hikaru-amd64 (serial console)       ^[[13;75H^[[m^[[m^[[14;3H Debian GNU/Linux, kernel 2.6.22-rc2-bisect-2c8307f63dd5caaf7ff8ad5118>  ^[[14;75H^[[m^[[m^[[15;3H Debian GNU/Linux, kernel 2.6.22-rc2-bisect-2c8307f63dd5caaf7ff8ad5118>  ^[[15;75H^[[m^[[m^[[16;3H Debian GNU/Linux, kernel 2.6.22-rc2-bisect-2c8307f63dd5caaf7ff8ad5118>  ^[[16;75H^[[m^[[16;78Hv^[[5;75H^[[23;4H The highlighted entry will be booted automatically in 5 seconds.   ^[[5;75H^[[23;4H The highlighted entry will be booted automatically in 4 seconds.   ^[[5;75H^[[23;4H The highlighted entry will be booted automatically in 3 seconds.   ^[[5;75H^[[23;4H                                                                    ^[[5;75H^[[m^[[5;3H Debian GNU/Linux, kernel 2.6.22-rc5-agp0-188e1f81ba31af1b65a2f3611df4>  ^[[5;75H^[[m^[[m^[[7m^[[6;3H Debian GNU/Linux, kernel 2.6.22-rc5-agp0-188e1f81ba31af1b65a2f3611df4>  ^[[6;75H^[[m^[[m^[[6;3H Debian GNU/Linux, kernel 2.6.22-rc5-agp0-188e1f81ba31af1b65a2f3611df4>  ^[[6;75H^[[m^[[m^[[7m^[[7;3H Debian GNU/Linux, kernel 2.6.22-rc5-agp0-188e1f81ba31af1b65a2f3611df4>  ^[[7;75H^[[m^[[m^[[7;3H Debian GNU/Linux, kernel 2.6.22-rc5-agp0-188!
 e1f81ba3
1af1b65a2f3611df4>  ^[[7;75H^[[m^[[m^[[7m^[[8;3H Debian GNU/Linux, kernel 2.6.22-rc5-master-188e1f81ba31af1b65a2f3611d>  ^[[8;75H^[[m^[[m^[[8;3H Debian GNU/Linux, kernel 2.6.22-rc5-master-188e1f81ba31af1b65a2f3611d>  ^[[8;75H^[[m^[[m^[[7m^[[9;3H Debian GNU/Linux, kernel 2.6.22-rc5-master-188e1f81ba31af1b65a2f3611d>  ^[[9;75H^[[m^[[m^[[9;3H Debian GNU/Linux, kernel 2.6.22-rc5-master-188e1f81ba31af1b65a2f3611d>  ^[[9;75H^[[m^[[m^[[7m^[[10;3H Debian GNU/Linux, kernel 2.6.22-rc5-master-188e1f81ba31af1b65a2f3611d>  ^[[10;75H^[[m^[[m^[[10;3H Debian GNU/Linux, kernel 2.6.22-rc5-master-188e1f81ba31af1b65a2f3611d>  ^[[10;75H^[[m^[[m^[[7m^[[11;3H Debian GNU/Linux, kernel 2.6.22-rc4-hikaru-amd64                        ^[[11;75H^[[m^[[m^[[11;3H Debian GNU/Linux, kernel 2.6.22-rc4-hikaru-amd64                        ^[[11;75H^[[m^[[m^[[7m^[[10;3H Debian GNU/Linux, kernel 2.6.22-rc5-master-188e1f81ba31af1b65a2f3611d>  ^[[10;75H^[[m^[[m^[[10;3H Debian GNU/Linux, kernel 2.6.22-rc5-master-188e1f81ba31af1b65a2f3611d>  ^[[10;75H^[[m^[[m^[[7m^[[9;3H Debian GNU/Linux, kernel 2.6.22-rc5-master-188e1f81ba31af1b65a2f3611d>  ^[[9;75H^[[m^[[m^[[9;3H Debian GNU/Linux, kernel 2.6.22-rc5-master-188e1f81ba31af1b65a2f3611d>  ^[[9;75H^[[m^[[m^[[7m^[[8;3H Debian GNU/Linux, kernel 2.6.22-rc5-master-188e1f81ba31af1b65a2f3611d>  ^[[8;75H^[[m^[[m^[[8;3H Debian GNU/Linux, kernel 2.6.22-rc5-master-188e1f81ba31af1b65a2f3611d>  ^[[8;75H^[[m^[[m^[[7m^[[7;3H Debian GNU/Linux, kernel 2.6.22-rc5-agp0-188e1f81ba31af1b65a2f3611df4>  ^[[7;75H^[[m^[[m^[[7;3H Debian GNU/Linux, kernel 2.6.22-rc5-agp0-188e1f81ba31af1b65a2f3611df4>  ^[[7;75H^[[m^[[m^[[7m^[[6;3H Debian GNU/Linux, kernel 2.6.22-rc5-agp0-188e1f81ba31af1b65a2f3611df4>  ^[[6;75H^[[m^[[m^[[6;3H Debian GNU/Linux, kernel 2.6.22-rc5-agp0-188e1f81ba31af1b65a2f3611df4>  ^[[6;75H^[[m^[[m^[[7m^[[5;3H Debian GNU/Linux, kernel 2.6.22-rc5-agp0-188e1f81ba31af1b65a2f3611df4>  ^[[5;75H^[[m^[[m^[[5;3H Debian GNU/Linux, kernel 2.6.22-rc5-agp0-188e1f81ba31af1b65a2f3611df4>  ^[[5;75H^[[m^[[m^[[7m^[[6;3H Debian G!
 NU/Linux
, kernel 2.6.22-rc5-agp0-188e1f81ba31af1b65a2f3611df4>  ^[[6;75H^[[m^[[m^[[6;3H Debian GNU/Linux, kernel 2.6.22-rc5-agp0-188e1f81ba31af1b65a2f3611df4>  ^[[6;75H^[[m^[[m^[[7m^[[7;3H Debian GNU/Linux, kernel 2.6.22-rc5-agp0-188e1f81ba31af1b65a2f3611df4>  ^[[7;75H^[[m^[[H^[[J  Booting 'Debian GNU/Linux, kernel 2.6.22-rc5-agp0-188e1f81ba31af1b65a2f3611df
4c670b092bbac-amd64 (serial console)'

root  (hd0,0)
 Filesystem type is ext2fs, partition type 0xfd
kernel  /vmlinuz-2.6.22-rc5-agp0-188e1f81ba31af1b65a2f3611df4c670b092bbac-amd64
 root=/dev/md2 ro console=tty0 console=ttyS0,38400n8
   [Linux-bzImage, setup=0x1e00, size=0x17ac68]
initrd  /initrd.img-2.6.22-rc5-agp0-188e1f81ba31af1b65a2f3611df4c670b092bbac-am
d64
   [Linux-initrd @ 0x379e6000, 0x60996b bytes]
savedefault

Linux version 2.6.22-rc5-agp0-188e1f81ba31af1b65a2f3611df4c670b092bbac-amd64 (carlo@hikaru) (gcc version 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)) #1 SMP Wed Jun 20 15:28:37 CEST 2007
Command line: root=/dev/md2 ro console=tty0 console=ttyS0,38400n8
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009ec00 (usable)
 BIOS-e820: 000000000009ec00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007ff90000 (usable)
 BIOS-e820: 000000007ff90000 - 000000007ff9e000 (ACPI data)
 BIOS-e820: 000000007ff9e000 - 000000007ffe0000 (ACPI NVS)
 BIOS-e820: 000000007ffe0000 - 0000000080000000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000180000000 (usable)
end_pfn_map = 1572864
DMI 2.4 present.
ACPI: RSDP 000FAE40, 0024 (r2 ACPIAM)
ACPI: XSDT 7FF90100, 0054 (r1 ÿÿÿÿÿÿ ÿÿÿÿÿÿÿÿ  3000709 MSFT       97)
ACPI: FACP 7FF90290, 00F4 (r3 MSTEST OEMFACP   3000709 MSFT       97)
ACPI: DSDT 7FF905C0, 8E7D (r1  A0483 A0483035       35 INTL 20060113)
ACPI: FACS 7FF9E000, 0040
ACPI: APIC 7FF90390, 006C (r1 MSTEST OEMAPIC   3000709 MSFT       97)
ACPI: MCFG 7FF90400, 003C (r1 MSTEST OEMMCFG   3000709 MSFT       97)
ACPI: SLIC 7FF90440, 0176 (r1 ÿÿÿÿÿÿ ÿÿÿÿÿÿÿÿ  3000709 MSFT       97)
ACPI: OEMB 7FF9E040, 007B (r1 MSTEST AMI_OEM   3000709 MSFT       97)
ACPI: HPET 7FF99440, 0038 (r1 MSTEST OEMHPET   3000709 MSFT       97)
No NUMA configuration found
Faking a node at 0000000000000000-0000000180000000
Bootmem setup node 0 0000000000000000-0000000180000000
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1572864
early_node_map[3] active PFN ranges
    0:        0 ->      158
    0:      256 ->   524176
    0:  1048576 ->  1572864
ACPI: PM-Timer IO Port: 0x808
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
Processor #2
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x01] enabled)
Processor #1
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
Processor #3
ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 4, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
Setting APIC routing to flat
ACPI: HPET id: 0x8086a202 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
swsusp: Registered nosave memory region: 000000000009e000 - 000000000009f000
swsusp: Registered nosave memory region: 000000000009f000 - 00000000000a0000
swsusp: Registered nosave memory region: 00000000000a0000 - 00000000000e4000
swsusp: Registered nosave memory region: 00000000000e4000 - 0000000000100000
swsusp: Registered nosave memory region: 000000007ff90000 - 000000007ff9e000
swsusp: Registered nosave memory region: 000000007ff9e000 - 000000007ffe0000
swsusp: Registered nosave memory region: 000000007ffe0000 - 0000000080000000
swsusp: Registered nosave memory region: 0000000080000000 - 00000000fee00000
swsusp: Registered nosave memory region: 00000000fee00000 - 00000000fee01000
swsusp: Registered nosave memory region: 00000000fee01000 - 00000000ffb00000
swsusp: Registered nosave memory region: 00000000ffb00000 - 0000000100000000
Allocating PCI resources starting at 88000000 (gap: 80000000:7ee00000)
SMP: Allowing 4 CPUs, 0 hotplug CPUs
PERCPU: Allocating 37768 bytes of per cpu data
Built 1 zonelists.  Total pages: 1025869
Kernel command line: root=/dev/md2 ro console=tty0 console=ttyS0,38400n8
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Extended CMOS year: 2000
time.c: Detected 2666.666 MHz processor.
Console: colour VGA+ 80x25
Checking aperture...
PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
Placing software IO TLB between 0x1059000 - 0x5059000
Memory: 4030964k/6291456k available (2015k kernel code, 162500k reserved, 947k data, 296k init)
Calibrating delay using timer specific routine.. 5336.91 BogoMIPS (lpj=10673830)
Security Framework v1.0.0 initialized
SELinux:  Disabled at boot.
Capability LSM initialized
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Mount-cache hash table entries: 256
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L3 cache: 4096K
CPU 0/0 -> Node 0
using mwait in idle threads.
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU0: Thermal monitoring enabled (TM2)
SMP alternatives: switching to UP code
ACPI: Core revision 20070126
Using local APIC timer interrupts.
result 16666652
Detected 16.666 MHz APIC timer.
SMP alternatives: switching to SMP code
Booting processor 1/4 APIC 0x2
Initializing CPU#1
Calibrating delay using timer specific routine.. 5333.36 BogoMIPS (lpj=10666730)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L3 cache: 4096K
CPU 1/2 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU1: Thermal monitoring enabled (TM2)
Intel(R) Core(TM)2 Quad CPU           @ 2.66GHz stepping 07
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
SMP alternatives: switching to SMP code
Booting processor 2/4 APIC 0x1
Initializing CPU#2
Calibrating delay using timer specific routine.. 5333.39 BogoMIPS (lpj=10666782)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L3 cache: 4096K
CPU 2/1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU2: Thermal monitoring enabled (TM2)
Intel(R) Core(TM)2 Quad CPU           @ 2.66GHz stepping 07
checking TSC synchronization [CPU#0 -> CPU#2]: passed.
SMP alternatives: switching to SMP code
Booting processor 3/4 APIC 0x3
Initializing CPU#3
Calibrating delay using timer specific routine.. 5333.36 BogoMIPS (lpj=10666729)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L3 cache: 4096K
CPU 3/3 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU3: Thermal monitoring enabled (TM2)
Intel(R) Core(TM)2 Quad CPU           @ 2.66GHz stepping 07
checking TSC synchronization [CPU#0 -> CPU#3]: passed.
Brought up 4 CPUs
migration_cost=3316
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: BIOS Bug: MCFG area at e0000000 is not E820-reserved
PCI: Not using MMCONFIG.
PCI: Using configuration type 1
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI quirk: region 0800-087f claimed by ICH6 ACPI/GPIO/TCO
PCI quirk: region 0480-04bf claimed by ICH6 GPIO
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11 12 14 *15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 *14 15)
ACPI: PCI Interrupt Link [LNKG] (IRQs *3 4 5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 *7 10 11 12 14 15)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 15 devices
ACPI: ACPI bus type pnp unregistered
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
NET: Registered protocol family 8
NET: Registered protocol family 20
PCI-GART: No AMD northbridge found.
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 64-bit timers, 14318180 Hz
ACPI: RTC can wake from S4
pnp: 00:01: iomem range 0xfed14000-0xfed19fff has been reserved
pnp: 00:07: ioport range 0x290-0x297 has been reserved
pnp: 00:08: iomem range 0xffafe000-0xffb0cbff could not be reserved
pnp: 00:08: iomem range 0xffb00000-0xffbfffff could not be reserved
pnp: 00:08: iomem range 0xfed1c000-0xfed1ffff has been reserved
pnp: 00:08: iomem range 0xfed20000-0xfed8ffff has been reserved
pnp: 00:0a: iomem range 0xfec00000-0xfec00fff has been reserved
pnp: 00:0a: iomem range 0xfee00000-0xfee00fff could not be reserved
pnp: 00:0d: iomem range 0xe0000000-0xefffffff has been reserved
pnp: 00:0e: iomem range 0x0-0x9ffff could not be reserved
pnp: 00:0e: iomem range 0xc0000-0xcffff has been reserved
pnp: 00:0e: iomem range 0xe0000-0xfffff could not be reserved
pnp: 00:0e: iomem range 0x100000-0x7fffffff could not be reserved
PCI: Bridge: 0000:00:01.0
  IO window: a000-afff
  MEM window: f8800000-fe8fffff
  PREFETCH window: bfe00000-dfdfffff
Time: tsc clocksource has been installed.
PCI: Bridge: 0000:00:1c.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: dfe00000-dfefffff
PCI: Bridge: 0000:00:1c.5
  IO window: b000-bfff
  MEM window: fe900000-fe9fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1e.0
  IO window: c000-cfff
  MEM window: fea00000-feafffff
  PREFETCH window: disabled.
ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level, low) -> IRQ 16
ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level, low) -> IRQ 16
ACPI: PCI Interrupt 0000:00:1c.5[B] -> GSI 17 (level, low) -> IRQ 17
NET: Registered protocol family 2
IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
TCP established hash table entries: 524288 (order: 11, 12582912 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 524288 bind 65536)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 6182k freed
audit: initializing netlink socket (disabled)
audit(1182347106.492:1): initialized
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
assign_interrupt_mode Found MSI capability
assign_interrupt_mode Found MSI capability
assign_interrupt_mode Found MSI capability
Real Time Clock Driver v1.12ac
Linux agpgart interface v0.102 (c) Dave Jones
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
RAMDISK driver initialized: 16 RAM disks of 65536K size 1024 blocksize
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
TCP bic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
input: AT Translated Set 2 keyboard as /class/input/input0
Freeing unused kernel memory: 296k freed
Loading, please wait...
Begin: Loading essential drivers... ...
Done.
Begin: Running /scripts/init-premount ...
ACPI Warning (tbutils-0158): Incorrect checksum in table [OEMB] -  F5, should be F4 [20070126]
ACPI: SSDT 7FF9E0C0, 0208 (r1    AMI   CPU1PM        1 INTL 20060113)
ACPI: SSDT 7FF9E2D0, 013A (r1    AMI   CPU2PM        1 INTL 20060113)
ACPI: SSDT 7FF9E410, 013A (r1    AMI   CPU3PM        1 INTL 20060113)
ACPI: SSDT 7FF9E550, 013A (r1    AMI   CPU4PM        1 INTL 20060113)
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1a.0[A] -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1a.0: UHCI Host Controller
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000e000
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
SCSI subsystem initialized
ACPI: PCI Interrupt 0000:00:1a.1[B] -> GSI 17 (level, low) -> IRQ 17
uhci_hcd 0000:00:1a.1: UHCI Host Controller
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1a.1: irq 17, io base 0x0000e080
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, low) -> IRQ 23
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000d800
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000d880
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000dc00
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1a.7[C] -> GSI 18 (level, low) -> IRQ 18
ehci_hcd 0000:00:1a.7: EHCI Host Controller
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 6
usb 4-2: new low speed USB device using uhci_hcd and address 2
ehci_hcd 0000:00:1a.7: debug port 1
ehci_hcd 0000:00:1a.7: irq 18, io mem 0xfebff400
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb6: configuration #1 chosen from 1 choice
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 4 ports detected
usb 4-2: configuration #1 chosen from 1 choice
ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level, low) -> IRQ 19
usbcore: registered new interface driver hiddev
input: Microsoft Microsoft Wireless Intellimouse Explorer® 1.0A as /class/input/input1
input: USB HID v1.10 Mouse [Microsoft Microsoft Wireless Intellimouse Explorer® 1.0A] on usb-0000:00:1d.1-2
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq ilck stag pm led clo pmp pio slum part 
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
scsi4 : ahci
scsi5 : ahci
ata1: SATA max UDMA/133 cmd 0xffffc20001446900 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 0
ata2: SATA max UDMA/133 cmd 0xffffc20001446980 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 0
ata3: SATA max UDMA/133 cmd 0xffffc20001446a00 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 0
ata4: SATA max UDMA/133 cmd 0xffffc20001446a80 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 0
ata5: SATA max UDMA/133 cmd 0xffffc20001446b00 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 0
ata6: SATA max UDMA/133 cmd 0xffffc20001446b80 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 0
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ata_hpa_resize 1: sectors = 145226112, hpa_sectors = 145226112
ata1.00: ATA-7: WDC WD740ADFD-00NLR1, 20.07P20, max UDMA/133
ata1.00: 145226112 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata1.00: ata_hpa_resize 1: sectors = 145226112, hpa_sectors = 145226112
ata1.00: configured for UDMA/133
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.00: ata_hpa_resize 1: sectors = 145226112, hpa_sectors = 145226112
ata2.00: ATA-7: WDC WD740ADFD-00NLR1, 20.07P20, max UDMA/133
ata2.00: 145226112 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata2.00: ata_hpa_resize 1: sectors = 145226112, hpa_sectors = 145226112
ata2.00: configured for UDMA/133
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata3.00: ata_hpa_resize 1: sectors = 145226112, hpa_sectors = 145226112
ata3.00: ATA-7: WDC WD740ADFD-00NLR1, 20.07P20, max UDMA/133
ata3.00: 145226112 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata3.00: ata_hpa_resize 1: sectors = 145226112, hpa_sectors = 145226112
ata3.00: configured for UDMA/133
ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata4.00: ata_hpa_resize 1: sectors = 625142448, hpa_sectors = 625142448
ata4.00: ATA-7: ST3320620AS, 3.AAE, max UDMA/133
ata4.00: 625142448 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata4.00: ata_hpa_resize 1: sectors = 625142448, hpa_sectors = 625142448
ata4.00: configured for UDMA/133
ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata5.00: ATAPI: LITE-ON DVDRW LH-20A1S, 9L02, max UDMA/100
ata5.00: configured for UDMA/100
ata6: SATA link down (SStatus 0 SControl 300)
scsi 0:0:0:0: Direct-Access     ATA      WDC WD740ADFD-00 20.0 PQ: 0 ANSI: 5
scsi 1:0:0:0: Direct-Access     ATA      WDC WD740ADFD-00 20.0 PQ: 0 ANSI: 5
scsi 2:0:0:0: Direct-Access     ATA      WDC WD740ADFD-00 20.0 PQ: 0 ANSI: 5
scsi 3:0:0:0: Direct-Access     ATA      ST3320620AS      3.AA PQ: 0 ANSI: 5
scsi 4:0:0:0: CD-ROM            LITE-ON  DVDRW LH-20A1S   9L02 PQ: 0 ANSI: 5
ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 7
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfebff000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb7: configuration #1 chosen from 1 choice
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 6 ports detected
sd 0:0:0:0: [sda] 145226112 512-byte hardware sectors (74356 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 145226112 512-byte hardware sectors (74356 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 sda4 < sda5 sda6<6>ACPI: PCI Interrupt 0000:04:03.0[A] ->  sda7 sda8GSI 21 (level, low) -> IRQ 21
 sda9 sda10 >
sd 0:0:0:0: [sda] Attached SCSI disk
sd 1:0:0:0: [sdb] 145226112 512-byte hardware sectors (74356 MB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[21]  MMIO=[feaff800-feafffff]  Max Packet=[2048]  IR/IT contexts=[4/8]
sd 1:0:0:0: [sdb] 145226112 512-byte hardware sectors (74356 MB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdb: sdb1 sdb2 sdb3 sdb4 < sdb5 sdb6 sdb7 sdb8 sdb9 sdb10 >
usb 4-2: USB disconnect, address 2
sd 1:0:0:0: [sdb] Attached SCSI disk
sd 2:0:0:0: [sdc] 145226112 512-byte hardware sectors (74356 MB)
sd 2:0:0:0: [sdc] Write Protect is off
sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 2:0:0:0: [sdc] 145226112 512-byte hardware sectors (74356 MB)
sd 2:0:0:0: [sdc] Write Protect is off
sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdc: sdc1 sdc2 sdc3 sdc4 < sdc5 sdc6 sdc7 sdc8 sdc9 sdc10 >
sd 2:0:0:0: [sdc] Attached SCSI disk
sd 3:0:0:0: [sdd] 625142448 512-byte hardware sectors (320073 MB)
sd 3:0:0:0: [sdd] Write Protect is off
sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 3:0:0:0: [sdd] 625142448 512-byte hardware sectors (320073 MB)
sd 3:0:0:0: [sdd] Write Protect is off
sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdd: sdd1 sdd2 sdd3
sd 3:0:0:0: [sdd] Attached SCSI disk
sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
usb 4-2: new low speed USB device using uhci_hcd and address 3
sd 0:0:0:0: Attached scsi generic sg0 type 0
sd 1:0:0:0: Attached scsi generic sg1 type 0
sd 2:0:0:0: Attached scsi generic sg2 type 0
sd 3:0:0:0: Attached scsi generic sg3 type 0
sr 4:0:0:0: Attached scsi generic sg4 type 5
Done.
Begin: Mounting root file system... ...
Begin: Running /scripts/local-top ...
usb 4-2: configuration #1 chosen from 1 choice
input: Microsoft Microsoft Wireless Intellimouse Explorer® 1.0A as /class/input/input2
input: USB HID v1.10 Mouse [Microsoft Microsoft Wireless Intellimouse Explorer® 1.0A] on usb-0000:00:1d.1-2
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
Begin: Loading Mmd: raid1 personality registered for level 1
D modules ...
raid5: automatically using best checksumming function: generic_sse
Success: loaded module raid1.
   generic_sse:  9512.000 MB/sec
raid5: using function: generic_sse (9512.000 MB/sec)
raid6: int64x1   2501 MB/s
raid6: int64x2   3018 MB/s
raid6: int64x4   2879 MB/s
raid6: int64x8   1920 MB/s
raid6: sse2x1    4193 MB/s
raid6: sse2x2    4804 MB/s
raid6: sse2x4    7876 MB/s
raid6: using algorithm sse2x4 (7876 MB/s)
md: raid6 personality registered for level 6
md: raid5 personality registered for level 5
md: raid4 personality registered for level 4
Success: loaded module raid456.
Done.
Begin: Amd: md0 stopped.
ssembling all MD arrays ...
md: bind<sdb1>
md: bind<sdc1>
md: bind<sda1>
raid1: raid set md0 active with 3 out of 3 mirrors
mdadm: /dev/md0 md: md1 stopped.
has been started with 3 drives.
md: bind<sdb2>
md: bind<sdc2>
md: bind<sda2>
raid5: device sda2 operational as raid disk 0
raid5: device sdc2 operational as raid disk 2
raid5: device sdb2 operational as raid disk 1
raid5: allocated 3212kB for md1
raid5: raid level 5 set md1 active with 3 out of 3 devices, algorithm 2
RAID5 conf printout:
 --- rd:3 wd:3
 disk 0, o:1, dev:sda2
 disk 1, o:1, dev:sdb2
 disk 2, o:1, dev:sdc2
mdadm: /dev/md1 md: md2 stopped.
has been started with 3 drives.
md: bind<sdb3>
md: bind<sdc3>
md: bind<sda3>
raid5: device sda3 operational as raid disk 0
raid5: device sdc3 operational as raid disk 2
raid5: device sdb3 operational as raid disk 1
raid5: allocated 3212kB for md2
raid5: raid level 5 set md2 active with 3 out of 3 devices, algorithm 2
RAID5 conf printout:
 --- rd:3 wd:3
 disk 0, o:1, dev:sda3
 disk 1, o:1, dev:sdb3
 disk 2, o:1, dev:sdc3
mdadm: /dev/md2 md: md3 stopped.
has been started with 3 drives.
md: bind<sdb5>
md: bind<sdc5>
md: bind<sda5>
raid5: device sda5 operational as raid disk 0
raid5: device sdc5 operational as raid disk 2
raid5: device sdb5 operational as raid disk 1
raid5: allocated 3212kB for md3
raid5: raid level 5 set md3 active with 3 out of 3 devices, algorithm 2
RAID5 conf printout:
 --- rd:3 wd:3
 disk 0, o:1, dev:sda5
 disk 1, o:1, dev:sdb5
 disk 2, o:1, dev:sdc5
mdadm: /dev/md3 md: md4 stopped.
has been started with 3 drives.
md: bind<sdb6>
md: bind<sdc6>
md: bind<sda6>
raid5: device sda6 operational as raid disk 0
raid5: device sdc6 operational as raid disk 2
raid5: device sdb6 operational as raid disk 1
raid5: allocated 3212kB for md4
raid5: raid level 5 set md4 active with 3 out of 3 devices, algorithm 2
RAID5 conf printout:
 --- rd:3 wd:3
 disk 0, o:1, dev:sda6
 disk 1, o:1, dev:sdb6
 disk 2, o:1, dev:sdc6
mdadm: /dev/md4 md: md5 stopped.
has been started with 3 drives.
md: bind<sdb7>
md: bind<sdc7>
md: bind<sda7>
raid5: device sda7 operational as raid disk 0
raid5: device sdc7 operational as raid disk 2
raid5: device sdb7 operational as raid disk 1
raid5: allocated 3212kB for md5
raid5: raid level 5 set md5 active with 3 out of 3 devices, algorithm 2
RAID5 conf printout:
 --- rd:3 wd:3
 disk 0, o:1, dev:sda7
 disk 1, o:1, dev:sdb7
 disk 2, o:1, dev:sdc7
mdadm: /dev/md5 md: md6 stopped.
has been started with 3 drives.
md: bind<sdb8>
md: bind<sdc8>
md: bind<sda8>
raid5: device sda8 operational as raid disk 0
raid5: device sdc8 operational as raid disk 2
raid5: device sdb8 operational as raid disk 1
raid5: allocated 3212kB for md6
raid5: raid level 5 set md6 active with 3 out of 3 devices, algorithm 2
RAID5 conf printout:
 --- rd:3 wd:3
 disk 0, o:1, dev:sda8
 disk 1, o:1, dev:sdb8
 disk 2, o:1, dev:sdc8
mdadm: /dev/md6 md: md7 stopped.
has been started with 3 drives.
md: bind<sdb9>
md: bind<sdc9>
md: bind<sda9>
raid5: device sda9 operational as raid disk 0
raid5: device sdc9 operational as raid disk 2
raid5: device sdb9 operational as raid disk 1
raid5: allocated 3212kB for md7
raid5: raid level 5 set md7 active with 3 out of 3 devices, algorithm 2
RAID5 conf printout:
 --- rd:3 wd:3
 disk 0, o:1, dev:sda9
 disk 1, o:1, dev:sdb9
 disk 2, o:1, dev:sdc9
mdadm: /dev/md7 md: md8 stopped.
has been started with 3 drives.
md: bind<sdb10>
md: bind<sdc10>
md: bind<sda10>
raid5: device sda10 operational as raid disk 0
raid5: device sdc10 operational as raid disk 2
raid5: device sdb10 operational as raid disk 1
raid5: allocated 3212kB for md8
raid5: raid level 5 set md8 active with 3 out of 3 devices, algorithm 2
RAID5 conf printout:
 --- rd:3 wd:3
 disk 0, o:1, dev:sda10
 disk 1, o:1, dev:sdb10
 disk 2, o:1, dev:sdc10
mdadm: /dev/md8 has been started with 3 drives.
Success: assembled all arrays.
Done.
Begin: Executing udevtrigger again ...
Done.
Done.
Begin: Running /scripts/local-premount ...
kinit: name_to_dAttempting manual resume
ev_t(/dev/md1) = md1(9,1)
kinit: trying to resume from /dev/md1
kinit: No resume image, doing normal boot...
Done.
kjournald starting.  Commit interval 5 seconds
Begin: Running /EXT3-fs: mounted filesystem with ordered data mode.
scripts/local-bottom ...
Done.
Done.
Begin: Running /scripts/init-bottom ...
Done.
Mount failed for selinuxfs on /selinux:  No such device
^MINIT: version 2.86 booting^M
Starting the hotplug events dispatcher: udevd.
Synthesizing the initial hotplug events...done.
Waiting for /dev to be fully populated...agpgart: Failed to find bridge device (chip_id: 29a2)
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.01 (21-Jan-2007)
iTCO_wdt: Found a ICH8 or ICH8R TCO device (Version=2, TCOBASE=0x0860)
iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 17 (level, low) -> IRQ 17
sky2 0000:02:00.0: v1.14 addr 0xfe9fc000 irq 17 Yukon-EC Ultra (0xb4) rev 2
sky2 eth0: addr 00:1a:92:3a:4a:c1
input: PC Speaker as /class/input/input3
PCI: Enabling device 0000:00:1f.3 (0001 -> 0003)
ACPI: PCI Interrupt 0000:00:1f.3[C] -> GSI 18 (level, low) -> IRQ 18
gameport: EMU10K1 is pci0000:04:02.1/gameport0, io 0xcc00, speed 1041kHz
ACPI: PCI Interrupt 0000:04:02.0[A] -> GSI 23 (level, low) -> IRQ 23
input: PS/2 Logitech Mouse as /class/input/input4
done.
Setting parameters of disc: (none).
Checking root file system...fsck 1.40-WIP (14-Nov-2006)
/dev/md2: clean, 20949/488640 files, 153388/975904 blocks
done.
EXT3 FS on md2, internal journal
Setting the system clock..
Cleaning up ifupdown....
Loading kernel modules...loop: module loaded
coretemp coretemp.0: Using undocumented features, absolute temperature might be wrong!
coretemp coretemp.1: Using undocumented features, absolute temperature might be wrong!
coretemp coretemp.2: Using undocumented features, absolute temperature might be wrong!
coretemp coretemp.3: Using undocumented features, absolute temperature might be wrong!
done.
Loading device-mapper supportdevice-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
.
Generating udev events for MD arrays...done.
Starting early crypto disks... cswap(starting) encrypted(starting)
Enter LUKS passphrase: 
key slot 1 unlocked.
Command successful.
done.
Starting remaining crypto disks... cswap(running) encrypted(running)done.
Checking file systems...fsck 1.40-WIP (14-Nov-2006)
/dev/md0: clean, 48/24096 files, 61709/96256 blocks
/dev/md5: clean, 40442/1221600 files, 1029243/2441824 blocks
/dev/sdd2: clean, 10111/4889248 files, 5934404/9765511 blocks (check in 3 mounts)
/dev/sdd3: clean, 2050/21987328 files, 40298300/43961872 blocks
/dev/md8: clean, 116771/2747136 files, 909674/5490144 blocks
/dev/md3: clean, 107476/2443200 files, 699836/4883712 blocks
/dev/md6: clean, 53/1221600 files, 76570/2441824 blocks (check in 3 mounts)
/dev/md7: clean, 1179373/7323648 files, 7577434/14647200 blocks
/dev/md4: clean, 8182/732960 files, 293632/1465856 blocks
/dev/mapper/encrypted: clean, 14627/12222464 files, 13984183/24414646 blocks
done.
Setting kernel variables...done.
Mounting local filesystems...kjournald starting.  Commit interval 5 seconds
EXT3 FS on md0, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on md5, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdd2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdd3, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on md8, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on md3, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on md6, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on md7, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on md4, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
done.
Activating swapfile swap...Adding 15631096k swap on /dev/mapper/cswap.  Priority:1 extents:1 across:15631096k
done.
Detecting hardware...Setting up networking....
Configuring network interfaces...done.
Starting portmap daemon...sky2 eth1: enabling interface
.
sky2 eth1: ram buffer 0K
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
ADDRCONF(NETDEV_UP): eth1: link is not ready
Setting sensors limits: done.
Setting console screen modes and fonts.
Setting up ALSA...done.
Recovering schroot sessions: sid32-c84448a9-0a57-4c2a-9a41-c60e0591ba06 sid32-df306a93-1d63-494d-a726-c924190900c6.
^MINIT: Entering runlevel: 2^M
Starting system log daemon....
Starting kernel log daemon....
Starting portmap daemon...Already running..
Starting HP Linux Printing and Imaging System:sky2 eth1: Link is up at 1000 Mbps, full duplex, flow control both
ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
 hpiod hpssd.
Loading ACPI modules...input: Power Button (FF) as /class/input/input5
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input6
ACPI: Power Button (CM) [PWRB]
.
Starting Advanced Configuration and Power Interface daemon....
Starting BitTorrent tracker: disabled in /etc/default/bittorrent.
Starting Common Unix Printing System: cupsdlp: driver loaded but no devices found
ppdev: user-space parallel port driver
.
Starting system message bus: dbus.
Starting network connection manager: NetworkManager.
Starting Avahi mDNS/DNS-SD Daemon: avahi-daemon.
Starting network events dispatcher: NetworkManagerDispatcher.
Starting MTA: exim4.
Starting mouse interface server: gpm.
Starting disk temperature monitoring daemon: hddtemp:  /dev/sda /dev/sdb /dev/sdc /dev/sdd..
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
Exporting directories for NFS kernel daemon....
Starting NFS kernel daemon: nfsdNFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
NFSD: starting 90-second grace period
 mountd.
Starting internet superserver: inetd.
Starting OpenBSD Secure Shell server: sshd.
Starting GNOME Display Manager: gdm.
Starting NFS common utilities: statd idmapd.
Starting DHCP D-Bus daemon: dhcdbd.
Starting Hardware abstraction layer: hald.
Starting MD monitoring service: mdadm --monitor.
Starting anac(h)ronistic cron: anacron.
Starting periodic command scheduler: crond.

Debian GNU/Linux lenny/sid hikaru ttyS0

hikaru login: 
==snip======================================

and I am not sure if you will consider the:

agpgart: Failed to find bridge device (chip_id: 29a2)

a bug.

-- 
Carlo Wood <carlo@alinoe.com>
