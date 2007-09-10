Return-Path: <linux-kernel-owner+w=401wt.eu-S932614AbXIJJzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932614AbXIJJzA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 05:55:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755262AbXIJJyv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 05:54:51 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:57597 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754178AbXIJJyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 05:54:50 -0400
Date: Mon, 10 Sep 2007 18:56:31 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "nickpiggin@yahoo.com.au" <nickpiggin@yahoo.com.au>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: [PATCH] add page->mapping handling interface [10/35] changes in EFS
Message-Id: <20070910185631.70386ef9.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070910184048.286dfc6e.kamezawa.hiroyu@jp.fujitsu.com>
References: <20070910184048.286dfc6e.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Change page->mapping handling in EFS

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


Index: test-2.6.23-rc4-mm1/fs/efs/symlink.c
===================================================================
--- test-2.6.23-rc4-mm1.orig/fs/efs/symlink.c
+++ test-2.6.23-rc4-mm1/fs/efs/symlink.c
@@ -16,7 +16,7 @@ static int efs_symlink_readpage(struct f
 {
 	char *link = kmap(page);
 	struct buffer_head * bh;
-	struct inode * inode = page->mapping->host;
+	struct inode * inode = page_inode(page);
 	efs_block_t size = inode->i_size;
 	int err;
   

