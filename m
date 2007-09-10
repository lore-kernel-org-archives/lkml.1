Return-Path: <linux-kernel-owner+w=401wt.eu-S933072AbXIJKOj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933072AbXIJKOj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 06:14:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755860AbXIJKOa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 06:14:30 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:59426 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753554AbXIJKO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 06:14:29 -0400
Date: Mon, 10 Sep 2007 19:16:22 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: dwmw2@infradead.org, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "nickpiggin@yahoo.com.au" <nickpiggin@yahoo.com.au>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: [PATCH] add page->mapping handling interface [22/35] changes in
 JFFS2
Message-Id: <20070910191622.d18b1aaa.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070910184048.286dfc6e.kamezawa.hiroyu@jp.fujitsu.com>
References: <20070910184048.286dfc6e.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Changes page->mapping handling in JFFS2

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

---
 fs/jffs2/file.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: test-2.6.23-rc4-mm1/fs/jffs2/file.c
===================================================================
--- test-2.6.23-rc4-mm1.orig/fs/jffs2/file.c
+++ test-2.6.23-rc4-mm1/fs/jffs2/file.c
@@ -111,11 +111,11 @@ int jffs2_do_readpage_unlock(struct inod
 
 static int jffs2_readpage (struct file *filp, struct page *pg)
 {
-	struct jffs2_inode_info *f = JFFS2_INODE_INFO(pg->mapping->host);
+	struct jffs2_inode_info *f = JFFS2_INODE_INFO(page_inode(pg));
 	int ret;
 
 	down(&f->sem);
-	ret = jffs2_do_readpage_unlock(pg->mapping->host, pg);
+	ret = jffs2_do_readpage_unlock(page_inode(pg), pg);
 	up(&f->sem);
 	return ret;
 }

