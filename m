Return-Path: <linux-kernel-owner+w=401wt.eu-S932762AbXIJKNf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932762AbXIJKNf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 06:13:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753554AbXIJKN1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 06:13:27 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:59328 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393AbXIJKN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 06:13:26 -0400
Date: Mon, 10 Sep 2007 19:15:06 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: sct@redhat.com, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "nickpiggin@yahoo.com.au" <nickpiggin@yahoo.com.au>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: [PATCH] add page->mapping handling interface [21/35] changes in JBD
Message-Id: <20070910191506.75a78deb.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070910184048.286dfc6e.kamezawa.hiroyu@jp.fujitsu.com>
References: <20070910184048.286dfc6e.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Changes page->mapping handling in JBD

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

---
 fs/jbd/journal.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: test-2.6.23-rc4-mm1/fs/jbd/journal.c
===================================================================
--- test-2.6.23-rc4-mm1.orig/fs/jbd/journal.c
+++ test-2.6.23-rc4-mm1/fs/jbd/journal.c
@@ -1822,7 +1822,7 @@ repeat:
 		jh = bh2jh(bh);
 	} else {
 		if (!(atomic_read(&bh->b_count) > 0 ||
-				(bh->b_page && bh->b_page->mapping))) {
+				(bh->b_page && page_mapping_cache(bh->b_page)))) {
 			printk(KERN_EMERG "%s: bh->b_count=%d\n",
 				__FUNCTION__, atomic_read(&bh->b_count));
 			printk(KERN_EMERG "%s: bh->b_page=%p\n",
@@ -1830,7 +1830,7 @@ repeat:
 			if (bh->b_page)
 				printk(KERN_EMERG "%s: "
 						"bh->b_page->mapping=%p\n",
-					__FUNCTION__, bh->b_page->mapping);
+				 __FUNCTION__, page_mapping_cache(bh->b_page));
 		}
 
 		if (!new_jh) {

