Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752440AbYLRLs5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752440AbYLRLs5 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 06:48:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751027AbYLRLsr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 06:48:47 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38277 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbYLRLsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 06:48:46 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: mmotm 2008-12-16-00-43 uploaded (fs)
Cc: kosaki.motohiro@jp.fujitsu.com, Randy Dunlap <randy.dunlap@oracle.com>,
        linux-kernel@vger.kernel.org, npiggin@suse.de
In-Reply-To: <20081218200145.D7B3.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20081216102136.08ba1714.akpm@linux-foundation.org> <20081218200145.D7B3.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Message-Id: <20081218204759.D7B6.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Thu, 18 Dec 2008 20:48:44 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I have fixing patch. this patch series have
> 
> 1) reiser4 fix
> 2) ubifs fix
> 3) fuse fix
> 



Tested on mmotm1217 + fs-symlink-write_begin-allocation-context-fix.patch

==
Subject: [PATCH 2/3] fix ubifs build error of fs-symlink-write_begin-allocation-context-fix.patch

build fix.


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 fs/ubifs/file.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: b/fs/ubifs/file.c
===================================================================
--- a/fs/ubifs/file.c
+++ b/fs/ubifs/file.c
@@ -219,7 +219,8 @@ static void release_existing_page_budget
 }
 
 static int write_begin_slow(struct address_space *mapping,
-			    loff_t pos, unsigned len, struct page **pagep)
+			    loff_t pos, unsigned len, struct page **pagep,
+			    unsigned flags)
 {
 	struct inode *inode = mapping->host;
 	struct ubifs_info *c = inode->i_sb->s_fs_info;
@@ -485,7 +486,7 @@ static int ubifs_write_begin(struct file
 		unlock_page(page);
 		page_cache_release(page);
 
-		return write_begin_slow(mapping, pos, len, pagep);
+		return write_begin_slow(mapping, pos, len, pagep, flags);
 	}
 
 	/*


