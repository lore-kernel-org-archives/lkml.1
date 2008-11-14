Return-Path: <linux-kernel-owner+w=401wt.eu-S1755670AbYKNSUU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755670AbYKNSUU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 13:20:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754279AbYKNSUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 13:20:04 -0500
Received: from rn-out-0910.google.com ([64.233.170.185]:37347 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753856AbYKNSUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 13:20:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=US+8D1VarrS1Wb5R55oHS6sZCPrUnPD29DYTzmp5pRMJnkkqe+gEqlU+o4R2PNq5zy
         pfaIGdnZ92tyO0jyHgkW9O+tEu8l9jBRKASMoQSLLyJryVUpkJ8tCE9lx1WhDB21intg
         EbmgQKra9gxImVZgtMaLxWichZZmPjGHCzBMo=
Subject: [PATCH] dvb: usb vendor_ids/product_ids are __le16
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: v4l-maintainer <v4l-dvb-maintainer@linuxtv.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 14 Nov 2008 10:19:56 -0800
Message-Id: <1226686796.5483.33.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Noticed by sparse:
drivers/media/dvb/dvb-usb/af9015.c:756:25: warning: restricted __le16 degrades to integer
drivers/media/dvb/dvb-usb/af9015.c:744:28: warning: restricted __le16 degrades to integer

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/media/dvb/dvb-usb/af9015.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/af9015.c b/drivers/media/dvb/dvb-usb/af9015.c
index 4b2af32..eb4495a 100644
--- a/drivers/media/dvb/dvb-usb/af9015.c
+++ b/drivers/media/dvb/dvb-usb/af9015.c
@@ -742,7 +742,7 @@ static int af9015_read_config(struct usb_device *udev)
 			}
 		} else {
 			switch (udev->descriptor.idVendor) {
-			case USB_VID_LEADTEK:
+			case cpu_to_le16(USB_VID_LEADTEK):
 				af9015_properties[i].rc_key_map =
 				  af9015_rc_keys_leadtek;
 				af9015_properties[i].rc_key_map_size =
@@ -752,9 +752,9 @@ static int af9015_read_config(struct usb_device *udev)
 				af9015_config.ir_table_size =
 				  ARRAY_SIZE(af9015_ir_table_leadtek);
 				break;
-			case USB_VID_VISIONPLUS:
+			case cpu_to_le16(USB_VID_VISIONPLUS):
 				if (udev->descriptor.idProduct ==
-				USB_PID_AZUREWAVE_AD_TU700) {
+				cpu_to_le16(USB_PID_AZUREWAVE_AD_TU700)) {
 					af9015_properties[i].rc_key_map =
 					  af9015_rc_keys_twinhan;
 					af9015_properties[i].rc_key_map_size =
@@ -765,7 +765,7 @@ static int af9015_read_config(struct usb_device *udev)
 					  ARRAY_SIZE(af9015_ir_table_twinhan);
 				}
 				break;
-			case USB_VID_KWORLD_2:
+			case cpu_to_le16(USB_VID_KWORLD_2):
 				/* TODO: use correct rc keys */
 				af9015_properties[i].rc_key_map =
 				  af9015_rc_keys_twinhan;
@@ -778,7 +778,7 @@ static int af9015_read_config(struct usb_device *udev)
 			/* Check USB manufacturer and product strings and try
 			   to determine correct remote in case of chip vendor
 			   reference IDs are used. */
-			case USB_VID_AFATECH:
+			case cpu_to_le16(USB_VID_AFATECH):
 				memset(manufacturer, 0, sizeof(manufacturer));
 				usb_string(udev, udev->descriptor.iManufacturer,
 					manufacturer, sizeof(manufacturer));
@@ -806,7 +806,7 @@ static int af9015_read_config(struct usb_device *udev)
 					  ARRAY_SIZE(af9015_ir_table_msi);
 				}
 				break;
-			case USB_VID_AVERMEDIA:
+			case cpu_to_le16(USB_VID_AVERMEDIA):
 				af9015_properties[i].rc_key_map =
 				  af9015_rc_keys_avermedia;
 				af9015_properties[i].rc_key_map_size =
-- 
1.6.0.4.879.g9d19a



