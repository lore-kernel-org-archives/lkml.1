Return-Path: <linux-kernel-owner+w=401wt.eu-S1761335AbYEHICg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761335AbYEHICg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 04:02:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752867AbYEHICQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 04:02:16 -0400
Received: from fnoeppeil48.netpark.at ([217.175.205.176]:33300 "EHLO
	roarinelk.homelinux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005AbYEHICN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 04:02:13 -0400
Date: Thu, 8 May 2008 10:02:11 +0200
From: Manuel Lauss <mano@roarinelk.homelinux.net>
To: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/7] Alchemy: dbdma: add API to delete custom DDMA device
	ids
Message-ID: <20080508080211.GC24383@roarinelk.homelinux.net>
References: <20080508080040.GA24383@roarinelk.homelinux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080508080040.GA24383@roarinelk.homelinux.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 41ebbbe49861a65f28947768db7945a5099673d3 Mon Sep 17 00:00:00 2001
From: Manuel Lauss <mlau@msc-ge.com>
Date: Wed, 7 May 2008 13:45:23 +0200
Subject: [PATCH] Alchemy: dbdma: add API to delete custom DDMA device ids.

Add API to delete custom DDMA device ids create with
au1xxx_ddma_device_add().

Signed-off-by: Manuel Lauss <mano@roarinelk.homelinux.net>
---
 arch/mips/au1000/common/dbdma.c             |   10 ++++++++++
 include/asm-mips/mach-au1x00/au1xxx_dbdma.h |    1 +
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/arch/mips/au1000/common/dbdma.c b/arch/mips/au1000/common/dbdma.c
index 53377df..69171c6 100644
--- a/arch/mips/au1000/common/dbdma.c
+++ b/arch/mips/au1000/common/dbdma.c
@@ -220,6 +220,16 @@ au1xxx_ddma_add_device(dbdev_tab_t *dev)
 }
 EXPORT_SYMBOL(au1xxx_ddma_add_device);
 
+void au1xxx_ddma_del_device(u32 devid)
+{
+	dbdev_tab_t *p = find_dbdev_id(devid);
+	if (p != NULL) {
+		memset(p, 0, sizeof(dbdev_tab_t));
+		p->dev_id = ~0;
+	}
+}
+EXPORT_SYMBOL(au1xxx_ddma_del_device);
+
 /* Allocate a channel and return a non-zero descriptor if successful.
 */
 u32
diff --git a/include/asm-mips/mach-au1x00/au1xxx_dbdma.h b/include/asm-mips/mach-au1x00/au1xxx_dbdma.h
index 93d507c..5e33ff0 100644
--- a/include/asm-mips/mach-au1x00/au1xxx_dbdma.h
+++ b/include/asm-mips/mach-au1x00/au1xxx_dbdma.h
@@ -367,6 +367,7 @@ void au1xxx_dbdma_dump(u32 chanid);
 u32 au1xxx_dbdma_put_dscr(u32 chanid, au1x_ddma_desc_t *dscr );
 
 u32 au1xxx_ddma_add_device( dbdev_tab_t *dev );
+void au1xxx_ddma_del_device(u32 devid);
 void * au1xxx_ddma_get_nextptr_virt(au1x_ddma_desc_t *dp);
 
 /*
-- 
1.5.5.1

