Return-Path: <linux-kernel-owner+w=401wt.eu-S1758250AbZHQWhP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758250AbZHQWhP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 18:37:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752598AbZHQWhP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 18:37:15 -0400
Received: from wg.visionengravers.com ([67.136.234.194]:5541 "EHLO
	visionfs1.visionengravers.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751228AbZHQWhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 18:37:14 -0400
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: jkosina@suse.cz
Subject: [PATCH] usbhid/hid-code.c: local function should be static
Date: Mon, 17 Aug 2009 15:37:18 -0700
Cc: linux-usb@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908171537.18923.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__usbhid_submit_report() is a local function wrapped by the exported
symbol usbhid_submit_report(). As such, it should be static.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc:  Jiri Kosina <jkosina@suse.cz>

---

diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index 3c1fcb7..1f31a9e 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -489,7 +489,8 @@ static void hid_ctrl(struct urb *urb)
 	wake_up(&usbhid->wait);
 }
 
-void __usbhid_submit_report(struct hid_device *hid, struct hid_report *report, unsigned char dir)
+static void __usbhid_submit_report(struct hid_device *hid, struct hid_report *report,
+				   unsigned char dir)
 {
 	int head;
 	struct usbhid_device *usbhid = hid->driver_data;
