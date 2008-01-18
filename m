Return-Path: <linux-kernel-owner+w=401wt.eu-S1761328AbYARCCg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761328AbYARCCg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 21:02:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759393AbYARCCS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 21:02:18 -0500
Received: from smtp-out2.blueyonder.co.uk ([195.188.213.5]:42827 "EHLO
	smtp-out2.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759153AbYARCCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 21:02:17 -0500
From: Byron Bradley <byron.bbradley@gmail.com>
To: linux-arm-kernel@lists.arm.linux.org.uk
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Byron Bradley <byron.bbradley@gmail.com>, Nick Piggin <npiggin@suse.de>,
       Russell King <rmk@arm.linux.org.uk>
Subject: [PATCH] ramdisk driver: make rd_size non-static
Date: Fri, 18 Jan 2008 02:02:17 +0000
Message-Id: <1200621737-1458-1-git-send-email-byron.bbradley@gmail.com>
X-Mailer: git-send-email 1.5.4.rc2.38.gd6da3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In arch/arm/kernel/setup.c:setup_ramdisk(), rd_size is set from the
boot tags. The replacement ramdisk driver has rd_size as static
which causes linking to fail when ramdisk is built-in.

Signed-off-by: Byron Bradley <byron.bbradley@gmail.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Russell King <rmk@arm.linux.org.uk>
---

This patch applies against 2.6.24-rc8-mm1 and has not been tested,
it is only know to compile. I'm not sure if there is a better way
to set rd_size or if this is OK.

 drivers/block/brd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index 5ef1d26..8536480 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -385,7 +385,7 @@ static struct block_device_operations brd_fops = {
  * And now the modules code and kernel interface.
  */
 static int rd_nr;
-static int rd_size = CONFIG_BLK_DEV_RAM_SIZE;
+int rd_size = CONFIG_BLK_DEV_RAM_SIZE;
 module_param(rd_nr, int, 0);
 MODULE_PARM_DESC(rd_nr, "Maximum number of brd devices");
 module_param(rd_size, int, 0);
-- 
1.5.4.rc2.38.gd6da3


