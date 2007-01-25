Return-Path: <linux-kernel-owner+w=401wt.eu-S1030674AbXAZAUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030674AbXAZAUq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 19:20:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030671AbXAZAU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 19:20:27 -0500
Received: from calculon.skynet.ie ([193.1.99.88]:54157 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030674AbXAZAUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 19:20:23 -0500
From: Mel Gorman <mel@csn.ul.ie>
To: linux-mm@kvack.org
Cc: Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org
Message-Id: <20070125234718.28809.13010.sendpatchset@skynet.skynet.ie>
In-Reply-To: <20070125234458.28809.5412.sendpatchset@skynet.skynet.ie>
References: <20070125234458.28809.5412.sendpatchset@skynet.skynet.ie>
Subject: [PATCH 7/8] ia64 - Specify amount of kernel memory at boot time
Date: Thu, 25 Jan 2007 23:47:18 +0000 (GMT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This patch adds the kernelcore= parameter for ia64.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---

 efi.c |    3 +++
 1 files changed, 3 insertions(+)

diff -rup -X /usr/src/patchset-0.6/bin//dontdiff linux-2.6.20-rc4-mm1-006_x8664_set_kernelcore/arch/ia64/kernel/efi.c linux-2.6.20-rc4-mm1-007_ia64_set_kernelcore/arch/ia64/kernel/efi.c
--- linux-2.6.20-rc4-mm1-006_x8664_set_kernelcore/arch/ia64/kernel/efi.c	2007-01-07 05:45:51.000000000 +0000
+++ linux-2.6.20-rc4-mm1-007_ia64_set_kernelcore/arch/ia64/kernel/efi.c	2007-01-25 17:42:15.000000000 +0000
@@ -27,6 +27,7 @@
 #include <linux/time.h>
 #include <linux/efi.h>
 #include <linux/kexec.h>
+#include <linux/mm.h>
 
 #include <asm/io.h>
 #include <asm/kregs.h>
@@ -422,6 +423,8 @@ efi_init (void)
 			mem_limit = memparse(cp + 4, &cp);
 		} else if (memcmp(cp, "max_addr=", 9) == 0) {
 			max_addr = GRANULEROUNDDOWN(memparse(cp + 9, &cp));
+		} else if (memcmp(cp, "kernelcore=",11) == 0) {
+			cmdline_parse_kernelcore(cp+11);
 		} else if (memcmp(cp, "min_addr=", 9) == 0) {
 			min_addr = GRANULEROUNDDOWN(memparse(cp + 9, &cp));
 		} else {
