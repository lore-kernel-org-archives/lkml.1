Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236Ab0BUU45 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 15:56:57 -0500
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:57096 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753160Ab0BUU4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 15:56:55 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: phil@ipom.com
Subject: [PATCH] unusual_devs.h: Fix capacity for SL11R-IDE 2.6c
Date: Sun, 21 Feb 2010 21:56:43 +0100
User-Agent: KMail/1.9.10
Cc: stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
       usb-storage@lists.one-eyed-alien.net, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201002212156.45896.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SL11R-IDE 2.6c (at least) reports wrong capacity (one sector more).
Reading that last sector causes the device not to work anymore (and looks
like HAL or something does that automatically after plugging in):
sd 5:0:0:0: [sdc] Device not ready
sd 5:0:0:0: [sdc] Result: hostbyte=0x00 driverbyte=0x08
sd 5:0:0:0: [sdc] Sense Key : 0x2 [current]
sd 5:0:0:0: [sdc] ASC=0x0 ASCQ=0x0
sd 5:0:0:0: [sdc] CDB: cdb[0]=0x28: 28 00 04 a8 b5 70 00 00 01 00

Add unusual_devs entry to fix the capacity.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

--- linux-2.6.32-orig/drivers/usb/storage/unusual_devs.h	2009-12-03 04:51:21.000000000 +0100
+++ linux-2.6.32/drivers/usb/storage/unusual_devs.h	2010-02-21 20:23:12.000000000 +0100
@@ -374,6 +374,12 @@ UNUSUAL_DEV(  0x04ce, 0x0002, 0x0074, 0x
 		US_SC_DEVICE, US_PR_DEVICE, NULL,
 		US_FL_FIX_INQUIRY),
 
+UNUSUAL_DEV(  0x04ce, 0x0002, 0x026c, 0x026c,
+		"ScanLogic",
+		"SL11R-IDE",
+		US_SC_DEVICE, US_PR_DEVICE, NULL,
+		US_FL_FIX_CAPACITY),
+
 /* Reported by Kriston Fincher <kriston@airmail.net>
  * Patch submitted by Sean Millichamp <sean@bruenor.org>
  * This is to support the Panasonic PalmCam PV-SD4090

-- 
Ondrej Zary
