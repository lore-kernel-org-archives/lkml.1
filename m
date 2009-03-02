Return-Path: <linux-kernel-owner+w=401wt.eu-S1758133AbZCJQve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758133AbZCJQve (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 12:51:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755676AbZCJQoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 12:44:00 -0400
Received: from zelda.netsplit.com ([87.194.19.211]:34609 "EHLO
	zelda.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755148AbZCJQnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 12:43:40 -0400
Message-Id: <e0ea71d3322d398cf06fa8560a41230803b5925b.1236702228.git.scott@canonical.com>
In-Reply-To: <cover.1236702228.git.scott@canonical.com>
References: <cover.1236702228.git.scott@canonical.com>
From: Scott James Remnant <scott@canonical.com>
Date: Mon, 2 Mar 2009 17:38:30 +0000
Subject: [PATCH 08/31] mtd: Auto-load ftl module when device opened.
To: linux-kernel@vger.kernel.org
Cc: joern@lazybastard.org, linux-mtd@lists.infradead.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ftl module is missing the block-major-44-* alias that would cause it
to be auto-loaded when a device of that type is opened.  This patch adds
the alias.

Signed-off-by: Scott James Remnant <scott@canonical.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 drivers/mtd/ftl.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/ftl.c b/drivers/mtd/ftl.c
index a790c06..0af7eee 100644
--- a/drivers/mtd/ftl.c
+++ b/drivers/mtd/ftl.c
@@ -69,6 +69,7 @@
 #include <linux/init.h>
 #include <linux/hdreg.h>
 #include <linux/vmalloc.h>
+#include <linux/blkdev.h>
 #include <linux/blkpg.h>
 #include <asm/uaccess.h>
 
@@ -1116,3 +1117,4 @@ module_exit(cleanup_ftl);
 MODULE_LICENSE("Dual MPL/GPL");
 MODULE_AUTHOR("David Hinds <dahinds@users.sourceforge.net>");
 MODULE_DESCRIPTION("Support code for Flash Translation Layer, used on PCMCIA devices");
+MODULE_ALIAS_BLOCKDEV_MAJOR(FTL_MAJOR);
-- 
1.6.0.5

