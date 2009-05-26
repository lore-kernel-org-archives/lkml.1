Return-Path: <linux-kernel-owner+w=401wt.eu-S1756461AbZEZJqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756461AbZEZJqt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 05:46:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755248AbZEZJqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 05:46:33 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:44899 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754999AbZEZJqc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 05:46:32 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org, Greg Ungerer <gerg@uclinux.org>,
       uclinux-dev@uclinux.org, linux-mtd@lists.infradead.org
Subject: [PATCH 2/2] mtd/maps: uclinux: support Blackfin systems
Date: Tue, 26 May 2009 05:46:31 -0400
Message-Id: <1243331191-11445-2-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1243331191-11445-1-git-send-email-vapier@gentoo.org>
References: <1243331191-11445-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to a processor anomaly (05000263 to be exact), most Blackfin parts
cannot keep the embedded filesystem image directly after the kernel in
RAM.  Instead, the filesystem needs to be relocated to the end of memory.
As such, we need to tweak the initial filesystem address for Blackfin
systems.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
CC: Greg Ungerer <gerg@uclinux.org>
CC: uclinux-dev@uclinux.org
CC: linux-mtd@lists.infradead.org
---
 drivers/mtd/maps/uclinux.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/maps/uclinux.c b/drivers/mtd/maps/uclinux.c
index 57699c2..dcb552f 100644
--- a/drivers/mtd/maps/uclinux.c
+++ b/drivers/mtd/maps/uclinux.c
@@ -55,8 +55,13 @@ static int __init uclinux_mtd_init(void)
 {
 	struct mtd_info *mtd;
 	struct map_info *mapp;
+#ifdef CONFIG_BLACKFIN
+	extern unsigned long memory_mtd_start;
+	unsigned long addr = (unsigned long) memory_mtd_start;
+#else
 	extern char _ebss;
 	unsigned long addr = (unsigned long) &_ebss;
+#endif
 
 	mapp = &uclinux_ram_map;
 	mapp->phys = addr;
-- 
1.6.3.1

