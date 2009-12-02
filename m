Return-Path: <linux-kernel-owner+w=401wt.eu-S1755873AbZLBWe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873AbZLBWe0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 17:34:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755744AbZLBWeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 17:34:25 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:57106 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755652AbZLBWeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 17:34:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=XHyaZErL/MNQbFPUNtKQ0i9GRSil7SzrPX9hNRiBex24vXr/NWL22mA1/Vum3oZr1J
         CqFCpsKUrRZ7cDQ9JdTIjWjVR752G5H+GsR7jSWXzLtITAsC2ipQbIwp1HFkBtEKCQS4
         wW+MW/f9hrEan4XqmXMLIqVYN8j4awHeBRZq4=
MIME-Version: 1.0
Date: Wed, 2 Dec 2009 14:34:30 -0800
Message-ID: <dd18b0c30912021434t4a247646q48f32c0d0e40faae@mail.gmail.com>
Subject: root hub lost power or was reset
From: Justin Mattock <justinmattock@gmail.com>
To: Linux-usb <linux-usb@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been getting a 45 sec
pause when waking my machine up
on the first cycle using s2ram.
At first thought it was udev, but later
am not sure it is. With further looking
if I remove the isight_firmware module from the kernel
suspend wakes up the first cycle as it should.(I don't have
isight-firmware-tools installed, leading me to believe this might
be the issue with isight-firmware.ko.)

Now looking at dmesg I see:

[  413.551845] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[  413.551855] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[  413.551887] usb usb2: root hub lost power or was reset
[  413.551927] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[  413.551937] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[  413.551967] usb usb3: root hub lost power or was reset
[  413.552019] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[  413.552029] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[  413.552058] usb usb4: root hub lost power or was reset
[  413.552094] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
[  413.552104] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[  413.552134] usb usb5: root hub lost power or was reset
[  413.552172] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[  413.552182] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[  413.552200] pci 0000:00:1e.0: setting latency timer to 64
[  413.552217] ata_piix 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[  413.552225] ata_piix 0000:00:1f.1: setting latency timer to 64
[  413.554437] ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[  413.554446] ata_piix 0000:00:1f.2: setting latency timer to 64
[  413.554548] pci 0000:00:1f.3: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[  413.554559] pci 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[  413.554567] pci 0000:01:00.0: setting latency timer to 64

for a bit I thought that this was also the cause of the delay
but the system wakes up as it should even with this happening to
usb.

BTW: Is CONFIG_USB_PERSIST in the kernel anymore
with 2.6.32*?(I can't seem to find that option);

-- 
Justin P. Mattock
