Return-Path: <linux-kernel-owner+w=401wt.eu-S1756644AbZIVOXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756644AbZIVOXQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 10:23:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756591AbZIVOXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 10:23:14 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:56363 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755913AbZIVOXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 10:23:12 -0400
From: Tim Abbott <tabbott@ksplice.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Tim Abbott <tabbott@ksplice.com>,
       Hirokazu Takata <takata@linux-m32r.org>
Subject: [PATCH 02/13] m32r: make PAGE_SIZE available to assembly.
Date: Tue, 22 Sep 2009 10:22:16 -0400
Message-Id: <1253629347-23119-3-git-send-email-tabbott@ksplice.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1253629347-23119-1-git-send-email-tabbott@ksplice.com>
References: <1253629347-23119-1-git-send-email-tabbott@ksplice.com>
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
Acked-by: Sam Ravnborg <sam@ravnborg.org>
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

