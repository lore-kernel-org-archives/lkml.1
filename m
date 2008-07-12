Return-Path: <linux-kernel-owner+w=401wt.eu-S1754612AbYGLLM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612AbYGLLM2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 07:12:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752192AbYGLLMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 07:12:21 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50487 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469AbYGLLMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 07:12:20 -0400
Date: Sat, 12 Jul 2008 20:11:02 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Tom Zanussi <tzanussi@gmail.com>, Jens Axboe <jens.axboe@oracle.com>
Subject: [mmotm] smp.c: fix build error 
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20080712200835.F6AC.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Against: mmotm
Patch name: full-conversion-to-early_initcall-interface-remove-old-interface-fix-fix.patch
Applies after: full-conversion-to-early_initcall-interface-remove-old-interface-fix.patch

--------------------------------

Now, init_call_single_data() is static function.
then redundant declaration cause build error as below.

     kernel/smp.c:36: error: static declaration of ‘init_call_single_data’ follows non-static declaration
     include/linux/smp.h:77: error: previous declaration of ‘init_call_single_data’ was here
     kernel/smp.c:47: warning: initialization from incompatible pointer type
     make[1]: *** [kernel/smp.o] error 1

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>
Cc: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>

---
 include/linux/smp.h |    5 -----
 1 file changed, 5 deletions(-)

Index: b/include/linux/smp.h
===================================================================
--- a/include/linux/smp.h
+++ b/include/linux/smp.h
@@ -74,15 +74,10 @@ void __smp_call_function_single(int cpui
 #ifdef CONFIG_USE_GENERIC_SMP_HELPERS
 void generic_smp_call_function_single_interrupt(void);
 void generic_smp_call_function_interrupt(void);
-void init_call_single_data(void);
 void ipi_call_lock(void);
 void ipi_call_unlock(void);
 void ipi_call_lock_irq(void);
 void ipi_call_unlock_irq(void);
-#else
-static inline void init_call_single_data(void)
-{
-}
 #endif
 
 /*




