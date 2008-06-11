Return-Path: <linux-kernel-owner+w=401wt.eu-S1758382AbYFKSyO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758382AbYFKSyO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 14:54:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758187AbYFKSrr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 14:47:47 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47930 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758171AbYFKSrp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 14:47:45 -0400
Message-Id: <20080611184339.493423475@redhat.com>
References: <20080611184214.605110868@redhat.com>
User-Agent: quilt/0.46-1
Date: Wed, 11 Jun 2008 14:42:25 -0400
From: Rik van Riel <riel@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: [PATCH -mm 11/24] pageflag helpers for configed-out flags
Content-Disposition: inline; filename=vmscan-pageflag-helpers-for-configed-out-flags.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lee Schermerhorn <lee.schermerhorn@hp.com>

Define proper false/noop inline functions for noreclaim page
flags when !defined(CONFIG_NORECLAIM_LRU)

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Rik van Riel <riel@redhat.com>

---
 include/linux/page-flags.h |   12 ++++++++++++
 1 file changed, 12 insertions(+)

Index: linux-2.6.26-rc5-mm2/include/linux/page-flags.h
===================================================================
--- linux-2.6.26-rc5-mm2.orig/include/linux/page-flags.h	2008-06-10 13:34:48.000000000 -0400
+++ linux-2.6.26-rc5-mm2/include/linux/page-flags.h	2008-06-10 13:44:55.000000000 -0400
@@ -162,6 +162,18 @@ static inline int Page##uname(struct pag
 #define TESTSCFLAG(uname, lname)					\
 	TESTSETFLAG(uname, lname) TESTCLEARFLAG(uname, lname)
 
+#define SETPAGEFLAG_NOOP(uname)						\
+static inline void SetPage##uname(struct page *page) {  }
+
+#define CLEARPAGEFLAG_NOOP(uname)					\
+static inline void ClearPage##uname(struct page *page) {  }
+
+#define __CLEARPAGEFLAG_NOOP(uname)					\
+static inline void __ClearPage##uname(struct page *page) {  }
+
+#define TESTCLEARFLAG_FALSE(uname)					\
+static inline int TestClearPage##uname(struct page *page) { return 0; }
+
 struct page;	/* forward declaration */
 
 PAGEFLAG(Locked, locked) TESTSCFLAG(Locked, locked)

-- 
All Rights Reversed

