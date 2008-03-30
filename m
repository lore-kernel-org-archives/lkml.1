Return-Path: <linux-kernel-owner+w=401wt.eu-S1758456AbYC3X3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758456AbYC3X3k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 19:29:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753713AbYC3X2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 19:28:53 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:55268 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756940AbYC3X2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 19:28:52 -0400
Date: Mon, 31 Mar 2008 02:28:39 +0300
From: Adrian Bunk <bunk@kernel.org>
To: dm-devel@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] drivers/md/dm-table.c: fix void returns
Message-ID: <20080330232839.GY28445@cs181133002.pp.htv.fi>
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

