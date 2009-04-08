Return-Path: <linux-kernel-owner+w=401wt.eu-S932306AbZDHN56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932306AbZDHN56 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 09:57:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758349AbZDHN5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 09:57:41 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:44280 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758700AbZDHN5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 09:57:40 -0400
X-Sasl-enc: lx4qleQWcFz6BOke9d6qVSKKeYoG7Yd2kfb/ctTbpAZg 1239199058
Message-ID: <49DCAD50.6070601@fastmail.fm>
Date: Wed, 08 Apr 2009 14:57:36 +0100
From: Jack Stone <jwjstone@fastmail.fm>
User-Agent: Thunderbird 2.0.0.21 (X11/20090325)
MIME-Version: 1.0
To: Bert Wesarg <bert.wesarg@googlemail.com>
CC: linux-kernel@vger.kernel.org, jeff@garzik.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 51/56] sysv: Remove void casts
References: <1239189748-11703-1-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-44-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-45-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-46-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-47-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-48-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-49-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-50-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-51-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-52-git-send-email-jwjstone@fastmail.fm> <36ca99e90904080502w1a9d703dg49a872b5539c3a9f@mail.gmail.com>
In-Reply-To: <36ca99e90904080502w1a9d703dg49a872b5539c3a9f@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed patch

Thanks,

Jack

--

sysv: Remove void casts

From: Jack Stone <jwjstone@fastmail.fm>

Remove uneeded void casts

Signed-Off-By: Jack Stone <jwjstone@fastmail.fm>
---

 fs/sysv/dir.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/sysv/dir.c b/fs/sysv/dir.c
index 56f6552..73b70a5 100644
--- a/fs/sysv/dir.c
+++ b/fs/sysv/dir.c
@@ -87,7 +87,7 @@ static int sysv_readdir(struct file * filp, void *
dirent, filldir_t filldir)
 
         if (IS_ERR(page))
             continue;
-        kaddr = (char *)page_address(page);
+        kaddr = page_address(page);
         de = (struct sysv_dir_entry *)(kaddr+offset);
         limit = kaddr + PAGE_CACHE_SIZE - SYSV_DIRSIZE;
         for ( ;(char*)de <= limit; de++) {
@@ -157,7 +157,7 @@ struct sysv_dir_entry *sysv_find_entry(struct dentry
*dentry, struct page **res_
         char *kaddr;
         page = dir_get_page(dir, n);
         if (!IS_ERR(page)) {
-            kaddr = (char*)page_address(page);
+            kaddr = page_address(page);
             de = (struct sysv_dir_entry *) kaddr;
             kaddr += PAGE_CACHE_SIZE - SYSV_DIRSIZE;
             for ( ; (char *) de <= kaddr ; de++) {
@@ -201,7 +201,7 @@ int sysv_add_link(struct dentry *dentry, struct
inode *inode)
         err = PTR_ERR(page);
         if (IS_ERR(page))
             goto out;
-        kaddr = (char*)page_address(page);
+        kaddr = page_address(page);
         de = (struct sysv_dir_entry *)kaddr;
         kaddr += PAGE_CACHE_SIZE - SYSV_DIRSIZE;
         while ((char *)de <= kaddr) {
@@ -244,7 +244,7 @@ int sysv_delete_entry(struct sysv_dir_entry *de,
struct page *page)
 {
     struct address_space *mapping = page->mapping;
     struct inode *inode = (struct inode*)mapping->host;
-    char *kaddr = (char*)page_address(page);
+    char *kaddr = page_address(page);
     loff_t pos = page_offset(page) + (char *)de - kaddr;
     int err;
 
@@ -278,7 +278,7 @@ int sysv_make_empty(struct inode *inode, struct
inode *dir)
     }
     kmap(page);
 
-    base = (char*)page_address(page);
+    base = page_address(page);
     memset(base, 0, PAGE_CACHE_SIZE);
 
     de = (struct sysv_dir_entry *) base;
@@ -312,7 +312,7 @@ int sysv_empty_dir(struct inode * inode)
         if (IS_ERR(page))
             continue;
 
-        kaddr = (char *)page_address(page);
+        kaddr = page_address(page);
         de = (struct sysv_dir_entry *)kaddr;
         kaddr += PAGE_CACHE_SIZE-SYSV_DIRSIZE;
 
