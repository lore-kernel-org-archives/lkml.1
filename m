Return-Path: <linux-kernel-owner+w=401wt.eu-S1753993AbZBCLiN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993AbZBCLiN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 06:38:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751859AbZBCLh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 06:37:58 -0500
Received: from hpsmtp-eml20.KPNXCHANGE.COM ([213.75.38.85]:14662 "EHLO
	hpsmtp-eml20.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751763AbZBCLh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 06:37:56 -0500
From: Frans Pop <elendil@planet.nl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Comparison between .28 and .29-rc3 for STR cycle
Date: Tue, 3 Feb 2009 12:37:52 +0100
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902031237.53579.elendil@planet.nl>
X-OriginalArrivalTime: 03 Feb 2009 11:37:54.0515 (UTC) FILETIME=[DA70EA30:01C985F3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

I've compared the log messages during a suspend/resume (STR) cycle for my
HP 2510p notebook. In general the changes look OK, but I noticed a few
things that I think may be worth looking into.

The analysis is based on v2.6.29-rc3-100-gf2257b7 with the following relevant
extra patches:
- PCI PM: Fix suspend error paths and testing facility breakage
- ricoh_mmc: Use suspend_late/resume_early

Below a *pseudo* diff between messages from .28-rc7 and .29-rc3-100. I've
concentrated on showing _what_ messages are shown, not _when_ they are shown.
Messages are shown in the order they appear with .29.

I've added some comments in the "diff" to indicate points of interest.

Summary of changes:
- Most config restores now happen during resume-early, but there are still
  some displayed later, including some duplicates.
- There are a lot more "PME# disabled" messages, both during suspend (which
  seems redundant?) and during resume. There are a few duplicates and it
  happen for a few devices for which it is not done during normal boot.

Cheers,
FJP

Pseudo diff
-----------
  Freezing user space processes ... (elapsed 0.00 seconds) done.
  Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
  Suspending console(s) (use no_console_suspend to debug)
# I would not have expected this next line to disappear. Device is VGA controller.
 -pci 0000:00:02.0: PCI INT A disabled
  sd 0:0:0:0: [sda] Synchronizing SCSI cache
  sd 0:0:0:0: [sda] Stopping disk
  ACPI handle has no context!
  ACPI handle has no context!
 +sdhci-pci 0000:02:06.2: PME# disabled
  sdhci-pci 0000:02:06.2: PCI INT C disabled
  ACPI handle has no context!
  ACPI handle has no context!
  iwlagn 0000:10:00.0: PCI INT A disabled
  ata2: port disabled. ignoring.
  ata_piix 0000:00:1f.1: PCI INT A disabled
  ehci_hcd 0000:00:1d.7: PCI INT A disabled
 +ehci_hcd 0000:00:1d.7: PME# disabled
  uhci_hcd 0000:00:1d.2: PCI INT C disabled
  uhci_hcd 0000:00:1d.1: PCI INT B disabled
  uhci_hcd 0000:00:1d.0: PCI INT A disabled
  HDA Intel 0000:00:1b.0: PCI INT A disabled
  HDA Intel 0000:00:1b.0: power state changed by ACPI to D3
  ehci_hcd 0000:00:1a.7: PCI INT C disabled
 +ehci_hcd 0000:00:1a.7: PME# disabled
  uhci_hcd 0000:00:1a.1: PCI INT B disabled
  uhci_hcd 0000:00:1a.0: PCI INT A disabled
  e1000e 0000:00:19.0: PME# enabled
# Not a change, but still strange that next 2 lines are duplicated.
  e1000e 0000:00:19.0: wake-up capability enabled by ACPI
  e1000e 0000:00:19.0: PME# enabled
  e1000e 0000:00:19.0: wake-up capability enabled by ACPI
  e1000e 0000:00:19.0: PCI INT A disabled
  ACPI handle has no context!
  ACPI: Preparing to enter system sleep state S3
  Disabling non-boot CPUs ...
  CPU 1 is now offline
  SMP alternatives: switching to UP code
  CPU0 attaching NULL sched-domain.
  CPU1 attaching NULL sched-domain.
  CPU0 attaching NULL sched-domain.
  CPU1 is down
  ricoh-mmc: Suspending.
  ricoh-mmc: Controller is now re-enabled.
  Extended CMOS year: 2000
  x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
  Back to C!
  Extended CMOS year: 2000
  pci 0000:00:02.0: restoring config space at offset 0x8 (was 0x1, writing 0x2001)
  pci 0000:00:02.1: restoring config space at offset 0x4 (was 0x4, writing 0xe0500004)
  pci 0000:00:02.1: restoring config space at offset 0x1 (was 0x900000, writing 0x900007)
  pci 0000:00:03.0: restoring config space at offset 0xf (was 0x100, writing 0x1ff)
  pci 0000:00:03.0: restoring config space at offset 0x4 (was 0xfed12004, writing 0xe0600004)
  pci 0000:00:03.2: restoring config space at offset 0xf (was 0x300, writing 0x30b)
  pci 0000:00:03.2: restoring config space at offset 0x8 (was 0x1, writing 0x2031)
  pci 0000:00:03.2: restoring config space at offset 0x7 (was 0x1, writing 0x2021)
  pci 0000:00:03.2: restoring config space at offset 0x6 (was 0x1, writing 0x2019)
  pci 0000:00:03.2: restoring config space at offset 0x5 (was 0x1, writing 0x2011)
  pci 0000:00:03.2: restoring config space at offset 0x4 (was 0x1, writing 0x2009)
  pci 0000:00:03.2: restoring config space at offset 0x1 (was 0xb00000, writing 0xb00001)
  serial 0000:00:03.3: restoring config space at offset 0xf (was 0x200, writing 0x20a)
  serial 0000:00:03.3: restoring config space at offset 0x5 (was 0x0, writing 0xe0601000)
  serial 0000:00:03.3: restoring config space at offset 0x4 (was 0x1, writing 0x2041)
  serial 0000:00:03.3: restoring config space at offset 0x1 (was 0xb00000, writing 0xb00007)
  e1000e 0000:00:19.0: restoring config space at offset 0xf (was 0x100, writing 0x10b)
  e1000e 0000:00:19.0: restoring config space at offset 0x6 (was 0x1, writing 0x2061)
  e1000e 0000:00:19.0: restoring config space at offset 0x5 (was 0x0, writing 0xe0640000)
  e1000e 0000:00:19.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100007)
  uhci_hcd 0000:00:1a.0: restoring config space at offset 0xf (was 0x100, writing 0x10a)
  uhci_hcd 0000:00:1a.0: restoring config space at offset 0x8 (was 0x1, writing 0x2081)
 +uhci_hcd 0000:00:1a.0: restoring config space at offset 0x1 (was 0x2800000, writing 0x2800001)
  uhci_hcd 0000:00:1a.1: restoring config space at offset 0xf (was 0x200, writing 0x20a)
  uhci_hcd 0000:00:1a.1: restoring config space at offset 0x8 (was 0x1, writing 0x20a1)
 +uhci_hcd 0000:00:1a.1: restoring config space at offset 0x1 (was 0x2800000, writing 0x2800001)
  ehci_hcd 0000:00:1a.7: restoring config space at offset 0xf (was 0x300, writing 0x30b)
  ehci_hcd 0000:00:1a.7: restoring config space at offset 0x4 (was 0x0, writing 0xe0641000)
 +ehci_hcd 0000:00:1a.7: restoring config space at offset 0x1 (was 0x2900000, writing 0x2900002)
  HDA Intel 0000:00:1b.0: restoring config space at offset 0xf (was 0x100, writing 0x10a)
  HDA Intel 0000:00:1b.0: restoring config space at offset 0x3 (was 0x0, writing 0x10)
  HDA Intel 0000:00:1b.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100002)
  pcieport-driver 0000:00:1c.0: restoring config space at offset 0xf (was 0x100, writing 0x4010a)
  pcieport-driver 0000:00:1c.0: restoring config space at offset 0x9 (was 0x10001, writing 0x1fff1)
  pcieport-driver 0000:00:1c.0: restoring config space at offset 0x8 (was 0x0, writing 0xfff0)
  pcieport-driver 0000:00:1c.0: restoring config space at offset 0x7 (was 0x0, writing 0x200000f0)
  pcieport-driver 0000:00:1c.0: restoring config space at offset 0x6 (was 0x0, writing 0x80800)
  pcieport-driver 0000:00:1c.0: restoring config space at offset 0x3 (was 0x810000, writing 0x810010)
  pcieport-driver 0000:00:1c.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100407)
# Weird, we already did a config restore at offset 0x7 4 lines up!
# So where does this next line come from?
 +pcieport-driver 0000:00:1c.0: restoring config space at offset 0x7 (was 0xf0, writing 0x200000f0)
  pcieport-driver 0000:00:1c.1: restoring config space at offset 0xf (was 0x200, writing 0x4020a)
  pcieport-driver 0000:00:1c.1: restoring config space at offset 0x9 (was 0x10001, writing 0x1fff1)
  pcieport-driver 0000:00:1c.1: restoring config space at offset 0x8 (was 0x0, writing 0xe000e000)
  pcieport-driver 0000:00:1c.1: restoring config space at offset 0x7 (was 0x0, writing 0xf0)
  pcieport-driver 0000:00:1c.1: restoring config space at offset 0x3 (was 0x810000, writing 0x810010)
  pcieport-driver 0000:00:1c.1: restoring config space at offset 0x1 (was 0x100000, writing 0x100407)
  uhci_hcd 0000:00:1d.0: restoring config space at offset 0xf (was 0x100, writing 0x10a)
  uhci_hcd 0000:00:1d.0: restoring config space at offset 0x8 (was 0x1, writing 0x20c1)
 +uhci_hcd 0000:00:1d.0: restoring config space at offset 0x1 (was 0x2800000, writing 0x2800001)
  uhci_hcd 0000:00:1d.1: restoring config space at offset 0xf (was 0x200, writing 0x20b)
  uhci_hcd 0000:00:1d.1: restoring config space at offset 0x8 (was 0x1, writing 0x20e1)
 +uhci_hcd 0000:00:1d.1: restoring config space at offset 0x1 (was 0x2800000, writing 0x2800001)
  uhci_hcd 0000:00:1d.2: restoring config space at offset 0xf (was 0x300, writing 0x30b)
  uhci_hcd 0000:00:1d.2: restoring config space at offset 0x8 (was 0x1, writing 0x2101)
 +uhci_hcd 0000:00:1d.2: restoring config space at offset 0x1 (was 0x2800000, writing 0x2800001)
  ehci_hcd 0000:00:1d.7: restoring config space at offset 0xf (was 0x100, writing 0x10a)
  ehci_hcd 0000:00:1d.7: restoring config space at offset 0x4 (was 0x0, writing 0xe0648000)
 +ehci_hcd 0000:00:1d.7: restoring config space at offset 0x1 (was 0x2900000, writing 0x2900002)
  pci 0000:00:1e.0: restoring config space at offset 0x9 (was 0x10001, writing 0x83f18001)
  pci 0000:00:1e.0: restoring config space at offset 0x8 (was 0x0, writing 0xe030e010)
  pci 0000:00:1e.0: restoring config space at offset 0x7 (was 0x228000f0, writing 0x22803030)
  pci 0000:00:1e.0: restoring config space at offset 0x1 (was 0x100007, writing 0x100103)
  ata_piix 0000:00:1f.1: restoring config space at offset 0xf (was 0x100, writing 0x10a)
  ata_piix 0000:00:1f.1: restoring config space at offset 0x8 (was 0xc01, writing 0x2121)
  ata_piix 0000:00:1f.1: restoring config space at offset 0x1 (was 0x2800005, writing 0x2880005)
  iwlagn 0000:10:00.0: restoring config space at offset 0xf (was 0x100, writing 0x10a)
  iwlagn 0000:10:00.0: restoring config space at offset 0x4 (was 0x4, writing 0xe0000004)
  iwlagn 0000:10:00.0: restoring config space at offset 0x3 (was 0x0, writing 0x10)
  iwlagn 0000:10:00.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100006)
  yenta_cardbus 0000:02:06.0: restoring config space at offset 0xf (was 0x3000100, writing 0x580010b)
  yenta_cardbus 0000:02:06.0: restoring config space at offset 0xe (was 0x0, writing 0x34fc)
  yenta_cardbus 0000:02:06.0: restoring config space at offset 0xd (was 0x0, writing 0x3400)
  yenta_cardbus 0000:02:06.0: restoring config space at offset 0xc (was 0x0, writing 0x30fc)
  yenta_cardbus 0000:02:06.0: restoring config space at offset 0xb (was 0x0, writing 0x3000)
  yenta_cardbus 0000:02:06.0: restoring config space at offset 0xa (was 0x0, writing 0x87fff000)
  yenta_cardbus 0000:02:06.0: restoring config space at offset 0x9 (was 0x0, writing 0x84000000)
  yenta_cardbus 0000:02:06.0: restoring config space at offset 0x8 (was 0x0, writing 0x83fff000)
  yenta_cardbus 0000:02:06.0: restoring config space at offset 0x7 (was 0x0, writing 0x80000000)
  yenta_cardbus 0000:02:06.0: restoring config space at offset 0x6 (was 0x0, writing 0xb0060302)
  yenta_cardbus 0000:02:06.0: restoring config space at offset 0x4 (was 0x0, writing 0xe0100000)
  yenta_cardbus 0000:02:06.0: restoring config space at offset 0x3 (was 0x820000, writing 0x82a800)
  yenta_cardbus 0000:02:06.0: restoring config space at offset 0x1 (was 0x2100000, writing 0x2100007)
  ohci1394 0000:02:06.1: restoring config space at offset 0xf (was 0x4020200, writing 0x4020205)
  ohci1394 0000:02:06.1: restoring config space at offset 0x4 (was 0x0, writing 0xe0101000)
  ohci1394 0000:02:06.1: restoring config space at offset 0x3 (was 0x800000, writing 0x804010)
  ohci1394 0000:02:06.1: restoring config space at offset 0x1 (was 0x2100000, writing 0x2100006)
  sdhci-pci 0000:02:06.2: restoring config space at offset 0xf (was 0x300, writing 0x30a)
  sdhci-pci 0000:02:06.2: restoring config space at offset 0x4 (was 0x0, writing 0xe0102000)
  sdhci-pci 0000:02:06.2: restoring config space at offset 0x3 (was 0x800000, writing 0x804010)
  sdhci-pci 0000:02:06.2: restoring config space at offset 0x1 (was 0x2100000, writing 0x2100006)
# Apparently we did not do a config restore for ricoh-mmc before. Surprising there are so many.
# And are the values that are written correct (all 0xffffffff...)?
 +ricoh-mmc 0000:02:06.3: restoring config space at offset 0xf (was 0x300, writing 0xffffffff)
 +ricoh-mmc 0000:02:06.3: restoring config space at offset 0xe (was 0x0, writing 0xffffffff)
 +ricoh-mmc 0000:02:06.3: restoring config space at offset 0xd (was 0x80, writing 0xffffffff)
 +ricoh-mmc 0000:02:06.3: restoring config space at offset 0xc (was 0x0, writing 0xffffffff)
 +ricoh-mmc 0000:02:06.3: restoring config space at offset 0xb (was 0x30c9103c, writing 0xffffffff)
 +ricoh-mmc 0000:02:06.3: restoring config space at offset 0xa (was 0x0, writing 0xffffffff)
 +ricoh-mmc 0000:02:06.3: restoring config space at offset 0x9 (was 0x0, writing 0xffffffff)
 +ricoh-mmc 0000:02:06.3: restoring config space at offset 0x8 (was 0x0, writing 0xffffffff)
 +ricoh-mmc 0000:02:06.3: restoring config space at offset 0x7 (was 0x0, writing 0xffffffff)
 +ricoh-mmc 0000:02:06.3: restoring config space at offset 0x6 (was 0x0, writing 0xffffffff)
 +ricoh-mmc 0000:02:06.3: restoring config space at offset 0x5 (was 0x0, writing 0xffffffff)
 +ricoh-mmc 0000:02:06.3: restoring config space at offset 0x4 (was 0x0, writing 0xffffffff)
 +ricoh-mmc 0000:02:06.3: restoring config space at offset 0x3 (was 0x800000, writing 0xffffffff)
 +ricoh-mmc 0000:02:06.3: restoring config space at offset 0x2 (was 0x8800011, writing 0xffffffff)
 +ricoh-mmc 0000:02:06.3: restoring config space at offset 0x1 (was 0x2100000, writing 0xffffffff)
 +ricoh-mmc 0000:02:06.3: restoring config space at offset 0x0 (was 0x8431180, writing 0xffffffff)
  ricoh-mmc: Resuming.
  ricoh-mmc: Controller is now disabled.
  Enabling non-boot CPUs ...
  SMP alternatives: switching to SMP code
  Booting processor 1 APIC 0x1 ip 0x6000
  Initializing CPU#1
  Calibrating delay using timer specific routine.. 2660.13 BogoMIPS (lpj=5320274)
  CPU: L1 I cache: 32K, L1 D cache: 32K
  CPU: L2 cache: 2048K
 +[ds] using core 2 configuration
  CPU: Physical Processor ID: 0
  CPU: Processor Core ID: 1
# Next message also appears during normal boot.
# Wonder if it is related to the APIC error now being fixed (see 15 lines down)?
 +CPU1: Thermal monitoring enabled (TM2)
  x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
  CPU1: Intel(R) Core(TM)2 Duo CPU     U7700  @ 1.33GHz stepping 0d
  CPU0 attaching NULL sched-domain.
  Switched to high resolution mode on CPU 1
  CPU0 attaching sched-domain:
   domain 0: span 0-1 level MC
    groups: 0 1
  CPU1 attaching sched-domain:
   domain 0: span 0-1 level MC
    groups: 1 0
  CPU1 is up
  ACPI: Waking up from system sleep state S3
# Great that the next line is now gone.
 -APIC error on CPU1: 00(40)
  ACPI: EC: non-query interrupt received, switching to interrupt mode
# resume-early only has a config restore at offset 0x8 for the VGA controller;
# where does this one come from? And it is repeated later (see bottom of diff)!
 +pci 0000:00:02.0: restoring config space at offset 0x1 (was 0x900403, writing 0x900003)
# Of the next 4 lines only the 3rd line also appears during normal boot.
 +pci 0000:00:02.0: PME# disabled
 +pci 0000:00:02.1: PME# disabled
 +pci 0000:00:03.0: PME# disabled
 +pci 0000:00:03.2: PME# disabled
  e1000e 0000:00:19.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
  e1000e 0000:00:19.0: setting latency timer to 64
# Not a change, but still strange that next 2 lines are duplicated (similar
# to duplication during suspend above).
  e1000e 0000:00:19.0: wake-up capability disabled by ACPI
  e1000e 0000:00:19.0: PME# disabled
  e1000e 0000:00:19.0: wake-up capability disabled by ACPI
  e1000e 0000:00:19.0: PME# disabled
  e1000e 0000:00:19.0: irq 26 for MSI/MSI-X
 -uhci_hcd 0000:00:1a.0: enabling device (0000 -> 0001)
  uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
  uhci_hcd 0000:00:1a.0: setting latency timer to 64
  usb usb2: root hub lost power or was reset
 -uhci_hcd 0000:00:1a.1: enabling device (0000 -> 0001)
  uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
  uhci_hcd 0000:00:1a.1: setting latency timer to 64
  usb usb3: root hub lost power or was reset
 -ehci_hcd 0000:00:1a.7: enabling device (0000 -> 0002)
 +ehci_hcd 0000:00:1a.7: PME# disabled
  ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
  ehci_hcd 0000:00:1a.7: setting latency timer to 64
# Next line is duplicate from 3 lines up.
 +ehci_hcd 0000:00:1a.7: PME# disabled
 -HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
  HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
  HDA Intel 0000:00:1b.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
  HDA Intel 0000:00:1b.0: setting latency timer to 64
  pcieport-driver 0000:00:1c.0: setting latency timer to 64
  pcieport-driver 0000:00:1c.1: setting latency timer to 64
 -uhci_hcd 0000:00:1d.0: enabling device (0000 -> 0001)
  uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
  uhci_hcd 0000:00:1d.0: setting latency timer to 64
  usb usb5: root hub lost power or was reset
 -uhci_hcd 0000:00:1d.1: enabling device (0000 -> 0001)
  uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 22 (level, low) -> IRQ 22
  uhci_hcd 0000:00:1d.1: setting latency timer to 64
  usb usb6: root hub lost power or was reset
 -uhci_hcd 0000:00:1d.2: enabling device (0000 -> 0001)
  uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
  uhci_hcd 0000:00:1d.2: setting latency timer to 64
  usb usb7: root hub lost power or was reset
 -ehci_hcd 0000:00:1d.7: enabling device (0000 -> 0002)
 +ehci_hcd 0000:00:1d.7: PME# disabled
  ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 20 (level, low) -> IRQ 20
  ehci_hcd 0000:00:1d.7: setting latency timer to 64
# Next line is duplicate from 3 lines up. Same as 00:1a.7 above, again for ehci_hcd.
 +ehci_hcd 0000:00:1d.7: PME# disabled
  pci 0000:00:1e.0: setting latency timer to 64
# Duplicate config restore! Was already done during resume-early.
 +ata_piix 0000:00:1f.1: restoring config space at offset 0x1 (was 0x2800005, writing 0x2880005)
  ata_piix 0000:00:1f.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
  ata_piix 0000:00:1f.1: setting latency timer to 64
  ata2: port disabled. ignoring.
  ACPI Exception (exoparg2-0445): AE_AML_PACKAGE_LIMIT, Index (000000005) is beyond end of object [20081204]
  ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.C2C3] (Node ffff88007e01dea0), AE_AML_PACKAGE_LIMIT
  ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.C003.C0F6.C3F3._STM] (Node ffff88007e043de0), AE_AML_PACKAGE_LIMIT
  ata1: ACPI set timing mode failed (status=0x300b)
 -iwlagn 0000:10:00.0: enabling device (0000 -> 0002)
  iwlagn 0000:10:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
  iwlagn 0000:10:00.0: irq 27 for MSI/MSI-X
  ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[19]  MMIO=[e0101000-e01017ff]  Max Packet=[2048]  IR/IT contexts=[4/4]
  sdhci-pci 0000:02:06.2: PCI INT C -> GSI 20 (level, low) -> IRQ 20
  Registered led device: iwl-phy0:radio
  Registered led device: iwl-phy0:assoc
  Registered led device: iwl-phy0:RX
  Registered led device: iwl-phy0:TX
  sd 0:0:0:0: [sda] Starting disk
  ata1.01: ACPI cmd ef/03:0c:00:00:00:b0 filtered out
  ata1.01: ACPI cmd ef/03:40:00:00:00:b0 filtered out
  ata1.00: ACPI cmd ef/03:01:00:00:00:a0 filtered out
  ata1.00: ACPI cmd ef/03:45:00:00:00:a0 filtered out
  ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
  ata1.00: ACPI cmd b1/c1:00:00:00:00:a0 filtered out
  ata1.00: ACPI cmd c6/00:10:00:00:00:a0 succeeded
  ata1.00: configured for UDMA/100
  ata1.01: configured for MWDMA2
  ata1.00: configured for UDMA/100
  ata1.01: configured for MWDMA2
  ata1: EH complete
  sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors: (120 GB/111 GiB)
  sd 0:0:0:0: [sda] Write Protect is off
  sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
  sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
  sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors: (120 GB/111 GiB)
  sd 0:0:0:0: [sda] Write Protect is off
  sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
  sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
  usb 2-1: reset full speed USB device using uhci_hcd and address 2
  usb 5-2: reset full speed USB device using uhci_hcd and address 2
# Is this line now missing because the INT is not disabled during suspend (see 1st comment)?
 -pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
# Duplicate config restore for the VGA controller.
 +pci 0000:00:02.0: restoring config space at offset 0x1 (was 0x900403, writing 0x900003)
  pci 0000:00:02.0: setting latency timer to 64
  Restarting tasks ... done.


"PME# disabled" messages displayed during normal boot
-----------------------------------------------------
pci 0000:00:03.0: PME# disabled
pci 0000:00:19.0: PME# disabled
pci 0000:00:1a.7: PME# disabled
pci 0000:00:1b.0: PME# disabled
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1c.1: PME# disabled
pci 0000:00:1d.7: PME# disabled
pci 0000:02:06.0: PME# disabled
pci 0000:02:06.1: PME# disabled
pci 0000:02:06.2: PME# disabled
pci 0000:02:06.3: PME# disabled
pci 0000:10:00.0: PME# disabled


Output of lspci (for reference)
-------------------------------
00:00.0 Host bridge: Intel Corporation Mobile PM965/GM965/GL960 Memory Controller Hub (rev 0c)
00:02.0 VGA compatible controller: Intel Corporation Mobile GM965/GL960 Integrated Graphics Controller (rev 0c)
00:02.1 Display controller: Intel Corporation Mobile GM965/GL960 Integrated Graphics Controller (rev 0c)
00:03.0 Communication controller: Intel Corporation Mobile PM965/GM965 MEI Controller (rev 0c)
00:03.2 IDE interface: Intel Corporation Mobile PM965/GM965 PT IDER Controller (rev 0c)
00:03.3 Serial controller: Intel Corporation Mobile PM965/GM965 KT Controller (rev 0c)
00:19.0 Ethernet controller: Intel Corporation 82566MM Gigabit Network Connection (rev 03)
00:1a.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #4 (rev 03)
00:1a.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #5 (rev 03)
00:1a.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI Controller #2 (rev 03)
00:1b.0 Audio device: Intel Corporation 82801H (ICH8 Family) HD Audio Controller (rev 03)
00:1c.0 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 1 (rev 03)
00:1c.1 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 2 (rev 03)
00:1d.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #1 (rev 03)
00:1d.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #2 (rev 03)
00:1d.2 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #3 (rev 03)
00:1d.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI Controller #1 (rev 03)
00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev f3)
00:1f.0 ISA bridge: Intel Corporation 82801HBM (ICH8M-E) LPC Interface Controller (rev 03)
00:1f.1 IDE interface: Intel Corporation 82801HBM/HEM (ICH8M/ICH8M-E) IDE Controller (rev 03)
02:06.0 CardBus bridge: Ricoh Co Ltd RL5c476 II (rev ba)
02:06.1 FireWire (IEEE 1394): Ricoh Co Ltd R5C832 IEEE 1394 Controller (rev 04)
02:06.2 SD Host controller: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro Host Adapter (rev 21)
02:06.3 System peripheral: Ricoh Co Ltd R5C843 MMC Host Controller (rev ff)
10:00.0 Network controller: Intel Corporation PRO/Wireless 4965 AG or AGN [Kedron] Network Connection (rev 61)
