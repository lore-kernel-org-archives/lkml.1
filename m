Return-Path: <linux-kernel-owner+w=401wt.eu-S933836AbXHWXz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933836AbXHWXz7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 19:55:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763661AbXHWXzv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 19:55:51 -0400
Received: from mu-out-0910.google.com ([209.85.134.185]:55901 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753677AbXHWXzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 19:55:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:resent-from:resent-to:resent-date:resent-message-id:message-id:in-reply-to:references:from:date:subject:to:cc:mime-version:content-transfer-encoding:content-disposition;
        b=TvlF0XIZ0QgQ4RJzaAMJ4WDNASc7EudFN6NgEl9RlkJtDXxWWDfwm0wRdowt4+0ueYCewfCAvW33hA9YwC33DdPmXjcyCX3mHmF8GAUUnSxOLafYyIpdQaqdptyWilfAjMHe2X6GEqscTA5fqJLQlzVcSUbUHEs/TvC1cnTcJUQ=
Message-Id: <5ebfb93eca0dd43cf17876e643079cbcfeb3111c.1187912217.git.jesper.juhl@gmail.com>
In-Reply-To: <1554af80879a7ef2f78a4d654f23c248203500d9.1187912217.git.jesper.juhl@gmail.com>
References: <1554af80879a7ef2f78a4d654f23c248203500d9.1187912217.git.jesper.juhl@gmail.com>
From: Jesper Juhl <jesper.juhl@gmail.com>
Date: Fri, 24 Aug 2007 01:52:57 +0200
Subject: [PATCH 09/30] mtd: Don't cast kmalloc() return value in drivers/mtd/maps/pmcmsp-flash.c
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
       Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

kmalloc() returns a void pointer.
No need to cast it.

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---
 drivers/mtd/maps/pmcmsp-flash.c |   13 +++++--------
 1 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/mtd/maps/pmcmsp-flash.c b/drivers/mtd/maps/pmcmsp-flash.c
index 7e0377e..dfdb120 100644
--- a/drivers/mtd/maps/pmcmsp-flash.c
+++ b/drivers/mtd/maps/pmcmsp-flash.c
@@ -73,12 +73,9 @@ int __init init_msp_flash(void)
 		return -ENXIO;
 
 	printk(KERN_NOTICE "Found %d PMC flash devices\n", fcnt);
-	msp_flash = (struct mtd_info **)kmalloc(
-			fcnt * sizeof(struct map_info *), GFP_KERNEL);
-	msp_parts = (struct mtd_partition **)kmalloc(
-			fcnt * sizeof(struct mtd_partition *), GFP_KERNEL);
-	msp_maps = (struct map_info *)kmalloc(
-			fcnt * sizeof(struct mtd_info), GFP_KERNEL);
+	msp_flash = kmalloc(fcnt * sizeof(struct map_info *), GFP_KERNEL);
+	msp_parts = kmalloc(fcnt * sizeof(struct mtd_partition *), GFP_KERNEL);
+	msp_maps = kmalloc(fcnt * sizeof(struct mtd_info), GFP_KERNEL);
 	memset(msp_maps, 0, fcnt * sizeof(struct mtd_info));
 
 	/* loop over the flash devices, initializing each */
@@ -95,8 +92,8 @@ int __init init_msp_flash(void)
 			continue;
 		}
 
-		msp_parts[i] = (struct mtd_partition *)kmalloc(
-			pcnt * sizeof(struct mtd_partition), GFP_KERNEL);
+		msp_parts[i] = kmalloc(pcnt * sizeof(struct mtd_partition),
+			GFP_KERNEL);
 		memset(msp_parts[i], 0, pcnt * sizeof(struct mtd_partition));
 
 		/* now initialize the devices proper */
-- 
1.5.2.2

