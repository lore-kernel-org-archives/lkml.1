Return-Path: <linux-kernel-owner+w=401wt.eu-S1754822AbYI3Hrw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822AbYI3Hrw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 03:47:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752124AbYI3Hmh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 03:42:37 -0400
Received: from smtp.nokia.com ([192.100.122.230]:59032 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619AbYI3HmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 03:42:14 -0400
From: Artem Bityutskiy <dedekind@infradead.org>
To: linux-fsdevel@vger.kernel.org
Cc: Adrian Hunter <ext-adrian.hunter@nokia.com>, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org
Subject: [PATCH] UBIFS: add a print, fix comments and more minor stuff
Date: Tue, 30 Sep 2008 12:18:57 +0300
Message-Id: <1222766358-21886-2-git-send-email-dedekind@infradead.org>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1222766358-21886-1-git-send-email-dedekind@infradead.org>
References: <1222766358-21886-1-git-send-email-dedekind@infradead.org>
X-OriginalArrivalTime: 30 Sep 2008 07:41:36.0412 (UTC) FILETIME=[F79595C0:01C922CF]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

This commit adds a reserved pool size print and tweaks the
prints to make them look nicer.

It also fixes and cleans-up some comments.

Additionally, it deletes some blank lines to make the code look
a little nicer.

In other words, nothing essential.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 fs/ubifs/budget.c |   26 ++++++++++++++------------
 fs/ubifs/lprops.c |    6 +-----
 fs/ubifs/super.c  |   16 +++++++++-------
 3 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/fs/ubifs/budget.c b/fs/ubifs/budget.c
index 73db464..1a4973e 100644
--- a/fs/ubifs/budget.c
+++ b/fs/ubifs/budget.c
@@ -414,19 +414,21 @@ static int do_budget_space(struct ubifs_info *c)
 	 *    @c->lst.empty_lebs + @c->freeable_cnt + @c->idx_gc_cnt -
 	 *    @c->lst.taken_empty_lebs
 	 *
-	 * @empty_lebs are available because they are empty. @freeable_cnt are
-	 * available because they contain only free and dirty space and the
-	 * index allocation always occurs after wbufs are synch'ed.
-	 * @idx_gc_cnt are available because they are index LEBs that have been
-	 * garbage collected (including trivial GC) and are awaiting the commit
-	 * before they can be unmapped - note that the in-the-gaps method will
-	 * grab these if it needs them. @taken_empty_lebs are empty_lebs that
-	 * have already been allocated for some purpose (also includes those
-	 * LEBs on the @idx_gc list).
+	 * @c->lst.empty_lebs are available because they are empty.
+	 * @c->freeable_cnt are available because they contain only free and
+	 * dirty space, @c->idx_gc_cnt are available because they are index
+	 * LEBs that have been garbage collected and are awaiting the commit
+	 * before they can be used. And the in-the-gaps method will grab these
+	 * if it needs them. @c->lst.taken_empty_lebs are empty LEBs that have
+	 * already been allocated for some purpose.
 	 *
-	 * Note, @taken_empty_lebs may temporarily be higher by one because of
-	 * the way we serialize LEB allocations and budgeting. See a comment in
-	 * 'ubifs_find_free_space()'.
+	 * Note, @c->idx_gc_cnt is included to both @c->lst.empty_lebs (because
+	 * these LEBs are empty) and to @c->lst.taken_empty_lebs (because they
+	 * are taken until after the commit).
+	 *
+	 * Note, @c->lst.taken_empty_lebs may temporarily be higher by one
+	 * because of the way we serialize LEB allocations and budgeting. See a
+	 * comment in 'ubifs_find_free_space()'.
 	 */
 	lebs = c->lst.empty_lebs + c->freeable_cnt + c->idx_gc_cnt -
 	       c->lst.taken_empty_lebs;
diff --git a/fs/ubifs/lprops.c b/fs/ubifs/lprops.c
index 2ba93da..3659b88 100644
--- a/fs/ubifs/lprops.c
+++ b/fs/ubifs/lprops.c
@@ -125,6 +125,7 @@ static void adjust_lpt_heap(struct ubifs_info *c, struct ubifs_lpt_heap *heap,
 			}
 		}
 	}
+
 	/* Not greater than parent, so compare to children */
 	while (1) {
 		/* Compare to left child */
@@ -576,7 +577,6 @@ const struct ubifs_lprops *ubifs_change_lp(struct ubifs_info *c,
 	ubifs_assert(!(lprops->free & 7) && !(lprops->dirty & 7));
 
 	spin_lock(&c->space_lock);
-
 	if ((lprops->flags & LPROPS_TAKEN) && lprops->free == c->leb_size)
 		c->lst.taken_empty_lebs -= 1;
 
@@ -637,11 +637,8 @@ const struct ubifs_lprops *ubifs_change_lp(struct ubifs_info *c,
 		c->lst.taken_empty_lebs += 1;
 
 	change_category(c, lprops);
-
 	c->idx_gc_cnt += idx_gc_cnt;
-
 	spin_unlock(&c->space_lock);
-
 	return lprops;
 }
 
@@ -1262,7 +1259,6 @@ static int scan_check_cb(struct ubifs_info *c,
 	}
 
 	ubifs_scan_destroy(sleb);
-
 	return LPT_SCAN_CONTINUE;
 
 out_print:
diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index 3f49020..667c72d 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -1144,19 +1144,21 @@ static int mount_ubifs(struct ubifs_info *c)
 	if (mounted_read_only)
 		ubifs_msg("mounted read-only");
 	x = (long long)c->main_lebs * c->leb_size;
-	ubifs_msg("file system size: %lld bytes (%lld KiB, %lld MiB, %d LEBs)",
-		  x, x >> 10, x >> 20, c->main_lebs);
+	ubifs_msg("file system size:   %lld bytes (%lld KiB, %lld MiB, %d "
+		  "LEBs)", x, x >> 10, x >> 20, c->main_lebs);
 	x = (long long)c->log_lebs * c->leb_size + c->max_bud_bytes;
-	ubifs_msg("journal size: %lld bytes (%lld KiB, %lld MiB, %d LEBs)",
-		  x, x >> 10, x >> 20, c->log_lebs + c->max_bud_cnt);
-	ubifs_msg("default compressor: %s", ubifs_compr_name(c->default_compr));
-	ubifs_msg("media format %d, latest format %d",
+	ubifs_msg("journal size:       %lld bytes (%lld KiB, %lld MiB, %d "
+		  "LEBs)", x, x >> 10, x >> 20, c->log_lebs + c->max_bud_cnt);
+	ubifs_msg("media format:       %d (latest is %d)",
 		  c->fmt_version, UBIFS_FORMAT_VERSION);
+	ubifs_msg("default compressor: %s", ubifs_compr_name(c->default_compr));
+	ubifs_msg("reserved pool size: %llu bytes (%llu KiB)",
+		c->report_rp_size, c->report_rp_size >> 10);
 
 	dbg_msg("compiled on:         " __DATE__ " at " __TIME__);
 	dbg_msg("min. I/O unit size:  %d bytes", c->min_io_size);
 	dbg_msg("LEB size:            %d bytes (%d KiB)",
-		c->leb_size, c->leb_size / 1024);
+		c->leb_size, c->leb_size >> 10);
 	dbg_msg("data journal heads:  %d",
 		c->jhead_cnt - NONDATA_JHEADS_CNT);
 	dbg_msg("UUID:                %02X%02X%02X%02X-%02X%02X"
-- 
1.5.4.1

