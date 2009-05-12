Return-Path: <linux-kernel-owner+w=401wt.eu-S1759350AbZELXct@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759350AbZELXct (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 19:32:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757618AbZELX1q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 19:27:46 -0400
Received: from 75-149-38-2-SFBA.hfc.comcastbusiness.net ([75.149.38.2]:36267
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758103AbZELX1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 19:27:44 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Mark McLoughlin <markmc@redhat.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 2/6] xen mtrr: Use specific cpu_has_foo macros instead of generic cpu_has()
Date: Tue, 12 May 2009 16:27:40 -0700
Message-Id: <1242170864-13560-3-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1242170864-13560-1-git-send-email-jeremy@goop.org>
References: <1242170864-13560-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark McLoughlin <markmc@redhat.com>

Use specific cpu_has_foo macros instead of generic cpu_has()

[ Impact: cleanup ]

Signed-off-by: Mark McLoughlin <markmc@redhat.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/kernel/cpu/mtrr/xen.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/xen.c b/arch/x86/kernel/cpu/mtrr/xen.c
index 6760907..8ac2ccd 100644
--- a/arch/x86/kernel/cpu/mtrr/xen.c
+++ b/arch/x86/kernel/cpu/mtrr/xen.c
@@ -41,15 +41,13 @@ static int __init xen_num_var_ranges(void)
 
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

