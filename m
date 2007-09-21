Return-Path: <linux-kernel-owner+w=401wt.eu-S1765225AbXIUUyr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765225AbXIUUyr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 16:54:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762764AbXIUUpY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 16:45:24 -0400
Received: from ns.suse.de ([195.135.220.2]:50071 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761528AbXIUUpO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 16:45:14 -0400
From: Andi Kleen <ak@suse.de>
References: <200709211044.901175000@suse.de>
In-Reply-To: <200709211044.901175000@suse.de>
To: akpm@linux-foundation.org, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [30/45] i386: Remove local CPU logic in MTRR call to smp_call_function_single 
Message-Id: <20070921204512.CF9A614F09@wotan.suse.de>
Date: Fri, 21 Sep 2007 22:45:12 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: akpm@linux-foundation.org

smp_call_function_single handles the call to local CPU case correctly now,
no need to handle this in the caller

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andi Kleen <ak@suse.de>

---

 arch/i386/kernel/cpu/mtrr/main.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

Index: linux/arch/i386/kernel/cpu/mtrr/main.c
===================================================================
--- linux.orig/arch/i386/kernel/cpu/mtrr/main.c
+++ linux/arch/i386/kernel/cpu/mtrr/main.c
@@ -738,13 +738,7 @@ void mtrr_ap_init(void)
  */
 void mtrr_save_state(void)
 {
-	int cpu = get_cpu();
-
-	if (cpu == 0)
-		mtrr_save_fixed_ranges(NULL);
-	else
-		smp_call_function_single(0, mtrr_save_fixed_ranges, NULL, 1, 1);
-	put_cpu();
+	smp_call_function_single(0, mtrr_save_fixed_ranges, NULL, 1, 1);
 }
 
 static int __init mtrr_init_finialize(void)
