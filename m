Return-Path: <linux-kernel-owner+w=401wt.eu-S1753987AbZGNUxJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987AbZGNUxJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 16:53:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752253AbZGNUxI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 16:53:08 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:49233 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663AbZGNUxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 16:53:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=TOQd4iFRpq5LwgsMBcFb187t71KEmmt/Z5KFTDIQWclmKWFppDwy0OSBsvLnqquyKx
         f/tLOjuRk+BHA6Buj/gcYsXoYya5pM0jusNR6wxqOvpMS4fQ7eODUZUZtVZpemi2WHGq
         RoCYVj/CPebsIhdGrixRbo8hJ49gL4GD7YXzM=
MIME-Version: 1.0
From: Ville Sundberg <vsundber@gmail.com>
Date: Tue, 14 Jul 2009 23:52:45 +0300
Message-ID: <246ec9720907141352p74744040xdb7e7083347b863a@mail.gmail.com>
Subject: [PATCH] ftdi_sio: Add support for GN Otometrics Aurical USB 
	Audiometer
To: linux-usb-devel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch adds support for the GN Otometrics Aurical USB Audiometer
(FT232BM-based).
A new VID and a new PID is added.

Signed-off-by: Ville Sundberg <vsundber@gmail.com>

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 60c64cc..b574878 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -698,6 +698,7 @@ static struct usb_device_id id_table_combined [] = {
 	{ USB_DEVICE(MARVELL_VID, MARVELL_SHEEVAPLUG_PID),
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
 	{ USB_DEVICE(LARSENBRUSGAARD_VID, LB_ALTITRACK_PID) },
+	{ USB_DEVICE(GN_OTOMETRICS_VID, AURICAL_USB_PID) },
 	{ },					/* Optional parameter entry */
 	{ }					/* Terminating entry */
 };
diff --git a/drivers/usb/serial/ftdi_sio.h b/drivers/usb/serial/ftdi_sio.h
index c9fbd74..77f2c4b 100644
--- a/drivers/usb/serial/ftdi_sio.h
+++ b/drivers/usb/serial/ftdi_sio.h
@@ -947,6 +947,14 @@
 #define FTDI_TURTELIZER_PID	0xBDC8 /* JTAG/RS-232 adapter by egnite GmBH */

 /*
+ * GN Otometrics (http://www.otometrics.com)
+ * Submitted by Ville Sundberg.
+ */
+#define GN_OTOMETRICS_VID	0x0c33 /* Vendor ID */
+#define AURICAL_USB_PID		0x0010 /* Aurical USB Audiometer */
+
+
+/*
  *   BmRequestType:  1100 0000b
  *   bRequest:       FTDI_E2_READ
  *   wValue:         0
