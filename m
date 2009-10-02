Return-Path: <linux-kernel-owner+w=401wt.eu-S1755996AbZJBBz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996AbZJBBz3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:55:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757242AbZJBBzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:55:09 -0400
Received: from kroah.org ([198.145.64.141]:33077 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755594AbZJBBdB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:33:01 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:12 2009
Message-Id: <20091002012412.328017076@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:16:30 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Michael Hennerich <michael.hennerich@analog.com>,
       Mike Frysinger <vapier@gentoo.org>
Subject: [042/136] USB: serial: ftdi: handle gnICE+ JTAG adaptors
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=usb-serial-ftdi-handle-gnice-jtag-adaptors.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Michael Hennerich <michael.hennerich@analog.com>

commit 11eaf170363d264ff587f300e41c927ba5a33967 upstream.

Detect the UART on interface1 and blacklist interface0 (as that is the
JTAG port).

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/ftdi_sio.c |    2 ++
 drivers/usb/serial/ftdi_sio.h |    1 +
 2 files changed, 3 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -697,6 +697,8 @@ static struct usb_device_id id_table_com
 	{ USB_DEVICE(DE_VID, WHT_PID) },
 	{ USB_DEVICE(ADI_VID, ADI_GNICE_PID),
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
+	{ USB_DEVICE(ADI_VID, ADI_GNICEPLUS_PID),
+		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
 	{ USB_DEVICE(JETI_VID, JETI_SPC1201_PID) },
 	{ USB_DEVICE(MARVELL_VID, MARVELL_SHEEVAPLUG_PID),
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
--- a/drivers/usb/serial/ftdi_sio.h
+++ b/drivers/usb/serial/ftdi_sio.h
@@ -933,6 +933,7 @@
  */
 #define ADI_VID 		0x0456
 #define ADI_GNICE_PID 		0xF000
+#define ADI_GNICEPLUS_PID 	0xF001
 
 /*
  * JETI SPECTROMETER SPECBOS 1201


