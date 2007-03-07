Return-Path: <linux-kernel-owner+w=401wt.eu-S1422974AbXCGRkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422974AbXCGRkA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:40:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422817AbXCGRjd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:39:33 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43301 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422808AbXCGRPn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:15:43 -0500
Message-Id: <20070307171358.484516818@mini.kroah.org>
References: <20070307171035.150802805@mini.kroah.org>
User-Agent: quilt/0.45-1
Date: Wed, 07 Mar 2007 09:11:24 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>,
       Jin-Bong lee <jinbong.lee@samsung.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [patch 049/101] DVB: cxusb: fix firmware patch for big endian systems
Content-Disposition: inline; filename=dvb-cxusb-fix-firmware-patch-for-big-endian-systems.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Jin-Bong lee <jinbong.lee@samsung.com>

Without this patch, the device will not be detected after firmware download
on big endian systems.

(cherry picked from commit 1d1370a48ca285ebe197ecd3197a8d5f161bc291)

Signed-off-by: Jin-Bong lee <jinbong.lee@samsung.com>
Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/dvb/dvb-usb/cxusb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.20.1.orig/drivers/media/dvb/dvb-usb/cxusb.c
+++ linux-2.6.20.1/drivers/media/dvb/dvb-usb/cxusb.c
@@ -469,9 +469,9 @@ static int bluebird_patch_dvico_firmware
 	    fw->data[BLUEBIRD_01_ID_OFFSET + 1] == USB_VID_DVICO >> 8) {
 
 		fw->data[BLUEBIRD_01_ID_OFFSET + 2] =
-			udev->descriptor.idProduct + 1;
+			le16_to_cpu(udev->descriptor.idProduct) + 1;
 		fw->data[BLUEBIRD_01_ID_OFFSET + 3] =
-			udev->descriptor.idProduct >> 8;
+			le16_to_cpu(udev->descriptor.idProduct) >> 8;
 
 		return usb_cypress_load_firmware(udev, fw, CYPRESS_FX2);
 	}

--
