Return-Path: <linux-kernel-owner+w=401wt.eu-S1751113AbXBUEtw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751113AbXBUEtw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 23:49:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751116AbXBUEtw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 23:49:52 -0500
Received: from ns.suse.de ([195.135.220.2]:49951 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751113AbXBUEtv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 23:49:51 -0500
From: Nick Piggin <npiggin@suse.de>
To: Linux Memory Management <linux-mm@kvack.org>,
       Andrew Morton <akpm@osdl.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Message-Id: <20070221023706.6306.55204.sendpatchset@linux.site>
In-Reply-To: <20070221023656.6306.246.sendpatchset@linux.site>
References: <20070221023656.6306.246.sendpatchset@linux.site>
Subject: [patch 1/6] mm: debug check for the fault vs invalidate race
Date: Wed, 21 Feb 2007 05:49:47 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add a bugcheck for Andrea's pagefault vs invalidate race. This is triggerable
for both linear and nonlinear pages with a userspace test harness (using
direct IO and truncate, respectively).

Signed-off-by: Nick Piggin <npiggin@suse.de>

 mm/filemap.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6/mm/filemap.c
===================================================================
--- linux-2.6.orig/mm/filemap.c
+++ linux-2.6/mm/filemap.c
@@ -120,6 +120,8 @@ void __remove_from_page_cache(struct pag
 	page->mapping = NULL;
 	mapping->nrpages--;
 	__dec_zone_page_state(page, NR_FILE_PAGES);
+
+	BUG_ON(page_mapped(page));
 }
 
 void remove_from_page_cache(struct page *page)
