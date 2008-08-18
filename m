Return-Path: <linux-kernel-owner+w=401wt.eu-S1761586AbYHRT1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761586AbYHRT1f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 15:27:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760551AbYHRT1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 15:27:08 -0400
Received: from ns2.suse.de ([195.135.220.15]:40300 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762153AbYHRT1G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 15:27:06 -0400
Date: Mon, 18 Aug 2008 12:19:25 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Frederik Kriewitz <frederik@kriewitz.eu>
Subject: [patch 06/49] USB: ftdi_sio: add support for Luminance Stellaris
	Evaluation/Development Kits
Message-ID: <20080818191925.GG10350@suse.de>
References: <20080818191012.663450219@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-ftdi_sio-add-support-for-luminance-stellaris-evaluation-development-kits.patch"
In-Reply-To: <20080818191834.GA10350@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Frederik Kriewitz <frederik@kriewitz.eu>

commit a00c3cadc2bf50b3c925acdb3d0e5789b1650498 upstream

The Patch adds support for Luminance Stellaris Evaluation/Development
Kits (FTDI 2232C based).
The PIDs were missing.

Successfully tested with a Stellaris LM3S8962 Evaluation kit.

Signed-off-by: Frederik Kriewitz <frederik@kriewitz.eu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/ftdi_sio.c |    4 ++++
 drivers/usb/serial/ftdi_sio.h |    5 +++++
 2 files changed, 9 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -367,6 +367,10 @@ static struct usb_device_id id_table_com
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
 	{ USB_DEVICE(FTDI_VID, FTDI_OOCDLINK_PID),
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
+	{ USB_DEVICE(FTDI_VID, LMI_LM3S_DEVEL_BOARD_PID),
+		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
+	{ USB_DEVICE(FTDI_VID, LMI_LM3S_EVAL_BOARD_PID),
+		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
 	{ USB_DEVICE(RATOC_VENDOR_ID, RATOC_PRODUCT_ID_USB60F) },
 	{ },					/* Optional parameter entry */
 	{ }					/* Terminating entry */
--- a/drivers/usb/serial/ftdi_sio.h
+++ b/drivers/usb/serial/ftdi_sio.h
@@ -548,6 +548,11 @@
 #define OLIMEX_VID			0x15BA
 #define OLIMEX_ARM_USB_OCD_PID		0x0003
 
+/* Luminary Micro Stellaris Boards, VID = FTDI_VID */
+/* FTDI 2332C Dual channel device, side A=245 FIFO (JTAG), Side B=RS232 UART */
+#define LMI_LM3S_DEVEL_BOARD_PID	0xbcd8
+#define LMI_LM3S_EVAL_BOARD_PID		0xbcd9
+
 /* www.elsterelectricity.com Elster Unicom III Optical Probe */
 #define FTDI_ELSTER_UNICOM_PID		0xE700 /* Product Id */
 

-- 
