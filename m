Return-Path: <linux-kernel-owner+w=401wt.eu-S966244AbZLHVVv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966244AbZLHVVv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 16:21:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966270AbZLHVVl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 16:21:41 -0500
Received: from one.firstfloor.org ([213.235.205.2]:49524 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966248AbZLHVQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 16:16:19 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <200912081016.198135742@firstfloor.org>
In-Reply-To: <200912081016.198135742@firstfloor.org>
To: fengguang.wu@intel.com, fengguang.wu@intel.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH] [9/31] HWPOISON: comment the possible set_page_dirty() race
Message-Id: <20091208211625.5B805B151F@basil.firstfloor.org>
Date: Tue,  8 Dec 2009 22:16:25 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Wu Fengguang <fengguang.wu@intel.com>

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 mm/memory-failure.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux/mm/memory-failure.c
===================================================================
--- linux.orig/mm/memory-failure.c
+++ linux/mm/memory-failure.c
@@ -689,6 +689,8 @@ static int hwpoison_user_mappings(struct
 	/*
 	 * Propagate the dirty bit from PTEs to struct page first, because we
 	 * need this to decide if we should kill or just drop the page.
+	 * XXX: the dirty test could be racy: set_page_dirty() may not always
+	 * be called inside page lock (it's recommended but not enforced).
 	 */
 	mapping = page_mapping(p);
 	if (!PageDirty(p) && mapping && mapping_cap_writeback_dirty(mapping)) {
