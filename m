Return-Path: <linux-kernel-owner+w=401wt.eu-S1758979AbZBLMl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758979AbZBLMl7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 07:41:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758832AbZBLMim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 07:38:42 -0500
Received: from one.firstfloor.org ([213.235.205.2]:49217 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758806AbZBLMij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 07:38:39 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <20090212137.750180365@firstfloor.org>
In-Reply-To: <20090212137.750180365@firstfloor.org>
To: akpm@linux-foundation.org, x86@firstfloor.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [10/10] x86: MCE: Fix ifdef for 64bit thermal apic vector clear on shutdown 
Message-Id: <20090212123729.6B3293E6674@basil.firstfloor.org>
Date: Thu, 12 Feb 2009 13:37:29 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: Bugfix

The ifdef for the apic clear on shutdown for the 64bit intel thermal
vector was incorrect and never triggered. Fix that.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/kernel/apic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/arch/x86/kernel/apic.c
===================================================================
--- linux.orig/arch/x86/kernel/apic.c	2009-02-12 11:30:48.000000000 +0100
+++ linux/arch/x86/kernel/apic.c	2009-02-12 12:10:16.000000000 +0100
@@ -862,7 +862,7 @@
 	}
 
 	/* lets not touch this if we didn't frob it */
-#if defined(CONFIG_X86_MCE_P4THERMAL) || defined(X86_MCE_INTEL)
+#if defined(CONFIG_X86_MCE_P4THERMAL) || defined(CONFIG_X86_MCE_INTEL)
 	if (maxlvt >= 5) {
 		v = apic_read(APIC_LVTTHMR);
 		apic_write(APIC_LVTTHMR, v | APIC_LVT_MASKED);
