Return-Path: <linux-kernel-owner+w=401wt.eu-S1763590AbXLPAVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763590AbXLPAVe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 19:21:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758772AbXLPAVI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 19:21:08 -0500
Received: from py-out-1112.google.com ([64.233.166.182]:21280 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757993AbXLPAVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 19:21:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=gXir2i01VLq1Ho/eM9q0KDtuRabwn1pAfqGM9jKBC+G75gsKHPFNXO7m4AKLLm5cBCAKznshTWbMay/v0kP8d21mN6233pEIJ++4cNBggSlXUaR2lWkyymZTEtr5vUP5ldn+6r4OywJk9YabZn2sMTFVW1S9YhYtFTrwxlSiKcI=
Message-ID: <8b67d60712151621i5134eb7co9bab02cfe9e4fb81@mail.gmail.com>
Date: Sun, 16 Dec 2007 00:21:05 +0000
From: "Adrian McMenamin" <lkmladrian@gmail.com>
To: linux-kernel@vger.kernel.org, "Paul Mundt" <lethal@linux-sh.org>,
       linux-sh@vger.kernel.org, linux-ide@vger.kernel.org, axboe@kernel.dk
Subject: [PATCH 1/3] Add GD-Rom support to the SEGA Dreamcast
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff -ruN ./linux-2.6-orig/drivers/block/Kconfig
./linux-2.6/drivers/block/Kconfig
--- ./linux-2.6-orig/drivers/block/Kconfig	2007-12-15 22:23:47.000000000 +0000
+++ ./linux-2.6/drivers/block/Kconfig	2007-12-15 22:18:28.000000000 +0000
@@ -105,6 +105,18 @@
 	  "MicroSolutions backpack protocol", "DataStor Commuter protocol"
 	  etc.).

+config	GDROM
+	tristate "SEGA Dreamcast GD-ROM drive"
+	depends on SH_DREAMCAST
+	help
+	  A standard SEGA Dreamcast comes with a modified CD ROM drive called a
+	  "GD-ROM" by SEGA to signify it is capable of reading special disks
+	  with up to 1 GB of data. This drive will also read standard CD ROM
+	  disks. Select this option to access any disks in you GD ROM drive.
+         Most users will want to say "Y" here.
+	  You can also build this as a module - which will be called gdrom.ko
+
+
 source "drivers/block/paride/Kconfig"

 config BLK_CPQ_DA
diff -ruN ./linux-2.6-orig/drivers/cdrom/Makefile
./linux-2.6/drivers/cdrom/Makefile
--- ./linux-2.6-orig/drivers/cdrom/Makefile	2007-12-15 22:23:47.000000000 +0000
+++ ./linux-2.6/drivers/cdrom/Makefile	2007-12-15 22:18:29.000000000 +0000
@@ -11,3 +11,4 @@
 obj-$(CONFIG_CDROM_PKTCDVD)	+=		cdrom.o

 obj-$(CONFIG_VIOCD)		+= viocd.o      cdrom.o
+obj-$(CONFIG_GDROM)		+=		cdrom.o
