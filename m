Return-Path: <linux-kernel-owner+w=401wt.eu-S1758096AbZJTAeF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758096AbZJTAeF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 20:34:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758067AbZJTAeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 20:34:04 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:32786 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756627AbZJTAeA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 20:34:00 -0400
Date: Tue, 20 Oct 2009 01:34:00 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: linux-kernel@vger.kernel.org
Subject: [REGRESSION] EFI boot on x86 fails in .32
Message-ID: <20091020003400.GA27997@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-rc5 (and some earlier git checkout I had) fail to boot on my HP 
2530p when using EFI - they boot fine with the BIOS emulation instead. I 
get an early exception when print_efi_memmap() is called, which implies 
that the memory map is broken somehow. Here's the dmesg for a working 
boot:

Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Linux version 2.6.30.8-64.fc11.x86_64 (mockbuild@x86-5.fedora.phx.redhat.com) (gcc version 4.4.1 20090725 (Red Hat 4.4.1-2) (GCC) ) #1 SMP Fri Sep 25 04:43:32 EDT 2009
Command line: ro root=UUID=fd334e23-080a-449d-8993-07758e5cd581 rhgb quiet
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  Centaur CentaurHauls
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 00000000000a0000 (usable)
 BIOS-e820: 0000000000100000 - 0000000075a4c000 (usable)
 BIOS-e820: 0000000075a4c000 - 0000000075a4e000 (reserved)
 BIOS-e820: 0000000075a4e000 - 0000000076870000 (usable)
 BIOS-e820: 0000000076870000 - 0000000076880000 (ACPI NVS)
 BIOS-e820: 0000000076880000 - 0000000078fb1000 (usable)
 BIOS-e820: 0000000078fb1000 - 00000000791b1000 (ACPI NVS)
 BIOS-e820: 00000000791b1000 - 000000007a88f000 (usable)
 BIOS-e820: 000000007a88f000 - 000000007a9cf000 (reserved)
 BIOS-e820: 000000007a9cf000 - 000000007aacf000 (ACPI NVS)
 BIOS-e820: 000000007aacf000 - 000000007aaff000 (ACPI data)
 BIOS-e820: 000000007aaff000 - 000000007ab00000 (usable)
 BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
 BIOS-e820: 00000000fffa0000 - 00000000fffa7000 (reserved)
EFI v2.00 by INTEL 
 ACPI=0x7aafe000  ACPI 2.0=0x7aafe014  SMBIOS=0x7a99f718 
Kernel-defined memdesc doesn't match the one from EFI!
EFI: mem00: type=3, attr=0xf, range=[0x0000000000000000-0x0000000000001000) (0MB)
EFI: mem01: type=7, attr=0xf, range=[0x0000000000001000-0x0000000000071000) (0MB)
EFI: mem02: type=2, attr=0xf, range=[0x0000000000071000-0x0000000000073000) (0MB)
EFI: mem03: type=7, attr=0xf, range=[0x0000000000073000-0x0000000000075000) (0MB)
EFI: mem04: type=3, attr=0xf, range=[0x0000000000075000-0x0000000000090000) (0MB)
EFI: mem05: type=7, attr=0xf, range=[0x0000000000090000-0x0000000000097000) (0MB)
EFI: mem06: type=4, attr=0xf, range=[0x0000000000097000-0x0000000000098000) (0MB)
EFI: mem07: type=3, attr=0xf, range=[0x0000000000098000-0x00000000000a0000) (0MB)
EFI: mem08: type=7, attr=0xf, range=[0x0000000000100000-0x0000000000c00000) (11MB)
EFI: mem09: type=3, attr=0xf, range=[0x0000000000c00000-0x0000000001000000) (4MB)
EFI: mem10: type=7, attr=0xf, range=[0x0000000001000000-0x000000007493e000) (1849MB)
EFI: mem11: type=2, attr=0xf, range=[0x000000007493e000-0x0000000074940000) (0MB)
EFI: mem12: type=7, attr=0xf, range=[0x0000000074940000-0x0000000074943000) (0MB)
EFI: mem13: type=2, attr=0xf, range=[0x0000000074943000-0x00000000759cd000) (16MB)
EFI: mem14: type=1, attr=0xf, range=[0x00000000759cd000-0x0000000075a05000) (0MB)
EFI: mem15: type=3, attr=0xf, range=[0x0000000075a05000-0x0000000075a4c000) (0MB)
EFI: mem16: type=0, attr=0xf, range=[0x0000000075a4c000-0x0000000075a4e000) (0MB)
EFI: mem17: type=3, attr=0xf, range=[0x0000000075a4e000-0x0000000075f0b000) (4MB)
EFI: mem18: type=4, attr=0xf, range=[0x0000000075f0b000-0x0000000076870000) (9MB)
EFI: mem19: type=10, attr=0xf, range=[0x0000000076870000-0x0000000076880000) (0MB)
EFI: mem20: type=3, attr=0xf, range=[0x0000000076880000-0x000000007688f000) (0MB)
EFI: mem21: type=7, attr=0xf, range=[0x000000007688f000-0x0000000077a8f000) (18MB)
EFI: mem22: type=2, attr=0xf, range=[0x0000000077a8f000-0x0000000077d99000) (3MB)
EFI: mem23: type=4, attr=0xf, range=[0x0000000077d99000-0x0000000077db9000) (0MB)
EFI: mem24: type=7, attr=0xf, range=[0x0000000077db9000-0x0000000077dc9000) (0MB)
EFI: mem25: type=4, attr=0xf, range=[0x0000000077dc9000-0x0000000077fcf000) (2MB)
EFI: mem26: type=7, attr=0xf, range=[0x0000000077fcf000-0x0000000077fd0000) (0MB)
EFI: mem27: type=4, attr=0xf, range=[0x0000000077fd0000-0x0000000078462000) (4MB)
EFI: mem28: type=7, attr=0xf, range=[0x0000000078462000-0x0000000078463000) (0MB)
EFI: mem29: type=4, attr=0xf, range=[0x0000000078463000-0x0000000078fb1000) (11MB)
EFI: mem30: type=10, attr=0xf, range=[0x0000000078fb1000-0x00000000791b1000) (2MB)
EFI: mem31: type=4, attr=0xf, range=[0x00000000791b1000-0x0000000079269000) (0MB)
EFI: mem32: type=7, attr=0xf, range=[0x0000000079269000-0x000000007926c000) (0MB)
EFI: mem33: type=4, attr=0xf, range=[0x000000007926c000-0x000000007a88f000) (22MB)
EFI: mem34: type=5, attr=0x800000000000000f, range=[0x000000007a88f000-0x000000007a92a000) (0MB)
EFI: mem35: type=5, attr=0x800000000000000f, range=[0x000000007a92a000-0x000000007a98f000) (0MB)
EFI: mem36: type=6, attr=0x800000000000000f, range=[0x000000007a98f000-0x000000007a993000) (0MB)
EFI: mem37: type=0, attr=0xf, range=[0x000000007a993000-0x000000007a99b000) (0MB)
EFI: mem38: type=6, attr=0x800000000000000f, range=[0x000000007a99b000-0x000000007a9bf000) (0MB)
EFI: mem39: type=0, attr=0xf, range=[0x000000007a9bf000-0x000000007a9c4000) (0MB)
EFI: mem40: type=0, attr=0xf, range=[0x000000007a9c4000-0x000000007a9cf000) (0MB)
EFI: mem41: type=10, attr=0xf, range=[0x000000007a9cf000-0x000000007aa38000) (0MB)
EFI: mem42: type=10, attr=0xf, range=[0x000000007aa38000-0x000000007aacf000) (0MB)
EFI: mem43: type=9, attr=0xf, range=[0x000000007aacf000-0x000000007aad5000) (0MB)
EFI: mem44: type=9, attr=0xf, range=[0x000000007aad5000-0x000000007aaff000) (0MB)
EFI: mem45: type=4, attr=0xf, range=[0x000000007aaff000-0x000000007ab00000) (0MB)
EFI: mem46: type=11, attr=0x8000000000000001, range=[0x00000000fed1c000-0x00000000fed20000) (0MB)
EFI: mem47: type=11, attr=0x8000000000000000, range=[0x00000000fffa0000-0x00000000fffa7000) (0MB)
DMI 2.4 present.
last_pfn = 0x7ab00 max_arch_pfn = 0x100000000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-FFFFF write-protect
MTRR variable ranges enabled:
  0 base 0FFE00000 mask FFFE00000 write-protect
  1 base 000000000 mask F80000000 write-back
  2 base 07F000000 mask FFF000000 uncachable
  3 base 076870000 mask FFFFF0000 uncachable
  4 disabled
  5 disabled
  6 disabled
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
original variable MTRRs
reg 0, base: 4094MB, range: 2MB, type WP
reg 1, base: 0GB, range: 2GB, type WB
reg 2, base: 2032MB, range: 16MB, type UC
reg 3, base: 1941952KB, range: 64KB, type UC
total RAM coverred: 2031M
 gran_size: 64K 	chunk_size: 64K 	num_reg: 7  	lose cover RAM: 138944K
 gran_size: 64K 	chunk_size: 128K 	num_reg: 7  	lose cover RAM: 138688K
 gran_size: 64K 	chunk_size: 256K 	num_reg: 7  	lose cover RAM: 138688K
 gran_size: 64K 	chunk_size: 512K 	num_reg: 7  	lose cover RAM: 138688K
 gran_size: 64K 	chunk_size: 1M 	num_reg: 7  	lose cover RAM: 138176K
 gran_size: 64K 	chunk_size: 2M 	num_reg: 7  	lose cover RAM: 137152K
 gran_size: 64K 	chunk_size: 4M 	num_reg: 7  	lose cover RAM: 135104K
 gran_size: 64K 	chunk_size: 8M 	num_reg: 7  	lose cover RAM: 128M
 gran_size: 64K 	chunk_size: 16M 	num_reg: 7  	lose cover RAM: 128M
 gran_size: 64K 	chunk_size: 32M 	num_reg: 7  	lose cover RAM: 0G
 gran_size: 64K 	chunk_size: 64M 	num_reg: 7  	lose cover RAM: 0G
 gran_size: 64K 	chunk_size: 128M 	num_reg: 7  	lose cover RAM: 0G
 gran_size: 64K 	chunk_size: 256M 	num_reg: 7  	lose cover RAM: 138944K
 gran_size: 64K 	chunk_size: 512M 	num_reg: 7  	lose cover RAM: 138944K
 gran_size: 64K 	chunk_size: 1G 	num_reg: 7  	lose cover RAM: 138944K
 gran_size: 64K 	chunk_size: 2G 	num_reg: 7  	lose cover RAM: 138944K
 gran_size: 128K 	chunk_size: 128K 	num_reg: 7  	lose cover RAM: 138944K
 gran_size: 128K 	chunk_size: 256K 	num_reg: 7  	lose cover RAM: 138688K
 gran_size: 128K 	chunk_size: 512K 	num_reg: 7  	lose cover RAM: 138688K
 gran_size: 128K 	chunk_size: 1M 	num_reg: 7  	lose cover RAM: 138176K
 gran_size: 128K 	chunk_size: 2M 	num_reg: 7  	lose cover RAM: 137152K
 gran_size: 128K 	chunk_size: 4M 	num_reg: 7  	lose cover RAM: 135104K
 gran_size: 128K 	chunk_size: 8M 	num_reg: 7  	lose cover RAM: 131136K
 gran_size: 128K 	chunk_size: 16M 	num_reg: 7  	lose cover RAM: 131136K
 gran_size: 128K 	chunk_size: 32M 	num_reg: 7  	lose cover RAM: 64K
 gran_size: 128K 	chunk_size: 64M 	num_reg: 7  	lose cover RAM: 64K
 gran_size: 128K 	chunk_size: 128M 	num_reg: 7  	lose cover RAM: 64K
 gran_size: 128K 	chunk_size: 256M 	num_reg: 7  	lose cover RAM: 138944K
 gran_size: 128K 	chunk_size: 512M 	num_reg: 7  	lose cover RAM: 138944K
 gran_size: 128K 	chunk_size: 1G 	num_reg: 7  	lose cover RAM: 138944K
 gran_size: 128K 	chunk_size: 2G 	num_reg: 7  	lose cover RAM: 138944K
 gran_size: 256K 	chunk_size: 256K 	num_reg: 7  	lose cover RAM: 138944K
 gran_size: 256K 	chunk_size: 512K 	num_reg: 7  	lose cover RAM: 138688K
 gran_size: 256K 	chunk_size: 1M 	num_reg: 7  	lose cover RAM: 138176K
 gran_size: 256K 	chunk_size: 2M 	num_reg: 7  	lose cover RAM: 137152K
 gran_size: 256K 	chunk_size: 4M 	num_reg: 7  	lose cover RAM: 135104K
 gran_size: 256K 	chunk_size: 8M 	num_reg: 7  	lose cover RAM: 131264K
 gran_size: 256K 	chunk_size: 16M 	num_reg: 7  	lose cover RAM: 131264K
 gran_size: 256K 	chunk_size: 32M 	num_reg: 7  	lose cover RAM: 192K
 gran_size: 256K 	chunk_size: 64M 	num_reg: 7  	lose cover RAM: 192K
 gran_size: 256K 	chunk_size: 128M 	num_reg: 7  	lose cover RAM: 192K
 gran_size: 256K 	chunk_size: 256M 	num_reg: 7  	lose cover RAM: 138944K
 gran_size: 256K 	chunk_size: 512M 	num_reg: 7  	lose cover RAM: 138944K
 gran_size: 256K 	chunk_size: 1G 	num_reg: 7  	lose cover RAM: 138944K
 gran_size: 256K 	chunk_size: 2G 	num_reg: 7  	lose cover RAM: 138944K
 gran_size: 512K 	chunk_size: 512K 	num_reg: 7  	lose cover RAM: 138688K
 gran_size: 512K 	chunk_size: 1M 	num_reg: 7  	lose cover RAM: 138688K
 gran_size: 512K 	chunk_size: 2M 	num_reg: 7  	lose cover RAM: 138688K
 gran_size: 512K 	chunk_size: 4M 	num_reg: 7  	lose cover RAM: 138688K
 gran_size: 512K 	chunk_size: 8M 	num_reg: 7  	lose cover RAM: 138688K
 gran_size: 512K 	chunk_size: 16M 	num_reg: 7  	lose cover RAM: 131520K
 gran_size: 512K 	chunk_size: 32M 	num_reg: 7  	lose cover RAM: 448K
 gran_size: 512K 	chunk_size: 64M 	num_reg: 7  	lose cover RAM: 448K
 gran_size: 512K 	chunk_size: 128M 	num_reg: 7  	lose cover RAM: 448K
 gran_size: 512K 	chunk_size: 256M 	num_reg: 7  	lose cover RAM: 138688K
 gran_size: 512K 	chunk_size: 512M 	num_reg: 7  	lose cover RAM: 138688K
 gran_size: 512K 	chunk_size: 1G 	num_reg: 7  	lose cover RAM: 138688K
 gran_size: 512K 	chunk_size: 2G 	num_reg: 7  	lose cover RAM: 138688K
 gran_size: 1M 	chunk_size: 1M 	num_reg: 7  	lose cover RAM: 138688K
 gran_size: 1M 	chunk_size: 2M 	num_reg: 7  	lose cover RAM: 138688K
 gran_size: 1M 	chunk_size: 4M 	num_reg: 7  	lose cover RAM: 138688K
 gran_size: 1M 	chunk_size: 8M 	num_reg: 7  	lose cover RAM: 138688K
 gran_size: 1M 	chunk_size: 16M 	num_reg: 7  	lose cover RAM: 131520K
 gran_size: 1M 	chunk_size: 32M 	num_reg: 7  	lose cover RAM: 448K
 gran_size: 1M 	chunk_size: 64M 	num_reg: 7  	lose cover RAM: 448K
 gran_size: 1M 	chunk_size: 128M 	num_reg: 7  	lose cover RAM: 448K
 gran_size: 1M 	chunk_size: 256M 	num_reg: 7  	lose cover RAM: 138688K
 gran_size: 1M 	chunk_size: 512M 	num_reg: 7  	lose cover RAM: 138688K
 gran_size: 1M 	chunk_size: 1G 	num_reg: 7  	lose cover RAM: 138688K
 gran_size: 1M 	chunk_size: 2G 	num_reg: 7  	lose cover RAM: 138688K
 gran_size: 2M 	chunk_size: 2M 	num_reg: 7  	lose cover RAM: 138688K
 gran_size: 2M 	chunk_size: 4M 	num_reg: 7  	lose cover RAM: 138688K
 gran_size: 2M 	chunk_size: 8M 	num_reg: 7  	lose cover RAM: 138688K
 gran_size: 2M 	chunk_size: 16M 	num_reg: 7  	lose cover RAM: 131520K
 gran_size: 2M 	chunk_size: 32M 	num_reg: 7  	lose cover RAM: 448K
 gran_size: 2M 	chunk_size: 64M 	num_reg: 7  	lose cover RAM: 448K
 gran_size: 2M 	chunk_size: 128M 	num_reg: 7  	lose cover RAM: 448K
 gran_size: 2M 	chunk_size: 256M 	num_reg: 7  	lose cover RAM: 138688K
 gran_size: 2M 	chunk_size: 512M 	num_reg: 7  	lose cover RAM: 138688K
 gran_size: 2M 	chunk_size: 1G 	num_reg: 7  	lose cover RAM: 138688K
 gran_size: 2M 	chunk_size: 2G 	num_reg: 7  	lose cover RAM: 138688K
 gran_size: 4M 	chunk_size: 4M 	num_reg: 7  	lose cover RAM: 138688K
 gran_size: 4M 	chunk_size: 8M 	num_reg: 7  	lose cover RAM: 138688K
 gran_size: 4M 	chunk_size: 16M 	num_reg: 7  	lose cover RAM: 131520K
 gran_size: 4M 	chunk_size: 32M 	num_reg: 7  	lose cover RAM: 448K
 gran_size: 4M 	chunk_size: 64M 	num_reg: 7  	lose cover RAM: 448K
 gran_size: 4M 	chunk_size: 128M 	num_reg: 7  	lose cover RAM: 448K
 gran_size: 4M 	chunk_size: 256M 	num_reg: 7  	lose cover RAM: 138688K
 gran_size: 4M 	chunk_size: 512M 	num_reg: 7  	lose cover RAM: 138688K
 gran_size: 4M 	chunk_size: 1G 	num_reg: 7  	lose cover RAM: 138688K
 gran_size: 4M 	chunk_size: 2G 	num_reg: 7  	lose cover RAM: 138688K
 gran_size: 8M 	chunk_size: 8M 	num_reg: 7  	lose cover RAM: 138688K
 gran_size: 8M 	chunk_size: 16M 	num_reg: 7  	lose cover RAM: 131520K
 gran_size: 8M 	chunk_size: 32M 	num_reg: 7  	lose cover RAM: 448K
 gran_size: 8M 	chunk_size: 64M 	num_reg: 7  	lose cover RAM: 448K
 gran_size: 8M 	chunk_size: 128M 	num_reg: 7  	lose cover RAM: 448K
 gran_size: 8M 	chunk_size: 256M 	num_reg: 7  	lose cover RAM: 138688K
 gran_size: 8M 	chunk_size: 512M 	num_reg: 7  	lose cover RAM: 138688K
 gran_size: 8M 	chunk_size: 1G 	num_reg: 7  	lose cover RAM: 138688K
 gran_size: 8M 	chunk_size: 2G 	num_reg: 7  	lose cover RAM: 138688K
 gran_size: 16M 	chunk_size: 16M 	num_reg: 7  	lose cover RAM: 145856K
 gran_size: 16M 	chunk_size: 32M 	num_reg: 7  	lose cover RAM: 145856K
*BAD*gran_size: 16M 	chunk_size: 64M 	num_reg: 7  	lose cover RAM: -7744K
*BAD*gran_size: 16M 	chunk_size: 128M 	num_reg: 7  	lose cover RAM: -7744K
 gran_size: 16M 	chunk_size: 256M 	num_reg: 7  	lose cover RAM: 145856K
 gran_size: 16M 	chunk_size: 512M 	num_reg: 7  	lose cover RAM: 145856K
 gran_size: 16M 	chunk_size: 1G 	num_reg: 7  	lose cover RAM: 145856K
 gran_size: 16M 	chunk_size: 2G 	num_reg: 7  	lose cover RAM: 145856K
 gran_size: 32M 	chunk_size: 32M 	num_reg: 7  	lose cover RAM: 145856K
*BAD*gran_size: 32M 	chunk_size: 64M 	num_reg: 7  	lose cover RAM: -7744K
*BAD*gran_size: 32M 	chunk_size: 128M 	num_reg: 7  	lose cover RAM: -7744K
 gran_size: 32M 	chunk_size: 256M 	num_reg: 7  	lose cover RAM: 145856K
 gran_size: 32M 	chunk_size: 512M 	num_reg: 7  	lose cover RAM: 145856K
 gran_size: 32M 	chunk_size: 1G 	num_reg: 7  	lose cover RAM: 145856K
 gran_size: 32M 	chunk_size: 2G 	num_reg: 7  	lose cover RAM: 145856K
 gran_size: 64M 	chunk_size: 64M 	num_reg: 7  	lose cover RAM: 176576K
 gran_size: 64M 	chunk_size: 128M 	num_reg: 7  	lose cover RAM: 156096K
 gran_size: 64M 	chunk_size: 256M 	num_reg: 7  	lose cover RAM: 176576K
 gran_size: 64M 	chunk_size: 512M 	num_reg: 7  	lose cover RAM: 176576K
 gran_size: 64M 	chunk_size: 1G 	num_reg: 7  	lose cover RAM: 176576K
 gran_size: 64M 	chunk_size: 2G 	num_reg: 7  	lose cover RAM: 176576K
 gran_size: 128M 	chunk_size: 128M 	num_reg: 3  	lose cover RAM: 245696K
 gran_size: 128M 	chunk_size: 256M 	num_reg: 3  	lose cover RAM: 245696K
 gran_size: 128M 	chunk_size: 512M 	num_reg: 3  	lose cover RAM: 245696K
 gran_size: 128M 	chunk_size: 1G 	num_reg: 3  	lose cover RAM: 245696K
 gran_size: 128M 	chunk_size: 2G 	num_reg: 3  	lose cover RAM: 245696K
 gran_size: 256M 	chunk_size: 256M 	num_reg: 3  	lose cover RAM: 245696K
 gran_size: 256M 	chunk_size: 512M 	num_reg: 3  	lose cover RAM: 245696K
 gran_size: 256M 	chunk_size: 1G 	num_reg: 3  	lose cover RAM: 245696K
 gran_size: 256M 	chunk_size: 2G 	num_reg: 3  	lose cover RAM: 245696K
 gran_size: 512M 	chunk_size: 512M 	num_reg: 2  	lose cover RAM: 507840K
 gran_size: 512M 	chunk_size: 1G 	num_reg: 2  	lose cover RAM: 507840K
 gran_size: 512M 	chunk_size: 2G 	num_reg: 2  	lose cover RAM: 507840K
 gran_size: 1G 	chunk_size: 1G 	num_reg: 1  	lose cover RAM: 1032128K
 gran_size: 1G 	chunk_size: 2G 	num_reg: 1  	lose cover RAM: 1032128K
 gran_size: 2G 	chunk_size: 2G 	num_reg: 0  	lose cover RAM: 2080704K
mtrr_cleanup: can not find optimal value
please specify mtrr_gran_size/mtrr_chunk_size
init_memory_mapping: 0000000000000000-000000007ab00000
 0000000000 - 007aa00000 page 2M
 007aa00000 - 007ab00000 page 4k
kernel direct mapping tables up to 7ab00000 @ 8000-c000
RAMDISK: 77a8f000 - 77d98445
ACPI: RSDP 000000007aafe014 00024 (v02 HPQOEM)
ACPI: XSDT 000000007aafe120 00084 (v01 HPQOEM SLIC-MPC 0000000F      01000013)
ACPI: FACP 000000007aafc000 000F4 (v03 HPQOEM 30E1     0000000F HP   00000001)
ACPI: DSDT 000000007aade000 18BB2 (v01 HPQOEM 30E1     00000001 INTL 20060912)
ACPI: FACS 000000007aa9d000 00040
ACPI: HPET 000000007aafb000 00038 (v01 HPQOEM 30E1     00000001 HP   00000001)
ACPI: APIC 000000007aafa000 00084 (v01 HPQOEM 30E1     00000001 HP   00000001)
ACPI: MCFG 000000007aaf9000 0003C (v01 HPQOEM 30E1     00000001 HP   00000001)
ACPI: TCPA 000000007aaf7000 00032 (v02 HPQOEM 30E1     00000000 HP   00000001)
ACPI: SSDT 000000007aadb000 002DD (v01 HPQOEM SataAhci 00001000 INTL 20060912)
ACPI: SLIC 000000007aad9000 00176 (v01 HPQOEM SLIC-MPC 00000001 HP   00000001)
ACPI: DMAR 000000007aad8000 00120 (v01                00000001      00000000)
ACPI: ASF! 000000007aaf8000 00095 (v32 HPQOEM 30E1     00000001 HP   00000001)
ACPI: SSDT 000000007aad7000 0066C (v01  PmRef    CpuPm 00003000 INTL 20060912)
ACPI: SSDT 000000007aad6000 00288 (v01  PmRef  Cpu0Tst 00003000 INTL 20060912)
ACPI: SSDT 000000007aad5000 00225 (v01  PmRef    ApTst 00003000 INTL 20060912)
ACPI: Local APIC address 0xfee00000
No NUMA configuration found
Faking a node at 0000000000000000-000000007ab00000
Bootmem setup node 0 0000000000000000-000000007ab00000
  NODE_DATA [000000000000a000 - 000000000001efff]
  bootmap [000000000001f000 -  000000000002e55f] pages 10
(8 early reservations) ==> bootmem [0000000000 - 007ab00000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
  #2 [0000200000 - 0000bd11a0]    TEXT DATA BSS ==> [0000200000 - 0000bd11a0]
  #3 [0077a8f000 - 0077d98445]          RAMDISK ==> [0077a8f000 - 0077d98445]
  #4 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
  #5 [007493e000 - 007493e900]       EFI memmap ==> [007493e000 - 007493e900]
  #6 [0000bd2000 - 0000bd21bc]              BRK ==> [0000bd2000 - 0000bd21bc]
  #7 [0000008000 - 000000a000]          PGTABLE ==> [0000008000 - 000000a000]
 [ffffe20000000000-ffffe20001bfffff] PMD -> [ffff880001200000-ffff880002dfffff] on node 0
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00100000
Movable zone start PFN for each node
early_node_map[6] active PFN ranges
    0: 0x00000000 -> 0x000000a0
    0: 0x00000100 -> 0x00075a4c
    0: 0x00075a4e -> 0x00076870
    0: 0x00076880 -> 0x00078fb1
    0: 0x000791b1 -> 0x0007a88f
    0: 0x0007aaff -> 0x0007ab00
On node 0 totalpages: 501278
  DMA zone: 56 pages used for memmap
  DMA zone: 2614 pages reserved
  DMA zone: 1330 pages, LIFO batch:0
  DMA32 zone: 6815 pages used for memmap
  DMA32 zone: 490463 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0x408
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x00] disabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x00] disabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, version 0, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8086a201 base: 0xfed00000
SMP: Allowing 4 CPUs, 2 hotplug CPUs
nr_irqs_gsi: 24
PM: Registered nosave memory: 00000000000a0000 - 0000000000100000
PM: Registered nosave memory: 0000000075a4c000 - 0000000075a4e000
PM: Registered nosave memory: 0000000076870000 - 0000000076880000
PM: Registered nosave memory: 0000000078fb1000 - 00000000791b1000
PM: Registered nosave memory: 000000007a88f000 - 000000007a9cf000
PM: Registered nosave memory: 000000007a9cf000 - 000000007aacf000
PM: Registered nosave memory: 000000007aacf000 - 000000007aaff000
Allocating PCI resources starting at 80000000 (gap: 7ab00000:8421c000)
NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:4 nr_node_ids:1
PERCPU: Embedded 27 pages at ffff880001010000, static data 79584 bytes
Built 1 zonelists in Node order, mobility grouping on.  Total pages: 491793
Policy zone: DMA32
Kernel command line: ro root=UUID=fd334e23-080a-449d-8993-07758e5cd581 rhgb quiet
Initializing CPU#0
NR_IRQS:4352 nr_irqs:440
PID hash table entries: 4096 (order: 12, 32768 bytes)
Extended CMOS year: 2000
Fast TSC calibration using PIT
Detected 1197.010 MHz processor.
Console: colour VGA+ 128x40
console [tty0] enabled
allocated 20971520 bytes of page_cgroup
please try cgroup_disable=memory option if you don't want
Checking aperture...
No AGP bridge found
Calgary: detecting Calgary via BIOS EBDA area
Calgary: Unable to locate Rio Grande table in EBDA - bailing!
Memory: 1942040k/2010112k available (4736k kernel code, 5000k absent, 63072k reserved, 2498k data, 1348k init)
SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
hpet clockevent registered
HPET: 4 timers in total, 0 timers will be used for per-cpu timer
Calibrating delay loop (skipped), value calculated using timer frequency.. 2394.02 BogoMIPS (lpj=1197010)
init_memory_mapping: 00000000fed1c000-00000000fed20000
 00fed1c000 - 00fed20000 page 4k
init_memory_mapping: 00000000fffa0000-00000000fffa7000
 00fffa0000 - 00fffa7000 page 4k
Security Framework initialized
SELinux:  Initializing.
SELinux:  Starting in permissive mode
Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
Mount-cache hash table entries: 256
Initializing cgroup subsys ns
Initializing cgroup subsys cpuacct
Initializing cgroup subsys memory
Initializing cgroup subsys devices
Initializing cgroup subsys freezer
Initializing cgroup subsys net_cls
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 3072K
CPU 0/0x0 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU0: Thermal monitoring handled by SMI
using mwait in idle threads.
ACPI: Core revision 20090320
ftrace: converting mcount calls to 0f 1f 44 00 00
ftrace: allocating 19374 entries in 76 pages
Setting APIC routing to flat
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Core(TM)2 Duo CPU     U9300  @ 1.20GHz stepping 06
Booting processor 1 APIC 0x1 ip 0x6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 2393.88 BogoMIPS (lpj=1196943)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 3072K
CPU 1/0x1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU1: Thermal monitoring enabled (TM2)
x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
CPU1: Intel(R) Core(TM)2 Duo CPU     U9300  @ 1.20GHz stepping 06
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
Total of 2 processors activated (4787.90 BogoMIPS).
sizeof(vma)=176 bytes
sizeof(page)=56 bytes
sizeof(inode)=576 bytes
sizeof(dentry)=192 bytes
sizeof(ext3inode)=784 bytes
sizeof(buffer_head)=104 bytes
sizeof(skbuff)=232 bytes
sizeof(task_struct)=5960 bytes
CPU0 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 0 1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 1 0
net_namespace: 1952 bytes
Booting paravirtualized kernel on bare hardware
regulator: core version 0.5
Time: 13:56:42  Date: 10/19/09
NET: Registered protocol family 16
ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
ACPI: bus type pci registered
PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
PCI: Not using MMCONFIG.
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: EC: Look up EC in DSDT
ACPI: BIOS _OSI(Linux) query ignored
ACPI: EC: non-query interrupt received, switching to interrupt mode
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
PCI: MCFG area at e0000000 reserved in ACPI motherboard resources
PCI: Using MMCONFIG at e0000000 - efffffff
ACPI: EC: GPE = 0x16, I/O: command/status = 0x66, data = 0x62
ACPI: EC: driver started in interrupt mode
ACPI: Power Resource [APPR] (off)
ACPI: No dock devices found.
ACPI: PCI Root Bridge [PCI0] (0000:00)
DMAR: Forcing write-buffer flush capability
pci 0000:00:02.0: reg 10 64bit mmio: [0x94000000-0x943fffff]
pci 0000:00:02.0: reg 18 64bit mmio: [0x80000000-0x8fffffff]
pci 0000:00:02.0: reg 20 io port: [0x4138-0x413f]
pci 0000:00:02.1: reg 10 64bit mmio: [0x94400000-0x944fffff]
pci 0000:00:03.0: reg 10 64bit mmio: [0x94827000-0x9482700f]
pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
pci 0000:00:03.0: PME# disabled
pci 0000:00:03.2: reg 10 io port: [0x4130-0x4137]
pci 0000:00:03.2: reg 14 io port: [0x414c-0x414f]
pci 0000:00:03.2: reg 18 io port: [0x4128-0x412f]
pci 0000:00:03.2: reg 1c io port: [0x4148-0x414b]
pci 0000:00:03.2: reg 20 io port: [0x4100-0x410f]
pci 0000:00:03.3: reg 10 io port: [0x4120-0x4127]
pci 0000:00:03.3: reg 14 32bit mmio: [0x94825000-0x94825fff]
pci 0000:00:19.0: reg 10 32bit mmio: [0x94800000-0x9481ffff]
pci 0000:00:19.0: reg 14 32bit mmio: [0x94824000-0x94824fff]
pci 0000:00:19.0: reg 18 io port: [0x40e0-0x40ff]
pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
pci 0000:00:19.0: PME# disabled
pci 0000:00:1a.0: reg 20 io port: [0x40c0-0x40df]
pci 0000:00:1a.1: reg 20 io port: [0x40a0-0x40bf]
pci 0000:00:1a.2: reg 20 io port: [0x4080-0x409f]
pci 0000:00:1a.7: reg 10 32bit mmio: [0x94826c00-0x94826fff]
pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1a.7: PME# disabled
pci 0000:00:1b.0: reg 10 64bit mmio: [0x94820000-0x94823fff]
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: PME# disabled
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.1: PME# disabled
pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.2: PME# disabled
pci 0000:00:1d.0: reg 20 io port: [0x4060-0x407f]
pci 0000:00:1d.1: reg 20 io port: [0x4040-0x405f]
pci 0000:00:1d.2: reg 20 io port: [0x4020-0x403f]
pci 0000:00:1d.7: reg 10 32bit mmio: [0x94826800-0x94826bff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
pci 0000:00:1f.2: reg 10 io port: [0x4118-0x411f]
pci 0000:00:1f.2: reg 14 io port: [0x4144-0x4147]
pci 0000:00:1f.2: reg 18 io port: [0x4110-0x4117]
pci 0000:00:1f.2: reg 1c io port: [0x4140-0x4143]
pci 0000:00:1f.2: reg 20 io port: [0x4000-0x401f]
pci 0000:00:1f.2: reg 24 32bit mmio: [0x94826000-0x948267ff]
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.2: PME# disabled
pci 0000:00:1c.0: bridge 32bit mmio: [0x94700000-0x947fffff]
pci 0000:02:00.0: reg 10 64bit mmio: [0x94600000-0x94601fff]
pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
pci 0000:02:00.0: PME# disabled
pci 0000:00:1c.1: bridge 32bit mmio: [0x94600000-0x946fffff]
pci 0000:00:1c.2: bridge io port: [0x2000-0x3fff]
pci 0000:00:1c.2: bridge 32bit mmio: [0x90000000-0x93ffffff]
pci 0000:44:06.0: reg 10 32bit mmio: [0x94500000-0x945007ff]
pci 0000:44:06.0: supports D1 D2
pci 0000:44:06.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:44:06.0: PME# disabled
pci 0000:44:06.1: reg 10 32bit mmio: [0x94500900-0x945009ff]
pci 0000:44:06.1: supports D1 D2
pci 0000:44:06.1: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:44:06.1: PME# disabled
pci 0000:44:06.2: reg 10 32bit mmio: [0x94500800-0x945008ff]
pci 0000:44:06.2: supports D1 D2
pci 0000:44:06.2: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:44:06.2: PME# disabled
pci 0000:00:1e.0: transparent bridge
pci 0000:00:1e.0: bridge 32bit mmio: [0x94500000-0x945fffff]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 *10 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
DMAR:Host address width 36
DMAR:DRHD (flags: 0x00000000)base: 0x00000000feb03000
DMAR:DRHD (flags: 0x00000000)base: 0x00000000feb01000
DMAR:DRHD (flags: 0x00000000)base: 0x00000000feb00000
DMAR:DRHD (flags: 0x00000001)base: 0x00000000feb02000
DMAR:RMRR base: 0x0000000076870000 end: 0x000000007687ffff
DMAR:RMRR base: 0x000000007ac00000 end: 0x000000007effffff
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
hpet0: 4 comparators, 64-bit 14.318180 MHz counter
pnp: PnP ACPI init
ACPI: bus type pnp registered
  alloc irq_desc for 23 on cpu 0 node 0
  alloc kstat_irqs on cpu 0 node 0
pnp: PnP ACPI: found 12 devices
ACPI: ACPI bus type pnp unregistered
system 00:01: iomem range 0xfed1c000-0xfed1ffff has been reserved
system 00:01: iomem range 0xfed10000-0xfed13fff has been reserved
system 00:01: iomem range 0xfed18000-0xfed18fff has been reserved
system 00:01: iomem range 0xfed19000-0xfed19fff has been reserved
system 00:01: iomem range 0xe0000000-0xefffffff has been reserved
system 00:01: iomem range 0xfec00000-0xfec00fff could not be reserved
system 00:01: iomem range 0xfed20000-0xfed3ffff has been reserved
system 00:01: iomem range 0xfed45000-0xfed8ffff has been reserved
system 00:05: iomem range 0xfed00000-0xfed003ff has been reserved
system 00:07: ioport range 0x200-0x27f has been reserved
system 00:07: ioport range 0x1000-0x1003 has been reserved
system 00:07: ioport range 0x1010-0x101f has been reserved
system 00:07: ioport range 0xffff-0xffff has been reserved
system 00:07: ioport range 0x400-0x47f has been reserved
system 00:07: ioport range 0x500-0x57f has been reserved
system 00:07: ioport range 0xef80-0xef9f has been reserved
pci 0000:00:1c.0: PCI bridge, secondary bus 0000:01
pci 0000:00:1c.0:   IO window: disabled
pci 0000:00:1c.0:   MEM window: 0x94700000-0x947fffff
pci 0000:00:1c.0:   PREFETCH window: disabled
pci 0000:00:1c.1: PCI bridge, secondary bus 0000:02
pci 0000:00:1c.1:   IO window: disabled
pci 0000:00:1c.1:   MEM window: 0x94600000-0x946fffff
pci 0000:00:1c.1:   PREFETCH window: disabled
pci 0000:00:1c.2: PCI bridge, secondary bus 0000:03
pci 0000:00:1c.2:   IO window: 0x2000-0x3fff
pci 0000:00:1c.2:   MEM window: 0x90000000-0x93ffffff
pci 0000:00:1c.2:   PREFETCH window: disabled
pci 0000:00:1e.0: PCI bridge, secondary bus 0000:44
pci 0000:00:1e.0:   IO window: disabled
pci 0000:00:1e.0:   MEM window: 0x94500000-0x945fffff
pci 0000:00:1e.0:   PREFETCH window: disabled
pci 0000:00:1c.0: enabling device (0000 -> 0002)
  alloc irq_desc for 16 on cpu 0 node 0
  alloc kstat_irqs on cpu 0 node 0
pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:1c.0: setting latency timer to 64
  alloc irq_desc for 17 on cpu 0 node 0
  alloc kstat_irqs on cpu 0 node 0
pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.1: setting latency timer to 64
pci 0000:00:1c.2: enabling device (0000 -> 0003)
  alloc irq_desc for 18 on cpu 0 node 0
  alloc kstat_irqs on cpu 0 node 0
pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
pci 0000:00:1c.2: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
pci_bus 0000:01: resource 1 mem: [0x94700000-0x947fffff]
pci_bus 0000:02: resource 1 mem: [0x94600000-0x946fffff]
pci_bus 0000:03: resource 0 io:  [0x2000-0x3fff]
pci_bus 0000:03: resource 1 mem: [0x90000000-0x93ffffff]
pci_bus 0000:44: resource 1 mem: [0x94500000-0x945fffff]
pci_bus 0000:44: resource 3 io:  [0x00-0xffff]
pci_bus 0000:44: resource 4 mem: [0x000000-0xffffffffffffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
NET: Registered protocol family 1
Trying to unpack rootfs image as initramfs...
Switched to high resolution mode on CPU 1
Switched to high resolution mode on CPU 0
Freeing initrd memory: 3109k freed
audit: initializing netlink socket (disabled)
type=2000 audit(1255960602.522:1): initialized
HugeTLB registered 2 MB page size, pre-allocated 0 pages
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
msgmni has been set to 3799
SELinux:  Registering netfilter hooks
alg: No test for stdrng (krng)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:00:02.0: Boot video device
  alloc irq_desc for 24 on cpu 0 node 0
  alloc kstat_irqs on cpu 0 node 0
pcieport-driver 0000:00:1c.0: irq 24 for MSI/MSI-X
pcieport-driver 0000:00:1c.0: setting latency timer to 64
  alloc irq_desc for 25 on cpu 0 node 0
  alloc kstat_irqs on cpu 0 node 0
pcieport-driver 0000:00:1c.1: irq 25 for MSI/MSI-X
pcieport-driver 0000:00:1c.1: setting latency timer to 64
  alloc irq_desc for 26 on cpu 0 node 0
  alloc kstat_irqs on cpu 0 node 0
pcieport-driver 0000:00:1c.2: irq 26 for MSI/MSI-X
pcieport-driver 0000:00:1c.2: setting latency timer to 64
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
Firmware did not grant requested _OSC control
Firmware did not grant requested _OSC control
Firmware did not grant requested _OSC control
Firmware did not grant requested _OSC control
Firmware did not grant requested _OSC control
Firmware did not grant requested _OSC control
pciehp: PCI Express Hot Plug Controller Driver version: 0.4
acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
acpiphp_glue: can't get bus number, assuming 0
acpiphp: Slot [1] registered
efifb: invalid framebuffer address
ACPI: AC Adapter [AC] (on-line)
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
ACPI: Power Button [PWRF]
input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input1
ACPI: Sleep Button [SLPB]
input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input2
ACPI: Lid Switch [LID]
ACPI: SSDT 000000007a9c7c98 00233 (v01  PmRef  Cpu0Ist 00003000 INTL 20060912)
ACPI: SSDT 000000007a9c5618 0057B (v01  PmRef  Cpu0Cst 00003001 INTL 20060912)
ACPI Warning (processor_throttling-0844): Invalid throttling state, reset [20090320]
Monitor-Mwait will be used to enter C-1 state
Monitor-Mwait will be used to enter C-2 state
Marking TSC unstable due to TSC halts in idle
ACPI: CPU0 (power states: C1[C1] C2[C2])
processor ACPI_CPU:00: registered as cooling_device0
ACPI: Processor [CPU0] (supports 8 throttling states)
ACPI: SSDT 000000007a9c6e18 001D7 (v01  PmRef    ApIst 00003000 INTL 20060912)
ACPI: SSDT 000000007a9c7f18 0008D (v01  PmRef    ApCst 00003000 INTL 20060912)
ACPI Warning (processor_throttling-0844): Invalid throttling state, reset [20090320]
ACPI: CPU1 (power states: C1[C1] C2[C2])
processor ACPI_CPU:01: registered as cooling_device1
ACPI: Processor [CPU1] (supports 8 throttling states)
thermal LNXTHERM:01: registered as thermal_zone0
ACPI: Thermal Zone [DTSZ] (39 C)
thermal LNXTHERM:02: registered as thermal_zone1
ACPI: Thermal Zone [BATZ] (27 C)
thermal LNXTHERM:03: registered as thermal_zone2
ACPI: Thermal Zone [CPUZ] (39 C)
thermal LNXTHERM:04: registered as thermal_zone3
ACPI: Thermal Zone [LOCZ] (37 C)
thermal LNXTHERM:05: registered as thermal_zone4
ACPI: Thermal Zone [SKNZ] (36 C)
Non-volatile memory driver v1.3
Linux agpgart interface v0.103
agpgart-intel 0000:00:00.0: Intel Mobile Intel® GM45 Express Chipset
agpgart-intel 0000:00:00.0: detected 65532K stolen memory
agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0x80000000
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
serial 0000:00:03.3: enabling device (0000 -> 0003)
serial 0000:00:03.3: PCI INT B -> GSI 17 (level, low) -> IRQ 17
0000:00:03.3: ttyS0 at I/O 0x4120 (irq = 17) is a 16550A
brd: module loaded
loop: module loaded
input: Macintosh mouse button emulation as /devices/virtual/input/input3
Driver 'sd' needs updating - please use bus_type methods
Driver 'sr' needs updating - please use bus_type methods
ahci 0000:00:1f.2: version 3.0
  alloc irq_desc for 21 on cpu 0 node 0
  alloc kstat_irqs on cpu 0 node 0
ahci 0000:00:1f.2: PCI INT A -> GSI 21 (level, low) -> IRQ 21
  alloc irq_desc for 27 on cpu 0 node 0
  alloc kstat_irqs on cpu 0 node 0
ahci 0000:00:1f.2: irq 27 for MSI/MSI-X
ahci: SSS flag set, parallel bus scan disabled
ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 4 ports 3 Gbps 0x3 impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio slum part ems 
ahci 0000:00:1f.2: setting latency timer to 64
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
ata1: SATA max UDMA/133 abar m2048@0x94826000 port 0x94826100 irq 27
ata2: SATA max UDMA/133 irq_stat 0x00000040, connection status changed irq 27
ata3: DUMMY
ata4: DUMMY
Fixed MDIO Bus: probed
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd 0000:00:1a.7: enabling device (0000 -> 0002)
  alloc irq_desc for 19 on cpu 0 node 0
  alloc kstat_irqs on cpu 0 node 0
ehci_hcd 0000:00:1a.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
ehci_hcd 0000:00:1a.7: setting latency timer to 64
ehci_hcd 0000:00:1a.7: EHCI Host Controller
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1a.7: debug port 1
ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
ehci_hcd 0000:00:1a.7: irq 19, io mem 0x94826c00
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.30.8-64.fc11.x86_64 ehci_hcd
usb usb1: SerialNumber: 0000:00:1a.7
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 6 ports detected
ehci_hcd 0000:00:1d.7: enabling device (0000 -> 0002)
  alloc irq_desc for 20 on cpu 0 node 0
  alloc kstat_irqs on cpu 0 node 0
ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 20 (level, low) -> IRQ 20
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
ehci_hcd 0000:00:1d.7: irq 20, io mem 0x94826800
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: EHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.30.8-64.fc11.x86_64 ehci_hcd
usb usb2: SerialNumber: 0000:00:1d.7
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 6 ports detected
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:1a.0: enabling device (0000 -> 0001)
uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1a.0: setting latency timer to 64
uhci_hcd 0000:00:1a.0: UHCI Host Controller
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1a.0: irq 16, io base 0x000040c0
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.30.8-64.fc11.x86_64 uhci_hcd
usb usb3: SerialNumber: 0000:00:1a.0
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
uhci_hcd 0000:00:1a.1: enabling device (0000 -> 0001)
uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
uhci_hcd 0000:00:1a.1: setting latency timer to 64
uhci_hcd 0000:00:1a.1: UHCI Host Controller
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1a.1: irq 17, io base 0x000040a0
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.30.8-64.fc11.x86_64 uhci_hcd
usb usb4: SerialNumber: 0000:00:1a.1
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
uhci_hcd 0000:00:1a.2: enabling device (0000 -> 0001)
uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1a.2: setting latency timer to 64
uhci_hcd 0000:00:1a.2: UHCI Host Controller
uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1a.2: irq 18, io base 0x00004080
usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: UHCI Host Controller
usb usb5: Manufacturer: Linux 2.6.30.8-64.fc11.x86_64 uhci_hcd
usb usb5: SerialNumber: 0000:00:1a.2
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.0: enabling device (0000 -> 0001)
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
uhci_hcd 0000:00:1d.0: irq 20, io base 0x00004060
usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb6: Product: UHCI Host Controller
usb usb6: Manufacturer: Linux 2.6.30.8-64.fc11.x86_64 uhci_hcd
usb usb6: SerialNumber: 0000:00:1d.0
usb usb6: configuration #1 chosen from 1 choice
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.1: enabling device (0000 -> 0001)
  alloc irq_desc for 22 on cpu 0 node 0
  alloc kstat_irqs on cpu 0 node 0
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 22 (level, low) -> IRQ 22
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
uhci_hcd 0000:00:1d.1: irq 22, io base 0x00004040
usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb7: Product: UHCI Host Controller
usb usb7: Manufacturer: Linux 2.6.30.8-64.fc11.x86_64 uhci_hcd
usb usb7: SerialNumber: 0000:00:1d.1
usb usb7: configuration #1 chosen from 1 choice
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.2: enabling device (0000 -> 0001)
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
uhci_hcd 0000:00:1d.2: irq 18, io base 0x00004020
usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb8: Product: UHCI Host Controller
usb usb8: Manufacturer: Linux 2.6.30.8-64.fc11.x86_64 uhci_hcd
usb usb8: SerialNumber: 0000:00:1d.2
usb usb8: configuration #1 chosen from 1 choice
hub 8-0:1.0: USB hub found
hub 8-0:1.0: 2 ports detected
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
i8042.c: Detected active multiplexing controller, rev 1.1.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX0 port at 0x60,0x64 irq 12
serio: i8042 AUX1 port at 0x60,0x64 irq 12
serio: i8042 AUX2 port at 0x60,0x64 irq 12
serio: i8042 AUX3 port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
rtc_cmos 00:08: RTC can wake from S4
rtc_cmos 00:08: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
cpuidle: using governor ladder
cpuidle: using governor menu
EFI Variables Facility v0.08 2004-May-17
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
ACPI: Battery Slot [BAT0] (battery present)
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
nf_conntrack.acct=1 kernel paramater, acct=1 nf_conntrack module option or
sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
ip_tables: (C) 2000-2006 Netfilter Core Team
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 17
PM: Resume from disk failed.
registered taskstats version 1
  Magic number: 13:720:938
Initalizing network drop monitor service
usb 1-2: new high speed USB device using ehci_hcd and address 3
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
ata1.00: ATA-8: SAMSUNG HS08XJF, 3AA10050, max UDMA/100
ata1.00: 156301488 sectors, multi 16: LBA48 
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
ata1.00: configured for UDMA/100
scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HS08XJF  3AA1 PQ: 0 ANSI: 5
sd 0:0:0:0: Attached scsi generic sg0 type 0
sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors: (80.0 GB/74.5 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3
usb 1-2: New USB device found, idVendor=03f0, idProduct=201d
usb 1-2: New USB device strings: Mfr=2, Product=1, SerialNumber=0
usb 1-2: Product: HP un2400 Mobile Broadband Module
usb 1-2: Manufacturer: HP un2400 Mobile Broadband Module
usb 1-2: configuration #1 chosen from 1 choice
sd 0:0:0:0: [sda] Attached SCSI disk
input: PS/2 Generic Mouse as /devices/platform/i8042/serio1/input/input5
usb 1-5: new high speed USB device using ehci_hcd and address 5
Clocksource tsc unstable (delta = -213797952 ns)
usb 1-5: New USB device found, idVendor=04f2, idProduct=b082
usb 1-5: New USB device strings: Mfr=2, Product=1, SerialNumber=3
usb 1-5: Product: CKA7227
usb 1-5: Manufacturer: Chicony Electronics Co., Ltd.
usb 1-5: SerialNumber: SN0001
usb 1-5: configuration #1 chosen from 1 choice
usb 3-1: new full speed USB device using uhci_hcd and address 2
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
ata2.00: ATAPI: Optiarc  DVD RW AD-7910S, 1.81, max UDMA/100
ata2.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
ata2.00: configured for UDMA/100
usb 3-1: New USB device found, idVendor=03f0, idProduct=171d
usb 3-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 3-1: Product: HP Integrated Module
usb 3-1: Manufacturer: Broadcom Corp
usb 3-1: configuration #1 chosen from 1 choice
scsi 1:0:0:0: CD-ROM            Optiarc  DVD RW AD-7910S  1.81 PQ: 0 ANSI: 5
sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 1:0:0:0: Attached scsi CD-ROM sr0
sr 1:0:0:0: Attached scsi generic sg1 type 5
Freeing unused kernel memory: 1348k freed
Write protecting the kernel read-only data: 6728k
Synaptics Touchpad, model: 1, fw: 7.0, id: 0x1a0b1, caps: 0xd04711/0xa00000
input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio4/input/input6
usb 4-1: new full speed USB device using uhci_hcd and address 2
usb 4-1: New USB device found, idVendor=08ff, idProduct=2810
usb 4-1: New USB device strings: Mfr=0, Product=1, SerialNumber=0
usb 4-1: Product: Fingerprint Sensor
usb 4-1: configuration #1 chosen from 1 choice
[drm] Initialized drm 1.1.0 20060810
i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
i915 0000:00:02.0: setting latency timer to 64
  alloc irq_desc for 28 on cpu 0 node 0
  alloc kstat_irqs on cpu 0 node 0
i915 0000:00:02.0: irq 28 for MSI/MSI-X
[drm] TV-13: set mode NTSC 480i 0
allocated 1280x800 fb: 0x04020000, bo ffff8800778e3a80
Console: switching to colour frame buffer device 160x50
[drm] LVDS-8: set mode 1280x800 15
fb0: inteldrmfb frame buffer device
registered panic notifier
acpi device:07: registered as cooling_device2
input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:03/input/input7
ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
type=1404 audit(1255960606.220:2): enforcing=1 old_enforcing=0 auid=4294967295 ses=4294967295
SELinux: 8192 avtab hash slots, 130119 rules.
SELinux: 8192 avtab hash slots, 130119 rules.
SELinux:  8 users, 12 roles, 2769 types, 129 bools, 1 sens, 1024 cats
SELinux:  74 classes, 130119 rules
SELinux:  Completing initialization.
SELinux:  Setting up existing superblocks.
SELinux: initialized (dev sda1, type ext3), uses xattr
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
SELinux: initialized (dev usbfs, type usbfs), uses genfs_contexts
SELinux: initialized (dev selinuxfs, type selinuxfs), uses genfs_contexts
SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses genfs_contexts
SELinux: initialized (dev devpts, type devpts), uses transition SIDs
SELinux: initialized (dev inotifyfs, type inotifyfs), uses genfs_contexts
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
SELinux: initialized (dev anon_inodefs, type anon_inodefs), uses genfs_contexts
SELinux: initialized (dev pipefs, type pipefs), uses task SIDs
SELinux: initialized (dev debugfs, type debugfs), uses genfs_contexts
SELinux: initialized (dev sockfs, type sockfs), uses task SIDs
SELinux: initialized (dev proc, type proc), uses genfs_contexts
SELinux: initialized (dev bdev, type bdev), uses genfs_contexts
SELinux: initialized (dev rootfs, type rootfs), uses genfs_contexts
SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
type=1403 audit(1255960606.737:3): policy loaded auid=4294967295 ses=4294967295
udev: starting version 141
usbcore: registered new interface driver usbserial
USB Serial support registered for generic
usbcore: registered new interface driver usbserial_generic
usbserial: USB Serial Driver core
USB Serial support registered for Qualcomm USB modem
qcserial 1-2:1.0: Qualcomm USB modem converter detected
usb 1-2: Qualcomm USB modem converter now attached to ttyUSB0
usbcore: registered new interface driver qcserial
Linux video capture interface: v2.00
uvcvideo: Found UVC 1.00 device CKA7227 (04f2:b082)
input: CKA7227 as /devices/pci0000:00/0000:00:1a.7/usb1/1-5/1-5:1.0/input/input8
usbcore: registered new interface driver uvcvideo
USB Video Class driver (v0.1.0)
cfg80211: Calling CRDA to update world regulatory domain
Bluetooth: Core ver 2.15
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
pata_acpi 0000:00:03.2: enabling device (0000 -> 0001)
pata_acpi 0000:00:03.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
pata_acpi 0000:00:03.2: setting latency timer to 64
pata_acpi 0000:00:03.2: PCI INT C disabled
ACPI: WMI: Mapper loaded
iTCO_vendor_support: vendor-support=0
lib80211: common routines for IEEE802.11 drivers
lib80211_crypt: registered algorithm 'NULL'
ricoh-mmc: Ricoh MMC Controller disabling driver
ricoh-mmc: Copyright(c) Philip Langdale
ricoh-mmc: Ricoh MMC controller found at 0000:44:06.2 [1180:0843] (rev 12)
ricoh-mmc: Controller is now disabled.
input: PC Speaker as /devices/platform/pcspkr/input/input9
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.05
iTCO_wdt: Found a ICH9M-E TCO device (Version=2, TCOBASE=0x0460)
iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
lis3lv02d: laptop model unknown, using default axes configuration
lis3lv02d: 1-byte sensor found
input: ST LIS3LV02DL Accelerometer as /devices/platform/lis3lv02d/input/input10
lis3_init_device: irq 23
lis3: registering device
Registered led device: hp::hddprotect
lis3lv02d driver loaded.
Bluetooth: Generic Bluetooth USB driver ver 0.5
usbcore: registered new interface driver btusb
e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.4-k4
e1000e: Copyright (c) 1999-2008 Intel Corporation.
e1000e 0000:00:19.0: enabling device (0000 -> 0002)
e1000e 0000:00:19.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
e1000e 0000:00:19.0: setting latency timer to 64
  alloc irq_desc for 29 on cpu 0 node 0
  alloc kstat_irqs on cpu 0 node 0
e1000e 0000:00:19.0: irq 29 for MSI/MSI-X
tpm_inf_pnp 00:04: Found GTPM with ID IFX0102
tpm_inf_pnp 00:04: TPM found: config base 0xfe00, data base 0xfe80, chip version 0x000b, vendor id 0x15d1 (Infineon), product id 0x000b (SLB 9635 TT 1.2)
SELinux: initialized (dev securityfs, type securityfs), uses genfs_contexts
0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:23:5a:34:9e:20
0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
0000:00:19.0: eth0: MAC: 7, PHY: 8, PBA No: 1052ff-0ff
sdhci: Secure Digital Host Controller Interface driver
sdhci: Copyright(c) Pierre Ossman
sdhci-pci 0000:44:06.1: SDHCI controller found [1180:0822] (rev 22)
sdhci-pci 0000:44:06.1: PCI INT B -> GSI 22 (level, low) -> IRQ 22
Registered led device: mmc0::
mmc0: SDHCI controller on PCI [0000:44:06.1] using PIO
iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, 1.3.27kds
iwlagn: Copyright(c) 2003-2009 Intel Corporation
iwlagn 0000:02:00.0: enabling device (0000 -> 0002)
iwlagn 0000:02:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
iwlagn 0000:02:00.0: setting latency timer to 64
iwlagn 0000:02:00.0: Detected Intel Wireless WiFi Link 5100AGN REV=0x54
iwlagn 0000:02:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
  alloc irq_desc for 30 on cpu 0 node 0
  alloc kstat_irqs on cpu 0 node 0
iwlagn 0000:02:00.0: irq 30 for MSI/MSI-X
firewire_ohci 0000:44:06.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
firewire_ohci 0000:44:06.0: setting latency timer to 64
firewire_ohci: Added fw-ohci device 0000:44:06.0, OHCI version 1.10
phy0: Selected rate control algorithm 'iwl-agn-rs'
firewire_core: created device fw0: GUID 5566778811223344, S400
HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
HDA Intel 0000:00:1b.0: enabling device (0000 -> 0002)
HDA Intel 0000:00:1b.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
HDA Intel 0000:00:1b.0: setting latency timer to 64
input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input11
cfg80211: World regulatory domain updated:
	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
	(2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
	(2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
	(2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
	(5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
	(5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
device-mapper: multipath: version 1.0.5 loaded
EXT3 FS on sda1, internal journal
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
SELinux: initialized (dev sda3, type vfat), uses genfs_contexts
Adding 2047992k swap on /dev/sda2.  Priority:-1 extents:1 across:2047992k 
SELinux: initialized (dev binfmt_misc, type binfmt_misc), uses genfs_contexts

-- 
Matthew Garrett | mjg59@srcf.ucam.org
