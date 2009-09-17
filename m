Return-Path: <linux-kernel-owner+w=401wt.eu-S1758122AbZIQJNY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758122AbZIQJNY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 05:13:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757605AbZIQJNX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 05:13:23 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:55872 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756583AbZIQJNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 05:13:16 -0400
Subject: [PATCH] Fix "W" macro in arch/arm/include/asm/unified.h
To: Russell King <rmk+kernel@arm.linux.org.uk>
From: Catalin Marinas <catalin.marinas@arm.com>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       Alexey Dobriyan <adobriyan@gmail.com>
Date: Thu, 17 Sep 2009 10:12:37 +0100
Message-ID: <20090917091237.8258.29171.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.15-rc3-5-ge7f0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Sep 2009 09:12:43.0349 (UTC) FILETIME=[0389F850:01CA3777]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Dobriyan <adobriyan@gmail.com>

Please, fold into 0becb088501886f37ade38762c8eaaf4263572cc
aka "Thumb-2: Add macros for the unified assembler syntax"

otherwise:

	crypto/cast6.c:372:39: error: macro "W" passed 2 arguments, but takes just 1

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm/include/asm/unified.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/arm/include/asm/unified.h b/arch/arm/include/asm/unified.h
index 073e85b..bc63116 100644
--- a/arch/arm/include/asm/unified.h
+++ b/arch/arm/include/asm/unified.h
@@ -35,7 +35,9 @@
 
 #define ARM(x...)
 #define THUMB(x...)	x
+#ifdef __ASSEMBLY__
 #define W(instr)	instr.w
+#endif
 #define BSYM(sym)	sym + 1
 
 #else	/* !CONFIG_THUMB2_KERNEL */
@@ -45,7 +47,9 @@
 
 #define ARM(x...)	x
 #define THUMB(x...)
+#ifdef __ASSEMBLY__
 #define W(instr)	instr
+#endif
 #define BSYM(sym)	sym
 
 #endif	/* CONFIG_THUMB2_KERNEL */

