Return-Path: <linux-kernel-owner+w=401wt.eu-S934862AbYBHUDs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934862AbYBHUDs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 15:03:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758273AbYBHUDk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 15:03:40 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:56546 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756369AbYBHUDj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 15:03:39 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: mpm@selenic.com, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] stub out is_swap_pte for !MMU
Date: Fri,  8 Feb 2008 15:02:39 -0500
Message-Id: <1202500959-2727-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With commit 698dd4ba6b12e34e1e432c944c01478c0b2cd773, swap_pte() was moved
into view of both MMU and !MMU, but uses functions only provided by MMU.
Here we stub out the function for !MMU ports.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 include/linux/swapops.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/linux/swapops.h b/include/linux/swapops.h
index 7bf2d14..e6b54f7 100644
--- a/include/linux/swapops.h
+++ b/include/linux/swapops.h
@@ -45,7 +45,11 @@ static inline pgoff_t swp_offset(swp_entry_t entry)
 /* check whether a pte points to a swap entry */
 static inline int is_swap_pte(pte_t pte)
 {
+#ifdef CONFIG_MMU
 	return !pte_none(pte) && !pte_present(pte) && !pte_file(pte);
+#else
+	return 0;
+#endif
 }
 
 /*
-- 
1.5.4

