Return-Path: <linux-kernel-owner+w=401wt.eu-S1759259AbYBPDW7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759259AbYBPDW7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 22:22:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759377AbYBPDWa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 22:22:30 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:24409 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601AbYBPDWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 22:22:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=u6lc8QExJ0nJn8pxISqPmvQ7h9J2xczVZi+XNlWvBqJ5pIGLJbyeiawOEYI9CIub6ROfexSWNNHM7sU5xotLZt39kxkJ0Wopl34sA4LkiqZWzsmhzgjOmmVxwNjR4kDfKkiFi99As0IMm2qf/BR9Zqem956MFldfRPwfD2Y8NTo=
Subject: [PATCH 2/4] jffs2: fix sparse warning in nodemgmt.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 15 Feb 2008 19:22:15 -0800
Message-Id: <1203132135.7442.31.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fs/jffs2/nodemgmt.c:60:8: warning: symbol 'ret' shadows an earlier one
fs/jffs2/nodemgmt.c:45:6: originally declared here

Use a different var (gc) in the inner loop to test the condition.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 fs/jffs2/nodemgmt.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/jffs2/nodemgmt.c b/fs/jffs2/nodemgmt.c
index a0313fa..96faa70 100644
--- a/fs/jffs2/nodemgmt.c
+++ b/fs/jffs2/nodemgmt.c
@@ -57,7 +57,7 @@ int jffs2_reserve_space(struct jffs2_sb_info *c, uint32_t minsize,
 	/* this needs a little more thought (true <tglx> :)) */
 	while(ret == -EAGAIN) {
 		while(c->nr_free_blocks + c->nr_erasing_blocks < blocksneeded) {
-			int ret;
+			int gc;
 			uint32_t dirty, avail;
 
 			/* calculate real dirty size
@@ -116,9 +116,9 @@ int jffs2_reserve_space(struct jffs2_sb_info *c, uint32_t minsize,
 				  c->free_size + c->dirty_size + c->wasted_size + c->used_size + c->erasing_size + c->bad_size, c->flash_size));
 			spin_unlock(&c->erase_completion_lock);
 
-			ret = jffs2_garbage_collect_pass(c);
-			if (ret)
-				return ret;
+			gc = jffs2_garbage_collect_pass(c);
+			if (gc)
+				return gc;
 
 			cond_resched();
 
-- 
1.5.4.1.1278.gc75be


