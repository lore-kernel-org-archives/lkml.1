Return-Path: <linux-kernel-owner+w=401wt.eu-S1758929AbZIGDNa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758929AbZIGDNa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 23:13:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758900AbZIGDNV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 23:13:21 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:61245 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758897AbZIGDNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 23:13:19 -0400
From: Tim Abbott <tabbott@ksplice.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Tim Abbott <tabbott@ksplice.com>,
       Hirokazu Takata <takata@linux-m32r.org>
Subject: [PATCH 1/6] m32r: make PAGE_SIZE available to assembly.
Date: Sun,  6 Sep 2009 23:12:54 -0400
Message-Id: <1252293179-13382-1-git-send-email-tabbott@ksplice.com>
X-Mailer: git-send-email 1.6.3.3
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

page.h includes ifndef __ASSEMBLY__ guards, but PAGE_SIZE is defined
using "1UL", which the assembler does not support. Use the _AC macro
from const.h to make it available to assembly (and linker scripts).

Signed-off-by: Tim Abbott <tabbott@ksplice.com>
Cc: Hirokazu Takata <takata@linux-m32r.org>
---
 arch/m32r/include/asm/page.h |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/m32r/include/asm/page.h b/arch/m32r/include/asm/page.h
index 11777f7..725ede8 100644
--- a/arch/m32r/include/asm/page.h
+++ b/arch/m32r/include/asm/page.h
@@ -1,9 +1,11 @@
 #ifndef _ASM_M32R_PAGE_H
 #define _ASM_M32R_PAGE_H
 
+#include <linux/const.h>
+
 /* PAGE_SHIFT determines the page size */
 #define PAGE_SHIFT	12
-#define PAGE_SIZE	(1UL << PAGE_SHIFT)
+#define PAGE_SIZE	(_AC(1, UL) << PAGE_SHIFT)
 #define PAGE_MASK	(~(PAGE_SIZE-1))
 
 #ifndef __ASSEMBLY__
-- 
1.6.3.3

