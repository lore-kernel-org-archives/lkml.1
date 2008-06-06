Return-Path: <linux-kernel-owner+w=401wt.eu-S932461AbYFFUas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932461AbYFFUas (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 16:30:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756330AbYFFUaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 16:30:25 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33117 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754571AbYFFUaY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 16:30:24 -0400
Message-Id: <20080606202859.230740877@redhat.com>
References: <20080606202838.390050172@redhat.com>
User-Agent: quilt/0.46-1
Date: Fri, 06 Jun 2008 16:28:50 -0400
From: Rik van Riel <riel@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
From: Rik van Riel <riel@redhat.com>
Subject: [PATCH -mm 12/25] pageflag helpers for configed-out flags
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

