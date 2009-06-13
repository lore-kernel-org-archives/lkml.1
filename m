Return-Path: <linux-kernel-owner+w=401wt.eu-S1757436AbZFMHOC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757436AbZFMHOC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 03:14:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755501AbZFMHNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 03:13:49 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:54466 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754157AbZFMHNs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 03:13:48 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18995.20721.75525.524733@cargo.ozlabs.ibm.com>
Date: Sat, 13 Jun 2009 17:10:41 +1000
From: Paul Mackerras <paulus@samba.org>
To: benh@kernel.crashing.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] powerpc: Use generic atomic64_t implementation on 32-bit processors
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 02fccb02e29bc24e84a5b2ea6ea5d63779247408 Mon Sep 17 00:00:00 2001
From: Paul Mackerras <paulus@samba.org>
Date: Sat, 13 Jun 2009 16:24:03 +1000
Subject: 

This makes 32-bit powerpc use the generic atomic64_t implementation.

Signed-off-by: Paul Mackerras <paulus@samba.org>
---
 arch/powerpc/Kconfig              |    1 +
 arch/powerpc/include/asm/atomic.h |    3 +++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index cdc9a6f..3f0a983 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -125,6 +125,7 @@ config PPC
 	select USE_GENERIC_SMP_HELPERS if SMP
 	select HAVE_OPROFILE
 	select HAVE_SYSCALL_WRAPPERS if PPC64
+	select GENERIC_ATOMIC64 if PPC32
 
 config EARLY_PRINTK
 	bool
diff --git a/arch/powerpc/include/asm/atomic.h b/arch/powerpc/include/asm/atomic.h
index b7d2d07..4012483 100644
--- a/arch/powerpc/include/asm/atomic.h
+++ b/arch/powerpc/include/asm/atomic.h
@@ -470,6 +470,9 @@ static __inline__ int atomic64_add_unless(atomic64_t *v, long a, long u)
 
 #define atomic64_inc_not_zero(v) atomic64_add_unless((v), 1, 0)
 
+#else  /* __powerpc64__ */
+#include <asm-generic/atomic64.h>
+
 #endif /* __powerpc64__ */
 
 #include <asm-generic/atomic-long.h>
-- 
1.6.0.4

