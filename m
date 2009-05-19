Return-Path: <linux-kernel-owner+w=401wt.eu-S1755369AbZESXDO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369AbZESXDO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 19:03:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754075AbZESXDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 19:03:05 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:22458 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882AbZESXDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 19:03:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=Fo4wxeyxknNZXWIJpo5Ttk21GOeNS21P/6nSOEtiyK8a+YJUx6juHa48+GrIgN1/Xf
         v5LFXzMqAvQVqYUyTgQrO8K4k45U0GMMxwrtsZushz0GsMIQbtP7Ax8a+SHdxImglVCB
         o+csNoX8rXGBcC/yabZNhpN+TTwHKHgXt5KUE=
Message-ID: <4A133AA7.6020508@gmail.com>
Date: Wed, 20 May 2009 01:03:03 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: axboe@kernel.dk
CC: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] cdrom: beyond ARRAY_SIZE of viocd_diskinfo
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not go beyond ARRAY_SIZE of viocd_diskinfo

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/cdrom/viocd.c b/drivers/cdrom/viocd.c
index 1392935..9b1624e 100644
--- a/drivers/cdrom/viocd.c
+++ b/drivers/cdrom/viocd.c
@@ -587,7 +587,7 @@ static int viocd_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 	struct device_node *node = vdev->dev.archdata.of_node;
 
 	deviceno = vdev->unit_address;
-	if (deviceno > VIOCD_MAX_CD)
+	if (deviceno >= VIOCD_MAX_CD)
 		return -ENODEV;
 	if (!node)
 		return -ENODEV;

