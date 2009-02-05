Return-Path: <linux-kernel-owner+w=401wt.eu-S1763362AbZBETom@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763362AbZBETom (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 14:44:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760091AbZBETcn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 14:32:43 -0500
Received: from gw.goop.org ([64.81.55.164]:40057 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756360AbZBETcV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 14:32:21 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 12 of 36] x86: include pgtable_SIZE.h earlier
X-Mercurial-Node: 8a2a44275f35b40d2c11d3fc15a6825805c097fe
Message-Id: <8a2a44275f35b40d2c11.1233862254@abulafia.goop.org>
In-Reply-To: <patchbomb.1233862242@abulafia.goop.org>
References: <patchbomb.1233862242@abulafia.goop.org>
Date: Thu, 05 Feb 2009 11:30:54 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We'll need the definitions sooner.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/pgtable.h |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -462,6 +462,16 @@
 }
 #endif	/* CONFIG_PARAVIRT */
 
+#endif	/* __ASSEMBLY__ */
+
+#ifdef CONFIG_X86_32
+# include "pgtable_32.h"
+#else
+# include "pgtable_64.h"
+#endif
+
+#ifndef __ASSEMBLY__
+
 static inline int pte_none(pte_t pte)
 {
 	return !pte.pte;
@@ -521,12 +531,6 @@
 
 #endif	/* __ASSEMBLY__ */
 
-#ifdef CONFIG_X86_32
-# include "pgtable_32.h"
-#else
-# include "pgtable_64.h"
-#endif
-
 /*
  * the pgd page can be thought of an array like this: pgd_t[PTRS_PER_PGD]
  *


