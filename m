Return-Path: <linux-kernel-owner+w=401wt.eu-S933803AbXHWXxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933803AbXHWXxm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 19:53:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933589AbXHWXxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 19:53:30 -0400
Received: from fk-out-0910.google.com ([209.85.128.184]:62584 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933592AbXHWXx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 19:53:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:resent-from:resent-to:resent-date:resent-message-id:message-id:in-reply-to:references:from:date:subject:to:cc:mime-version:content-transfer-encoding:content-disposition;
        b=BVUnKFyIC77qyR+0WhAjHnRnBoc59lALB+U4pAB4gILvsKeSE6SvgTUh0C1X/mDJUbzdv9QsKUk6Zzv3wXgE1Oyx2p177xFj48xOwgOnPkeLkNbnVrN/u6HtOlSqNUUJnNccf1JOighymTVTqtIBG6L7TNYe32k69Bj76PX2qvM=
Message-Id: <7ce3fff85ac7859141ad1035c6c037dffeec9b66.1187912217.git.jesper.juhl@gmail.com>
In-Reply-To: <1554af80879a7ef2f78a4d654f23c248203500d9.1187912217.git.jesper.juhl@gmail.com>
References: <1554af80879a7ef2f78a4d654f23c248203500d9.1187912217.git.jesper.juhl@gmail.com>
From: Jesper Juhl <jesper.juhl@gmail.com>
Date: Fri, 24 Aug 2007 01:50:33 +0200
Subject: [PATCH 07/30] mtd: Get rid of pointless cast of kzalloc() return value in AT26xxx driver
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
       Hans J Koch <hjk@linutronix.de>, Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

kzalloc() returns a void pointer - no need to cast it in
 drivers/mtd/devices/at91_dataflash26.c::add_dataflash()

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---
 drivers/mtd/devices/at91_dataflash26.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/devices/at91_dataflash26.c b/drivers/mtd/devices/at91_dataflash26.c
index 64ce37f..9c4aac4 100644
--- a/drivers/mtd/devices/at91_dataflash26.c
+++ b/drivers/mtd/devices/at91_dataflash26.c
@@ -360,8 +360,7 @@ static int __init add_dataflash(int channel, char *name, int nr_pages,
 	device->read = at91_dataflash26_read;
 	device->write = at91_dataflash26_write;
 
-	priv = (struct dataflash_local *)kzalloc(sizeof(struct dataflash_local),
-		GFP_KERNEL);
+	priv = kzalloc(sizeof(struct dataflash_local), GFP_KERNEL);
 	if (!priv) {
 		kfree(device);
 		return -ENOMEM;
-- 
1.5.2.2

