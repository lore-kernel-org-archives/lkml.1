Return-Path: <linux-kernel-owner+w=401wt.eu-S1030293AbXCCOiq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030293AbXCCOiq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 09:38:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030291AbXCCOhg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 09:37:36 -0500
Received: from thing.hostingexpert.com ([67.15.235.34]:47374 "EHLO
	thing.hostingexpert.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030294AbXCCOhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 09:37:08 -0500
Message-ID: <45E987D5.8080200@linuxtv.org>
Date: Sat, 03 Mar 2007 09:36:05 -0500
From: Michael Krufky <mkrufky@linuxtv.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070103)
MIME-Version: 1.0
To: stable@kernel.org
CC: v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [2.6.20.y PATCH 4/7] DVB: cxusb: fix firmware patch for big endian
 systems
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - thing.hostingexpert.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - linuxtv.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jin-Bong lee <jinbong.lee@samsung.com>
Date: Tue, 20 Feb 2007 23:10:34 -0300
Subject: [PATCH] DVB: cxusb: fix firmware patch for big endian systems

Without this patch, the device will not be detected after firmware download
on big endian systems.

Signed-off-by: Jin-Bong lee <jinbong.lee@samsung.com>
Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
(cherry picked from commit 1d1370a48ca285ebe197ecd3197a8d5f161bc291)
---
 drivers/media/dvb/dvb-usb/cxusb.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/cxusb.c b/drivers/media/dvb/dvb-usb/cxusb.c
index 15d12fc..127a94b 100644
--- a/drivers/media/dvb/dvb-usb/cxusb.c
+++ b/drivers/media/dvb/dvb-usb/cxusb.c
@@ -469,9 +469,9 @@ static int bluebird_patch_dvico_firmware_download(struct usb_device *udev,
 	    fw->data[BLUEBIRD_01_ID_OFFSET + 1] == USB_VID_DVICO >> 8) {
 
 		fw->data[BLUEBIRD_01_ID_OFFSET + 2] =
-			udev->descriptor.idProduct + 1;
+			le16_to_cpu(udev->descriptor.idProduct) + 1;
 		fw->data[BLUEBIRD_01_ID_OFFSET + 3] =
-			udev->descriptor.idProduct >> 8;
+			le16_to_cpu(udev->descriptor.idProduct) >> 8;
 
 		return usb_cypress_load_firmware(udev, fw, CYPRESS_FX2);
 	}
