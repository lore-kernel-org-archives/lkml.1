Return-Path: <linux-kernel-owner+w=401wt.eu-S1762139AbXEOTiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762139AbXEOTiX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 15:38:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759857AbXEOThE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 15:37:04 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45135 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761983AbXEOThB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 15:37:01 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] [m32r] __xchg() should be always_inline
Cc: linux-kernel@vger.kernel.org, takata@linux-m32r.org
Message-Id: <E1Ho2pQ-0003Uu-BS@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Tue, 15 May 2007 20:37:00 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


it depends on elimination of unreachable branches in switch (by object
size), so we must declare it always_inline

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 include/asm-m32r/system.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/include/asm-m32r/system.h b/include/asm-m32r/system.h
index b291b2f..8ee73d3 100644
--- a/include/asm-m32r/system.h
+++ b/include/asm-m32r/system.h
@@ -10,6 +10,7 @@
  * Copyright (C) 2004, 2006  Hirokazu Takata <takata at linux-m32r.org>
  */
 
+#include <linux/compiler.h>
 #include <asm/assembler.h>
 
 #ifdef __KERNEL__
@@ -154,7 +155,7 @@ extern void  __xchg_called_with_bad_pointer(void);
 #define DCACHE_CLEAR(reg0, reg1, addr)
 #endif	/* CONFIG_CHIP_M32700_TS1 */
 
-static inline unsigned long
+static __always_inline unsigned long
 __xchg(unsigned long x, volatile void * ptr, int size)
 {
 	unsigned long flags;
-- 
1.5.0-rc2.GIT


