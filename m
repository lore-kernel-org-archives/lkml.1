Return-Path: <linux-kernel-owner+w=401wt.eu-S1030670AbXAZAUY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030670AbXAZAUY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 19:20:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030675AbXAZAUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 19:20:23 -0500
Received: from calculon.skynet.ie ([193.1.99.88]:54161 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030670AbXAZAUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 19:20:23 -0500
X-Greylist: delayed 2122 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Jan 2007 19:20:23 EST
From: Mel Gorman <mel@csn.ul.ie>
To: linux-mm@kvack.org
Cc: Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org
Message-Id: <20070125234638.28809.50391.sendpatchset@skynet.skynet.ie>
In-Reply-To: <20070125234458.28809.5412.sendpatchset@skynet.skynet.ie>
References: <20070125234458.28809.5412.sendpatchset@skynet.skynet.ie>
Subject: [PATCH 5/8] ppc and powerpc - Specify amount of kernel memory at boot time
Date: Thu, 25 Jan 2007 23:46:38 +0000 (GMT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This patch adds the kernelcore= parameter for ppc and powerpc.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---

 powerpc/kernel/prom.c |    1 +
 ppc/mm/init.c         |    2 ++
 2 files changed, 3 insertions(+)

diff -rup -X /usr/src/patchset-0.6/bin//dontdiff linux-2.6.20-rc4-mm1-004_x86_set_kernelcore/arch/powerpc/kernel/prom.c linux-2.6.20-rc4-mm1-005_ppc64_set_kernelcore/arch/powerpc/kernel/prom.c
--- linux-2.6.20-rc4-mm1-004_x86_set_kernelcore/arch/powerpc/kernel/prom.c	2007-01-07 05:45:51.000000000 +0000
+++ linux-2.6.20-rc4-mm1-005_ppc64_set_kernelcore/arch/powerpc/kernel/prom.c	2007-01-25 17:38:17.000000000 +0000
@@ -431,6 +431,7 @@ static int __init early_parse_mem(char *
 	return 0;
 }
 early_param("mem", early_parse_mem);
+early_param("kernelcore", cmdline_parse_kernelcore);
 
 /*
  * The device tree may be allocated below our memory limit, or inside the
diff -rup -X /usr/src/patchset-0.6/bin//dontdiff linux-2.6.20-rc4-mm1-004_x86_set_kernelcore/arch/ppc/mm/init.c linux-2.6.20-rc4-mm1-005_ppc64_set_kernelcore/arch/ppc/mm/init.c
--- linux-2.6.20-rc4-mm1-004_x86_set_kernelcore/arch/ppc/mm/init.c	2007-01-07 05:45:51.000000000 +0000
+++ linux-2.6.20-rc4-mm1-005_ppc64_set_kernelcore/arch/ppc/mm/init.c	2007-01-25 17:38:17.000000000 +0000
@@ -214,6 +214,8 @@ void MMU_setup(void)
 	}
 }
 
+early_param("kernelcore", cmdline_parse_kernelcore);
+
 /*
  * MMU_init sets up the basic memory mappings for the kernel,
  * including both RAM and possibly some I/O regions,
