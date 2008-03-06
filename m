Return-Path: <linux-kernel-owner+w=401wt.eu-S933349AbYCFNIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933349AbYCFNIm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 08:08:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757462AbYCFNId
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 08:08:33 -0500
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:46534 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761233AbYCFNId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 08:08:33 -0500
Message-ID: <47CFECCB.7050909@tiscali.nl>
Date: Thu, 06 Mar 2008 14:08:27 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: elf@buici.com
CC: Linux-arm <linux-arm-kernel@lists.arm.linux.org.uk>,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] locomo.c: convert strncpy(x, y, sizeof(x)) to strlcpy
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch was not yet tested. Please confirm it's right.
---
strncpy does not append '\0' if the length of the source string equals
the size parameter, strlcpy does.

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/arch/arm/common/locomo.c b/arch/arm/common/locomo.c
index ae21755..89b2328 100644
--- a/arch/arm/common/locomo.c
+++ b/arch/arm/common/locomo.c
@@ -516,7 +516,7 @@ locomo_init_one_child(struct locomo *lchip, struct locomo_dev_info *info)
 		goto out;
 	}
 
-	strncpy(dev->dev.bus_id, info->name, sizeof(dev->dev.bus_id));
+	strlcpy(dev->dev.bus_id, info->name, sizeof(dev->dev.bus_id));
 	/*
 	 * If the parent device has a DMA mask associated with it,
 	 * propagate it down to the children.
