Return-Path: <linux-kernel-owner+w=401wt.eu-S1758841AbZFPVyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758841AbZFPVyT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 17:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753377AbZFPVyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 17:54:08 -0400
Received: from cmpxchg.org ([85.214.51.133]:53267 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753250AbZFPVyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 17:54:08 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrea Arcangeli <aarcange@redhat.com>, Izik Eidus <ieidus@redhat.com>,
       Rik van Riel <riel@redhat.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [patch 1/2] mm: make swap token dummies static inlines
Date: Tue, 16 Jun 2009 23:50:36 +0200
Message-Id: <1245189037-22961-1-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.6.3
In-Reply-To: <Pine.LNX.4.64.0906162152250.12770@sister.anvils>
References: <Pine.LNX.4.64.0906162152250.12770@sister.anvils>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make use of the compiler's typechecking on !CONFIG_SWAP as well.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 include/linux/swap.h |   20 ++++++++++++++++----
 1 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index d476aad..3c6e856 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -426,10 +426,22 @@ static inline swp_entry_t get_swap_page(void)
 }
 
 /* linux/mm/thrash.c */
-#define put_swap_token(x) do { } while(0)
-#define grab_swap_token()  do { } while(0)
-#define has_swap_token(x) 0
-#define disable_swap_token() do { } while(0)
+static inline void put_swap_token(struct mm_struct *mm)
+{
+}
+
+static inline void grab_swap_token(void)
+{
+}
+
+static inline int has_swap_token(struct mm_struct *mm)
+{
+	return 0;
+}
+
+static inline void disable_swap_token(struct mm_struct *mm)
+{
+}
 
 static inline int mem_cgroup_cache_charge_swapin(struct page *page,
 			struct mm_struct *mm, gfp_t mask, bool locked)
-- 
1.6.3

