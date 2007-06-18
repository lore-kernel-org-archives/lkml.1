Return-Path: <linux-kernel-owner+w=401wt.eu-S1761435AbXFRJsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761435AbXFRJsU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 05:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761364AbXFRJsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 05:48:05 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:28975 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761320AbXFRJsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 05:48:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:subject:date:message-id;
        b=Ok11usrLRl2yCMtfL/3FyamTEwsMOrDIv1E/GuIxqCJHYYj4xGwGVb12UG+wTmCWq4Ls4RrVF+qRHPJXKqL123vohqeicbc79sRRWQjoLOykwOxULqzRMVeVF1RCgY8xBpUbjELuTZqxa5/F5m+nJN2l6xR5USPQcc/A+yQxslI=
From: Denis Cheng <crquan@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] the memset operation on a automatic array variable
	should be optimized out by data initialization
Date: Mon, 18 Jun 2007 02:48:02 -0700 (PDT)
Message-ID: <467654d2.14da600a.3067.ffffbc11@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Is there some comments on this?

Signed-Off-By: Denis Cheng <crquan@gmail.com>

--

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
