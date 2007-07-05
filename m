Return-Path: <linux-kernel-owner+w=401wt.eu-S1763130AbXGEXXD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763130AbXGEXXD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 19:23:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761339AbXGEXWO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 19:22:14 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:52128 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762463AbXGEXWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 19:22:13 -0400
Date: Fri, 6 Jul 2007 01:22:42 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>, jeremy@xensource.com,
       chrisw@sous-sol.org
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: [-mm patch] arch/i386/xen/mmu.c must #include <linux/sched.h>
Message-ID: <20070705232242.GV3492@stusta.de>
References: <20070628034321.38c9f12b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070628034321.38c9f12b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following compile error:

<--  snip  -->

...
  CC      arch/i386/xen/mmu.o
In file included from 
/home/bunk/linux/kernel-2.6/linux-2.6.22-rc6-mm1/arch/i386/xen/mmu.c:46:
include2/asm/mmu_context.h: In function ‘switch_mm’:
include2/asm/mmu_context.h:45: error: dereferencing pointer to incomplete type
include2/asm/mmu_context.h:50: error: dereferencing pointer to incomplete type
include2/asm/mmu_context.h:53: error: dereferencing pointer to incomplete type
include2/asm/mmu_context.h:58: error: dereferencing pointer to incomplete type
include2/asm/mmu_context.h:58: error: dereferencing pointer to incomplete type
include2/asm/mmu_context.h:59: error: dereferencing pointer to incomplete type
include2/asm/mmu_context.h:66: error: dereferencing pointer to incomplete type
include2/asm/mmu_context.h:70: error: dereferencing pointer to incomplete type
include2/asm/mmu_context.h:71: error: dereferencing pointer to incomplete type
...
make[2]: *** [arch/i386/xen/mmu.o] Error 1

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.22-rc6-mm1/arch/i386/xen/mmu.c.old	2007-07-04 00:11:28.000000000 +0200
+++ linux-2.6.22-rc6-mm1/arch/i386/xen/mmu.c	2007-07-04 00:11:39.000000000 +0200
@@ -39,6 +39,7 @@
  * Jeremy Fitzhardinge <jeremy@xensource.com>, XenSource Inc, 2007
  */
 #include <linux/highmem.h>
+#include <linux/sched.h>
 
 #include <asm/bug.h>
 #include <asm/pgtable.h>

