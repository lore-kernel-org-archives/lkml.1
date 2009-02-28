Return-Path: <linux-kernel-owner+w=401wt.eu-S1762944AbZB1CGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762944AbZB1CGj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 21:06:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761054AbZB1B7n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 20:59:43 -0500
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:59180
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757419AbZB1B7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 20:59:33 -0500
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Mark McLoughlin <markmc@redhat.com>
Subject: [PATCH] xen mtrr: Use specific cpu_has_foo macros instead of generic cpu_has()
Date: Fri, 27 Feb 2009 17:59:21 -0800
Message-Id: <1235786365-17744-16-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1235786365-17744-1-git-send-email-jeremy@goop.org>
References: <1235786365-17744-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark McLoughlin <markmc@redhat.com>

Signed-off-by: Mark McLoughlin <markmc@redhat.com>
---
 arch/x86/kernel/cpu/mtrr/xen.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/xen.c b/arch/x86/kernel/cpu/mtrr/xen.c
index db3ef39..e03532c 100644
--- a/arch/x86/kernel/cpu/mtrr/xen.c
+++ b/arch/x86/kernel/cpu/mtrr/xen.c
@@ -44,15 +44,13 @@ static int __init xen_num_var_ranges(void)
 
 void __init xen_init_mtrr(void)
 {
-	struct cpuinfo_x86 *c = &boot_cpu_data;
-
 	if (!xen_initial_domain())
 		return;
 
-	if ((!cpu_has(c, X86_FEATURE_MTRR)) &&
-	    (!cpu_has(c, X86_FEATURE_K6_MTRR)) &&
-	    (!cpu_has(c, X86_FEATURE_CYRIX_ARR)) &&
-	    (!cpu_has(c, X86_FEATURE_CENTAUR_MCR)))
+	if (!cpu_has_mtrr &&
+	    !cpu_has_k6_mtrr &&
+	    !cpu_has_cyrix_arr &&
+	    !cpu_has_centaur_mcr)
 		return;
 
 	mtrr_if = &xen_mtrr_ops;
-- 
1.6.0.6

