Return-Path: <linux-kernel-owner+w=401wt.eu-S1764834AbYEGQLf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764834AbYEGQLf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 12:11:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763073AbYEGQKo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 12:10:44 -0400
Received: from fnoeppeil48.netpark.at ([217.175.205.176]:47693 "EHLO
	roarinelk.homelinux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762231AbYEGQKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 12:10:41 -0400
Date: Wed, 7 May 2008 18:03:58 +0200
From: Manuel Lauss <mano@roarinelk.homelinux.net>
To: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/7] Alchemy: dbdma: add api to delete custom ddma devices
Message-ID: <20080507160358.GC17806@roarinelk.homelinux.net>
References: <20080507160154.GA17806@roarinelk.homelinux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080507160154.GA17806@roarinelk.homelinux.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 54c63c0bbf48673e5550b62d3ca4272dd0a1bedf Mon Sep 17 00:00:00 2001
From: Manuel Lauss <mlau@msc-ge.com>
Date: Wed, 7 May 2008 13:45:23 +0200
Subject: [PATCH] Alchemy: dbdma: add API to delete custom DDMA device ids.

Add API to delete custom DDMA device ids created with
au1xxx_ddma_device_add(), to avoid filling the ddma id table by repeatedly
loading/unloading a module using this function.

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

