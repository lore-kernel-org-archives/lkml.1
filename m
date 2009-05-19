Return-Path: <linux-kernel-owner+w=401wt.eu-S1756064AbZESXKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064AbZESXKr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 19:10:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755049AbZESXKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 19:10:39 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:38361 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755811AbZESXKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 19:10:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=IrrpllIkHl5mJk33phMntE08OcWLho2r5pgkJdELtNKiJ7ESMTokQxTr1Ct+Jm+QV3
         Hrsm7R8QIsUXzRu3qAtjoeXf1GedHEiXRsZn7gTtGRqeCvtSh3alORWt5xlbiG17fcRj
         9iweC2B03+z0PH2YUCNmWCXXipYmlVG9GAIIk=
Message-ID: <4A133C6D.9050300@gmail.com>
Date: Wed, 20 May 2009 01:10:37 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: sfr@canb.auug.org.au
CC: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] tape: beyond ARRAY_SIZE of viocd_diskinfo
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not go beyond ARRAY_SIZE of tape_device and viotape_unitinfo

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
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
