Return-Path: <linux-kernel-owner+w=401wt.eu-S1760948AbXFRHnx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760948AbXFRHnx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 03:43:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756450AbXFRHnq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 03:43:46 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:2837 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756129AbXFRHnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 03:43:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:message-id;
        b=UHHHmkVV79dltcyirXQf6C7aopIPK8v+PEo42f9dAYk41wK+t0VOIy35cT2fhXEtDTgcLIQp4rbwAfKzfS1p+rxjVoEuC1drGNGDMId9vxOUVapmMo9kwP3Eyr8u94AiF2FffJjcWplCSy2eRgvKO4K3FzflRmOFJesCIfLS1n4=
From: Denis Cheng <crquan@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: the memset operation on a automatic array variable can be removed by
	data Initialization
Date: Mon, 18 Jun 2007 00:43:44 -0700 (PDT)
Message-ID: <467637b0.16be600a.377c.ffff8c04@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-Off-By: Denis Cheng <crquan@gmail.com>

--- arch/x86_64/mm/init.c	2007-06-07 10:08:04.000000000 +0800
+++ /tmp/init.c	2007-06-18 14:43:15.000000000 +0800
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
