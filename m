Return-Path: <linux-kernel-owner+w=401wt.eu-S1757063AbZCOMEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757063AbZCOMEf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 08:04:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754411AbZCOME0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 08:04:26 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:59499 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752972AbZCOME0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 08:04:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=j41G39uP7PaNgGRczbN44NPctArVliPuqXxZzt2edSno6uGYI0eKJ3gQBfes4V+ymd
         HIOOml/5tspRIEqL+Rps30bJ0bmsj1l31QAWX90ZKSAx0O/GyxTEqT+vHH9vLEO6OmR1
         13jaylEH18S2/tR5W9nlxFjVULiSQ8jK3X3to=
MIME-Version: 1.0
Date: Sun, 15 Mar 2009 21:04:21 +0900
Message-ID: <d5dec53b0903150504v9843fefr939f0a0cbc8a300f@mail.gmail.com>
Subject: DMAR ERROR by nVidia video card
From: Yoshiharu Mori <ymori4480@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I enabled DMAR by kernel parameter, and started X windows.
The following error message is reported forever.
Is this driver's issue?

Mar 15 19:50:44 localhost kernel: IRQ 16/nvidia: IRQF_DISABLED is not
guaranteed on shared IRQs
Mar 15 19:50:45 localhost kernel: DMAR:[DMA Read] Request device
[02:00.0] fault addr 0
Mar 15 19:50:45 localhost kernel: DMAR:[fault reason 06] PTE Read
access is not set
Mar 15 19:50:45 localhost acpid: client connected from 4682[0:0]
Mar 15 19:50:45 localhost kernel: DMAR:[DMA Read] Request device
[02:00.0] fault addr 0
Mar 15 19:50:45 localhost kernel: DMAR:[fault reason 06] PTE Read
access is not set
Mar 15 19:50:45 localhost kernel: DMAR:[DMA Read] Request device
[02:00.0] fault addr 0
Mar 15 19:50:45 localhost kernel: DMAR:[fault reason 06] PTE Read
access is not set
...continue

-- my env --
Distribution    :Fedora 10
kernel          :2.6.29-rc8
kernel parameter:intel_iommu=igfx_off intel_iommu=on
nVidia driver   :NVIDIA-Linux-x86_64-180.29-pkg2.run

#lspci
..
02:00.0 VGA compatible controller: nVidia Corporation GeForce 8400 GS (rev a1)
..

#cat /proc/interrupts
          CPU0       CPU1       CPU2       CPU3       CPU4       CPU5
     CPU6       CPU7
  0:        150          0          0     115006          0          0
         0          0   IO-APIC-edge      timer
  1:          0          0          0          2          0          0
         0          0   IO-APIC-edge      i8042
  3:          0          0          0          2          0          0
         0          0   IO-APIC-edge
  4:          0          0          0        278          0          0
         0          0   IO-APIC-edge      serial
  8:          0          0          0          0          0          0
         0          0   IO-APIC-edge      rtc0
  9:          0          0          0          0          0          0
         0          0   IO-APIC-fasteoi   acpi
 12:          0          0          0          4          0          0
         0          0   IO-APIC-edge      i8042
 16:         29          0          0          0          0        115
        20          0   IO-APIC-fasteoi   sata_sil24, nvidia
 17:          0          0          0          0          0         12
         0          0   IO-APIC-fasteoi   firewire_ohci
 20:          0          0          0          0          0          0
         0          0   IO-APIC-fasteoi   ehci_hcd:usb2,
uhci_hcd:usb3, uhci_hcd:usb6
 21:          0          0          0         72          0        184
       894          0   IO-APIC-fasteoi   uhci_hcd:usb4, uhci_hcd:usb7
 22:          0          0        281          0          0         42
         0          0   IO-APIC-fasteoi   ehci_hcd:usb1,
uhci_hcd:usb8, HDA Intel
 23:          0          0          0          0          0          0
         0          0   IO-APIC-fasteoi   uhci_hcd:usb5
 24:          0          0          0          0        231          0
         0          0  DMAR_MSI-edge      dmar0
 31:          1       2939       9024          0          0          0
         0          0   PCI-MSI-edge      ahci
 50:          0          0         21          0          0          0
      2187          0   PCI-MSI-edge      eth2-rx-0
 51:          0          0          0         35          0     971163
         0          0   PCI-MSI-edge      eth2-tx-0
 52:          0          0          0          3          0          0
         0          0   PCI-MSI-edge      eth2
NMI:          0          0          0          0          0          0
         0          0   Non-maskable interrupts
LOC:      22415      15089      20532       5501      11525      14125
     17015      11666   Local timer interrupts
RES:       3397       1695       2233       1548       2027       1919
      2824       2388   Rescheduling interrupts
CAL:        170        183        170        199        217        198
       225        227   Function call interrupts
TLB:         79        100         84        112        459        360
       431        499   TLB shootdowns
TRM:          0          0          0          0          0          0
         0          0   Thermal event interrupts
THR:          0          0          0          0          0          0
         0          0   Threshold APIC interrupts
SPU:          0          0          0          0          0          0
         0          0   Spurious interrupts
ERR:          0
MIS:          0
