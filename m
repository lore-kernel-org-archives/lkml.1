Return-Path: <linux-kernel-owner+w=401wt.eu-S1754684AbXJXCZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684AbXJXCZv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 22:25:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752925AbXJXCZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 22:25:44 -0400
Received: from mail.suse.de ([195.135.220.2]:51028 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752745AbXJXCZn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 22:25:43 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: linux-kernel@vger.kernel.org
Subject: nmi loop in 2.6.23-g0895e91d with nmi watchdog = 1
Date: Wed, 24 Oct 2007 04:25:35 +0200
User-Agent: KMail/1.9.6
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710240425.35427.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


FYI -- i had an unknown NMI loop once while booting a recent git kernel on a core2
system with nmi_watchdog=1. Unfortunately I couldn't reproduce it later;
so it's likely some race.

This is the first time this happened so I presume it's a new problem.

-Andi

Console: colour VGA+ 80x60
console [tty0] enabled
Linux version 2.6.23-g0895e91d (andi@basil) (gcc version 4.1.2 20061115 (prerelease) (SUSE Linux)) #2 SMP Tue Oct 23 22:51:10 CEST 2007
Command line: ip=dhcp nfsroot=xxxx:/home/nfsroot/gaston root=/dev/nfs debug vga=0x0f07 rw pci=noacpi earlyprintk=serial,ttyS0,115200 kst
ack=512 console=tty0 console=ttyS0,115200 earlyprintk=serial,ttyS0,115200 nmi_watchdog=1 BOOT_IMAGE=bzImage 
BIOS-provided physical RAM map:
...
ACPI: PM-Timer IO Port: 0x408
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Processor #1
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
ACPI: HPET id: 0x8086a201 base: 0xfed00000
Using ACPI for processor (LAPIC) configuration information
Intel MultiProcessor Specification v1.4
MPTABLE: OEM ID:  MPTABLE: Product ID:  MPTABLE: APIC at: 0xFEE00000
Setting APIC routing to flat
BIOS bug, no explicit IRQ entries, using default mptable. (tell your hw vendor)
Processors: 2
...
Memory: 2034512k/2071552k available (3433k kernel code, 35572k reserved, 1958k data, 332k init)
Calibrating delay using timer specific routine.. 4803.42 BogoMIPS (lpj=9606841)
Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
Mount-cache hash table entries: 256
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU 0/0 -> Node 0
using mwait in idle threads.
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU0: Thermal monitoring enabled (TM2)
SMP alternatives: switching to UP code
ACPI: Core revision 20070126
Using local APIC timer interrupts.
APIC timer calibration result 16667236
Detected 16.667 MHz APIC timer.
APIC timer registered as dummy, due to nmi_watchdog=1!
SMP alternatives: switching to SMP code
Booting processor 1/2 APIC 0x1
Initializing CPU#1
Calibrating delay using timer specific routine.. 4800.16 BogoMIPS (lpj=9600338)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU 1/1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU1: Thermal monitoring enabled (TM2)
Intel(R) Core(TM)2 CPU          6600  @ 2.40GHz stepping 06
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
testing NMI watchdog ... CPU#0: NMI appears to be stuck (0->0)!
OK.
net_namespace: 120 bytes
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: BIOS Bug: MCFG area at f0000000 is not E820-reserved
PCI: Not using MMCONFIG.
PCI: Using configuration type 1
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
Uhhuh. NMI received for unknown reason 2d.
Do you have a strange power saving mode enabled?
Dazed and confused, but trying to continue
Uhhuh. NMI received for unknown reason 3d.
Do you have a strange power saving mode enabled?
Dazed and confused, but trying to continue
Uhhuh. NMI received for unknown reason 3d.
Do you have a strange power saving mode enabled?
Dazed and confused, but trying to continue
Uhhuh. NMI received for unknown reason 2d.
Do you have a strange power saving mode enabled?
Dazed and confused, but trying to continue
... messages continue forever ...

-Andi
