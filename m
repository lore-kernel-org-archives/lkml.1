Return-Path: <linux-kernel-owner+w=401wt.eu-S1752381AbZK1G1y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752381AbZK1G1y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Nov 2009 01:27:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752062AbZK1G1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Nov 2009 01:27:52 -0500
Received: from mail.gmx.net ([213.165.64.20]:54362 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752017AbZK1G1m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Nov 2009 01:27:42 -0500
X-Authenticated: #25574588
X-Provags-ID: V01U2FsdGVkX1/cU9gPirPcr7LUSLt7yPOhX8AIEoRKVzpVwS7MiO
	LsJdJ2nhxG6sE/
From: Johannes Buchner <buchner.johannes@gmx.at>
To: linux-kernel@vger.kernel.org, reiserfs-devel@vger.kernel.org
Cc: Johannes Buchner <buchner.johannes@gmx.at>
Subject: [PATCH 2/4] reiser4: some comments were still mentioning pdflush
Date: Sat, 28 Nov 2009 19:28:02 +1300
Message-Id: <1259389684-18625-3-git-send-email-buchner.johannes@gmx.at>
X-Mailer: git-send-email 1.6.4.4
In-Reply-To: <1259389684-18625-2-git-send-email-buchner.johannes@gmx.at>
References: <1259389179-3772-2-git-send-email-buchner.johannes@gmx.at>
 <1259389684-18625-1-git-send-email-buchner.johannes@gmx.at>
 <1259389684-18625-2-git-send-email-buchner.johannes@gmx.at>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 fs/reiser4/context.c |    2 +-
 fs/reiser4/txnmgr.c  |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/reiser4/context.c b/fs/reiser4/context.c
index eed3efa..248a21f 100644
--- a/fs/reiser4/context.c
+++ b/fs/reiser4/context.c
@@ -147,7 +147,7 @@ static void reiser4_throttle_write_at(reiser4_context *context)
 	 * call balance_dirty_pages_ratelimited() to process formatted nodes
 	 * dirtied during this system call. Do that only if we are not in mount
 	 * and there were nodes dirtied in this context and we are not in
-	 * writepage (to avoid deadlock) and not in pdflush
+	 * writepage (to avoid deadlock)
 	 */
 	if (sbinfo != NULL && sbinfo->fake != NULL &&
 	    context->nr_marked_dirty != 0 &&
diff --git a/fs/reiser4/txnmgr.c b/fs/reiser4/txnmgr.c
index 74b49f2..844d19e 100644
--- a/fs/reiser4/txnmgr.c
+++ b/fs/reiser4/txnmgr.c
@@ -1360,7 +1360,7 @@ static int txn_try_to_fuse_small_atom(txn_mgr * tmgr, txn_atom * atom)
    code tries to flush current atom.
 
    flush_some_atom() is called as part of memory clearing process. It is
-   invoked from balance_dirty_pages(), pdflushd, and entd.
+   invoked from balance_dirty_pages() and entd.
 
    If we can flush no nodes, atom is committed, because this frees memory.
 
@@ -1469,7 +1469,7 @@ flush_some_atom(jnode * start, long *nr_submitted, const struct writeback_contro
 			 * or atom is too old/large,
 			 * we force current atom to commit */
 			/* wait for commit completion but only if this
-			 * wouldn't stall pdflushd and ent thread. */
+			 * wouldn't stall ent thread. */
 			if (!wbc->nonblocking && !ctx->entd)
 				txnh->flags |= TXNH_WAIT_COMMIT;
 			atom->flags |= ATOM_FORCE_COMMIT;
-- 
1.6.4.4

