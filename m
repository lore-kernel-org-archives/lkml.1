Return-Path: <linux-kernel-owner+w=401wt.eu-S1757415AbZD0SMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757415AbZD0SMj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 14:12:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756859AbZD0SM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 14:12:29 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:65489 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754051AbZD0SM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 14:12:27 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Paul Mundt <lethal@linux-sh.org>,
       Tim Abbott <tabbott@MIT.EDU>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 5/8] powerpc: Use __REF macro instead of old .text.init.refok.
Date: Mon, 27 Apr 2009 14:02:24 -0400
Message-Id: <1240855347-19316-6-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1240855347-19316-5-git-send-email-tabbott@mit.edu>
References: <1240855347-19316-1-git-send-email-tabbott@mit.edu>
 <1240855347-19316-2-git-send-email-tabbott@mit.edu>
 <1240855347-19316-3-git-send-email-tabbott@mit.edu>
 <1240855347-19316-4-git-send-email-tabbott@mit.edu>
 <1240855347-19316-5-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The section .text.init.refok is deprecated and __REF (.ref.text)
should be used in assembly files instead.  This patch cleans up a few
uses of .text.init.refok in the powerpc architecture.

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 arch/powerpc/include/asm/ppc_asm.h |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/include/asm/ppc_asm.h b/arch/powerpc/include/asm/ppc_asm.h
index f59a666..384d90c 100644
--- a/arch/powerpc/include/asm/ppc_asm.h
+++ b/arch/powerpc/include/asm/ppc_asm.h
@@ -4,6 +4,7 @@
 #ifndef _ASM_POWERPC_PPC_ASM_H
 #define _ASM_POWERPC_PPC_ASM_H
 
+#include <linux/init.h>
 #include <linux/stringify.h>
 #include <asm/asm-compat.h>
 #include <asm/processor.h>
@@ -189,7 +190,7 @@ name: \
 GLUE(.,name):
 
 #define _INIT_GLOBAL(name) \
-	.section ".text.init.refok"; \
+	__REF; \
 	.align 2 ; \
 	.globl name; \
 	.globl GLUE(.,name); \
@@ -229,7 +230,7 @@ name: \
 GLUE(.,name):
 
 #define _INIT_STATIC(name) \
-	.section ".text.init.refok"; \
+	__REF; \
 	.align 2 ; \
 	.section ".opd","aw"; \
 name: \
-- 
1.6.2.1

