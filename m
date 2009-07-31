Return-Path: <linux-kernel-owner+w=401wt.eu-S1753013AbZGaVCF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013AbZGaVCF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 17:02:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751655AbZGaVCE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 17:02:04 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:54580 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753108AbZGaVCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 17:02:01 -0400
From: Tim Abbott <tabbott@ksplice.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Anders Kaseorg <andersk@ksplice.com>,
       Nelson Elhage <nelhage@ksplice.com>, Ralf Baechle <ralf@linux-mips.org>,
       linux-mips@linux-mips.org
Subject: [PATCH 1/3] mips: make page.h constants available to assembly.
Date: Fri, 31 Jul 2009 16:58:17 -0400
Message-Id: <1249073899-30145-1-git-send-email-tabbott@ksplice.com>
X-Mailer: git-send-email 1.6.3.3
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nelson Elhage <nelhage@ksplice.com>

page.h includes ifndef __ASSEMBLY__ guards, but PAGE_SIZE and some other
constants are defined using "1UL", which the assembler does not
support. Use the _AC macro from const.h to make them available to
assembly (and linker scripts).

Signed-off-by: Nelson Elhage <nelhage@ksplice.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org
---
 arch/mips/include/asm/page.h |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/mips/include/asm/page.h b/arch/mips/include/asm/page.h
index 96a14a4..939ed8b 100644
--- a/arch/mips/include/asm/page.h
+++ b/arch/mips/include/asm/page.h
@@ -10,6 +10,7 @@
 #define _ASM_PAGE_H
 
 #include <spaces.h>
+#include <linux/const.h>
 
 /*
  * PAGE_SHIFT determines the page size
@@ -29,11 +30,11 @@
 #ifdef CONFIG_PAGE_SIZE_64KB
 #define PAGE_SHIFT	16
 #endif
-#define PAGE_SIZE	(1UL << PAGE_SHIFT)
+#define PAGE_SIZE	(_AC(1,UL) << PAGE_SHIFT)
 #define PAGE_MASK       (~((1 << PAGE_SHIFT) - 1))
 
 #define HPAGE_SHIFT	(PAGE_SHIFT + PAGE_SHIFT - 3)
-#define HPAGE_SIZE	((1UL) << HPAGE_SHIFT)
+#define HPAGE_SIZE	(_AC(1,UL) << HPAGE_SHIFT)
 #define HPAGE_MASK	(~(HPAGE_SIZE - 1))
 #define HUGETLB_PAGE_ORDER	(HPAGE_SHIFT - PAGE_SHIFT)
 
-- 
1.6.3.3

