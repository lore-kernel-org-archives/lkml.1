Return-Path: <linux-kernel-owner+w=401wt.eu-S1754040AbZDNGyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040AbZDNGyU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 02:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751885AbZDNGyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 02:54:09 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64509 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751488AbZDNGyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 02:54:08 -0400
From: Xu Gang <xug@cn.fujitsu.com>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Xu Gang <xug@cn.fujitsu.com>
Subject: [PATCH] GFS2: Use DEFINE_SPINLOCK
Date: Tue, 14 Apr 2009 14:54:14 +0800
Message-Id: <1239692054-22797-1-git-send-email-xug@cn.fujitsu.com>
X-Mailer: git-send-email 1.5.3.5
In-Reply-To: xug@cn.fujitsu.com
References: xug@cn.fujitsu.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SPIN_LOCK_UNLOCKED is deprecated, use DEFINE_SPINLOCK instead.
(as suggested in Documentation/spinlocks.txt)

Signed-off-by: Xu Gang <xug@cn.fujitsu.com>
---
 fs/gfs2/quota.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index 8d53f66..56fb9a2 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -81,7 +81,7 @@ struct gfs2_quota_change_host {
 
 static LIST_HEAD(qd_lru_list);
 static atomic_t qd_lru_count = ATOMIC_INIT(0);
-static spinlock_t qd_lru_lock = SPIN_LOCK_UNLOCKED;
+static DEFINE_SPINLOCK(qd_lru_lock);
 
 int gfs2_shrink_qd_memory(int nr, gfp_t gfp_mask)
 {
-- 
1.5.3.5

