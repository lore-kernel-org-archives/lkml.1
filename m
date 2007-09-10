Return-Path: <linux-kernel-owner+w=401wt.eu-S933275AbXIJK0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933275AbXIJK0h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 06:26:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756958AbXIJK00
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 06:26:26 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:60264 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755827AbXIJK0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 06:26:25 -0400
Date: Mon, 10 Sep 2007 19:28:15 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "nickpiggin@yahoo.com.au" <nickpiggin@yahoo.com.au>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: [PATCH] add page->mapping handling interface [30/35] changes ROMFS
Message-Id: <20070910192815.de8419da.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070910184048.286dfc6e.kamezawa.hiroyu@jp.fujitsu.com>
References: <20070910184048.286dfc6e.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Changes page->mapping handling in ROMFS

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

---
 fs/romfs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: test-2.6.23-rc4-mm1/fs/romfs/inode.c
===================================================================
--- test-2.6.23-rc4-mm1.orig/fs/romfs/inode.c
+++ test-2.6.23-rc4-mm1/fs/romfs/inode.c
@@ -417,7 +417,7 @@ out:	unlock_kernel();
 static int
 romfs_readpage(struct file *file, struct page * page)
 {
-	struct inode *inode = page->mapping->host;
+	struct inode *inode = page_inode(page);
 	loff_t offset, avail, readlen;
 	void *buf;
 	int result = -EIO;

