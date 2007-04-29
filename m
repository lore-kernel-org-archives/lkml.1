Return-Path: <linux-kernel-owner+w=401wt.eu-S1161599AbXD2Xt1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161599AbXD2Xt1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 19:49:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161600AbXD2XrE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 19:47:04 -0400
Received: from mx2.suse.de ([195.135.220.15]:38476 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161599AbXD2Xq0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 19:46:26 -0400
From: Andi Kleen <ak@suse.de>
References: <20070430146.588463000@suse.de>
In-Reply-To: <20070430146.588463000@suse.de>
To: Joachim Deguara <joachim.deguara@amd.com>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [16/26] i386: Enable machine check for AMD Family 10
Message-Id: <20070429234625.C1DD6150F2@wotan.suse.de>
Date: Mon, 30 Apr 2007 01:46:25 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Joachim Deguara <joachim.deguara@amd.com>

We don't check for any specific family because the code is generic
to all systems supporting the Intel machine check architecture.
Just check the CPUID bit instead

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/i386/kernel/cpu/mcheck/mce.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/arch/i386/kernel/cpu/mcheck/mce.c
===================================================================
--- linux.orig/arch/i386/kernel/cpu/mcheck/mce.c
+++ linux/arch/i386/kernel/cpu/mcheck/mce.c
@@ -38,7 +38,7 @@ void mcheck_init(struct cpuinfo_x86 *c)
 
 	switch (c->x86_vendor) {
 		case X86_VENDOR_AMD:
-			if (c->x86==6 || c->x86==15)
+			if (boot_cpu_has(X86_FEATURE_MCA))
 				amd_mcheck_init(c);
 			break;
 
