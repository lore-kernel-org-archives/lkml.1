Return-Path: <linux-kernel-owner+w=401wt.eu-S1759501AbZEZXdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759501AbZEZXdi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 19:33:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757083AbZEZXdU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 19:33:20 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:57294 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756468AbZEZXdT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 19:33:19 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org, Greg Ungerer <gerg@uclinux.org>,
       uclinux-dev@uclinux.org, linux-mtd@lists.infradead.org
Subject: [PATCH 2/3] mtd/maps: uclinux: mark local stuff static
Date: Tue, 26 May 2009 19:33:17 -0400
Message-Id: <1243380798-10089-2-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <20090526231902.GA6295@linux-sh.org>
References: <20090526231902.GA6295@linux-sh.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The uclinux_ram_mtdinfo, uclinux_romfs, and uclinux_point symbols do not
need to be visible outside of this module, so mark them static.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
CC: Greg Ungerer <gerg@uclinux.org>
CC: uclinux-dev@uclinux.org
CC: linux-mtd@lists.infradead.org
---
 drivers/mtd/maps/uclinux.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/mtd/maps/uclinux.c b/drivers/mtd/maps/uclinux.c
index 61d4087..d4314fb 100644
--- a/drivers/mtd/maps/uclinux.c
+++ b/drivers/mtd/maps/uclinux.c
@@ -30,11 +30,11 @@ struct map_info uclinux_ram_map = {
 	.size = 0,
 };
 
-struct mtd_info *uclinux_ram_mtdinfo;
+static struct mtd_info *uclinux_ram_mtdinfo;
 
 /****************************************************************************/
 
-struct mtd_partition uclinux_romfs[] = {
+static struct mtd_partition uclinux_romfs[] = {
 	{ .name = "ROMfs" }
 };
 
@@ -42,7 +42,7 @@ struct mtd_partition uclinux_romfs[] = {
 
 /****************************************************************************/
 
-int uclinux_point(struct mtd_info *mtd, loff_t from, size_t len,
+static int uclinux_point(struct mtd_info *mtd, loff_t from, size_t len,
 	size_t *retlen, void **virt, resource_size_t *phys)
 {
 	struct map_info *map = mtd->priv;
-- 
1.6.3.1

