Return-Path: <linux-kernel-owner+w=401wt.eu-S1753596AbYJaVEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596AbYJaVEg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 17:04:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753346AbYJaVEV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 17:04:21 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43460 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753310AbYJaVEU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 17:04:20 -0400
Date: Fri, 31 Oct 2008 17:03:55 -0400
From: Chuck Ebbert <cebbert@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, linux-kernel@vger.kernel.org
Subject: [patch] x86: Kill bogus MTRR warning when running under vmware
Message-ID: <20081031170355.5368be60@redhat.com>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86: Kill bogus MTRR warning when running under vmware

The warning is suppressed when running under KVM, but VMware
guests also have empty MTRRs.

Fixes:
https://bugzilla.redhat.com/show_bug.cgi?id=468845

Signed-off-by: Chuck Ebbert <cebbert@redhat.com>

Index: linux-2.6.27.noarch/arch/x86/kernel/cpu/mtrr/main.c
===================================================================
--- linux-2.6.27.noarch.orig/arch/x86/kernel/cpu/mtrr/main.c
+++ linux-2.6.27.noarch/arch/x86/kernel/cpu/mtrr/main.c
@@ -1495,11 +1495,8 @@ int __init mtrr_trim_uncached_memory(uns
 	}
 
 	/* kvm/qemu doesn't have mtrr set right, don't trim them all */
-	if (!highest_pfn) {
-		WARN(!kvm_para_available(), KERN_WARNING
-				"WARNING: strange, CPU MTRRs all blank?\n");
+	if (!highest_pfn)
 		return 0;
-	}
 
 	/* check entries number */
 	memset(num, 0, sizeof(num));
