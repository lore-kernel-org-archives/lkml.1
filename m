Return-Path: <linux-kernel-owner+w=401wt.eu-S1755355AbZCEPWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355AbZCEPWd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 10:22:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752435AbZCEPWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 10:22:25 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:50574 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165AbZCEPWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 10:22:24 -0500
Subject: [PATCH] x86: init_memory_mapping() PSE and PGE setup ifdef removal
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: mingo@elte.hu
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 05 Mar 2009 17:22:21 +0200
Message-Id: <1236266541.31324.14.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

Impact: cleanup

Section 3.10 ("PAE-Enabled Paging in IA-32e Mode") of the Intel manual states
that The CR4.PSE bit is ignored in IA-32e mode. In 64-bit mode, PGE is enabled
at early boot so there's no need to hide setting them up in an ifdef.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 arch/x86/mm/init.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 244ae9c..3002f62 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -221,7 +221,6 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 	if (nx_enabled)
 		printk(KERN_INFO "NX (Execute Disable) protection: active\n");
 
-#ifdef CONFIG_X86_32
 	/* Enable PSE if available */
 	if (cpu_has_pse)
 		set_in_cr4(X86_CR4_PSE);
@@ -231,7 +230,6 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 		set_in_cr4(X86_CR4_PGE);
 		__supported_pte_mask |= _PAGE_GLOBAL;
 	}
-#endif
 
 	if (use_gbpages)
 		page_size_mask |= 1 << PG_LEVEL_1G;
-- 
1.5.4.3



