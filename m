Return-Path: <linux-kernel-owner+w=401wt.eu-S933848AbYBGU40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933848AbYBGU40 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 15:56:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758273AbYBGUvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 15:51:11 -0500
Received: from mx1.suse.de ([195.135.220.2]:45161 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758289AbYBGUvI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 15:51:08 -0500
Date: Thu, 7 Feb 2008 12:47:04 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, linux-usb@vger.kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Peter Stark <peter.stark@t-online.de>
Subject: [patch 11/45] USB: ftdi_sio - enabling multiple ELV devices,
	adding EM1010PC
Message-ID: <20080207204704.GL16389@suse.de>
References: <20080207204118.202098927@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-ftdi_sio-enabling-multiple-elv-devices-adding-em1010pc.patch"
In-Reply-To: <20080207204549.GA16389@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.24-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Peter Stark <Peter.Stark@t-online.de>

I work with a group of people on a free home automation tool called
FHEM.  Some of the users own more than one USB-serial device by ELV. The
ftdi_sio driver has most of the ELV devices disabled by default and
needs to be re-enabled every time you get a new kernel. Additionally a
new device (EM 1010 PC - enegry monitor) is missing in the list.
Currently our users have to follow the instructions we provide at
http://www.koeniglich.de/fhem/linux.html ... However, to some users it
is too complicated to compile their own kernel module.

We are aware that you can specify one additional device using the
vendor/product option of the module. But lot's of users own more than
one device.

Signed-off-by: Peter Stark <peter.stark@t-online.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/ftdi_sio.c |   44 ++++++++++++++++++++----------------------
 drivers/usb/serial/ftdi_sio.h |    1 
 2 files changed, 22 insertions(+), 23 deletions(-)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -471,30 +471,28 @@ static struct usb_device_id id_table_com
 	{ USB_DEVICE(FTDI_VID, FTDI_IBS_PEDO_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_IBS_PROD_PID) },
 	/*
-	 * These will probably use user-space drivers.  Uncomment them if
-	 * you need them or use the user-specified vendor/product module
-	 * parameters (see ftdi_sio.h for the numbers).  Make a fuss if
-	 * you think the driver should recognize any of them by default.
+	 * Due to many user requests for multiple ELV devices we enable
+	 * them by default.
 	 */
-	/* { USB_DEVICE(FTDI_VID, FTDI_ELV_CLI7000_PID) }, */
-	/* { USB_DEVICE(FTDI_VID, FTDI_ELV_PPS7330_PID) }, */
-	/* { USB_DEVICE(FTDI_VID, FTDI_ELV_TFM100_PID) }, */
-	/* { USB_DEVICE(FTDI_VID, FTDI_ELV_UDF77_PID) }, */
-	/* { USB_DEVICE(FTDI_VID, FTDI_ELV_UIO88_PID) }, */
-	/* { USB_DEVICE(FTDI_VID, FTDI_ELV_UAD8_PID) }, */
-	/* { USB_DEVICE(FTDI_VID, FTDI_ELV_UDA7_PID) }, */
-	/* { USB_DEVICE(FTDI_VID, FTDI_ELV_USI2_PID) }, */
-	/* { USB_DEVICE(FTDI_VID, FTDI_ELV_T1100_PID) }, */
-	/* { USB_DEVICE(FTDI_VID, FTDI_ELV_PCD200_PID) }, */
-	/* { USB_DEVICE(FTDI_VID, FTDI_ELV_ULA200_PID) }, */
-	/* { USB_DEVICE(FTDI_VID, FTDI_ELV_CSI8_PID) }, */
-	/* { USB_DEVICE(FTDI_VID, FTDI_ELV_EM1000DL_PID) }, */
-	/* { USB_DEVICE(FTDI_VID, FTDI_ELV_PCK100_PID) }, */
-	/* { USB_DEVICE(FTDI_VID, FTDI_ELV_RFP500_PID) }, */
-	/* { USB_DEVICE(FTDI_VID, FTDI_ELV_FS20SIG_PID) }, */
-	/* { USB_DEVICE(FTDI_VID, FTDI_ELV_WS300PC_PID) }, */
-	/* { USB_DEVICE(FTDI_VID, FTDI_ELV_FHZ1300PC_PID) }, */
-	/* { USB_DEVICE(FTDI_VID, FTDI_ELV_WS500_PID) }, */
+	{ USB_DEVICE(FTDI_VID, FTDI_ELV_CLI7000_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_ELV_PPS7330_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_ELV_TFM100_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_ELV_UDF77_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_ELV_UIO88_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_ELV_UAD8_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_ELV_UDA7_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_ELV_USI2_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_ELV_T1100_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_ELV_PCD200_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_ELV_ULA200_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_ELV_CSI8_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_ELV_EM1000DL_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_ELV_PCK100_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_ELV_RFP500_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_ELV_FS20SIG_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_ELV_WS300PC_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_ELV_FHZ1300PC_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_ELV_WS500_PID) },
 	{ USB_DEVICE(FTDI_VID, LINX_SDMUSBQSS_PID) },
 	{ USB_DEVICE(FTDI_VID, LINX_MASTERDEVEL2_PID) },
 	{ USB_DEVICE(FTDI_VID, LINX_FUTURE_0_PID) },
--- a/drivers/usb/serial/ftdi_sio.h
+++ b/drivers/usb/serial/ftdi_sio.h
@@ -245,6 +245,7 @@
 #define FTDI_ELV_WS300PC_PID	0xE0F6	/* PC-Wetterstation (WS 300 PC) */
 #define FTDI_ELV_FHZ1300PC_PID	0xE0E8	/* FHZ 1300 PC */
 #define FTDI_ELV_WS500_PID	0xE0E9	/* PC-Wetterstation (WS 500) */
+#define FTDI_ELV_EM1010PC_PID	0xE0EF	/* Engery monitor EM 1010 PC */
 
 /*
  * Definitions for ID TECH (www.idt-net.com) devices

-- 
