Return-Path: <linux-kernel-owner+w=401wt.eu-S1752808AbXCORcs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808AbXCORcs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 13:32:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752811AbXCORcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 13:32:48 -0400
Received: from spirit.analogic.com ([204.178.40.4]:1355 "EHLO
	spirit.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808AbXCORcr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 13:32:47 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 15 Mar 2007 17:32:46.0324 (UTC) FILETIME=[F1E7E340:01C76727]
Content-class: urn:content-classes:message
Subject: USB Keyboard
Date: Thu, 15 Mar 2007 13:32:45 -0400
Message-ID: <Pine.LNX.4.61.0703151331060.4442@chaos.analogic.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: USB Keyboard
Thread-Index: AcdnJ/HxDrEY/DdLQwiipPIt2WNmzg==
From: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
To: "Linux kernel" <linux-kernel@vger.kernel.org>
Reply-To: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



I have multiple AMD 64-bit servers in several configurations,
with several different motherboards, which fail to recognize
a USB keyboard when booted from a "stock" Linux kernel.
They only work with a RedHat kernel! I have removed all but
one CPU from one in an attempt to find the problem.

The drivers:
 	uhci_hcd      34064  0
 	ehci_hcd      34056  0

install fine, but remain unused. They don't generate any interrupts!
I even installed dm_mod (after this snapshot), thinking maybe it
would fix it. Anyway, the machines can't be accessed without a keyboard
because they don't have anything but USB. They are not on a network
either, which makes troubleshooting without a keyboard a bitch. There
apparently is a keyboard controller (which gets one interrupt), but
it is not connected to a keyboard socket.

            CPU0
   0:    4691734    IO-APIC-edge  timer
   1:          1    IO-APIC-edge  i8042
   7:          0    IO-APIC-edge  parport0
   8:          1    IO-APIC-edge  rtc
   9:          0   IO-APIC-level  acpi
  12:        104    IO-APIC-edge  i8042
  14:       8719    IO-APIC-edge  ide0
  16:          0   IO-APIC-level  uhci_hcd:usb4
  17:       1079   IO-APIC-level  aic79xx
  18:          0   IO-APIC-level  ehci_hcd:usb1
  19:          0   IO-APIC-level  uhci_hcd:usb2, uhci_hcd:usb5
  20:          0   IO-APIC-level  uhci_hcd:usb3
  21:       6735   IO-APIC-level  eth0
  22:       2334   IO-APIC-level  eth1
NMI:          0 
LOC:    4691769 
ERR:          0
MIS:          0

I have tried the following stock kernels. Manufacturing and the
customer "requires" Linux version 2.6.N

linux-2.6.8 linux-2.6.9 linux-2.6.10 linux-2.6.11
linux-2.6.11.9 linux-2.6.12 linux-2.6.12.5 linux-2.6.13
linux-2.6.13.4 linux-2.6.15.4 linux-2.6.16.24 linux-2.6.16.4
linux-2.6.19

I have tried various games such as "pci=routeirq." Nothing
works! Does anybody know how RedHat gets the USB keyboard to
be recognized?

Cheers,
Dick Johnson
Penguin : Linux version 2.6.16.24 on an i686 machine (5592.71 BogoMips).
New book: http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
