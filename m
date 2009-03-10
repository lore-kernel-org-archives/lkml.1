Return-Path: <linux-kernel-owner+w=401wt.eu-S1755701AbZCJNFe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755701AbZCJNFe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 09:05:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755351AbZCJNDo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 09:03:44 -0400
Received: from cmpxchg.org ([85.214.51.133]:38771 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755364AbZCJNDn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 09:03:43 -0400
Message-Id: <20090310120632.078480048@emlix.com>
References: <20090310115643.653120649@emlix.com>
User-Agent: quilt/0.46-1
Date: Tue, 10 Mar 2009 12:56:50 +0100
From: Johannes Weiner <jw@emlix.com>
To: Chris Zankel <chris@zankel.net>
Cc: Oskar Schirmer <os@emlix.com>, Daniel Gloeckner <dg@emlix.com>,
       linux-kernel@vger.kernel.org
Subject: [patch 7/8] xtensa: let platform override KERNELOFFSET
Content-Disposition: inline; filename=0006-xtensa-let-platform-override-KERNELOFFSET.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The linker script should not assume a fix offset in memory for the
kernel, this is platform-specific, so let the platform set it.

Signed-off-by: Johannes Weiner <jw@emlix.com>
---
 arch/xtensa/kernel/vmlinux.lds.S |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/xtensa/kernel/vmlinux.lds.S
+++ b/arch/xtensa/kernel/vmlinux.lds.S
@@ -17,6 +17,7 @@
 #include <asm-generic/vmlinux.lds.h>
 
 #include <variant/core.h>
+#include <platform/hardware.h>
 OUTPUT_ARCH(xtensa)
 ENTRY(_start)
 
@@ -26,7 +27,9 @@ jiffies = jiffies_64 + 4;
 jiffies = jiffies_64;
 #endif
 
+#ifndef KERNELOFFSET
 #define KERNELOFFSET 0xd0001000
+#endif
 
 /* Note: In the following macros, it would be nice to specify only the
    vector name and section kind and construct "sym" and "section" using

-- 

