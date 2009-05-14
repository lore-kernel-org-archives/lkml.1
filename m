Return-Path: <linux-kernel-owner+w=401wt.eu-S1758971AbZENLMx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758971AbZENLMx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 07:12:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754974AbZENLMj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 07:12:39 -0400
Received: from cpsmtpm-eml104.kpnxchange.com ([195.121.3.8]:61250 "EHLO
	CPSMTPM-EML104.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754528AbZENLMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 07:12:37 -0400
From: Frans Pop <elendil@planet.nl>
To: Netdev <netdev@vger.kernel.org>
Subject: [2.6.30] e1000e: pci_enable_pcie_error_reporting failed 0xfffffffb
Date: Thu, 14 May 2009 13:12:35 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, e1000-devel@lists.sourceforge.net,
       linux-pm@lists.linux-foundation.org
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_jy/CKFvWxGFJHj8"
Message-Id: <200905141312.35945.elendil@planet.nl>
X-OriginalArrivalTime: 14 May 2009 11:12:36.0543 (UTC) FILETIME=[E2F7C4F0:01C9D484]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_jy/CKFvWxGFJHj8
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

With 2.6.30-rc[45] I'm always seeing this error while resuming from STR on 
my HP 2510p notebook:

  e1000e 0000:00:19.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
! e1000e 0000:00:19.0: pci_enable_pcie_error_reporting failed 0xfffffffb
  e1000e 0000:00:19.0: setting latency timer to 64
  e1000e 0000:00:19.0: wake-up capability disabled by ACPI
  e1000e 0000:00:19.0: PME# disabled
  e1000e 0000:00:19.0: wake-up capability disabled by ACPI
  e1000e 0000:00:19.0: PME# disabled
  e1000e 0000:00:19.0: irq 26 for MSI/MSI-X

The error only shows up during resume, not during normal boot.

With 2.6.29 the error is not present. Is this something that should be 
looked into? Networking still comes up normally.

Attached a full diff for a suspend/resume cycle with .29.3 and .30-rc5.

Cheers,
FJP


--Boundary-00=_jy/CKFvWxGFJHj8
Content-Type: text/x-diff;
  charset="us-ascii";
  name="e1000e_STR.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="e1000e_STR.diff"

--- ../aragorn/2.6.29.3-rjw	2009-05-14 12:45:06.000000000 +0200
+++ ../aragorn/2.6.30-rc5	2009-05-14 12:48:53.000000000 +0200
[... switch from wireless to wired networking ...]
 e1000e 0000:00:19.0: irq 26 for MSI/MSI-X
 ADDRCONF(NETDEV_UP): eth0: link is not ready
 e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Control: None
 0000:00:19.0: eth0: 10/100 speed: disabling TSO
 ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
 wlan0: deauthenticating by local choice (reason=3)
-iwlagn: MAC is in deep sleep!
-iwlagn: MAC is in deep sleep!
-iwlagn: MAC is in deep sleep!
-iwlagn 0000:10:00.0: PCI INT A disabled
-wlan0: deauthenticating by local choice (reason=3)
 eth0: no IPv6 routers present
[... suspend ...]
 [drm:i915_get_vblank_counter] *ERROR* trying to get vblank count for disabled pipe 1
 PM: Syncing filesystems ... done.
 Freezing user space processes ... (elapsed 0.00 seconds) done.
 Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
 Suspending console(s) (use no_console_suspend to debug)
 sd 0:0:0:0: [sda] Synchronizing SCSI cache
 sd 0:0:0:0: [sda] Stopping disk
 ACPI handle has no context!
 ACPI handle has no context!
 sdhci-pci 0000:02:06.2: PME# disabled
 sdhci-pci 0000:02:06.2: PCI INT C disabled
 ACPI handle has no context!
 ACPI handle has no context!
 ata2: port disabled. ignoring.
 ata_piix 0000:00:1f.1: PCI INT A disabled
 ehci_hcd 0000:00:1d.7: PCI INT A disabled
 ehci_hcd 0000:00:1d.7: PME# disabled
 uhci_hcd 0000:00:1d.2: PCI INT C disabled
 uhci_hcd 0000:00:1d.1: PCI INT B disabled
 uhci_hcd 0000:00:1d.0: PCI INT A disabled
 HDA Intel 0000:00:1b.0: PCI INT A disabled
 HDA Intel 0000:00:1b.0: power state changed by ACPI to D3
 ehci_hcd 0000:00:1a.7: PCI INT C disabled
 ehci_hcd 0000:00:1a.7: PME# disabled
 uhci_hcd 0000:00:1a.1: PCI INT B disabled
 uhci_hcd 0000:00:1a.0: PCI INT A disabled
+e1000e 0000:00:19.0: PCI INT A disabled
 e1000e 0000:00:19.0: PME# enabled
 e1000e 0000:00:19.0: wake-up capability enabled by ACPI
-e1000e 0000:00:19.0: PME# enabled
-e1000e 0000:00:19.0: wake-up capability enabled by ACPI
-e1000e 0000:00:19.0: PCI INT A disabled
 ACPI handle has no context!
 ricoh-mmc: Suspending.
 ricoh-mmc: Controller is now re-enabled.
 ACPI: Preparing to enter system sleep state S3
 Disabling non-boot CPUs ...
 CPU 1 is now offline
 SMP alternatives: switching to UP code
 CPU0 attaching NULL sched-domain.
 CPU1 attaching NULL sched-domain.
 CPU0 attaching NULL sched-domain.
 CPU1 is down
[... resume ...]
 Extended CMOS year: 2000
 x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
 Back to C!
-CPU0: Thermal monitoring enabled (TM2)
+CPU0: Thermal monitoring handled by SMI
 Extended CMOS year: 2000
 Enabling non-boot CPUs ...
 SMP alternatives: switching to SMP code
 Booting processor 1 APIC 0x1 ip 0x6000
 Initializing CPU#1
-Calibrating delay using timer specific routine.. 2660.07 BogoMIPS (lpj=5320140)
+Calibrating delay using timer specific routine.. 2660.14 BogoMIPS (lpj=5320280)
 CPU: L1 I cache: 32K, L1 D cache: 32K
 CPU: L2 cache: 2048K
 CPU: Physical Processor ID: 0
 CPU: Processor Core ID: 1
 CPU1: Thermal monitoring enabled (TM2)
 x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
 CPU1: Intel(R) Core(TM)2 Duo CPU     U7700  @ 1.33GHz stepping 0d
+checking TSC synchronization [CPU#0 -> CPU#1]: passed.
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
 uhci_hcd 0000:00:1a.0: restoring config space at offset 0x1 (was 0x2800000, writing 0x2800001)
 uhci_hcd 0000:00:1a.1: restoring config space at offset 0xf (was 0x200, writing 0x20a)
 uhci_hcd 0000:00:1a.1: restoring config space at offset 0x8 (was 0x1, writing 0x20a1)
 uhci_hcd 0000:00:1a.1: restoring config space at offset 0x1 (was 0x2800000, writing 0x2800001)
 ehci_hcd 0000:00:1a.7: restoring config space at offset 0xf (was 0x300, writing 0x30b)
 ehci_hcd 0000:00:1a.7: restoring config space at offset 0x4 (was 0x0, writing 0xe0641000)
 ehci_hcd 0000:00:1a.7: restoring config space at offset 0x1 (was 0x2900000, writing 0x2900002)
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
 pcieport-driver 0000:00:1c.1: restoring config space at offset 0xf (was 0x200, writing 0x4020a)
 pcieport-driver 0000:00:1c.1: restoring config space at offset 0x9 (was 0x10001, writing 0x1fff1)
 pcieport-driver 0000:00:1c.1: restoring config space at offset 0x8 (was 0x0, writing 0xe000e000)
 pcieport-driver 0000:00:1c.1: restoring config space at offset 0x7 (was 0x0, writing 0xf0)
 pcieport-driver 0000:00:1c.1: restoring config space at offset 0x3 (was 0x810000, writing 0x810010)
 pcieport-driver 0000:00:1c.1: restoring config space at offset 0x1 (was 0x100000, writing 0x100407)
 uhci_hcd 0000:00:1d.0: restoring config space at offset 0xf (was 0x100, writing 0x10a)
 uhci_hcd 0000:00:1d.0: restoring config space at offset 0x8 (was 0x1, writing 0x20c1)
 uhci_hcd 0000:00:1d.0: restoring config space at offset 0x1 (was 0x2800000, writing 0x2800001)
 uhci_hcd 0000:00:1d.1: restoring config space at offset 0xf (was 0x200, writing 0x20b)
 uhci_hcd 0000:00:1d.1: restoring config space at offset 0x8 (was 0x1, writing 0x20e1)
 uhci_hcd 0000:00:1d.1: restoring config space at offset 0x1 (was 0x2800000, writing 0x2800001)
 uhci_hcd 0000:00:1d.2: restoring config space at offset 0xf (was 0x300, writing 0x30b)
 uhci_hcd 0000:00:1d.2: restoring config space at offset 0x8 (was 0x1, writing 0x2101)
 uhci_hcd 0000:00:1d.2: restoring config space at offset 0x1 (was 0x2800000, writing 0x2800001)
 ehci_hcd 0000:00:1d.7: restoring config space at offset 0xf (was 0x100, writing 0x10a)
 ehci_hcd 0000:00:1d.7: restoring config space at offset 0x4 (was 0x0, writing 0xe0648000)
 ehci_hcd 0000:00:1d.7: restoring config space at offset 0x1 (was 0x2900000, writing 0x2900002)
 pci 0000:00:1e.0: restoring config space at offset 0x9 (was 0x10001, writing 0x83f18001)
 pci 0000:00:1e.0: restoring config space at offset 0x8 (was 0x0, writing 0xe030e010)
 pci 0000:00:1e.0: restoring config space at offset 0x7 (was 0x228000f0, writing 0x22803030)
 pci 0000:00:1e.0: restoring config space at offset 0x1 (was 0x100007, writing 0x100107)
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
 ricoh-mmc 0000:02:06.3: restoring config space at offset 0xf (was 0x300, writing 0x30a)
 ricoh-mmc 0000:02:06.3: restoring config space at offset 0x4 (was 0x0, writing 0xe0103000)
 ricoh-mmc 0000:02:06.3: restoring config space at offset 0x3 (was 0x800000, writing 0x804010)
 ricoh-mmc 0000:02:06.3: restoring config space at offset 0x1 (was 0x2100000, writing 0x2100006)
 ricoh-mmc: Resuming.
 ricoh-mmc: Controller is now disabled.
-ACPI: EC: non-query interrupt received, switching to interrupt mode
 pci 0000:00:02.0: restoring config space at offset 0x1 (was 0x900403, writing 0x900003)
 pci 0000:00:02.0: PME# disabled
 pci 0000:00:02.1: PME# disabled
 pci 0000:00:03.0: PME# disabled
 pci 0000:00:03.2: PME# disabled
 e1000e 0000:00:19.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
+e1000e 0000:00:19.0: pci_enable_pcie_error_reporting failed 0xfffffffb
 e1000e 0000:00:19.0: setting latency timer to 64
 e1000e 0000:00:19.0: wake-up capability disabled by ACPI
 e1000e 0000:00:19.0: PME# disabled
 e1000e 0000:00:19.0: wake-up capability disabled by ACPI
 e1000e 0000:00:19.0: PME# disabled
 e1000e 0000:00:19.0: irq 26 for MSI/MSI-X
 uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
 uhci_hcd 0000:00:1a.0: setting latency timer to 64
 usb usb3: root hub lost power or was reset
 uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
 uhci_hcd 0000:00:1a.1: setting latency timer to 64
 usb usb4: root hub lost power or was reset
 ehci_hcd 0000:00:1a.7: PME# disabled
 ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
 ehci_hcd 0000:00:1a.7: setting latency timer to 64
 ehci_hcd 0000:00:1a.7: PME# disabled
 HDA Intel 0000:00:1b.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
 HDA Intel 0000:00:1b.0: setting latency timer to 64
-pcieport-driver 0000:00:1c.0: setting latency timer to 64
-pcieport-driver 0000:00:1c.1: setting latency timer to 64
 uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
 uhci_hcd 0000:00:1d.0: setting latency timer to 64
 usb usb5: root hub lost power or was reset
 uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 22 (level, low) -> IRQ 22
 uhci_hcd 0000:00:1d.1: setting latency timer to 64
 usb usb6: root hub lost power or was reset
 uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
 uhci_hcd 0000:00:1d.2: setting latency timer to 64
 usb usb7: root hub lost power or was reset
 ehci_hcd 0000:00:1d.7: PME# disabled
 ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 20 (level, low) -> IRQ 20
 ehci_hcd 0000:00:1d.7: setting latency timer to 64
 ehci_hcd 0000:00:1d.7: PME# disabled
 pci 0000:00:1e.0: setting latency timer to 64
 ata_piix 0000:00:1f.1: restoring config space at offset 0x1 (was 0x2800005, writing 0x2880005)
 ata_piix 0000:00:1f.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
 ata_piix 0000:00:1f.1: setting latency timer to 64
 ata2: port disabled. ignoring.
-ACPI Exception (exoparg2-0445): AE_AML_PACKAGE_LIMIT, Index (000000005) is beyond end of object [20081204]
+ACPI Exception (exoparg2-0445): AE_AML_PACKAGE_LIMIT, Index (000000005) is beyond end of object [20090320]
 ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.C2C3] (Node ffff88007e01eea0), AE_AML_PACKAGE_LIMIT
 ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.C003.C0F6.C3F3._STM] (Node ffff88007e044de0), AE_AML_PACKAGE_LIMIT
 ata1: ACPI set timing mode failed (status=0x300b)
+iwlagn 0000:10:00.0: restoring config space at offset 0x1 (was 0x100406, writing 0x100006)
 ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[19]  MMIO=[e0101000-e01017ff]  Max Packet=[2048]  IR/IT contexts=[4/4]
 sdhci-pci 0000:02:06.2: PCI INT C -> GSI 20 (level, low) -> IRQ 20
 sd 0:0:0:0: [sda] Starting disk
 ata1.01: ACPI cmd ef/03:0c:00:00:00:b0 filtered out
 ata1.01: ACPI cmd ef/03:40:00:00:00:b0 filtered out
 ata1.00: ACPI cmd ef/03:01:00:00:00:a0 filtered out
 ata1.00: ACPI cmd ef/03:45:00:00:00:a0 filtered out
 ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
 ata1.00: ACPI cmd b1/c1:00:00:00:00:a0 filtered out
 ata1.00: ACPI cmd c6/00:10:00:00:00:a0 succeeded
 ata1.00: configured for UDMA/100
 e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Control: None
 0000:00:19.0: eth0: 10/100 speed: disabling TSO
 ata1.01: configured for MWDMA2
 ata1.00: configured for UDMA/100
 ata1.01: configured for MWDMA2
 ata1: EH complete
-sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors: (120 GB/111 GiB)
-sd 0:0:0:0: [sda] Write Protect is off
-sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
-sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
-sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors: (120 GB/111 GiB)
-sd 0:0:0:0: [sda] Write Protect is off
-sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
-sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 usb 3-1: reset full speed USB device using uhci_hcd and address 2
 usb 5-2: reset full speed USB device using uhci_hcd and address 2
 HP WMI: Setting initial dock state
 pci 0000:00:02.0: restoring config space at offset 0x1 (was 0x900403, writing 0x900003)
 pci 0000:00:02.0: setting latency timer to 64
 Restarting tasks ... done.

--Boundary-00=_jy/CKFvWxGFJHj8--
