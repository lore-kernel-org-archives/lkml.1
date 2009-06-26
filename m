Return-Path: <linux-kernel-owner+w=401wt.eu-S1756083AbZFZNWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083AbZFZNWR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 09:22:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754946AbZFZNWE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 09:22:04 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:2428 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754921AbZFZNWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 09:22:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=lzWRXqblpSWq0+vAXFY63KsCxhtV3hzwLZGeXSYx3ZMUB5VrO+HxOAKBsa4JJ4opFF
         aOb8sxZ2hFnRBXSeOctfbQLXlMTaIiaEaTuiwetR8maali+SVUArNH/R5sCvrNGycNoH
         dPi8K5arTrebBZ5EtQhBRYH6gbaRIiJAqbMSc=
From: tom.leiming@gmail.com
To: dwmw2@infradead.org, linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, david-b@pacbell.net,
       Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH][MTD][NAND]: fix omap2.c compile failure and warning
Date: Fri, 26 Jun 2009 21:21:49 +0800
Message-Id: <1246022509-16194-1-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.6.0.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ming Lei <tom.leiming@gmail.com>

drivers/mtd/nand/omap2.c: In function 'omap_wait':
drivers/mtd/nand/omap2.c:543: error: 'jiffies' undeclared (first use in this function)
drivers/mtd/nand/omap2.c:543: error: (Each undeclared identifier is reported only once
drivers/mtd/nand/omap2.c:543: error: for each function it appears in.)
drivers/mtd/nand/omap2.c:557: error: implicit declaration of function 'time_before'

......

drivers/mtd/nand/omap2.c: In function 'omap_wait':
drivers/mtd/nand/omap2.c:545: warning: 'status' may be used uninitialized in this function

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 drivers/mtd/nand/omap2.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/nand/omap2.c b/drivers/mtd/nand/omap2.c
index 0cd76f8..2905c79 100644
--- a/drivers/mtd/nand/omap2.c
+++ b/drivers/mtd/nand/omap2.c
@@ -15,6 +15,7 @@
 #include <linux/mtd/nand.h>
 #include <linux/mtd/partitions.h>
 #include <linux/io.h>
+#include <linux/jiffies.h>
 
 #include <asm/dma.h>
 
@@ -541,7 +542,8 @@ static int omap_wait(struct mtd_info *mtd, struct nand_chip *chip)
 	struct omap_nand_info *info = container_of(mtd, struct omap_nand_info,
 							mtd);
 	unsigned long timeo = jiffies;
-	int status, state = this->state;
+	int state = this->state;
+	int status = 0;
 
 	if (state == FL_ERASING)
 		timeo += (HZ * 400) / 1000;
-- 
1.6.0.GIT

