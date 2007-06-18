Return-Path: <linux-kernel-owner+w=401wt.eu-S1761957AbXFRKMr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761957AbXFRKMr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 06:12:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762654AbXFRKFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 06:05:20 -0400
Received: from qb-out-0506.google.com ([72.14.204.239]:25818 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762640AbXFRKFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 06:05:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:date:message-id;
        b=d9PSKMSmBDrSxGrfsD5CZP9xbAHx4mzyu27vquC9NvZeGrk0uyppJxCK05/ooq+0e/AXMoLnJpRDUkRnYnxwMeIY9Ae3c4zp3w4OeiYHWkdLOLY7km9MeoYzXRRn/iJNEL2rEUJcC2x7diAa0ex0MOR1QyixIDU570eRZxuJ0iY=
Subject: [PATCH] trivial: the memset operation on a automatic array
	variable should be optimized out by data initialization
From: Denis Cheng <crquan@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org
Date: Mon, 18 Jun 2007 03:05:15 -0700 (PDT)
Message-ID: <467658db.0f98600a.5a55.ffffdd79@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Denis Cheng <crquan@gmail.com>

the explicit memset call could be optimized out by data initialization,
thus all the fill working can be done by the compiler implicitly.

Signed-off-by: Denis Cheng <crquan@gmail.com>

---
Is there some comments on this?

--- arch/x86_64/mm/init.c.orig	2007-06-07 10:08:04.000000000 +0800
+++ arch/x86_64/mm/init.c	2007-06-18 14:43:15.000000000 +0800
@@ -406,8 +406,7 @@ void __cpuinit zap_low_mappings(int cpu)
 #ifndef CONFIG_NUMA
 void __init paging_init(void)
 {
-	unsigned long max_zone_pfns[MAX_NR_ZONES];
-	memset(max_zone_pfns, 0, sizeof(max_zone_pfns));
+	unsigned long max_zone_pfns[MAX_NR_ZONES] = { 0, };
 	max_zone_pfns[ZONE_DMA] = MAX_DMA_PFN;
 	max_zone_pfns[ZONE_DMA32] = MAX_DMA32_PFN;
 	max_zone_pfns[ZONE_NORMAL] = end_pfn;
