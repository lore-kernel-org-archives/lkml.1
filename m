Return-Path: <linux-kernel-owner+w=401wt.eu-S932088AbXIJJwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932088AbXIJJwS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 05:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752625AbXIJJwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 05:52:05 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:32935 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755773AbXIJJwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 05:52:04 -0400
Date: Mon, 10 Sep 2007 18:53:30 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "nickpiggin@yahoo.com.au" <nickpiggin@yahoo.com.au>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: [PATCH] add page->mapping handling interface [8/35] changes in
 CRAMFS
Message-Id: <20070910185330.d26d250e.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070910184048.286dfc6e.kamezawa.hiroyu@jp.fujitsu.com>
References: <20070910184048.286dfc6e.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

patches for handling page->mapping in CRAMFS.

Signed-off-by : KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

---
 fs/cramfs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: test-2.6.23-rc4-mm1/fs/cramfs/inode.c
===================================================================
--- test-2.6.23-rc4-mm1.orig/fs/cramfs/inode.c
+++ test-2.6.23-rc4-mm1/fs/cramfs/inode.c
@@ -469,7 +469,7 @@ static struct dentry * cramfs_lookup(str
 
 static int cramfs_readpage(struct file *file, struct page * page)
 {
-	struct inode *inode = page->mapping->host;
+	struct inode *inode = page_inode(page);
 	u32 maxblock, bytes_filled;
 	void *pgdata;
 

