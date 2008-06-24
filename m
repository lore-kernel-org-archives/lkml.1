Return-Path: <linux-kernel-owner+w=401wt.eu-S1757590AbYFXBqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757590AbYFXBqh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 21:46:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757276AbYFXBqG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 21:46:06 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:33735 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752849AbYFXBqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 21:46:04 -0400
Message-ID: <486051AA.8000507@np.css.fujitsu.com>
Date: Tue, 24 Jun 2008 10:45:14 +0900
From: Kentaro Makita <k-makita@np.css.fujitsu.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       viro@ZenIV.linux.org.uk, harvey.harrison@gmail.com
Subject: [RESEND][PATCH -mm 1/2] vfs: fix coding style at dcache.c.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o fix coding style at dcache.c. No behavior changed.

Signed-off-by: Kentaro Makita <k-makita@np.css.fujitsu.com>
---
 fs/dcache.c |   21 ++++++++++-----------
 1 files changed, 10 insertions(+), 11 deletions(-)

Index: b/fs/dcache.c
===================================================================
--- a/fs/dcache.c	2008-06-05 11:44:26.000000000 +0900
+++ b/fs/dcache.c	2008-06-05 11:48:57.000000000 +0900
@@ -453,15 +453,15 @@ static void __shrink_dcache_sb(struct su
 	int cnt = 0;

 	BUG_ON(!sb);
-	BUG_ON((flags & DCACHE_REFERENCED) && count == NULL);
+	BUG_ON((flags & DCACHE_REFERENCED) && !count);
 	spin_lock(&dcache_lock);
-	if (count != NULL)
+	if (count)
 		/* called from prune_dcache() and shrink_dcache_parent() */
 		cnt = *count;
 restart:
-	if (count == NULL)
+	if (!count) {
 		list_splice_init(&sb->s_dentry_lru, &tmp);
-	else {
+	} else {
 		while (!list_empty(&sb->s_dentry_lru)) {
 			dentry = list_entry(sb->s_dentry_lru.prev,
 					struct dentry, d_lru);
@@ -473,16 +473,15 @@ restart:
 			 * the dentry has this flag set, don't free it. Clear
 			 * the flag and put it back on the LRU.
 			 */
-			if ((flags & DCACHE_REFERENCED)
-				&& (dentry->d_flags & DCACHE_REFERENCED)) {
+			if ((flags & DCACHE_REFERENCED) &&
+			    (dentry->d_flags & DCACHE_REFERENCED)) {
 				dentry->d_flags &= ~DCACHE_REFERENCED;
 				list_move_tail(&dentry->d_lru, &referenced);
 				spin_unlock(&dentry->d_lock);
 			} else {
 				list_move_tail(&dentry->d_lru, &tmp);
 				spin_unlock(&dentry->d_lock);
-				cnt--;
-				if (!cnt)
+				if (--cnt == 0)
 					break;
 			}
 		}
@@ -504,10 +503,10 @@ restart:
 		/* dentry->d_lock was dropped in prune_one_dentry() */
 		cond_resched_lock(&dcache_lock);
 	}
-	if (count == NULL && !list_empty(&sb->s_dentry_lru))
-		goto restart;
-	if (count != NULL)
+	if (count)
 		*count = cnt;
+	else if (!list_empty(&sb->s_dentry_lru))
+		goto restart;
 	if (!list_empty(&referenced))
 		list_splice(&referenced, &sb->s_dentry_lru);
 	spin_unlock(&dcache_lock);









