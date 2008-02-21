Return-Path: <linux-kernel-owner+w=401wt.eu-S934560AbYBUQDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934560AbYBUQDe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 11:03:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933288AbYBUP7V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 10:59:21 -0500
Received: from mx1.redhat.com ([66.187.233.31]:33465 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933737AbYBUP7T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 10:59:19 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] NOMMU: is_vmalloc_addr() won't compile if !MMU
To: torvalds@osdl.org, akpm@linux-foundation.org, clameter@sgi.com
Cc: linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Thu, 21 Feb 2008 15:58:36 +0000
Message-ID: <20080221155836.4591.91128.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>

Make is_vmalloc_addr() contingent on CONFIG_MMU=y, as it won't compile in !MMU
mode (commit 9e2779fa281cfda13ac060753d674bbcaa23367e).

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/linux/mm.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)


diff --git a/include/linux/mm.h b/include/linux/mm.h
index 26c7124..f6f649a 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -235,6 +235,7 @@ static inline int get_page_unless_zero(struct page *page)
 struct page *vmalloc_to_page(const void *addr);
 unsigned long vmalloc_to_pfn(const void *addr);
 
+#ifdef CONFIG_MMU
 /* Determine if an address is within the vmalloc range */
 static inline int is_vmalloc_addr(const void *x)
 {
@@ -242,6 +243,7 @@ static inline int is_vmalloc_addr(const void *x)
 
 	return addr >= VMALLOC_START && addr < VMALLOC_END;
 }
+#endif
 
 static inline struct page *compound_head(struct page *page)
 {

