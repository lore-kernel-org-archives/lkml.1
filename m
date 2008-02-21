Return-Path: <linux-kernel-owner+w=401wt.eu-S1765715AbYBUQNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765715AbYBUQNU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 11:13:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755039AbYBUQNE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 11:13:04 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49052 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758893AbYBUQND (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 11:13:03 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] MM: Fix macro argument substitution in PageHead() and
	PageTail()
To: torvalds@osdl.org, akpm@linux-foundation.org, clameter@sgi.com
Cc: linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Thu, 21 Feb 2008 16:12:45 +0000
Message-ID: <20080221161245.12991.32410.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>

Fix macro argument substitution in PageHead() and PageTail() - 'page' should
have brackets surrounding it (commit 6d7779538f765963ced45a3fa4bed7ba8d2c277d).

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/linux/page-flags.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index bbad43f..b5b30f1 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -266,7 +266,7 @@ static inline void SetPageUptodate(struct page *page)
 
 #define PG_head_tail_mask ((1L << PG_compound) | (1L << PG_reclaim))
 
-#define PageTail(page)	((page->flags & PG_head_tail_mask) \
+#define PageTail(page)	(((page)->flags & PG_head_tail_mask)	\
 				== PG_head_tail_mask)
 
 static inline void __SetPageTail(struct page *page)
@@ -279,7 +279,7 @@ static inline void __ClearPageTail(struct page *page)
 	page->flags &= ~PG_head_tail_mask;
 }
 
-#define PageHead(page)	((page->flags & PG_head_tail_mask) \
+#define PageHead(page)	(((page)->flags & PG_head_tail_mask)	\
 				== (1L << PG_compound))
 #define __SetPageHead(page)	__SetPageCompound(page)
 #define __ClearPageHead(page)	__ClearPageCompound(page)

