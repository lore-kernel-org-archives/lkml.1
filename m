Return-Path: <linux-kernel-owner+w=401wt.eu-S1756267AbZC2Ixm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756267AbZC2Ixm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 04:53:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756059AbZC2Ix0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 04:53:26 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40092 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753952AbZC2IxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 04:53:25 -0400
References: <git-1238272225-803c78e4da28d7d7cb0642caf643b9289ae7838a@dyn-67.arm.linux.org.uk>
Message-ID: <git-1238272225-f0bba9f934517533acbda7329be93f55d5a01c03@dyn-67.arm.linux.org.uk>
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: stable@kernel.org,
       Linux Kernel Mailing list <linux-kernel@vger.kernel.org>
Date: Sat, 28 Mar 2009 20:30:26 +0000
Content-type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Subject: Re: [PATCH] [ARM] 5435/1: fix compile warning in sanity_check_meminfo()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikael Pettersson <mikpe@it.uu.se>

Compiling recent 2.6.29-rc kernels for ARM gives me the following warning:

arch/arm/mm/mmu.c: In function 'sanity_check_meminfo':
arch/arm/mm/mmu.c:697: warning: comparison between pointer and integer

This is because commit 3fd9825c42c784a59b3b90bdf073f49d4bb42a8d
"[ARM] 5402/1: fix a case of wrap-around in sanity_check_meminfo()"
in 2.6.29-rc5-git4 added a comparison of a pointer with PAGE_OFFSET,
which is an integer.

Fixed by casting PAGE_OFFSET to void *.

Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>
Acked-by: Nicolas Pitre <nico@cam.org>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 arch/arm/mm/mmu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index d4d082c..5a89e57 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -694,7 +694,7 @@ static void __init sanity_check_meminfo(void)
 		 * the vmalloc area.
 		 */
 		if (__va(bank->start) >= VMALLOC_MIN ||
-		    __va(bank->start) < PAGE_OFFSET) {
+		    __va(bank->start) < (void *)PAGE_OFFSET) {
 			printk(KERN_NOTICE "Ignoring RAM at %.8lx-%.8lx "
 			       "(vmalloc region overlap).\n",
 			       bank->start, bank->start + bank->size - 1);
