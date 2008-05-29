Return-Path: <linux-kernel-owner+w=401wt.eu-S1754508AbYE2UZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508AbYE2UZn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 16:25:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754900AbYE2UZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 16:25:07 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42642 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752388AbYE2UZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 16:25:05 -0400
Message-Id: <20080529202312.803249972@redhat.com>
References: <20080529202246.322317334@redhat.com>
User-Agent: quilt/0.46-1
Date: Thu, 29 May 2008 16:22:58 -0400
From: Rik van Riel <riel@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: [PATCH -mm 12/12] pageflag helpers for configed-out flags
Content-Disposition: inline; filename=pageflag-helpers.patch
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

Index: linux-2.6.26-rc2-mm1/include/linux/page-flags.h
===================================================================
--- linux-2.6.26-rc2-mm1.orig/include/linux/page-flags.h	2008-05-28 09:40:59.000000000 -0400
+++ linux-2.6.26-rc2-mm1/include/linux/page-flags.h	2008-05-28 09:42:35.000000000 -0400
@@ -147,6 +147,18 @@ static inline int Page##uname(struct pag
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

