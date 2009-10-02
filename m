Return-Path: <linux-kernel-owner+w=401wt.eu-S1757249AbZJBBzJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757249AbZJBBzJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:55:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755467AbZJBBdC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:33:02 -0400
Received: from kroah.org ([198.145.64.141]:33062 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755602AbZJBBc7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:32:59 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:12 2009
Message-Id: <20091002012412.038619620@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:16:28 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Pawel Ludwikow <pludwiko@rab.ict.pwr.wroc.pl>
Subject: [040/136] USB: serial: ftdi_sio: new hardware support - hameg power supply
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=usb-serial-ftdi_sio-new-hardware-support-hameg-power-supply.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Pawel Ludwikow <pludwiko@rab.ict.pwr.wroc.pl>

commit e7d7fcc09ebde1ea1773521ecab5a3f0ad6bef6e upstream.

I'd like to present my small patch enabling to use Hameg HM8143 programmable
power supply with linux.

Signed-off-by: Pawel Ludwikow <pludwiko@rab.ict.pwr.wroc.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/ftdi_sio.c |    2 ++
 drivers/usb/serial/ftdi_sio.h |    6 ++++++
 2 files changed, 8 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -702,6 +702,8 @@ static struct usb_device_id id_table_com
 	{ USB_DEVICE(BAYER_VID, BAYER_CONTOUR_CABLE_PID) },
 	{ USB_DEVICE(FTDI_VID, MARVELL_OPENRD_PID),
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
+	{ USB_DEVICE(FTDI_VID, HAMEG_HO820_PID) },
+	{ USB_DEVICE(FTDI_VID, HAMEG_HO870_PID) },
 	{ },					/* Optional parameter entry */
 	{ }					/* Terminating entry */
 };
--- a/drivers/usb/serial/ftdi_sio.h
+++ b/drivers/usb/serial/ftdi_sio.h
@@ -968,6 +968,12 @@
 #define MARVELL_OPENRD_PID	0x9e90
 
 /*
+ * Hameg HO820 and HO870 interface (using VID 0x0403)
+ */
+#define        HAMEG_HO820_PID         0xed74
+#define        HAMEG_HO870_PID         0xed71
+
+/*
  *   BmRequestType:  1100 0000b
  *   bRequest:       FTDI_E2_READ
  *   wValue:         0


