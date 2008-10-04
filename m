Return-Path: <linux-kernel-owner+w=401wt.eu-S1753722AbYJDKKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722AbYJDKKc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 06:10:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752486AbYJDKKR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 06:10:17 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:34200 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475AbYJDKKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 06:10:15 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [mmotm 02/Oct] fix buid error of hid-core
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20081004190725.CE3E.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20081004190725.CE3E.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Message-Id: <20081004190856.CE41.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Sat,  4 Oct 2008 19:10:11 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch against: mmotm 02 Oct
Applied after: usb-usb-remove-warn-macro-from-usbh.patch

fix following buiild error

-------------------------
  CC [M]  drivers/hid/usbhid/hid-core.o
drivers/hid/usbhid/hid-core.c: In function 'usbhid_submit_report':
drivers/hid/usbhid/hid-core.c:417: error: incompatible type for argument 1 of 'dev_driver_string'
drivers/hid/usbhid/hid-core.c:417: error: incompatible type for argument 1 of 'dev_name'
drivers/hid/usbhid/hid-core.c:436: error: incompatible type for argument 1 of 'dev_driver_string'
drivers/hid/usbhid/hid-core.c:436: error: incompatible type for argument 1 of 'dev_name'
drivers/hid/usbhid/hid-core.c: In function 'usbhid_init_reports':
drivers/hid/usbhid/hid-core.c:568: error: incompatible type for argument 1 of 'dev_driver_string'
drivers/hid/usbhid/hid-core.c:568: error: incompatible type for argument 1 of 'dev_name'
make[3]: *** [drivers/hid/usbhid/hid-core.o] Error 1
make[2]: *** [drivers/hid/usbhid] Error 2
make[1]: *** [drivers/hid] Error 2
make: *** [drivers] Error 2
-------------------

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>

---
 drivers/hid/usbhid/hid-core.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: b/drivers/hid/usbhid/hid-core.c
===================================================================
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -414,7 +414,7 @@ void usbhid_submit_report(struct hid_dev
 
 		if ((head = (usbhid->outhead + 1) & (HID_OUTPUT_FIFO_SIZE - 1)) == usbhid->outtail) {
 			spin_unlock_irqrestore(&usbhid->outlock, flags);
-			dev_warn(hid->dev, "output queue full\n");
+			dev_warn(&hid->dev, "output queue full\n");
 			return;
 		}
 
@@ -433,7 +433,7 @@ void usbhid_submit_report(struct hid_dev
 
 	if ((head = (usbhid->ctrlhead + 1) & (HID_CONTROL_FIFO_SIZE - 1)) == usbhid->ctrltail) {
 		spin_unlock_irqrestore(&usbhid->ctrllock, flags);
-		dev_warn(hid->dev, "control queue full\n");
+		dev_warn(&hid->dev, "control queue full\n");
 		return;
 	}
 
@@ -565,7 +565,7 @@ void usbhid_init_reports(struct hid_devi
 	}
 
 	if (err)
-		dev_warn(hid->dev, "timeout initializing reports\n");
+		dev_warn(&hid->dev, "timeout initializing reports\n");
 }
 
 /*


