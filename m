Return-Path: <linux-kernel-owner+w=401wt.eu-S1755364AbXFRHrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364AbXFRHrX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 03:47:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754956AbXFRHrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 03:47:16 -0400
Received: from nz-out-0506.google.com ([64.233.162.236]:34933 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbXFRHrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 03:47:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:subject:date:message-id;
        b=js1m3sY9lRonR65adI3FqgJFr//Bf12v9N4oSeLEjOW4NBSTUPWByzkoA/4k4082YdTGJISYWA/Y5gn10FSuJRtIsjdL+1Znn/LZltgyIgzxyg2OUenAOoxFc6vd4OXoFaEkDImit9vg4rR6ShmO5eyupwriCra+IXY8Z9LkLeI=
From: Denis Cheng <crquan@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: the memset operation on a automatic array variable can be removed by
	data Initialization
Date: Mon, 18 Jun 2007 00:47:14 -0700 (PDT)
Message-ID: <46763882.16be600a.377c.ffff8f6f@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-Off-By: Denis Cheng <crquan@gmail.com>

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
