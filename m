Return-Path: <linux-kernel-owner+w=401wt.eu-S1753715AbXLDMqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715AbXLDMqQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 07:46:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751610AbXLDMqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 07:46:05 -0500
Received: from moutng.kundenserver.de ([212.227.126.179]:56942 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbXLDMqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 07:46:04 -0500
Message-ID: <47554BE5.7000204@anagramm.de>
Date: Tue, 04 Dec 2007 13:45:25 +0100
From: Clemens Koller <clemens.koller@anagramm.de>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: LKML List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Allow to disable CONFIG_SCSI_WAIT_SCAN=m in menuconfig.
Content-Type: multipart/mixed;
 boundary="------------090506010102050707000303"
X-Provags-ID: V01U2FsdGVkX1/OS0wau35q+zkTMGGjp52NLcT7D7oCHujP8d+
 xOy9hYwsKZWEKYzA9jai6Wg4s7Smuz/HGeWoKZietBA4RfSRSg
 4u5NkGtiistO1fQvNxEYw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090506010102050707000303
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit

Hi there!

This was already discussed in May: http://lkml.org/lkml/2007/5/13/75
without any valuable results.

I don't want to have the scsi_wait_scan.ko around but still need
SCSI for usb disks and module support for driver development.
Otherwise, I am working with a monolithic kernel on embedded machines.

The attached patch is another try to at least allow to get
rid of this module.

Feedback is welcome.

Regards,
-- 
Clemens Koller
__________________________________
R&D Imaging Devices
Anagramm GmbH
Rupert-Mayer-Straße 45/1
Linhof Werksgelände
D-81379 München
Tel.089-741518-50
Fax 089-741518-19
http://www.anagramm-technology.com

--------------090506010102050707000303
Content-Type: text/plain;
 name="allow-disabling-of-scsi_wait_scan-module.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="allow-disabling-of-scsi_wait_scan-module.patch"

Allow to disable to build the scsi_wait_scan.ko module if not needed.

Signed-off-by: Clemens Koller <clemens.koller@anagramm.de>

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index a6676be..1dc452d 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -248,10 +248,19 @@ config SCSI_SCAN_ASYNC
 	  or async on the kernel's command line.
 
 config SCSI_WAIT_SCAN
-	tristate
+	tristate "create module which waits for SCSI scanning to finish"
 	default m
 	depends on SCSI
 	depends on MODULES
+	help
+	  When this module is loaded, it will do nothing else than wait for
+	  SCSI low-level drivers to finish asynchronous scanning for devices.
+	  This module will be called scsi_wait_scan.
+
+	  It's default and safe to create this module even if it's not used
+	  in your distro's init scripts. You can override this if you are
+	  really sure you don't need or want it. It does not make sense to
+	  compile this into the kernel with Y.
 
 menu "SCSI Transports"
 	depends on SCSI

--------------090506010102050707000303--
