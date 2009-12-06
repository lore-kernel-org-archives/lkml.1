Return-Path: <linux-kernel-owner+w=401wt.eu-S932492AbZLFIAC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932492AbZLFIAC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 03:00:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932343AbZLFH7p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 02:59:45 -0500
Received: from mtoichi14.ns.itscom.net ([219.110.2.184]:47871 "EHLO
	mtoichi14.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932287AbZLFH7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 02:59:41 -0500
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
To: linux-kernel@vger.kernel.org
Cc: stewb@linux-foundation.org, "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: [RFC 2/5] ext2, support pathconf(3) with _PC_LINK_MAX
Date: Sun,  6 Dec 2009 16:59:00 +0900
Message-Id: <1260086343-8406-3-git-send-email-hooanon05@yahoo.co.jp>
X-Mailer: git-send-email 1.6.1.284.g5dc13
In-Reply-To: <1260086343-8406-1-git-send-email-hooanon05@yahoo.co.jp>
References: <1260086343-8406-1-git-send-email-hooanon05@yahoo.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return the value via struct statfs.f_spare[0].

Signed-off-by: J. R. Okajima <hooanon05@yahoo.co.jp>
---
 fs/ext2/super.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 1a9ffee..720c5c1 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -1304,6 +1304,7 @@ static int ext2_statfs (struct dentry * dentry, struct kstatfs * buf)
 	       le64_to_cpup((void *)es->s_uuid + sizeof(u64));
 	buf->f_fsid.val[0] = fsid & 0xFFFFFFFFUL;
 	buf->f_fsid.val[1] = (fsid >> 32) & 0xFFFFFFFFUL;
+	buf->f_linkmax = EXT2_LINK_MAX;
 	return 0;
 }
 
-- 
1.6.1.284.g5dc13

