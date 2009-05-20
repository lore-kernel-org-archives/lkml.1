Return-Path: <linux-kernel-owner+w=401wt.eu-S1755659AbZETA7G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659AbZETA7G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 20:59:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755100AbZETA64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 20:58:56 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:41474 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754938AbZETA6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 20:58:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=SjsB1ipRKXN2pOeFITXUAVc0n8PBwITQyw1fY5h8ibjSu1sNZp0ZGHLDIQfOSzu2NU
         TG8bPrT8o8Smw68kSoFCoEKhUI0GU63P7CZCkhrCvY4l1qYy6M2BwJ7ySuv1dCeN4ufr
         s/fvwlZnkMjuKVCO9Ji+ieQwI5L+RWU+twuMc=
Message-ID: <4A1355D0.80406@gmail.com>
Date: Wed, 20 May 2009 02:58:56 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: linuxppc-dev@ozlabs.org
CC: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, sfr@canb.auug.org.au
Subject: [PATCH] tape: beyond ARRAY_SIZE of viocd_diskinfo
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not go beyond ARRAY_SIZE of tape_device and viotape_unitinfo

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Acked-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
diff --git a/drivers/char/viotape.c b/drivers/char/viotape.c
index ffc9254..042c814 100644
--- a/drivers/char/viotape.c
+++ b/drivers/char/viotape.c
@@ -867,7 +867,7 @@ static int viotape_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 	int j;
 	struct device_node *node = vdev->dev.archdata.of_node;
 
-	if (i > VIOTAPE_MAX_TAPE)
+	if (i >= VIOTAPE_MAX_TAPE)
 		return -ENODEV;
 	if (!node)
 		return -ENODEV;

