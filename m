Return-Path: <linux-kernel-owner+w=401wt.eu-S1758503AbZABKrm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758503AbZABKrm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 05:47:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757910AbZABKmD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 05:42:03 -0500
Received: from nelson.telenet-ops.be ([195.130.133.66]:36266 "EHLO
	nelson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757183AbZABKlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 05:41:39 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] m68k: zorro - use %pR to print resources
Date: Fri,  2 Jan 2009 11:41:30 +0100
Message-Id: <1230892892-25751-18-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1230892892-25751-17-git-send-email-geert@linux-m68k.org>
References: <1230892892-25751-1-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-2-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-3-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-4-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-5-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-6-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-7-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-8-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-9-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-10-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-11-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-12-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-13-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-14-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-15-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-16-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-17-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/zorro/zorro.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/zorro/zorro.c b/drivers/zorro/zorro.c
index 2dda20a..a1585d6 100644
--- a/drivers/zorro/zorro.c
+++ b/drivers/zorro/zorro.c
@@ -165,10 +165,8 @@ static int __init zorro_init(void)
 	zorro_name_device(z);
 	z->resource.name = z->name;
 	if (request_resource(zorro_find_parent_resource(z), &z->resource))
-	    printk(KERN_ERR "Zorro: Address space collision on device %s "
-		   "[%lx:%lx]\n",
-		   z->name, (unsigned long)zorro_resource_start(z),
-		   (unsigned long)zorro_resource_end(z));
+	    pr_err("Zorro: Address space collision on device %s %pR\n",
+		   z->name, &z->resource);
 	sprintf(z->dev.bus_id, "%02x", i);
 	z->dev.parent = &zorro_bus.dev;
 	z->dev.bus = &zorro_bus_type;
-- 
1.5.6.5

