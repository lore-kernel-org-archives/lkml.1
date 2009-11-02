Return-Path: <linux-kernel-owner+w=401wt.eu-S1754743AbZKBKJx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743AbZKBKJx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 05:09:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754542AbZKBKHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 05:07:21 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58538 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754398AbZKBKHE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 05:07:04 -0500
From: Jan Blunck <jblunck@suse.de>
To: linux-fsdevel@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       Jan Blunck <jblunck@suse.de>,
       "Sergey S. Kostyliov" <rathamahata@php4.ru>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 11/27] BKL: Remove BKL from befs
Date: Mon,  2 Nov 2009 11:04:51 +0100
Message-Id: <1257156307-24175-12-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1257156307-24175-1-git-send-email-jblunck@suse.de>
References: <1257156307-24175-1-git-send-email-jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BKL is only used in fill_super. It is safe to remove it.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 fs/befs/linuxvfs.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/fs/befs/linuxvfs.c b/fs/befs/linuxvfs.c
index f2aa193..33baf27 100644
--- a/fs/befs/linuxvfs.c
+++ b/fs/befs/linuxvfs.c
@@ -759,8 +759,6 @@ befs_fill_super(struct super_block *sb, void *data, int silent)
 	const unsigned long sb_block = 0;
 	const off_t x86_sb_off = 512;
 
-	lock_kernel();
-
 	save_mount_options(sb, data);
 
 	sb->s_fs_info = kmalloc(sizeof (*befs_sb), GFP_KERNEL);
@@ -869,7 +867,6 @@ befs_fill_super(struct super_block *sb, void *data, int silent)
 		befs_sb->nls = load_nls_default();
 	}
 
-	unlock_kernel();
 	return 0;
 /*****************/
       unacquire_bh:
@@ -880,7 +877,6 @@ befs_fill_super(struct super_block *sb, void *data, int silent)
 
       unacquire_none:
 	sb->s_fs_info = NULL;
-	unlock_kernel();
 	return ret;
 }
 
-- 
1.6.4.2

