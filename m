Return-Path: <linux-kernel-owner+w=401wt.eu-S1765582AbXGaR0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765582AbXGaR0n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 13:26:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758255AbXGaR0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 13:26:34 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:1759 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758979AbXGaR0d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 13:26:33 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 18] drivers/md/dm-table.c: kmalloc + memset conversion to kzalloc
Date: Tue, 31 Jul 2007 19:26:32 +0200
User-Agent: KMail/1.9.5
Cc: kernel-janitors@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <200707311845.48807.m.kozlowski@tuxland.pl>
In-Reply-To: <200707311845.48807.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707311926.33125.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/md/dm-table.c | 21698 -> 21664 (-34 bytes)
 drivers/md/dm-table.o | 132153 -> 132093 (-60 bytes)

 drivers/md/dm-table.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- linux-2.6.23-rc1-mm1-a/drivers/md/dm-table.c	2007-07-26 13:07:41.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/drivers/md/dm-table.c	2007-07-31 13:19:43.000000000 +0200
@@ -213,12 +213,12 @@ static int alloc_targets(struct dm_table
 int dm_table_create(struct dm_table **result, int mode,
 		    unsigned num_targets, struct mapped_device *md)
 {
-	struct dm_table *t = kmalloc(sizeof(*t), GFP_KERNEL);
-
+	struct dm_table *t;
+
+	t = kzalloc(sizeof(*t), GFP_KERNEL);
 	if (!t)
 		return -ENOMEM;

-	memset(t, 0, sizeof(*t));
 	INIT_LIST_HEAD(&t->devices);
 	atomic_set(&t->holders, 1);

@@ -229,7 +229,6 @@ int dm_table_create(struct dm_table **re

 	if (alloc_targets(t, num_targets)) {
 		kfree(t);
-		t = NULL;
 		return -ENOMEM;
 	}

