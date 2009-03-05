Return-Path: <linux-kernel-owner+w=401wt.eu-S1756012AbZCENKw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012AbZCENKw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 08:10:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755462AbZCENIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 08:08:43 -0500
Received: from smtp-68.nebula.fi ([83.145.220.68]:39720 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753827AbZCENIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 08:08:39 -0500
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: mingo@elte.hu
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 13/17] x86: add stub init_gbpages() for 32-bit init_memory_mapping()
Date: Thu,  5 Mar 2009 14:55:04 +0200
Message-Id: <1236257708-27269-13-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

This patch adds an empty static inline init_gbpages() for the 32-bit version of
init_memory_mapping() making both versions identical.

Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 arch/x86/mm/init_32.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index f59e9b8..cd3c24b 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -922,6 +922,10 @@ static int save_mr(struct map_range *mr, int nr_range,
 	return nr_range;
 }
 
+static inline void init_gbpages(void)
+{
+}
+
 /*
  * Setup the direct mapping of the physical memory at PAGE_OFFSET.
  * This runs before bootmem is initialized and gets pages directly from
@@ -941,6 +945,9 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 
 	printk(KERN_INFO "init_memory_mapping: %016lx-%016lx\n", start, end);
 
+	if (!after_bootmem)
+		init_gbpages();
+
 #ifdef CONFIG_DEBUG_PAGEALLOC
 	/*
 	 * For CONFIG_DEBUG_PAGEALLOC, identity mapping will use small pages.
-- 
1.5.4.3

