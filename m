Return-Path: <linux-kernel-owner+w=401wt.eu-S934574AbZLGD4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934574AbZLGD4X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 22:56:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933155AbZLGD4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 22:56:19 -0500
Received: from xenotime.net ([72.52.64.118]:36621 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S934489AbZLGDw4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 22:52:56 -0500
Date: Sun, 06 Dec 2009 18:30:44 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: linux-kernel@vger.kernel.org
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6/6] docs: use misc-devices/ dir for drivers
Message-ID: <12601530444017@xenotime.net>
In-Reply-To: <12601530442994@xenotime.net>
X-Mailer: gregkh_patchbomb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean Delvare <khali@linux-fr.org>
Subject: Doc: use misc-devices/ dir for drivers

We have a directory for misc drivers documentation, let's use it.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Rodolfo Giometti <giometti@linux.it>
---
Resending with proper name quoting, sorry for the noise.

 Documentation/c2port.txt              |   90 ------------------------
 Documentation/ics932s401              |   31 --------
 Documentation/misc-devices/c2port.txt |   90 ++++++++++++++++++++++++
 Documentation/misc-devices/ics932s401 |   31 ++++++++
 4 files changed, 121 insertions(+), 121 deletions(-)

--- lnx-2632-rc6.orig/Documentation/c2port.txt
+++ /dev/null
@@ -1,90 +0,0 @@
-			C2 port support
-			---------------
-
-(C) Copyright 2007 Rodolfo Giometti <giometti@enneenne.com>
-
-This program is free software; you can redistribute it and/or modify
-it under the terms of the GNU General Public License as published by
-the Free Software Foundation; either version 2 of the License, or
-(at your option) any later version.
-
-This program is distributed in the hope that it will be useful,
-but WITHOUT ANY WARRANTY; without even the implied warranty of
-MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-GNU General Public License for more details.
-
-
-
-Overview
---------
-
-This driver implements the support for Linux of Silicon Labs (Silabs)
-C2 Interface used for in-system programming of micro controllers.
-
-By using this driver you can reprogram the in-system flash without EC2
-or EC3 debug adapter. This solution is also useful in those systems
-where the micro controller is connected via special GPIOs pins.
-
-References
-----------
-
-The C2 Interface main references are at (http://www.silabs.com)
-Silicon Laboratories site], see:
-
-- AN127: FLASH Programming via the C2 Interface at
-http://www.silabs.com/public/documents/tpub_doc/anote/Microcontrollers/Small_Form_Factor/en/an127.pdf, and
-
-- C2 Specification at
-http://www.silabs.com/public/documents/tpub_doc/spec/Microcontrollers/en/C2spec.pdf,
-
-however it implements a two wire serial communication protocol (bit
-banging) designed to enable in-system programming, debugging, and
-boundary-scan testing on low pin-count Silicon Labs devices. Currently
-this code supports only flash programming but extensions are easy to
-add.
-
-Using the driver
-----------------
-
-Once the driver is loaded you can use sysfs support to get C2port's
-info or read/write in-system flash.
-
-# ls /sys/class/c2port/c2port0/
-access            flash_block_size  flash_erase       rev_id
-dev_id            flash_blocks_num  flash_size        subsystem/
-flash_access      flash_data        reset             uevent
-
-Initially the C2port access is disabled since you hardware may have
-such lines multiplexed with other devices so, to get access to the
-C2port, you need the command:
-
-# echo 1 > /sys/class/c2port/c2port0/access
-
-after that you should read the device ID and revision ID of the
-connected micro controller:
-
-# cat /sys/class/c2port/c2port0/dev_id
-8
-# cat /sys/class/c2port/c2port0/rev_id
-1
-
-However, for security reasons, the in-system flash access in not
-enabled yet, to do so you need the command:
-
-# echo 1 > /sys/class/c2port/c2port0/flash_access
-
-After that you can read the whole flash:
-
-# cat /sys/class/c2port/c2port0/flash_data > image
-
-erase it:
-
-# echo 1 > /sys/class/c2port/c2port0/flash_erase
-
-and write it:
-
-# cat image > /sys/class/c2port/c2port0/flash_data
-
-after writing you have to reset the device to execute the new code:
-
-# echo 1 > /sys/class/c2port/c2port0/reset
--- lnx-2632-rc6.orig/Documentation/ics932s401
+++ /dev/null
@@ -1,31 +0,0 @@
-Kernel driver ics932s401
-======================
-
-Supported chips:
-  * IDT ICS932S401
-    Prefix: 'ics932s401'
-    Addresses scanned: I2C 0x69
-    Datasheet: Publically available at the IDT website
-
-Author: Darrick J. Wong
-
-Description
------------
-
-This driver implements support for the IDT ICS932S401 chip family.
-
-This chip has 4 clock outputs--a base clock for the CPU (which is likely
-multiplied to get the real CPU clock), a system clock, a PCI clock, a USB
-clock, and a reference clock.  The driver reports selected and actual
-frequency.  If spread spectrum mode is enabled, the driver also reports by what
-percent the clock signal is being spread, which should be between 0 and -0.5%.
-All frequencies are reported in KHz.
-
-The ICS932S401 monitors all inputs continuously. The driver will not read
-the registers more often than once every other second.
-
-Special Features
-----------------
-
-The clocks could be reprogrammed to increase system speed.  I will not help you
-do this, as you risk damaging your system!
--- /dev/null
+++ lnx-2632-rc6/Documentation/misc-devices/c2port.txt
@@ -0,0 +1,90 @@
+			C2 port support
+			---------------
+
+(C) Copyright 2007 Rodolfo Giometti <giometti@enneenne.com>
+
+This program is free software; you can redistribute it and/or modify
+it under the terms of the GNU General Public License as published by
+the Free Software Foundation; either version 2 of the License, or
+(at your option) any later version.
+
+This program is distributed in the hope that it will be useful,
+but WITHOUT ANY WARRANTY; without even the implied warranty of
+MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+GNU General Public License for more details.
+
+
+
+Overview
+--------
+
+This driver implements the support for Linux of Silicon Labs (Silabs)
+C2 Interface used for in-system programming of micro controllers.
+
+By using this driver you can reprogram the in-system flash without EC2
+or EC3 debug adapter. This solution is also useful in those systems
+where the micro controller is connected via special GPIOs pins.
+
+References
+----------
+
+The C2 Interface main references are at (http://www.silabs.com)
+Silicon Laboratories site], see:
+
+- AN127: FLASH Programming via the C2 Interface at
+http://www.silabs.com/public/documents/tpub_doc/anote/Microcontrollers/Small_Form_Factor/en/an127.pdf, and
+
+- C2 Specification at
+http://www.silabs.com/public/documents/tpub_doc/spec/Microcontrollers/en/C2spec.pdf,
+
+however it implements a two wire serial communication protocol (bit
+banging) designed to enable in-system programming, debugging, and
+boundary-scan testing on low pin-count Silicon Labs devices. Currently
+this code supports only flash programming but extensions are easy to
+add.
+
+Using the driver
+----------------
+
+Once the driver is loaded you can use sysfs support to get C2port's
+info or read/write in-system flash.
+
+# ls /sys/class/c2port/c2port0/
+access            flash_block_size  flash_erase       rev_id
+dev_id            flash_blocks_num  flash_size        subsystem/
+flash_access      flash_data        reset             uevent
+
+Initially the C2port access is disabled since you hardware may have
+such lines multiplexed with other devices so, to get access to the
+C2port, you need the command:
+
+# echo 1 > /sys/class/c2port/c2port0/access
+
+after that you should read the device ID and revision ID of the
+connected micro controller:
+
+# cat /sys/class/c2port/c2port0/dev_id
+8
+# cat /sys/class/c2port/c2port0/rev_id
+1
+
+However, for security reasons, the in-system flash access in not
+enabled yet, to do so you need the command:
+
+# echo 1 > /sys/class/c2port/c2port0/flash_access
+
+After that you can read the whole flash:
+
+# cat /sys/class/c2port/c2port0/flash_data > image
+
+erase it:
+
+# echo 1 > /sys/class/c2port/c2port0/flash_erase
+
+and write it:
+
+# cat image > /sys/class/c2port/c2port0/flash_data
+
+after writing you have to reset the device to execute the new code:
+
+# echo 1 > /sys/class/c2port/c2port0/reset
--- /dev/null
+++ lnx-2632-rc6/Documentation/misc-devices/ics932s401
@@ -0,0 +1,31 @@
+Kernel driver ics932s401
+======================
+
+Supported chips:
+  * IDT ICS932S401
+    Prefix: 'ics932s401'
+    Addresses scanned: I2C 0x69
+    Datasheet: Publically available at the IDT website
+
+Author: Darrick J. Wong
+
+Description
+-----------
+
+This driver implements support for the IDT ICS932S401 chip family.
+
+This chip has 4 clock outputs--a base clock for the CPU (which is likely
+multiplied to get the real CPU clock), a system clock, a PCI clock, a USB
+clock, and a reference clock.  The driver reports selected and actual
+frequency.  If spread spectrum mode is enabled, the driver also reports by what
+percent the clock signal is being spread, which should be between 0 and -0.5%.
+All frequencies are reported in KHz.
+
+The ICS932S401 monitors all inputs continuously. The driver will not read
+the registers more often than once every other second.
+
+Special Features
+----------------
+
+The clocks could be reprogrammed to increase system speed.  I will not help you
+do this, as you risk damaging your system!


-- 

