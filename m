Return-Path: <linux-kernel-owner+w=401wt.eu-S1759166AbXKCTBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759166AbXKCTBf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 15:01:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756840AbXKCTBH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 15:01:07 -0400
Received: from mail0.scram.de ([78.47.204.202]:48484 "EHLO mail0.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756542AbXKCTBF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 15:01:05 -0400
X-Spam-Score: -3.899
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
 * -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
 *      [score: 0.0000]
 *  0.5 AWL AWL: From: address is in the auto white-list
Message-ID: <472CC572.9050508@scram.de>
Date: Sat, 03 Nov 2007 20:01:06 +0100
From: Jochen Friedrich <jochen@scram.de>
User-Agent: Mozilla-Thunderbird 2.0.0.6 (X11/20071009)
MIME-Version: 1.0
To: "linuxppc-embedded@ozlabs.org" <linuxppc-embedded@ozlabs.org>
CC: Marcelo Tosatti <marcelo@kvack.org>, Scott Wood <scottwood@freescale.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH1/2] [POWERPC] Kill non-existant symbols from ksyms and commproc.h
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove exports of __res and cpm_install_handler/cpm_free_handler.
Remove cpm_install_handler/cpm_free_handler from the commproc.h as well.
Both were used for ARCH=ppc and aren't defined for ARCH=powerpc.

CC      arch/powerpc/kernel/ppc_ksyms.o
arch/powerpc/kernel/ppc_ksyms.c:180: error: '__res' undeclared here (not in a function)
arch/powerpc/kernel/ppc_ksyms.c:180: warning: type defaults to 'int' in declaration of '__res'
make[1]: *** [arch/powerpc/kernel/ppc_ksyms.o] Error 1
make: *** [arch/powerpc/kernel] Error 2

LD      .tmp_vmlinux1
arch/powerpc/kernel/built-in.o:(__ksymtab+0x198): undefined reference to `cpm_free_handler'
arch/powerpc/kernel/built-in.o:(__ksymtab+0x1a0): undefined reference to `cpm_install_handler'
make: *** [.tmp_vmlinux1] Error 1

Signed-off-by: Jochen Friedrich <jochen@scram.de>
---
arch/powerpc/kernel/ppc_ksyms.c |   12 ------------
include/asm-powerpc/commproc.h  |    3 ---
2 files changed, 0 insertions(+), 15 deletions(-)

diff --git a/arch/powerpc/kernel/ppc_ksyms.c b/arch/powerpc/kernel/ppc_ksyms.c
index c6b1aa3..13ebeb2 100644
--- a/arch/powerpc/kernel/ppc_ksyms.c
+++ b/arch/powerpc/kernel/ppc_ksyms.c
@@ -45,10 +45,6 @@
#include <asm/signal.h>
#include <asm/dcr.h>

-#ifdef  CONFIG_8xx
-#include <asm/commproc.h>
-#endif
-
#ifdef CONFIG_PPC64
EXPORT_SYMBOL(local_irq_restore);
#endif
@@ -172,14 +168,6 @@ EXPORT_SYMBOL(console_drivers);
EXPORT_SYMBOL(cacheable_memcpy);
#endif

-#ifdef  CONFIG_8xx
-EXPORT_SYMBOL(cpm_install_handler);
-EXPORT_SYMBOL(cpm_free_handler);
-#endif /* CONFIG_8xx */
-#if defined(CONFIG_8xx)
-EXPORT_SYMBOL(__res);
-#endif
-
#ifdef CONFIG_PPC32
EXPORT_SYMBOL(next_mmu_context);
EXPORT_SYMBOL(set_context);
diff --git a/include/asm-powerpc/commproc.h b/include/asm-powerpc/commproc.h
index 0307c84..5dff922 100644
--- a/include/asm-powerpc/commproc.h
+++ b/include/asm-powerpc/commproc.h
@@ -698,9 +698,6 @@ typedef struct risc_timer_pram {
#define CICR_IEN		((uint)0x00000080)	/* Int. enable */
#define CICR_SPS		((uint)0x00000001)	/* SCC Spread */

-extern void cpm_install_handler(int vec, void (*handler)(void *), void *dev_id);
-extern void cpm_free_handler(int vec);
-
#define IMAP_ADDR		(get_immrbase())

#define CPM_PIN_INPUT     0
-- 
1.5.3.4





