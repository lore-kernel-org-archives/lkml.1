Return-Path: <linux-kernel-owner+w=401wt.eu-S1755050Ab0ARC5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050Ab0ARC5k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 21:57:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753207Ab0ARC5i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 21:57:38 -0500
Received: from mail.gmx.net ([213.165.64.20]:45802 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753085Ab0ARC5f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 21:57:35 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/LTJ4uYC7LmNosyvVaFLOxsWXjbOmjb6iwadkLgf
	Fgf18mLEdjwG3S
From: Peter Huewe <PeterHuewe@gmx.de>
To: Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH] arch/sh: Fix build failure caused by missing semicolon / missing include
Date: Mon, 18 Jan 2010 03:57:31 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.27-05415-g69a8594; KDE/4.3.3; x86_64; ; )
Cc: Matt Fleming <matt@console-pimps.org>,
       Francesco Virlinzi <francesco.virlinzi@st.com>,
       linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
       peterhuewe@gmx.de
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201001180357.31594.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.52000000000000002
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Huewe <peterhuewe@gmx.de>
Date: Mon, 18 Jan 2010 03:48:31 +0100

This patch fixes a build failure[1][2] for all sh configs, by fixing a
missing semicolon and a missing include file.

Build failure was introduced by the patch
	sh: fixed PMB mode refactoring [3]
	of Wed, 13 Jan 2010 09:31:48 +0000 (18:31 +0900)

References:
[1] http://kisskb.ellerman.id.au/kisskb/buildresult/2019836/
[2] http://kisskb.ellerman.id.au/kisskb/compiler/16/
[3] http://git.kernel.org/?p=linux/kernel/git/sfr/linux-next.git;a=commit;h=a0ab36689a36e583b6e736f1c99ac8c9aebdad59

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
Patch against linux-next tree of 20100114
KernelVersion: next-20100114

 arch/sh/include/asm/mmu.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/sh/include/asm/mmu.h b/arch/sh/include/asm/mmu.h
index 4b0882b..c5313e2 100644
--- a/arch/sh/include/asm/mmu.h
+++ b/arch/sh/include/asm/mmu.h
@@ -1,5 +1,6 @@
 #ifndef __MMU_H
 #define __MMU_H
+#include <linux/errno.h>
 
 /*
  * Privileged Space Mapping Buffer (PMB) definitions
@@ -75,7 +76,7 @@ int pmb_init(void);
 static inline long pmb_remap(unsigned long virt, unsigned long phys,
 			     unsigned long size, unsigned long flags)
 {
-	return -EINVAL
+	return -EINVAL;
 }
 
 static inline void pmb_unmap(unsigned long addr)
-- 
1.6.4.4

