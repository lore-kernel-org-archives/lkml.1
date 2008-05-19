Return-Path: <linux-kernel-owner+w=401wt.eu-S1757970AbYESIFR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757970AbYESIFR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 04:05:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755101AbYESIE7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 04:04:59 -0400
Received: from fnoeppeil48.netpark.at ([217.175.205.176]:58967 "EHLO
	roarinelk.homelinux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752459AbYESIE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 04:04:58 -0400
Date: Mon, 19 May 2008 10:04:56 +0200
From: Manuel Lauss <mano@roarinelk.homelinux.net>
To: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org, drzeus@drzeus.cx,
       sshtylyov@ru.mvista.com
Subject: [PATCH 2/9] Alchemy: dbdma: add API to delete custom DDMA device
	ids.
Message-ID: <20080519080456.GC21985@roarinelk.homelinux.net>
References: <20080519080339.GA21985@roarinelk.homelinux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080519080339.GA21985@roarinelk.homelinux.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 44aefed96c1358e52c24cc7c526b2cbe76166cfe Mon Sep 17 00:00:00 2001
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
index 42d5552..e7cb64e 100644
--- a/arch/mips/au1000/common/dbdma.c
+++ b/arch/mips/au1000/common/dbdma.c
@@ -216,6 +216,16 @@ u32 au1xxx_ddma_add_device(dbdev_tab_t *dev)
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
 /* Allocate a channel and return a non-zero descriptor if successful. */
 u32 au1xxx_dbdma_chan_alloc(u32 srcid, u32 destid,
        void (*callback)(int, void *), void *callparam)
diff --git a/include/asm-mips/mach-au1x00/au1xxx_dbdma.h b/include/asm-mips/mach-au1x00/au1xxx_dbdma.h
index ad17d7c..9077763 100644
--- a/include/asm-mips/mach-au1x00/au1xxx_dbdma.h
+++ b/include/asm-mips/mach-au1x00/au1xxx_dbdma.h
@@ -355,6 +355,7 @@ void au1xxx_dbdma_dump(u32 chanid);
 u32 au1xxx_dbdma_put_dscr(u32 chanid, au1x_ddma_desc_t *dscr);
 
 u32 au1xxx_ddma_add_device(dbdev_tab_t *dev);
+void au1xxx_ddma_del_device(u32 devid);
 void *au1xxx_ddma_get_nextptr_virt(au1x_ddma_desc_t *dp);
 
 /*
-- 
1.5.5.1

