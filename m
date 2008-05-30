Return-Path: <linux-kernel-owner+w=401wt.eu-S1755049AbYE3Btz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755049AbYE3Btz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 21:49:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752707AbYE3Btr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 21:49:47 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:47923 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972AbYE3Btq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 21:49:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=APsfZj9BIWWyLN5cfVC9/96weN8JElKVamRVotR6LFUxIlMh9/XQrfzldVZTMg+IxmANIFj9c4N6bDCCSGtJ6dhUgy+nke+MAifthz1GHRqqyi8z1y/cdBqxcFQNmevOjcLCNovQ97QGHaTbrucafAgG1sedOxHCh966wW8laGQ=
Subject: [PATCH] jffs2: add sparse annotations for the erase_completion_lock
From: Harvey Harrison <harvey.harrison@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 29 May 2008 18:47:44 -0700
Message-Id: <1212112064.28403.171.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 fs/jffs2/gc.c       |    2 ++
 fs/jffs2/nodemgmt.c |    4 ++++
 fs/jffs2/summary.c  |    2 ++
 3 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/fs/jffs2/gc.c b/fs/jffs2/gc.c
index 090c556..6312a67 100644
--- a/fs/jffs2/gc.c
+++ b/fs/jffs2/gc.c
@@ -39,6 +39,8 @@ static int jffs2_garbage_collect_live(struct jffs2_sb_info *c,  struct jffs2_era
 
 /* Called with erase_completion_lock held */
 static struct jffs2_eraseblock *jffs2_find_gc_block(struct jffs2_sb_info *c)
+__releases(&c->erase_completion_lock)
+__acquires(&c->erase_completion_lock)
 {
 	struct jffs2_eraseblock *ret;
 	struct list_head *nextlist = NULL;
diff --git a/fs/jffs2/nodemgmt.c b/fs/jffs2/nodemgmt.c
index a9bf960..728c8aa 100644
--- a/fs/jffs2/nodemgmt.c
+++ b/fs/jffs2/nodemgmt.c
@@ -204,6 +204,8 @@ static void jffs2_close_nextblock(struct jffs2_sb_info *c, struct jffs2_eraseblo
 /* Select a new jeb for nextblock */
 
 static int jffs2_find_nextblock(struct jffs2_sb_info *c)
+__releases(&c->erase_completion_lock)
+__acquires(&c->erase_completion_lock)
 {
 	struct list_head *next;
 
@@ -269,6 +271,8 @@ static int jffs2_find_nextblock(struct jffs2_sb_info *c)
 /* Called with alloc sem _and_ erase_completion_lock */
 static int jffs2_do_reserve_space(struct jffs2_sb_info *c, uint32_t minsize,
 				  uint32_t *len, uint32_t sumsize)
+__releases(&c->erase_completion_lock)
+__acquires(&c->erase_completion_lock)
 {
 	struct jffs2_eraseblock *jeb = c->nextblock;
 	uint32_t reserved_size;				/* for summary information at the end of the jeb */
diff --git a/fs/jffs2/summary.c b/fs/jffs2/summary.c
index 629af01..8410b6c 100644
--- a/fs/jffs2/summary.c
+++ b/fs/jffs2/summary.c
@@ -818,6 +818,8 @@ static int jffs2_sum_write_data(struct jffs2_sb_info *c, struct jffs2_eraseblock
 /* Write out summary information - called from jffs2_do_reserve_space */
 
 int jffs2_sum_write_sumnode(struct jffs2_sb_info *c)
+__releases(&c->erase_completion_lock)
+__acquires(&c->erase_completion_lock)
 {
 	int datasize, infosize, padsize;
 	struct jffs2_eraseblock *jeb;
-- 
1.5.6.rc0.277.g804cf



