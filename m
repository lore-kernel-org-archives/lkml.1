Return-Path: <linux-kernel-owner+w=401wt.eu-S1761797AbYAQWwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761797AbYAQWwg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 17:52:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760237AbYAQWkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 17:40:20 -0500
Received: from elasmtp-dupuy.atl.sa.earthlink.net ([209.86.89.62]:55356 "EHLO
	elasmtp-dupuy.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760466AbYAQWkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 17:40:16 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=mindspring.com;
  b=kJfAztKZ7mYQAksbBgUbojQkauJO70i5sTCa6ltavhl1tlZmtqmZPvpQBtYmq6Vz;
  h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:Subject:Content-Type:Content-Transfer-Encoding:X-ELNK-Trace:X-Originating-IP;
Message-ID: <478FD8BA.6040604@mindspring.com>
Date: Thu, 17 Jan 2008 17:37:46 -0500
From: Ed Beroset <beroset@mindspring.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.11) Gecko/20071202 Fedora/1.1.7-1.fc7 pango-text SeaMonkey/1.1.7
MIME-Version: 1.0
To: gregkh@suse.de, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net
Subject: [PATCH] usb-serial: ftdi driver- add support for optical probe device
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ELNK-Trace: 105d402e9ac1c2b99649176a89d694c0f43c108795ac45073b422ed00b06ca032175408de4edc2a2350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 66.245.123.200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is for the 2.6.24-rc8 kernel.

Added support for the Elster Unicom III Optical Probe.
The device ID has already been added to the usb.ids file.

Signed-off-by:  Ed Beroset <beroset@mindspring.com>
---

diff -aur --exclude-from=a/.gitignore a/drivers/usb/serial/ftdi_sio.c
b/drivers/usb/serial/ftdi_sio.c
--- a/drivers/usb/serial/ftdi_sio.c	2008-01-16 10:03:24.000000000 -0500
+++ b/drivers/usb/serial/ftdi_sio.c	2008-01-16 10:59:22.000000000 -0500
@@ -17,6 +17,10 @@
   * See http://ftdi-usb-sio.sourceforge.net for upto date testing info
   *	and extra documentation
   *
+ * (16/Jan/2007) Ed Beroset
+ *      Added PID for Elster Unicom III Optical Probe
+ *      see http://www.elsterelectricity.com/ for product description
+ *
   * (21/Jul/2004) Ian Abbott
   *      Incorporated Steven Turner's code to add support for the
FT2232C chip.
   *      The prelimilary port to the 2.6 kernel was by Rus V.
Brushkoff.  I have
@@ -571,6 +575,7 @@
  	{ USB_DEVICE(TML_VID, TML_USB_SERIAL_PID) },
  	{ USB_DEVICE(OLIMEX_VID, OLIMEX_ARM_USB_OCD_PID),
  		.driver_info = (kernel_ulong_t)&ftdi_olimex_quirk },
+	{ USB_DEVICE(FTDI_VID, FTDI_ELSTER_UNICOM_PID) },
  	{ },					/* Optional parameter entry */
  	{ }					/* Terminating entry */
  };
diff -aur --exclude-from=a/.gitignore a/drivers/usb/serial/ftdi_sio.h
b/drivers/usb/serial/ftdi_sio.h
--- a/drivers/usb/serial/ftdi_sio.h	2008-01-16 10:03:24.000000000 -0500
+++ b/drivers/usb/serial/ftdi_sio.h	2008-01-16 11:01:44.000000000 -0500
@@ -534,6 +534,8 @@
  #define OLIMEX_VID			0x15BA
  #define OLIMEX_ARM_USB_OCD_PID		0x0003

+/* www.elsterelectricity.com Elster Unicom III Optical Probe */
+#define FTDI_ELSTER_UNICOM_PID 0xE700 /* Product Id */

  /*
   * The Mobility Lab (TML)

