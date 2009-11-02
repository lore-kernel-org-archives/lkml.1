Return-Path: <linux-kernel-owner+w=401wt.eu-S1754592AbZKBKH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592AbZKBKH0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 05:07:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754569AbZKBKHZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 05:07:25 -0500
Received: from cantor.suse.de ([195.135.220.2]:47292 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754395AbZKBKHD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 05:07:03 -0500
From: Jan Blunck <jblunck@suse.de>
To: linux-fsdevel@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       Jan Blunck <jblunck@suse.de>, Jeff Dike <jdike@addtoit.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       WANG Cong <wangcong@zeuux.org>, Nick Piggin <npiggin@suse.de>,
       user-mode-linux-devel@lists.sourceforge.net,
       user-mode-linux-user@lists.sourceforge.net
Subject: [PATCH 18/27] BKL: Remove BKL from hostfs
Date: Mon,  2 Nov 2009 11:04:58 +0100
Message-Id: <1257156307-24175-19-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1257156307-24175-1-git-send-email-jblunck@suse.de>
References: <1257156307-24175-1-git-send-email-jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BKL is only used in fill_super. It is safe to remove it.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 fs/hostfs/hostfs_kern.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/fs/hostfs/hostfs_kern.c b/fs/hostfs/hostfs_kern.c
index 5eb2c26..032604e 100644
--- a/fs/hostfs/hostfs_kern.c
+++ b/fs/hostfs/hostfs_kern.c
@@ -968,8 +968,6 @@ static int hostfs_fill_sb_common(struct super_block *sb, void *d, int silent)
 	char *host_root_path, *req_root = d;
 	int err;
 
-	lock_kernel();
-
 	sb->s_blocksize = 1024;
 	sb->s_blocksize_bits = 10;
 	sb->s_magic = HOSTFS_SUPER_MAGIC;
@@ -1018,7 +1016,6 @@ static int hostfs_fill_sb_common(struct super_block *sb, void *d, int silent)
 		goto out;
 	}
 
-	unlock_kernel();
 	return 0;
 
 out_put:
@@ -1026,7 +1023,6 @@ out_put:
 out_free:
 	kfree(host_root_path);
 out:
-	unlock_kernel();
 	return err;
 }
 
-- 
1.6.4.2

