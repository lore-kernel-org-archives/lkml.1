Return-Path: <linux-kernel-owner+w=401wt.eu-S1754815AbZBDBJJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815AbZBDBJJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 20:09:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751577AbZBDBI4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 20:08:56 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:62013 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508AbZBDBI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 20:08:56 -0500
X-IronPort-AV: E=Sophos;i="4.37,375,1231113600"; 
   d="scan'208";a="242370480"
From: Roland Dreier <rdreier@cisco.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Eli Cohen <eli@mellanox.co.il>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: FW: [PATCH] powerpc/mm: Export HPAGE_SHIFT
References: <20090203164930.GA10101@mtls03>
X-Message-Flag: Warning: May contain useful information
Date: Tue, 03 Feb 2009 17:08:54 -0800
In-Reply-To: <20090203164930.GA10101@mtls03> (Eli Cohen's message of "Tue, 3
	Feb 2009 18:49:30 +0200")
Message-ID: <ada8wonnh3t.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 04 Feb 2009 01:08:55.0135 (UTC) FILETIME=[266E46F0:01C98665]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Forwarding Eli's patch below, since PowerPC guys may have missed it.  I
guess the question for Ben et al is whether there is any issue with
exporting HPAGE_SHIFT for modules (can be EXPORT_SYMBOL_GPL if you feel
it's an internal detail).  It would probably make sense to roll this
change into the mlx4 change that Eli alludes to below and merge through
my tree (with ppc maintainer acks of course), rather than splitting this
patch out and introducing cross-tree dependencies (and also separating
the rationale for the change from the change itself).

Thanks,
  Roland


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


