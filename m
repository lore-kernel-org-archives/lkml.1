Return-Path: <linux-kernel-owner+w=401wt.eu-S932234AbXIJKM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932234AbXIJKM3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 06:12:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753481AbXIJKMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 06:12:19 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34791 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748AbXIJKMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 06:12:17 -0400
Date: Mon, 10 Sep 2007 19:13:51 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "nickpiggin@yahoo.com.au" <nickpiggin@yahoo.com.au>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: [PATCH] add page->mapping handling interface [20/35] changes in
 ISOFS
Message-Id: <20070910191351.e9aafb20.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070910184048.286dfc6e.kamezawa.hiroyu@jp.fujitsu.com>
References: <20070910184048.286dfc6e.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Changes page->mapping handling in ISOFS

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

---
 fs/isofs/rock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: test-2.6.23-rc4-mm1/fs/isofs/rock.c
===================================================================
--- test-2.6.23-rc4-mm1.orig/fs/isofs/rock.c
+++ test-2.6.23-rc4-mm1/fs/isofs/rock.c
@@ -640,7 +640,7 @@ int parse_rock_ridge_inode(struct iso_di
  */
 static int rock_ridge_symlink_readpage(struct file *file, struct page *page)
 {
-	struct inode *inode = page->mapping->host;
+	struct inode *inode = page_inode(page);
 	struct iso_inode_info *ei = ISOFS_I(inode);
 	char *link = kmap(page);
 	unsigned long bufsize = ISOFS_BUFFER_SIZE(inode);

