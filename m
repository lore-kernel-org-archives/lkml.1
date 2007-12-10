Return-Path: <linux-kernel-owner+w=401wt.eu-S1754156AbXLJAvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156AbXLJAvY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 19:51:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751225AbXLJAvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 19:51:17 -0500
Received: from kuber.nabble.com ([216.139.236.158]:46078 "EHLO
	kuber.nabble.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbXLJAvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 19:51:16 -0500
Message-ID: <14245613.post@talk.nabble.com>
Date: Sun, 9 Dec 2007 16:51:15 -0800 (PST)
From: kinesis <jriley1337@yahoo.com>
To: linux-kernel@vger.kernel.org
Subject: hwclock --systohc locks machine up, RTC conflict problems
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Nabble-From: jriley1337@yahoo.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Issuing the command hwclock --systohc and sometimes at boot --hctosys causes
my machine to freeze.

The reason is there is a problem loading rtc-cmos. I will say that my
machine also runs Windows, and it detects the device fine as a Real Time
Clock/CMOS driver at io range 0070-0071. According to /proc/ioports rtc is
probed at 0070-0077.

During boot we get the following when attempting to modprobe rtc-cmos:


root@excalibur:/usr/src/linux-2.6# dmesg|grep rtc

drivers/rtc/hctosys.c: unable to open rtc device (rtc0)

rtc_cmos 00:09: i/o registers already in use

rtc_cmos: probe of 00:09 failed with error -16

root@excalibur:/usr/src/linux-2.6#



this has happened with the stock kernel that came with my distribution, as
well.

Apparently you can only use 0070-0071 for my rtc? how can I get the device
to work?

here is /proc/interrupts:

          CPU0       CPU1
  0:      23106   13272660   IO-APIC-edge      timer
  1:         49       5781   IO-APIC-edge      i8042
  8:          0          1   IO-APIC-edge      rtc
  9:        159       9301   IO-APIC-fasteoi   acpi
 12:       1818     190257   IO-APIC-edge      i8042
 14:          0         35   IO-APIC-edge      ide0
 17:       2174     312677   IO-APIC-fasteoi   nvidia
 18:        363      27432   IO-APIC-fasteoi   HDA Intel
 19:       1914     283347   IO-APIC-fasteoi   ndiswrapper
 20:       6434    1328206   IO-APIC-fasteoi   eth0
 21:          0          0   IO-APIC-fasteoi   ohci_hcd:usb2
 22:          0          0   IO-APIC-fasteoi   ehci_hcd:usb1
 23:        209      19944   IO-APIC-fasteoi   sata_nv
NMI:          0          0   Non-maskable interrupts
LOC:   13272488      22989   Local timer interrupts
RES:     105913      91197   Rescheduling interrupts
CAL:        151        134   function call interrupts
TLB:      18445      19521   TLB shootdowns
TRM:          0          0   Thermal event interrupts
THR:          0          0   Threshold APIC interrupts
SPU:          0          0   Spurious interrupts
ERR:          0


-- 
View this message in context: http://www.nabble.com/hwclock---systohc-locks-machine-up%2C-RTC-conflict-problems-tp14245613p14245613.html
Sent from the linux-kernel mailing list archive at Nabble.com.

