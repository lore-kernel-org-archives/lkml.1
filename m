Return-Path: <linux-kernel-owner+w=401wt.eu-S1757622AbYEILKt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757622AbYEILKt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 07:10:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753342AbYEILJf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 07:09:35 -0400
Received: from gw.goop.org ([64.81.55.164]:47566 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752145AbYEILJd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 07:09:33 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 3 of 8] x86: rearrange __(VIRTUAL|PHYSICAL)_MASK
X-Mercurial-Node: 694381a8dbb357bc3890eb5e6b85630dd1cfc1d2
Message-Id: <694381a8dbb357bc3890.1210330961@localhost>
In-Reply-To: <patchbomb.1210330958@localhost>
Date: Fri, 09 May 2008 12:02:41 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Hugh Dickins <hugh@veritas.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Put the definitions of __(VIRTUAL|PHYSICAL)_MASK before their uses.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 include/asm-x86/page.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/asm-x86/page.h b/include/asm-x86/page.h
--- a/include/asm-x86/page.h
+++ b/include/asm-x86/page.h
@@ -9,6 +9,9 @@
 #define PAGE_MASK	(~(PAGE_SIZE-1))
 
 #ifdef __KERNEL__
+
+#define __PHYSICAL_MASK		((phys_addr_t)(1ULL << __PHYSICAL_MASK_SHIFT) - 1)
+#define __VIRTUAL_MASK		((1UL << __VIRTUAL_MASK_SHIFT) - 1)
 
 /* Cast PAGE_MASK to a signed type so that it is sign-extended if
    virtual addresses are 32-bits but physical addresses are larger
@@ -28,9 +31,6 @@
 
 /* to align the pointer to the (next) page boundary */
 #define PAGE_ALIGN(addr)	(((addr)+PAGE_SIZE-1)&PAGE_MASK)
-
-#define __PHYSICAL_MASK		((phys_addr_t)(1ULL << __PHYSICAL_MASK_SHIFT) - 1)
-#define __VIRTUAL_MASK		((1UL << __VIRTUAL_MASK_SHIFT) - 1)
 
 #ifndef __ASSEMBLY__
 #include <linux/types.h>


