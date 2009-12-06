Return-Path: <linux-kernel-owner+w=401wt.eu-S1756264AbZLFH7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756264AbZLFH7Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 02:59:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753765AbZLFH7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 02:59:11 -0500
Received: from mtoichi12.ns.itscom.net ([219.110.2.182]:47259 "EHLO
	mtoichi12.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293AbZLFH7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 02:59:10 -0500
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
To: linux-kernel@vger.kernel.org
Cc: stewb@linux-foundation.org, "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: [RFC 3/5] ext3, support pathconf(3) with _PC_LINK_MAX
Date: Sun,  6 Dec 2009 16:59:01 +0900
Message-Id: <1260086343-8406-4-git-send-email-hooanon05@yahoo.co.jp>
X-Mailer: git-send-email 1.6.1.284.g5dc13
In-Reply-To: <1260086343-8406-1-git-send-email-hooanon05@yahoo.co.jp>
References: <1260086343-8406-1-git-send-email-hooanon05@yahoo.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return the value via struct statfs.f_spare[0].

Signed-off-by: J. R. Okajima <hooanon05@yahoo.co.jp>
---
 fs/ext3/super.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 427496c..19cdc14 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -2698,6 +2698,7 @@ static int ext3_statfs (struct dentry * dentry, struct kstatfs * buf)
 	       le64_to_cpup((void *)es->s_uuid + sizeof(u64));
 	buf->f_fsid.val[0] = fsid & 0xFFFFFFFFUL;
 	buf->f_fsid.val[1] = (fsid >> 32) & 0xFFFFFFFFUL;
+	buf->f_linkmax = EXT3_LINK_MAX;
 	return 0;
 }
 
-- 
1.6.1.284.g5dc13

