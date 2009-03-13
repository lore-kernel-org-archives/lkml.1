Return-Path: <linux-kernel-owner+w=401wt.eu-S1760958AbZCMRGh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760958AbZCMRGh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 13:06:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759906AbZCMRB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 13:01:27 -0400
Received: from gw.goop.org ([64.81.55.164]:57439 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759803AbZCMRB0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 13:01:26 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       David Airlie <airlied@linux.ie>, Mark McLoughlin <markmc@redhat.com>
Subject: [PATCH 20/27] xen mtrr: Use specific cpu_has_foo macros instead of generic cpu_has()
Date: Fri, 13 Mar 2009 10:00:05 -0700
Message-Id: <1236963612-14287-21-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1236963612-14287-1-git-send-email-jeremy@goop.org>
References: <1236963612-14287-1-git-send-email-jeremy@goop.org>
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

