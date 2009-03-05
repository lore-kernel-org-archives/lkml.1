Return-Path: <linux-kernel-owner+w=401wt.eu-S1756299AbZCENJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756299AbZCENJd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 08:09:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754813AbZCENIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 08:08:39 -0500
Received: from smtp-68.nebula.fi ([83.145.220.68]:39598 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855AbZCENIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 08:08:37 -0500
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: mingo@elte.hu
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 06/17] x86: remove unnecessary save_mr() sanity check
Date: Thu,  5 Mar 2009 14:54:57 +0200
Message-Id: <1236257708-27269-6-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

The save_mr() function already checks that start_pfn is less than end_pfn so we
can remove the unnecessary check which reduces the diff between the 32-bit and
the 64-bit versions of init_memory_mapping().

Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 arch/x86/mm/init_32.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index eb98cb9..559715b 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -1008,8 +1008,7 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 	/* tail is not big page (2M) alignment */
 	start_pfn = pos>>PAGE_SHIFT;
 	end_pfn = end>>PAGE_SHIFT;
-	if (start_pfn < end_pfn)
-		nr_range = save_mr(mr, nr_range, start_pfn, end_pfn, 0);
+	nr_range = save_mr(mr, nr_range, start_pfn, end_pfn, 0);
 
 	/* try to merge same page size and continuous */
 	for (i = 0; nr_range > 1 && i < nr_range - 1; i++) {
-- 
1.5.4.3

