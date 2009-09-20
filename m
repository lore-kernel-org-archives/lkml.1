Return-Path: <linux-kernel-owner+w=401wt.eu-S1755356AbZITTkT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356AbZITTkT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 15:40:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754996AbZITTkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 15:40:19 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:45980 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753616AbZITTkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 15:40:18 -0400
Date: Sun, 20 Sep 2009 21:40:12 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH v2] arm: export "W" macro just for assembly code
Message-ID: <20090920194012.GA22062@Chamillionaire.breakpoint.cc>
References: <20090917091237.8258.29171.stgit@pc1117.cambridge.arm.com>
 <20090918193422.GA6601@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20090918193422.GA6601@n2100.arm.linux.org.uk>
X-Key-Id: FE3F4706
X-Key-Fingerprint: FFDA BBBB 3563 1B27 75C9  925B 98D5 5C1C FE3F 4706
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Dobriyan <adobriyan@gmail.com>

The W macro which got introduced in 0becb08 aka "Thumb-2: Add macros for
the unified assembler syntax" clashes with the W function in
crypto/cast6.c since commit 8b59278 aka "Thumb-2: Implement the unified
arch/arm/lib functions" due to the following include path:
|arch/arm/include/asm/unified.h <---
|arch/arm/include/asm/uaccess.h:20
|include/linux/uaccess.h:5
|include/linux/crypto.h:26
|crypto/cast6.c:23

This patch allows the usage of the new W macro only in assembly files
since it is the place where it is used.

[sebastian@breakpoint]: patch description
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
---
Russel, I've added a new patch description for this patch since my
rename edition was a little larger.

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

