Return-Path: <linux-kernel-owner+w=401wt.eu-S1756909AbZCENLv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756909AbZCENLv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 08:11:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755405AbZCENIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 08:08:46 -0500
Received: from smtp-68.nebula.fi ([83.145.220.68]:39747 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754844AbZCENIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 08:08:40 -0500
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: mingo@elte.hu
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 09/17] x86: add table start and end sanity checks to 32-bit init_memory_mapping()
Date: Thu,  5 Mar 2009 14:55:00 +0200
Message-Id: <1236257708-27269-9-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

This patch adds a sanity check to the 32-bit version of init_memory_mapping()
to reduce the diff to the 64-bit version.

Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 arch/x86/mm/init_32.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 00c1d85..0a3707f 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -1060,7 +1060,7 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 
 	__flush_tlb_all();
 
-	if (!after_bootmem)
+	if (!after_bootmem && table_end > table_start)
 		reserve_early(table_start << PAGE_SHIFT,
 				 table_end << PAGE_SHIFT, "PGTABLE");
 
-- 
1.5.4.3

