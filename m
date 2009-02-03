Return-Path: <linux-kernel-owner+w=401wt.eu-S1755929AbZBCQza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929AbZBCQza (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 11:55:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752485AbZBCQzO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 11:55:14 -0500
Received: from mail.mellanox.co.il ([194.90.237.43]:58848 "EHLO mellanox.co.il"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755164AbZBCQzM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 11:55:12 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Feb 2009 11:55:11 EST
Date: Tue, 3 Feb 2009 18:49:30 +0200
From: Eli Cohen <eli@mellanox.co.il>
To: linux-kernel@vger.kernel.org, Roland Dreier <rdreier@cisco.com>
Subject: [PATCH] powerpc/mm: Export HPAGE_SHIFT
Message-ID: <20090203164930.GA10101@mtls03>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-OriginalArrivalTime: 03 Feb 2009 16:48:27.0842 (UTC) FILETIME=[3CC4FA20:01C9861F]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-5.500.1027-16442.000
X-TM-AS-Result: No--5.470300-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drivers may want to take advantage of the large pages used for memory obtained
from hugetlbfs. One example is mlx4_ib which can use much less MTT entries (in
the order of HPAGE_SIZE / PAGE_SIZE) when registering such memory, thus scale
significantly better when registering larger memory regions. Other drivers
could also benefit from this.

Signed-off-by: Eli Cohen <eli@mellanox.co.il>
---
 arch/powerpc/mm/hash_utils_64.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/mm/hash_utils_64.c b/arch/powerpc/mm/hash_utils_64.c
index 8d5b475..6cff8c7 100644
--- a/arch/powerpc/mm/hash_utils_64.c
+++ b/arch/powerpc/mm/hash_utils_64.c
@@ -104,6 +104,7 @@ int mmu_highuser_ssize = MMU_SEGSIZE_256M;
 u16 mmu_slb_size = 64;
 #ifdef CONFIG_HUGETLB_PAGE
 unsigned int HPAGE_SHIFT;
+EXPORT_SYMBOL(HPAGE_SHIFT);
 #endif
 #ifdef CONFIG_PPC_64K_PAGES
 int mmu_ci_restrictions;
-- 
1.6.1

