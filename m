Return-Path: <linux-kernel-owner+w=401wt.eu-S932497AbXIJKJ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932497AbXIJKJ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 06:09:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751772AbXIJKJV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 06:09:21 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34459 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753874AbXIJKJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 06:09:20 -0400
Date: Mon, 10 Sep 2007 19:11:15 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "nickpiggin@yahoo.com.au" <nickpiggin@yahoo.com.au>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: [PATCH] add page->mapping handling interface [19/35] changes in
 HPFS
Message-Id: <20070910191115.9bdd3a71.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070910184048.286dfc6e.kamezawa.hiroyu@jp.fujitsu.com>
References: <20070910184048.286dfc6e.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Changes page->mapping handling in HPFS

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

---
 fs/hpfs/namei.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: test-2.6.23-rc4-mm1/fs/hpfs/namei.c
===================================================================
--- test-2.6.23-rc4-mm1.orig/fs/hpfs/namei.c
+++ test-2.6.23-rc4-mm1/fs/hpfs/namei.c
@@ -511,7 +511,7 @@ out:
 static int hpfs_symlink_readpage(struct file *file, struct page *page)
 {
 	char *link = kmap(page);
-	struct inode *i = page->mapping->host;
+	struct inode *i = page_inode(page);
 	struct fnode *fnode;
 	struct buffer_head *bh;
 	int err;

