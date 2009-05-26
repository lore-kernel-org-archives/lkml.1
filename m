Return-Path: <linux-kernel-owner+w=401wt.eu-S1755579AbZEZJqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579AbZEZJqj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 05:46:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754185AbZEZJqc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 05:46:32 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:44888 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753889AbZEZJqb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 05:46:31 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Timofei Bondarenko <tim@ipi.ac.ru>,
       Sonic Zhang <sonic.zhang@analog.com>, Greg Ungerer <gerg@uclinux.org>,
       uclinux-dev@uclinux.org, linux-mtd@lists.infradead.org
Subject: [PATCH 1/2] mtd/maps: uclinux: fix building when partition support is disabled
Date: Tue, 26 May 2009 05:46:30 -0400
Message-Id: <1243331191-11445-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Timofei Bondarenko <tim@ipi.ac.ru>

The uClinux map driver doesn't even use partitions, so we shouldn't require
it in order to work properly.

Signed-off-by: Timofei Bondarenko <tim@ipi.ac.ru>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
CC: Greg Ungerer <gerg@uclinux.org>
CC: uclinux-dev@uclinux.org
CC: linux-mtd@lists.infradead.org
---
 drivers/mtd/maps/uclinux.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/maps/uclinux.c b/drivers/mtd/maps/uclinux.c
index 81756e3..57699c2 100644
--- a/drivers/mtd/maps/uclinux.c
+++ b/drivers/mtd/maps/uclinux.c
@@ -87,7 +87,11 @@ static int __init uclinux_mtd_init(void)
 	mtd->priv = mapp;
 
 	uclinux_ram_mtdinfo = mtd;
+#ifdef CONFIG_MTD_PARTITIONS
 	add_mtd_partitions(mtd, uclinux_romfs, NUM_PARTITIONS);
+#else
+	add_mtd_device(mtd);
+#endif
 
 	return(0);
 }
@@ -97,7 +101,11 @@ static int __init uclinux_mtd_init(void)
 static void __exit uclinux_mtd_cleanup(void)
 {
 	if (uclinux_ram_mtdinfo) {
+#ifdef CONFIG_MTD_PARTITIONS
 		del_mtd_partitions(uclinux_ram_mtdinfo);
+#else
+		del_mtd_device(uclinux_ram_mtdinfo);
+#endif
 		map_destroy(uclinux_ram_mtdinfo);
 		uclinux_ram_mtdinfo = NULL;
 	}
-- 
1.6.3.1

