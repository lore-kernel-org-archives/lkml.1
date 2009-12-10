Return-Path: <linux-kernel-owner+w=401wt.eu-S1759330AbZLJJLF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759330AbZLJJLF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 04:11:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757990AbZLJJK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 04:10:56 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:59290 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758043AbZLJJKf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 04:10:35 -0500
Date: Thu, 10 Dec 2009 10:10:41 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu
Subject: current -git fails to boot on nehalem-ex
Message-ID: <20091210091040.GG8742@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

As written in the subject, it just hard hangs before writing anything on
the console. With earlyprintk, I captured the failure, see below.

I'll try and bisect this, but it takes some time (since the bios and
post process takes forever). I just updated the firmware on the box as
well, but it did boot 2.6.32 (and RHEL5 boots fine too). Of course that
doesn't rule out a BIOS bug.

kernel  /vmlinuz-2.6 root=/dev/sda3 ro console=ttyS0,115200 console=tty0 earlyprintk=serial,ttyS0,115200
   [Linux-bzImage, setup=0x3200, size=0x298f90]


               [    0.000000] Linux version 2.6.32 (axboe@nehalem) (gcc version 4.3.2 (Debian 4.3.2-1.1) ) #35 SMP Thu Dec 10 09:47:51 CET 2009            *    
[    0.000000] Command line: root=/dev/sda3 ro console=ttyS0,115200 console=tty0 earlyprintk=serial,ttyS0,115200                                           *    
[    0.000000] BIOS-provided physical RAM map:                             *    
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009a400 (usable)    *    
[    0.000000]  BIOS-e820: 000000000009a400 - 00000000000a0000 (reserved)  *    
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)***    
[    0.000000]  BIOS-e820: 0000000000100000 - 0000000078c75000 (usable)         
[    0.000000]  BIOS-e820: 0000000078c75000 - 0000000078e89000 (ACPI NVS)       
[    0.000000]  BIOS-e820: 0000000078e89000 - 000000007924e000 (ACPI data)      
[    0.000000]  BIOS-e820: 000000007924e000 - 00000000792c2000 (reserved)       
[    0.000000]  BIOS-e820: 00000000792c2000 - 00000000792d2000 (ACPI data)      
[    0.000000]  BIOS-e820: 00000000792d2000 - 00000000792e7000 (reserved)       
[    0.000000]  BIOS-e820: 00000000792e7000 - 0000000079301000 (ACPI data)      
[    0.000000]  BIOS-e820: 0000000079301000 - 0000000079303000 (reserved)      
[    0.000000]  BIOS-e820: 0000000079303000 - 0000000079305000 (ACPI data)
[    0.000000]  BIOS-e820: 0000000079305000 - 0000000079310000 (reserved)
[    0.000000]  BIOS-e820: 0000000079310000 - 0000000079314000 (ACPI data)
[    0.000000]  BIOS-e820: 0000000079314000 - 0000000079319000 (reserved)
[    0.000000]  BIOS-e820: 0000000079319000 - 0000000079336000 (ACPI data)
[    0.000000]  BIOS-e820: 0000000079336000 - 0000000079358000 (reserved)
[    0.000000]  BIOS-e820: 0000000079358000 - 0000000079388000 (ACPI data)
[    0.000000]  BIOS-e820: 0000000079388000 - 00000000793c9000 (reserved)
[    0.000000]  BIOS-e820: 00000000793c9000 - 000000007968f000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007968f000 - 00000000796bb000 (reserved)
[    0.000000]  BIOS-e820: 00000000796bb000 - 00000000799d8000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000799d8000 - 0000000079bd8000 (ACPI NVS)
[    0.000000]  BIOS-e820: 0000000079bd8000 - 0000000079dc7000 (ACPI data)
[    0.000000]  BIOS-e820: 0000000079dc7000 - 0000000079dcb000 (reserved)
[    0.000000]  BIOS-e820: 0000000079dcb000 - 0000000079e1c000 (ACPI data)
[    0.000000]  BIOS-e820: 0000000079e1c000 - 0000000079e87000 (reserved)
[    0.000000]  BIOS-e820: 0000000079e87000 - 000000007bd5f000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007bd5f000 - 000000007be4f000 (reserved)
[    0.000000]  BIOS-e820: 000000007be4f000 - 000000007bf87000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007bf87000 - 000000007bfcf000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007bfcf000 - 000000007bfff000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007bfff000 - 0000000090000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fc000000 - 00000000fd000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000001080000000 (usable)
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.5 present.
[    0.000000] last_pfn = 0x1080000 max_arch_pfn = 0x400000000
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] last_pfn = 0x78c75 max_arch_pfn = 0x400000000
[    0.000000] init_memory_mapping: 0000000000000000-0000000078c75000
[    0.000000] init_memory_mapping: 0000000100000000-0000001080000000
[    0.000000] ACPI: RSDP 00000000000f0410 00024 (v02 QUANTA)
[    0.000000] ACPI: XSDT 000000007bffe120 000BC (v01 QUANTA QSSC-S4R 00000000      01000013)
[    0.000000] ACPI: FACP 000000007bffd000 000F4 (v04 QUANTA QSSC-S4R 00000000 MSFT 0100000D)
[    0.000000] ACPI: DSDT 000000007bfe3000 19BAD (v02 QUANTA QSSC-S4R 00000003 MSFT 0100000D)
[    0.000000] ACPI: FACS 000000007bf87000 00040
[    0.000000] ACPI: APIC 000000007bfe2000 003E4 (v02 QUANTA QSSC-S4R 00000000 MSFT 0100000D)
[    0.000000] ACPI: MSCT 000000007bfe1000 00090 (v01 QUANTA QSSC-S4R 00000001 MSFT 0100000D)
[    0.000000] ACPI: MCFG 000000007bfe0000 0003C (v01 QUANTA QSSC-S4R 00000001 MSFT 0100000D)
[    0.000000] ACPI: HPET 000000007bfdf000 00038 (v01 QUANTA QSSC-S4R 00000001 MSFT 0100000D)
[    0.000000] ACPI: SLIT 000000007bfde000 0003C (v01 QUANTA QSSC-S4R 00000001 MSFT 0100000D)
[    0.000000] ACPI: SRAT 000000007bfdd000 00930 (v02 QUANTA QSSC-S4R 00000001 MSFT 0100000D)
[    0.000000] ACPI: SPCR 000000007bfdc000 00050 (v01 QUANTA QSSC-S4R 00000000 MSFT 0100000D)
[    0.000000] ACPI: WDDT 000000007bfdb000 00040 (v01 QUANTA QSSC-S4R 00000000 MSFT 0100000D)
[    0.000000] ACPI: SSDT 000000007bf4a000 3CFA4 (v02 QUANTA QSSC-S4R 00004000 INTL 20061109)
[    0.000000] ACPI: SSDT 000000007bfda000 00174 (v02 QUANTA QSSC-S4R 00004000 INTL 20061109)
[    0.000000] ACPI: PMCT 000000007bfd9000 00064 (v01 QUANTA QSSC-S4R 00000000 MSFT 0100000D)
[    0.000000] ACPI: MIGT 000000007bfd8000 00040 (v01 QUANTA QSSC-S4R 00000000 MSFT 0100000D)
[    0.000000] ACPI: TCPA 000000007bfd5000 00032 (v00 QUANTA QSSC-S4R 00000000      00000000)
[    0.000000] ACPI: HEST 000000007bfd4000 005D0 (v01 QUANTA QSSC-S4R 00000001 INTL 00000001)
[    0.000000] ACPI: BERT 000000007bfd3000 00030 (v01 QUANTA QSSC-S4R 00000001 INTL 00000001)
[    0.000000] ACPI: ERST 000000007bfd2000 00230 (v01 QUANTA QSSC-S4R 00000001 INTL 00000001)
[    0.000000] ACPI: EINJ 000000007bfd1000 00130 (v01 QUANTA QSSC-S4R 00000001 INTL 00000001)
[    0.000000] ACPI: DMAR 000000007bfd0000 00350 (v01 QUANTA QSSC-S4R 00000001 MSFT 0100000D)
[    0.000000] found SMP MP-table at [ffff8800000fdd80] fdd80
[    0.000000] Kernel panic - not syncing: Overlapping early reservations 12-f011 MP-table mpc to 0-fff BIOS data page
[    0.000000] 
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.32 #35
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff813c9eeb>] panic+0xa0/0x16a
[    0.000000]  [<ffffffff8167d280>] ? reserve_early_overlap_ok+0x2e/0x39
[    0.000000]  [<ffffffff8167d234>] ? drop_overlaps_that_are_ok+0x101/0x11f
[    0.000000]  [<ffffffff8167d133>] drop_overlaps_that_are_ok+0x0/0x11f
[    0.000000]  [<ffffffff8167d2c6>] reserve_early+0x3b/0x3d
[    0.000000]  [<ffffffff81683248>] smp_scan_config+0xe7/0x10e
[    0.000000]  [<ffffffff816832a9>] default_find_smp_config+0x3a/0x60
[    0.000000]  [<ffffffff8167b0be>] setup_arch+0x6ae/0xa88
[    0.000000]  [<ffffffff816789ff>] start_kernel+0x82/0x412
[    0.000000]  [<ffffffff81678289>] x86_64_start_reservations+0x99/0xb9
[    0.000000]  [<ffffffff81678389>] x86_64_start_kernel+0xe0/0xf2

-- 
Jens Axboe

