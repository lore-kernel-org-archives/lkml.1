Return-Path: <linux-kernel-owner+w=401wt.eu-S932568AbZDHLfh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932568AbZDHLfh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 07:35:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762116AbZDHL11
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 07:27:27 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:34240 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764225AbZDHL1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 07:27:24 -0400
X-Sasl-enc: 4ZiEmfFCM09ZX/iEHZ8Yb8flw3Qf0tPyRWAW8RC8+2sK 1239190042
From: Jack Stone <jwjstone@fastmail.fm>
To: linux-kernel@vger.kernel.org
Cc: jeff@garzik.org, kernel-janitors@vger.kernel.org,
       Jack Stone <jwjstone@fastmail.fm>
Subject: [PATCH 23/56] minix: Remove void casts
Date: Wed,  8 Apr 2009 12:21:55 +0100
Message-Id: <1239189748-11703-24-git-send-email-jwjstone@fastmail.fm>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1239189748-11703-23-git-send-email-jwjstone@fastmail.fm>
References: <>
 <1239189748-11703-1-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-2-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-3-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-4-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-5-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-6-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-7-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-8-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-9-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-10-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-11-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-12-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-13-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-14-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-15-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-16-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-17-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-18-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-19-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-20-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-21-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-22-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-23-git-send-email-jwjstone@fastmail.fm>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove uneeded void casts

Signed-Off-By: Jack Stone <jwjstone@fastmail.fm>
---
 fs/minix/dir.c   |    8 ++++----
 fs/minix/inode.c |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/minix/dir.c b/fs/minix/dir.c
index d4946c4..e17634c 100644
--- a/fs/minix/dir.c
+++ b/fs/minix/dir.c
@@ -114,7 +114,7 @@ static int minix_readdir(struct file * filp, void * dirent, filldir_t filldir)
 
 		if (IS_ERR(page))
 			continue;
-		kaddr = (char *)page_address(page);
+		kaddr = page_address(page);
 		p = kaddr+offset;
 		limit = kaddr + minix_last_byte(inode, n) - chunk_size;
 		for ( ; p <= limit; p = minix_next_entry(p, sbi)) {
@@ -189,7 +189,7 @@ minix_dirent *minix_find_entry(struct dentry *dentry, struct page **res_page)
 		if (IS_ERR(page))
 			continue;
 
-		kaddr = (char*)page_address(page);
+		kaddr = page_address(page);
 		limit = kaddr + minix_last_byte(dir, n) - sbi->s_dirsize;
 		for (p = kaddr; p <= limit; p = minix_next_entry(p, sbi)) {
 			if (sbi->s_version == MINIX_V3) {
@@ -246,7 +246,7 @@ int minix_add_link(struct dentry *dentry, struct inode *inode)
 		if (IS_ERR(page))
 			goto out;
 		lock_page(page);
-		kaddr = (char*)page_address(page);
+		kaddr = page_address(page);
 		dir_end = kaddr + minix_last_byte(dir, n);
 		limit = kaddr + PAGE_CACHE_SIZE - sbi->s_dirsize;
 		for (p = kaddr; p <= limit; p = minix_next_entry(p, sbi)) {
@@ -392,7 +392,7 @@ int minix_empty_dir(struct inode * inode)
 		if (IS_ERR(page))
 			continue;
 
-		kaddr = (char *)page_address(page);
+		kaddr = page_address(page);
 		limit = kaddr + minix_last_byte(inode, i) - sbi->s_dirsize;
 		for (p = kaddr; p <= limit; p = minix_next_entry(p, sbi)) {
 			if (sbi->s_version == MINIX_V3) {
diff --git a/fs/minix/inode.c b/fs/minix/inode.c
index daad3c2..eb74488 100644
--- a/fs/minix/inode.c
+++ b/fs/minix/inode.c
@@ -57,7 +57,7 @@ static struct kmem_cache * minix_inode_cachep;
 static struct inode *minix_alloc_inode(struct super_block *sb)
 {
 	struct minix_inode_info *ei;
-	ei = (struct minix_inode_info *)kmem_cache_alloc(minix_inode_cachep, GFP_KERNEL);
+	ei = kmem_cache_alloc(minix_inode_cachep, GFP_KERNEL);
 	if (!ei)
 		return NULL;
 	return &ei->vfs_inode;
-- 
1.5.4.3

