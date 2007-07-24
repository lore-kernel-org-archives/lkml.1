Return-Path: <linux-kernel-owner+w=401wt.eu-S935188AbXGXI6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935188AbXGXI6Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 04:58:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935129AbXGXI6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 04:58:09 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:40945 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935143AbXGXI6G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 04:58:06 -0400
Date: Tue, 24 Jul 2007 12:58:36 +0400
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: device-mapper development <dm-devel@redhat.com>
Subject: [PATCH 5/8] dm: dm-table.c Convert  kmalloc + memset  to kzalloc
Message-ID: <20070724085836.GE16507@dnb.sw.ru>
Mail-Followup-To: linux-kernel@vger.kernel.org,
	device-mapper development <dm-devel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070724085106.GD20538@dnb.sw.ru>
Organization: SWsoft
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 drivers/md/dm-table.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 2fc199b..17237b1 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -213,12 +213,11 @@ static int alloc_targets(struct dm_table *t, unsigned int num)
 int dm_table_create(struct dm_table **result, int mode,
 		    unsigned num_targets, struct mapped_device *md)
 {
-	struct dm_table *t = kmalloc(sizeof(*t), GFP_KERNEL);
+	struct dm_table *t = kzalloc(sizeof(*t), GFP_KERNEL);
 
 	if (!t)
 		return -ENOMEM;
 
-	memset(t, 0, sizeof(*t));
 	INIT_LIST_HEAD(&t->devices);
 	atomic_set(&t->holders, 1);
 
-- 
1.5.2.2


