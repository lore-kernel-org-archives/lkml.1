Return-Path: <linux-kernel-owner+w=401wt.eu-S1764470AbXJZQhr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764470AbXJZQhr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 12:37:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757936AbXJZQge
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 12:36:34 -0400
Received: from waste.org ([66.93.16.53]:56554 "EHLO cinder.waste.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754495AbXJZQgb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 12:36:31 -0400
From: Matt Mackall <mpm@selenic.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
X-PatchBomber: http://selenic.com/scripts/mailpatches
Cc: Dave Hansen <haveblue@us.ibm.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       David Rientjes <rientjes@google.com>,
       Fengguang Wu <wfg@mail.ustc.edu.cn>
In-Reply-To: <1.430487409@selenic.com>
Message-Id: <4.430487409@selenic.com>
Subject: [PATCH 3/12] maps4: move is_swap_pte
Date: Fri, 26 Oct 2007 11:36:29 -0500
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Move is_swap_pte helper function to swapops.h for use by pagemap code

Signed-off-by: Matt Mackall <mpm@selenic.com>

Index: l/include/linux/swapops.h
===================================================================
--- l.orig/include/linux/swapops.h	2007-10-09 17:36:25.000000000 -0500
+++ l/include/linux/swapops.h	2007-10-10 11:46:34.000000000 -0500
@@ -42,6 +42,12 @@ static inline pgoff_t swp_offset(swp_ent
 	return entry.val & SWP_OFFSET_MASK(entry);
 }
 
+/* check whether a pte points to a swap entry */
+static inline int is_swap_pte(pte_t pte)
+{
+	return !pte_none(pte) && !pte_present(pte) && !pte_file(pte);
+}
+
 /*
  * Convert the arch-dependent pte representation of a swp_entry_t into an
  * arch-independent swp_entry_t.
Index: l/mm/migrate.c
===================================================================
--- l.orig/mm/migrate.c	2007-10-09 17:37:59.000000000 -0500
+++ l/mm/migrate.c	2007-10-10 11:46:34.000000000 -0500
@@ -114,11 +114,6 @@ int putback_lru_pages(struct list_head *
 	return count;
 }
 
-static inline int is_swap_pte(pte_t pte)
-{
-	return !pte_none(pte) && !pte_present(pte) && !pte_file(pte);
-}
-
 /*
  * Restore a potential migration pte to a working pte entry
  */
