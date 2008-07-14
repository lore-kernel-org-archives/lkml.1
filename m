Return-Path: <linux-kernel-owner+w=401wt.eu-S1757388AbYGNUkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757388AbYGNUkZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 16:40:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754348AbYGNUkO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 16:40:14 -0400
Received: from perninha.conectiva.com.br ([200.140.247.100]:35518 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431AbYGNUkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 16:40:13 -0400
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Organization: Mandriva
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] Fix typos from signal_32/64.h merge
Date: Mon, 14 Jul 2008 17:40:23 -0300
User-Agent: KMail/1.9.9
Cc: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Roland McGrath <roland@redhat.com>, stable@kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807141740.23750.herton@mandriva.com.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fallout from commit 33185c504f8e521b398536b5a8d415779a24593c ("x86:
merge signal_32/64.h")

Thanks to Dick Streefland who provided an useful testcase on
http://lkml.org/lkml/2008/3/17/205 (only applicable to 2.6.24.x), that
helped a lot as a deterministic way to bisect an issue that leaded to
this fix.

Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Signed-off-by: Luiz Fernando N. Capitulino <lcapitulino@mandriva.com.br>
---
 include/asm-x86/signal.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/asm-x86/signal.h b/include/asm-x86/signal.h
index f15186d..6dac493 100644
--- a/include/asm-x86/signal.h
+++ b/include/asm-x86/signal.h
@@ -181,12 +181,12 @@ typedef struct sigaltstack {
 #ifdef __KERNEL__
 #include <asm/sigcontext.h>
 
-#ifdef __386__
+#ifdef __i386__
 
 #define __HAVE_ARCH_SIG_BITOPS
 
 #define sigaddset(set,sig)		    \
-	(__builtin_constantp(sig)	    \
+	(__builtin_constant_p(sig)	    \
 	 ? __const_sigaddset((set), (sig))  \
 	 : __gen_sigaddset((set), (sig)))
 
-- 
1.5.6


