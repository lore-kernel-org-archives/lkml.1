Return-Path: <linux-kernel-owner+w=401wt.eu-S1753661AbZJXOBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753661AbZJXOBU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Oct 2009 10:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753607AbZJXOBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Oct 2009 10:01:19 -0400
Received: from mailout05.t-online.de ([194.25.134.82]:47692 "EHLO
	mailout05.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753507AbZJXOBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Oct 2009 10:01:18 -0400
Message-ID: <4AE308A8.2070309@t-online.de>
Date: Sat, 24 Oct 2009 16:01:12 +0200
From: Harald Dunkel <harald.dunkel@t-online.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090923 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.31.5: /dev/input/event? are gone sometimes
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ID: ZZ2LY+ZXrhqZD6hOa1qTf4n2z-LCGuscCYcfFX3Il2U+ZH4-ZCzLWZW55yG8y0lQs5
X-TOI-MSGID: 3c910aa7-e81d-4d9d-a117-fb943855bf67
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

Sometimes (by chance, as it seems) the /dev/input/event? devices
are not working after power-on or reboot. They are not listed in
/proc/bus/input/devices. The mouse in X is not moving, keyboard
is dead, etc. All I can do is reboot and hope.

Below you can find the diff of /proc/bus/input/devices between
a bad and a good start.


udev is 146-5 (included with Debian Sid).


Any helpful hints would be highly appreciated. Of course I can
send you the .config, if there is some interest.


Regards

Harri
===================================================================
% diff -u devices.bad devices.good
--- devices.bad 2009-10-24 15:08:24.000000000 +0200
+++ devices.good        2009-10-24 15:17:17.000000000 +0200
@@ -3,7 +3,7 @@
  P: Phys=isa0060/serio0/input0
  S: Sysfs=/devices/platform/i8042/serio0/input/input0
  U: Uniq=
-H: Handlers=kbd
+H: Handlers=kbd event0
  B: EV=120013
  B: KEY=402000000 3803078f800d001 feffffdfffefffff fffffffffffffffe
  B: MSC=10
@@ -14,7 +14,7 @@
  P: Phys=usb-0000:00:1a.2-2/input0
  S: Sysfs=/devices/pci0000:00/0000:00:1a.2/usb5/5-2/5-2:1.0/input/input1
  U: Uniq=
-H: Handlers=kbd
+H: Handlers=kbd event1
  B: EV=120013
  B: KEY=1000000000007 ff980000000007ff febeffdfffefffff fffffffffffffffe
  B: MSC=10
@@ -25,7 +25,7 @@
  P: Phys=usb-0000:00:1a.2-2/input1
  S: Sysfs=/devices/pci0000:00/0000:00:1a.2/usb5/5-2/5-2:1.1/input/input2
  U: Uniq=
-H: Handlers=kbd mouse0
+H: Handlers=kbd mouse0 event2
  B: EV=17
  B: KEY=1f001f 2020000 3878d801d001 1e000000000000 0
  B: REL=103
@@ -36,7 +36,25 @@
  P: Phys=isa0061/input0
  S: Sysfs=/devices/platform/pcspkr/input/input3
  U: Uniq=
-H: Handlers=kbd
+H: Handlers=kbd event3
  B: EV=40001
  B: SND=6

+I: Bus=0019 Vendor=0000 Product=0001 Version=0000
+N: Name="Power Button"
+P: Phys=LNXPWRBN/button/input0
+S: Sysfs=/devices/LNXSYSTM:00/LNXPWRBN:00/input/input4
+U: Uniq=
+H: Handlers=kbd event4
+B: EV=3
+B: KEY=10000000000000 0
+
+I: Bus=0019 Vendor=0000 Product=0001 Version=0000
+N: Name="Power Button"
+P: Phys=PNP0C0C/button/input0
+S: Sysfs=/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input5
+U: Uniq=
+H: Handlers=kbd event5
+B: EV=3
+B: KEY=10000000000000 0
+
