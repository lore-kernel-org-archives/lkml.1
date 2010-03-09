Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755767Ab0CIXBI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 18:01:08 -0500
Received: from trinity.develer.com ([83.149.158.210]:52838 "EHLO
	trinity.develer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755551Ab0CIXBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 18:01:02 -0500
From: Andrea Righi <arighi@develer.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
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
Date: Wed, 10 Mar 2010 00:00:34 +0100
Message-Id: <1268175636-4673-4-git-send-email-arighi@develer.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1268175636-4673-1-git-send-email-arighi@develer.com>
References: <1268175636-4673-1-git-send-email-arighi@develer.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce page_cgroup flags to keep track of file cache pages.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrea Righi <arighi@develer.com>
---
 include/linux/page_cgroup.h |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/include/linux/page_cgroup.h b/include/linux/page_cgroup.h
index 0d2f92c..4e09c8c 100644
--- a/include/linux/page_cgroup.h
+++ b/include/linux/page_cgroup.h
@@ -39,6 +39,11 @@ enum {
 	PCG_CACHE, /* charged as cache */
 	PCG_USED, /* this object is in use. */
 	PCG_ACCT_LRU, /* page has been accounted for */
+	PCG_ACCT_FILE_MAPPED, /* page is accounted as file rss*/
+	PCG_ACCT_DIRTY, /* page is dirty */
+	PCG_ACCT_WRITEBACK, /* page is being written back to disk */
+	PCG_ACCT_WRITEBACK_TEMP, /* page is used as temporary buffer for FUSE */
+	PCG_ACCT_UNSTABLE_NFS, /* NFS page not yet committed to the server */
 };
 
 #define TESTPCGFLAG(uname, lname)			\
@@ -73,6 +78,27 @@ CLEARPCGFLAG(AcctLRU, ACCT_LRU)
 TESTPCGFLAG(AcctLRU, ACCT_LRU)
 TESTCLEARPCGFLAG(AcctLRU, ACCT_LRU)
 
+/* File cache and dirty memory flags */
+TESTPCGFLAG(FileMapped, ACCT_FILE_MAPPED)
+SETPCGFLAG(FileMapped, ACCT_FILE_MAPPED)
+CLEARPCGFLAG(FileMapped, ACCT_FILE_MAPPED)
+
+TESTPCGFLAG(Dirty, ACCT_DIRTY)
+SETPCGFLAG(Dirty, ACCT_DIRTY)
+CLEARPCGFLAG(Dirty, ACCT_DIRTY)
+
+TESTPCGFLAG(Writeback, ACCT_WRITEBACK)
+SETPCGFLAG(Writeback, ACCT_WRITEBACK)
+CLEARPCGFLAG(Writeback, ACCT_WRITEBACK)
+
+TESTPCGFLAG(WritebackTemp, ACCT_WRITEBACK_TEMP)
+SETPCGFLAG(WritebackTemp, ACCT_WRITEBACK_TEMP)
+CLEARPCGFLAG(WritebackTemp, ACCT_WRITEBACK_TEMP)
+
+TESTPCGFLAG(UnstableNFS, ACCT_UNSTABLE_NFS)
+SETPCGFLAG(UnstableNFS, ACCT_UNSTABLE_NFS)
+CLEARPCGFLAG(UnstableNFS, ACCT_UNSTABLE_NFS)
+
 static inline int page_cgroup_nid(struct page_cgroup *pc)
 {
 	return page_to_nid(pc->page);
-- 
1.6.3.3

