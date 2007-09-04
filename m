Return-Path: <linux-kernel-owner+w=401wt.eu-S1753628AbXIDIYO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753628AbXIDIYO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 04:24:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751680AbXIDIX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 04:23:58 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:43305 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbXIDIX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 04:23:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:content-type:content-transfer-encoding;
        b=btCd2QsyIPg5NhDp7Gxb1sNkK9iSUJgDopLVOx9k8ZCq5LCEBmIXUBwI8+Pja1zvCVkzrgTVGxym3sYN/gYc470LMV/f3fkOtz6M7rk34CBqvvVLki30CywKKa1bdDlSdE60q4BMLh56f8rVsear8PpI/EMkkep2EGZ24eFA6EA=
Message-ID: <46DD1661.4070500@gmail.com>
Date: Tue, 04 Sep 2007 16:25:05 +0800
From: Micah Gruber <micah.gruber@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net,
       gregkh@suse.de
Subject: [PATCH] Fix a potential NULL pointer dereference in usbat_check_status()
 in drivers/usb/storage/shuttle_usbat.c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a potential null dereference bug where we dereference us before a null check. This patch simply moves the dereferencing after the null check.

Signed-off-by: Micah Gruber <micah.gruber@gmail.com>
---

--- a/drivers/usb/storage/shuttle_usbat.c
+++ b/drivers/usb/storage/shuttle_usbat.c
@@ -187,12 +187,14 @@
  */
 static int usbat_check_status(struct us_data *us)
 {
-	unsigned char *reply = us->iobuf;
+	unsigned char *reply;
 	int rc;
 
 	if (!us)
 		return USB_STOR_TRANSPORT_ERROR;
 
+	reply = us->iobuf;
+
 	rc = usbat_get_status(us, reply);
 	if (rc != USB_STOR_XFER_GOOD)
 		return USB_STOR_TRANSPORT_FAILED;

