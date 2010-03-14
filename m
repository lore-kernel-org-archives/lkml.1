Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934697Ab0CNX1N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 19:27:13 -0400
Received: from trinity.develer.com ([83.149.158.210]:52281 "EHLO
	trinity.develer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754742Ab0CNX04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 19:26:56 -0400
From: Andrea Righi <arighi@develer.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Suleiman Souhlal <suleiman@google.com>,
       Greg Thelen <gthelen@google.com>,
       "Kirill A. Shutemov" <kirill@shutemov.name>,
       Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Andrea Righi <arighi@develer.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [PATCH -mmotm 3/5] page_cgroup: introduce file cache flags
Date: Mon, 15 Mar 2010 00:26:40 +0100
Message-Id: <1268609202-15581-4-git-send-email-arighi@develer.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1268609202-15581-1-git-send-email-arighi@develer.com>
References: <1268609202-15581-1-git-send-email-arighi@develer.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce page_cgroup flags to keep track of file cache pages.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrea Righi <arighi@develer.com>
---
 include/linux/page_cgroup.h |   22 +++++++++++++++++++++-
 1 files changed, 21 insertions(+), 1 deletions(-)

diff --git a/include/linux/page_cgroup.h b/include/linux/page_cgroup.h
index bf9a913..65247e4 100644
--- a/include/linux/page_cgroup.h
+++ b/include/linux/page_cgroup.h
@@ -40,7 +40,11 @@ enum {
 	PCG_USED, /* this object is in use. */
 	PCG_ACCT_LRU, /* page has been accounted for */
 	/* for cache-status accounting */
-	PCG_FILE_MAPPED,
+	PCG_FILE_MAPPED, /* page is accounted as file rss*/
+	PCG_FILE_DIRTY, /* page is dirty */
+	PCG_FILE_WRITEBACK, /* page is being written back to disk */
+	PCG_FILE_WRITEBACK_TEMP, /* page is used as temporary buffer for FUSE */
+	PCG_FILE_UNSTABLE_NFS, /* NFS page not yet committed to the server */
 };
 
 #define TESTPCGFLAG(uname, lname)			\
@@ -83,6 +87,22 @@ TESTPCGFLAG(FileMapped, FILE_MAPPED)
 SETPCGFLAG(FileMapped, FILE_MAPPED)
 CLEARPCGFLAG(FileMapped, FILE_MAPPED)
 
+TESTPCGFLAG(FileDirty, FILE_DIRTY)
+SETPCGFLAG(FileDirty, FILE_DIRTY)
+CLEARPCGFLAG(FileDirty, FILE_DIRTY)
+
+TESTPCGFLAG(FileWriteback, FILE_WRITEBACK)
+SETPCGFLAG(FileWriteback, FILE_WRITEBACK)
+CLEARPCGFLAG(FileWriteback, FILE_WRITEBACK)
+
+TESTPCGFLAG(FileWritebackTemp, FILE_WRITEBACK_TEMP)
+SETPCGFLAG(FileWritebackTemp, FILE_WRITEBACK_TEMP)
+CLEARPCGFLAG(FileWritebackTemp, FILE_WRITEBACK_TEMP)
+
+TESTPCGFLAG(FileUnstableNFS, FILE_UNSTABLE_NFS)
+SETPCGFLAG(FileUnstableNFS, FILE_UNSTABLE_NFS)
+CLEARPCGFLAG(FileUnstableNFS, FILE_UNSTABLE_NFS)
+
 static inline int page_cgroup_nid(struct page_cgroup *pc)
 {
 	return page_to_nid(pc->page);
-- 
1.6.3.3

