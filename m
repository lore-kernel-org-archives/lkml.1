Return-Path: <linux-kernel-owner+w=401wt.eu-S1754908AbYEYNSu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908AbYEYNSu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 09:18:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752748AbYEYNSl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 09:18:41 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:64809 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428AbYEYNSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 09:18:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=JeNrroQMZxRBqP55gkU6dQ30wRImnEy5KiArraSbxXk462giI05tkKDfZJkO/9nhDXPqA1+0BkLCWPnrnVjCthpFx/Cgl8Kd+uL1DbHVd+CiqvisepnRXZdZFvU0DDDJPtK+K6Voypu+yc4nyFfDN+eUQC1KR/W25VU1z7Y5LaU=
From: Qinghuang Feng <s3c24xx@gmail.com>
Reply-To: s3c24xx@gmail.com
To: rmk@arm.linux.org.uk
Subject: [PATCH]scsi: check the return value of device_create_file() in powertec.c
Date: Sun, 25 May 2008 21:18:25 +0800
User-Agent: KMail/1.9.1
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805252118.25798.s3c24xx@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds code to check the return value of device_create_file() called from powertecscsi_probe() in powertec.c 
 
Signed-off-by: Qinghuang Feng <s3c24xx@gmail.com>
---
diff --git a/drivers/scsi/arm/powertec.c b/drivers/scsi/arm/powertec.c
index d9a546d..d695a6d 100644
--- a/drivers/scsi/arm/powertec.c
+++ b/drivers/scsi/arm/powertec.c
@@ -361,7 +361,9 @@ powertecscsi_probe(struct expansion_card
 
 	ecard_setirq(ec, &powertecscsi_ops, info);
 
-	device_create_file(&ec->dev, &dev_attr_bus_term);
+	ret = device_create_file(&ec->dev, &dev_attr_bus_term);
+	if (ret)
+		goto out_put;
 
 	ret = fas216_init(host);
 	if (ret)
@@ -399,6 +401,8 @@ powertecscsi_probe(struct expansion_card
 
  out_free:
 	device_remove_file(&ec->dev, &dev_attr_bus_term);
+
+ out_put:
 	scsi_host_put(host);
 
  out_region:

