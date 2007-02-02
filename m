Return-Path: <linux-kernel-owner+w=401wt.eu-S1945953AbXBBQhl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945953AbXBBQhl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 11:37:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945979AbXBBQhl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 11:37:41 -0500
Received: from 81-174-11-161.f5.ngi.it ([81.174.11.161]:45240 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945953AbXBBQhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 11:37:40 -0500
Date: Fri, 2 Feb 2007 17:37:46 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: linux-arm-kernel@lists.arm.linux.org.uk
Cc: linux-kernel@vger.kernel.org
Message-ID: <20070202163746.GG8882@enneenne.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="eheScQNz3K90DVRs"
Content-Disposition: inline
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: [PATCH] ARM: Convert to use shared "Device Drivers" menu
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--eheScQNz3K90DVRs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

ARM: Convert to use shared "Device Drivers" menu.

Signed-off-by: Rodolfo Giometti <giometti@enneenne.com>

--eheScQNz3K90DVRs
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="arm-drivers-menu-reunion.patch"

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 6783c2e..a2ca665 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -885,84 +885,7 @@ endmenu
 
 source "net/Kconfig"
 
-menu "Device Drivers"
-
-source "drivers/base/Kconfig"
-
-source "drivers/connector/Kconfig"
-
-if ALIGNMENT_TRAP || !CPU_CP15_MMU
-source "drivers/mtd/Kconfig"
-endif
-
-source "drivers/parport/Kconfig"
-
-source "drivers/pnp/Kconfig"
-
-source "drivers/block/Kconfig"
-
-source "drivers/acorn/block/Kconfig"
-
-if PCMCIA || ARCH_CLPS7500 || ARCH_IOP32X || ARCH_IOP33X || ARCH_IXP4XX \
-	|| ARCH_L7200 || ARCH_LH7A40X || ARCH_PXA || ARCH_RPC \
-	|| ARCH_S3C2410 || ARCH_SA1100 || ARCH_SHARK || FOOTBRIDGE \
-	|| ARCH_IXP23XX
-source "drivers/ide/Kconfig"
-endif
-
-source "drivers/scsi/Kconfig"
-
-source "drivers/ata/Kconfig"
-
-source "drivers/md/Kconfig"
-
-source "drivers/message/fusion/Kconfig"
-
-source "drivers/ieee1394/Kconfig"
-
-source "drivers/message/i2o/Kconfig"
-
-source "drivers/net/Kconfig"
-
-source "drivers/isdn/Kconfig"
-
-# input before char - char/joystick depends on it. As does USB.
-
-source "drivers/input/Kconfig"
-
-source "drivers/char/Kconfig"
-
-source "drivers/i2c/Kconfig"
-
-source "drivers/spi/Kconfig"
-
-source "drivers/w1/Kconfig"
-
-source "drivers/hwmon/Kconfig"
-
-#source "drivers/l3/Kconfig"
-
-source "drivers/misc/Kconfig"
-
-source "drivers/mfd/Kconfig"
-
-source "drivers/leds/Kconfig"
-
-source "drivers/media/Kconfig"
-
-source "drivers/video/Kconfig"
-
-source "sound/Kconfig"
-
-source "drivers/hid/Kconfig"
-
-source "drivers/usb/Kconfig"
-
-source "drivers/mmc/Kconfig"
-
-source "drivers/rtc/Kconfig"
-
-endmenu
+source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
diff --git a/drivers/Kconfig b/drivers/Kconfig
index e7da9fa..23c1f57 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -6,7 +6,9 @@ source "drivers/base/Kconfig"
 
 source "drivers/connector/Kconfig"
 
+if ! ARM || ( ALIGNMENT_TRAP || !CPU_CP15_MMU )
 source "drivers/mtd/Kconfig"
+endif
 
 source "drivers/parport/Kconfig"
 
@@ -18,7 +20,14 @@ source "drivers/block/Kconfig"
 
 source "drivers/misc/Kconfig"
 
+source "drivers/acorn/block/Kconfig"
+
+if ! ARM || ( PCMCIA || ARCH_CLPS7500 || ARCH_IOP32X || ARCH_IOP33X || \
+              ARCH_IXP4XX || ARCH_L7200 || ARCH_LH7A40X || ARCH_PXA || \
+	      ARCH_RPC || ARCH_S3C2410 || ARCH_SA1100 || ARCH_SHARK || \
+	      FOOTBRIDGE || ARCH_IXP23XX )
 source "drivers/ide/Kconfig"
+endif
 
 source "drivers/scsi/Kconfig"
 

--eheScQNz3K90DVRs--
