Return-Path: <linux-kernel-owner+w=401wt.eu-S1030503AbXAYTOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030503AbXAYTOn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 14:14:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030508AbXAYTOn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 14:14:43 -0500
Received: from the.earth.li ([193.201.200.66]:36884 "EHLO the.earth.li"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030503AbXAYTOn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 14:14:43 -0500
X-Greylist: delayed 1982 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Jan 2007 14:14:42 EST
Date: Thu, 25 Jan 2007 18:41:39 +0000
From: Jonathan McDowell <noodles@earth.li>
To: i2c@lm-sensors.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Add support for OneForAll remote JP1 parallel port interface
Message-ID: <20070125184139.GV27092@earth.li>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This simple patch adds support to i2c-parport for the OneForAll remote
JP1 parallel port interfaces which can be found detailed at:

http://www.hifi-remote.com/jp1/hardware.shtml

These allow access to the internal configuration EEPROM on various
remote controls and there are a variety of Windows tools that make use
of this hardware. I have tested this patch with the "simple" parallel
port device and a OneForAll URC-7562 and confirmed that the data read
using the eeprom i2c driver matches that returned by the Windows "IR"
JP1 tool.

Signed-Off-By: Jonathan McDowell <noodles@earth.li>

-----
--- linux-2.6.19/Documentation/i2c/busses/i2c-parport.orig	2007-01-25 18:19:29.000000000 +0000
+++ linux-2.6.19/Documentation/i2c/busses/i2c-parport	2007-01-25 18:22:12.000000000 +0000
@@ -19,6 +19,7 @@
  * (type=4) Analog Devices ADM1032 evaluation board
  * (type=5) Analog Devices evaluation boards: ADM1025, ADM1030, ADM1031
  * (type=6) Barco LPT->DVI (K5800236) adapter
+ * (type=7) OneForAll JP1 parallel port adapter
 
 These devices use different pinout configurations, so you have to tell
 the driver what you have, using the type module parameter. There is no
@@ -157,3 +158,17 @@
   http://home.wanadoo.nl/hihihi/libk8005.htm
   http://struyve.mine.nu:8080/index.php?block=k8000
   http://sourceforge.net/projects/libk8005/
+
+
+OneForAll JP1 parallel port adapter
+-----------------------------------
+
+The JP1 project revolves around a set of remote controls which expose
+the i2c bus their internal configuration EEPROM lives on via a 6 pin
+jumper in the battery compartment. More details can be found at:
+
+http://www.hifi-remote.com/jp1/
+
+Details of the simple parallel port hardware can be found at:
+
+http://www.hifi-remote.com/jp1/hardware.shtml
--- linux-2.6.19/drivers/i2c/busses/i2c-parport.h.orig	2007-01-25 18:26:06.000000000 +0000
+++ linux-2.6.19/drivers/i2c/busses/i2c-parport.h	2007-01-25 18:23:14.000000000 +0000
@@ -88,6 +88,13 @@
 		.getscl	= { 0x40, STAT, 0 },
 		.init	= { 0xfc, DATA, 0 },
 	},
+	/* type 7: OneForAll JP1 parallel port adapter */
+	{
+		.setsda	= { 0x01, DATA, 0 },
+		.setscl	= { 0x02, DATA, 0 },
+		.getsda	= { 0x80, STAT, 1 },
+		.init	= { 0x04, DATA, 1 },
+	},
 };
 
 static int type = -1;
@@ -101,4 +108,5 @@
 	" 4 = ADM1032 evaluation board\n"
 	" 5 = ADM1025, ADM1030 and ADM1031 evaluation boards\n"
 	" 6 = Barco LPT->DVI (K5800236) adapter\n"
+	" 7 = OneForAll JP1 parallel port adapter\n"
 );
-----

J.

-- 
] http://www.earth.li/~noodles/ []   "Hey, topic drift isn't just a    [
]  PGP/GPG Key @ the.earth.li   []   hobby, its a way of life around   [
] via keyserver, web or email.  []      here ..." -- \pir, b.l-w       [
] RSA: 4DC4E7FD / DSA: 5B430367 []                                     [
