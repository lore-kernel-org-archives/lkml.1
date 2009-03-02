Return-Path: <linux-kernel-owner+w=401wt.eu-S1757121AbZCJQp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757121AbZCJQp5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 12:45:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755925AbZCJQnp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 12:43:45 -0400
Received: from zelda.netsplit.com ([87.194.19.211]:34591 "EHLO
	zelda.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754850AbZCJQni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 12:43:38 -0400
Message-Id: <6a809405735d17d1183aa585314ff55b516a48b0.1236702228.git.scott@canonical.com>
In-Reply-To: <cover.1236702228.git.scott@canonical.com>
References: <cover.1236702228.git.scott@canonical.com>
From: Scott James Remnant <scott@canonical.com>
Date: Mon, 2 Mar 2009 17:43:04 +0000
Subject: [PATCH 11/31] mtd: Auto-load nftl module when device opened.
To: linux-kernel@vger.kernel.org
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The nftl module is missing the block-major-93-* alias that would cause
it to be auto-loaded when a nftl of that type is opened.  This patch
adds the alias.

Signed-off-by: Scott James Remnant <scott@canonical.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 drivers/mtd/nftlcore.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/nftlcore.c b/drivers/mtd/nftlcore.c
index d1c4546..ff0a249 100644
--- a/drivers/mtd/nftlcore.c
+++ b/drivers/mtd/nftlcore.c
@@ -20,6 +20,7 @@
 #include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/hdreg.h>
+#include <linux/blkdev.h>
 
 #include <linux/kmod.h>
 #include <linux/mtd/mtd.h>
@@ -818,3 +819,4 @@ module_exit(cleanup_nftl);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("David Woodhouse <dwmw2@infradead.org>, Fabrice Bellard <fabrice.bellard@netgem.com> et al.");
 MODULE_DESCRIPTION("Support code for NAND Flash Translation Layer, used on M-Systems DiskOnChip 2000 and Millennium");
+MODULE_ALIAS_BLOCKDEV_MAJOR(NFTL_MAJOR);
-- 
1.6.0.5

