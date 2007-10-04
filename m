Return-Path: <linux-kernel-owner+w=401wt.eu-S1760622AbXJDXTZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760622AbXJDXTZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 19:19:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760149AbXJDXTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 19:19:14 -0400
Received: from mail.gmx.net ([213.165.64.20]:37307 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1762076AbXJDXTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 19:19:13 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX19yuNps2lhyeIotjd1sgOlEx9LPzTysPBzn7nPlez
	qAuWczYZVyJv5U
Date: Fri, 5 Oct 2007 01:19:31 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-kernel@vger.kernel.org
cc: linux-usb-devel@lists.sourceforge.net
Subject: [IRQ map] VIA C7 CN700 2.6.23-rc9-git USB IRQs disabled
Message-ID: <Pine.LNX.4.60.0710050105450.4537@poirot.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Booting git snapshot of about 6 hours ago, getting the following:

USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt Link [ALKB] enabled at IRQ 21
ACPI: PCI Interrupt 0000:00:10.0[A] -> Link [ALKB] -> GSI 21 (level, low) -> IRQ 18
ACPI: PCI interrupt for device 0000:00:10.0 disabled
uhci_hcd 0000:00:10.0: init 0000:00:10.0 fail, -16
uhci_hcd: probe of 0000:00:10.0 failed with error -16
ACPI: PCI Interrupt 0000:00:10.1[A] -> Link [ALKB] -> GSI 21 (level, low) -> IRQ 18
ACPI: PCI interrupt for device 0000:00:10.1 disabled
uhci_hcd 0000:00:10.1: init 0000:00:10.1 fail, -16
uhci_hcd: probe of 0000:00:10.1 failed with error -16
ACPI: PCI Interrupt 0000:00:10.2[B] -> Link [ALKB] -> GSI 21 (level, low) -> IRQ 18
ACPI: PCI interrupt for device 0000:00:10.2 disabled
uhci_hcd 0000:00:10.2: init 0000:00:10.2 fail, -16
uhci_hcd: probe of 0000:00:10.2 failed with error -16
ACPI: PCI Interrupt 0000:00:10.3[B] -> Link [ALKB] -> GSI 21 (level, low) -> IRQ 18
ACPI: PCI interrupt for device 0000:00:10.3 disabled
uhci_hcd 0000:00:10.3: init 0000:00:10.3 fail, -16
uhci_hcd: probe of 0000:00:10.3 failed with error -16
ACPI: PCI Interrupt 0000:00:10.4[C] -> Link [ALKB] -> GSI 21 (level, low) -> IRQ 18
ACPI: PCI interrupt for device 0000:00:10.4 disabled
ehci_hcd 0000:00:10.4: init 0000:00:10.4 fail, -16
ehci_hcd: probe of 0000:00:10.4 failed with error -16

With "pci=routeirq" it is the same, but then it's "IRQ 17" instead of 18, 
and the line

ACPI: PCI Interrupt Link [ALKB] enabled at IRQ 21

is missing. Works with Debian etch default 2.6.18. /proc/interrupts under 
.23-rc9-...:

$ cat /proc/interrupts
           CPU0
  0:      31756   IO-APIC-edge      timer
  1:          2   IO-APIC-edge      i8042
  8:          1   IO-APIC-edge      rtc
  9:          0   IO-APIC-fasteoi   acpi
 12:          4   IO-APIC-edge      i8042
 16:       2627   IO-APIC-fasteoi   sata_via
 19:        472   IO-APIC-fasteoi   eth0

Under 2.6.18:

ACPI: PCI Interrupt Link [ALKB] enabled at IRQ 21
ACPI: PCI Interrupt 0000:00:10.0[A] -> Link [ALKB] -> GSI 21 (level, low) -> IRQ 177
PCI: VIA IRQ fixup for 0000:00:10.0, from 10 to 1
uhci_hcd 0000:00:10.0: UHCI Host Controller
uhci_hcd 0000:00:10.0: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:10.0: irq 177, io base 0x0000f900

Thanks
Guennadi
---
Guennadi Liakhovetski
