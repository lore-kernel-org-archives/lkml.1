Return-Path: <linux-kernel-owner+w=401wt.eu-S1754727AbZKBKLM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727AbZKBKLM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 05:11:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754413AbZKBKHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 05:07:13 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58561 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754416AbZKBKHF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 05:07:05 -0500
From: Jan Blunck <jblunck@suse.de>
To: linux-fsdevel@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       Jan Blunck <jblunck@suse.de>, Artem Bityutskiy <dedekind@infradead.org>,
       Adrian Hunter <adrian.hunter@nokia.com>,
       Jens Axboe <jens.axboe@oracle.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>, linux-mtd@lists.infradead.org
Subject: [PATCH 26/27] BKL: Remove BKL from ubifs
Date: Mon,  2 Nov 2009 11:05:06 +0100
Message-Id: <1257156307-24175-27-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1257156307-24175-1-git-send-email-jblunck@suse.de>
References: <1257156307-24175-1-git-send-email-jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BKL is only used in get_sb. It is safe to remove it.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 fs/ubifs/super.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index 04a0fc9..333e181 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -2029,8 +2029,6 @@ static int ubifs_get_sb(struct file_system_type *fs_type, int flags,
 	struct super_block *sb;
 	int err;
 
-	lock_kernel();
-
 	dbg_gen("name %s, flags %#x", name, flags);
 
 	/*
@@ -2042,7 +2040,6 @@ static int ubifs_get_sb(struct file_system_type *fs_type, int flags,
 	if (IS_ERR(ubi)) {
 		ubifs_err("cannot open \"%s\", error %d",
 			  name, (int)PTR_ERR(ubi));
-		unlock_kernel();
 		return PTR_ERR(ubi);
 	}
 	ubi_get_volume_info(ubi, &vi);
@@ -2080,14 +2077,12 @@ static int ubifs_get_sb(struct file_system_type *fs_type, int flags,
 	ubi_close_volume(ubi);
 
 	simple_set_mnt(mnt, sb);
-	unlock_kernel();
 	return 0;
 
 out_deact:
 	deactivate_locked_super(sb);
 out_close:
 	ubi_close_volume(ubi);
-	unlock_kernel();
 	return err;
 }
 
-- 
1.6.4.2

