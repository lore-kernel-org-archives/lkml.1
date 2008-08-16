Return-Path: <linux-kernel-owner+w=401wt.eu-S1756108AbYHPI4K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108AbYHPI4K (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 04:56:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752780AbYHPIz4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 04:55:56 -0400
Received: from jenny.ondioline.org ([66.220.1.122]:33224 "EHLO
	jenny.ondioline.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730AbYHPIzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 04:55:55 -0400
From: Paul Collins <paul@burly.ondioline.org>
To: linux-kernel@vger.kernel.org
Cc: ying.huang@intel.com, akpm@linux-foundation.org, linuxppc-dev@ozlabs.org
Subject: [PATCH] kexec: fix up KEXEC_CONTROL_CODE_SIZE missed during conversion
Date: Sat, 16 Aug 2008 20:55:54 +1200
Message-ID: <877iah8hk5.fsf@burly.wgtn.ondioline.org>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 163f6876f5c3ff8215e900b93779e960a56b3694 missed one, resulting in
the following compile error:

  AS      arch/powerpc/kernel/misc_32.o
arch/powerpc/kernel/misc_32.S: Assembler messages:
arch/powerpc/kernel/misc_32.S:902: Error: unsupported relocation against KEXEC_CONTROL_CODE_SIZE
make[2]: *** [arch/powerpc/kernel/misc_32.o] Error 1
make[1]: *** [arch/powerpc/kernel] Error 2
make: *** [vmlinux] Error 2

I grepped arch/ and found no further instances.

Signed-off-by: Paul Collins <paul@ondioline.org>
---
 arch/powerpc/kernel/misc_32.S |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/kernel/misc_32.S b/arch/powerpc/kernel/misc_32.S
index 6321ae3..7a6dfbc 100644
--- a/arch/powerpc/kernel/misc_32.S
+++ b/arch/powerpc/kernel/misc_32.S
@@ -899,7 +899,7 @@ relocate_new_kernel:
 
 	/* set a new stack at the bottom of our page... */
 	/* (not really needed now) */
-	addi	r1, r4, KEXEC_CONTROL_CODE_SIZE - 8 /* for LR Save+Back Chain */
+	addi	r1, r4, KEXEC_CONTROL_PAGE_SIZE - 8 /* for LR Save+Back Chain */
 	stw	r0, 0(r1)
 
 	/* Do the copies */

-- 
Paul Collins
Wellington, New Zealand

Dag vijandelijk luchtschip de huismeester is dood
