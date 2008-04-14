Return-Path: <linux-kernel-owner+w=401wt.eu-S932205AbYDNSve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932205AbYDNSve (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 14:51:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934777AbYDNSpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 14:45:33 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:42773 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934771AbYDNSpc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 14:45:32 -0400
Date: Mon, 14 Apr 2008 21:41:49 +0300
From: Adrian Bunk <bunk@kernel.org>
To: dm-devel@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] drivers/md/dm-table.c: fix void returns
Message-ID: <20080414184149.GX6695@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

void returning functions returned the return value of another void 
returning function...

Spotted by sparse.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

This patch has been sent on:
- 31 Mar 2008

 drivers/md/dm-table.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

6b1b4f659d1dfff36c6cf740353dc040e56c1bc2 diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index ce27283..545d8c6 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -916,7 +916,7 @@ void dm_table_presuspend_targets(struct dm_table *t)
 	if (!t)
 		return;
 
-	return suspend_targets(t, 0);
+	suspend_targets(t, 0);
 }
 
 void dm_table_postsuspend_targets(struct dm_table *t)
@@ -924,7 +924,7 @@ void dm_table_postsuspend_targets(struct dm_table *t)
 	if (!t)
 		return;
 
-	return suspend_targets(t, 1);
+	suspend_targets(t, 1);
 }
 
 int dm_table_resume_targets(struct dm_table *t)

