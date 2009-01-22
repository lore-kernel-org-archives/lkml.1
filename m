Return-Path: <linux-kernel-owner+w=401wt.eu-S1758302AbZAVOOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758302AbZAVOOl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 09:14:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755246AbZAVOOa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 09:14:30 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:36666 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755237AbZAVOO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 09:14:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=gq1Ymx9V5xWxZilxd3mjxKHuofrcIUSY+YelO5726Ka2LRvrhtwyP+fze4p4PaqF+7
         6my9edr1JaQVWX4deh1b3lMxtnMpJMg1YXQbms1gj8eK1JKA1nXPNaZwLX1k6r04KdoD
         YFj7dDut+f6WcVl6LF4CqZEUx7Hd1tekoC4Es=
Message-ID: <49787F42.8080908@gmail.com>
Date: Thu, 22 Jan 2009 15:14:26 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: linux-media@vger.kernel.org, video4linux-list@redhat.com,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] V4L/DVB: fix v4l2_device_call_all/v4l2_device_call_until_err
 macro
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When these macros aren't called with 'grp_id' this will result in a
build failure.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/include/media/v4l2-device.h b/include/media/v4l2-device.h
index 9bf4ccc..ad86caa 100644
--- a/include/media/v4l2-device.h
+++ b/include/media/v4l2-device.h
@@ -94,16 +94,16 @@ void v4l2_device_unregister_subdev(struct v4l2_subdev *sd);
 /* Call the specified callback for all subdevs matching grp_id (if 0, then
    match them all). Ignore any errors. Note that you cannot add or delete
    a subdev while walking the subdevs list. */
-#define v4l2_device_call_all(dev, grp_id, o, f, args...) 		\
+#define v4l2_device_call_all(dev, _grp_id, o, f, args...) 		\
 	__v4l2_device_call_subdevs(dev, 				\
-			!(grp_id) || sd->grp_id == (grp_id), o, f , ##args)
+			!(_grp_id) || sd->grp_id == (_grp_id), o, f , ##args)
 
 /* Call the specified callback for all subdevs matching grp_id (if 0, then
    match them all). If the callback returns an error other than 0 or
    -ENOIOCTLCMD, then return with that error code. Note that you cannot
    add or delete a subdev while walking the subdevs list. */
-#define v4l2_device_call_until_err(dev, grp_id, o, f, args...) 		\
+#define v4l2_device_call_until_err(dev, _grp_id, o, f, args...) 		\
 	__v4l2_device_call_subdevs_until_err(dev,			\
-		       !(grp_id) || sd->grp_id == (grp_id), o, f , ##args)
+		       !(_grp_id) || sd->grp_id == (_grp_id), o, f , ##args)
 
 #endif

