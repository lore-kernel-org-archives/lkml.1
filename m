Return-Path: <linux-kernel-owner+w=401wt.eu-S932286AbZLFH7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932286AbZLFH7j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 02:59:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754428AbZLFH7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 02:59:37 -0500
Received: from mtoichi14.ns.itscom.net ([219.110.2.184]:47862 "EHLO
	mtoichi14.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754378AbZLFH7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 02:59:36 -0500
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
To: linux-kernel@vger.kernel.org
Cc: stewb@linux-foundation.org, "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: [RFC 5/5] tmpfs, support pathconf(3) with _PC_LINK_MAX
Date: Sun,  6 Dec 2009 16:59:03 +0900
Message-Id: <1260086343-8406-6-git-send-email-hooanon05@yahoo.co.jp>
X-Mailer: git-send-email 1.6.1.284.g5dc13
In-Reply-To: <1260086343-8406-1-git-send-email-hooanon05@yahoo.co.jp>
References: <1260086343-8406-1-git-send-email-hooanon05@yahoo.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return the value via struct statfs.f_spare[0].
Actually tmpfs doesn't check the link count in link(2) and it can be
wrap around. Set LINK_MAX_UNLIMITED.

Signed-off-by: J. R. Okajima <hooanon05@yahoo.co.jp>
---
 mm/shmem.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 356dd99..78f7e21 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1784,6 +1784,7 @@ static int shmem_statfs(struct dentry *dentry, struct kstatfs *buf)
 	buf->f_type = TMPFS_MAGIC;
 	buf->f_bsize = PAGE_CACHE_SIZE;
 	buf->f_namelen = NAME_MAX;
+	buf->f_linkmax = LINK_MAX_UNLIMITED;
 	spin_lock(&sbinfo->stat_lock);
 	if (sbinfo->max_blocks) {
 		buf->f_blocks = sbinfo->max_blocks;
-- 
1.6.1.284.g5dc13

