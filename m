Return-Path: <linux-kernel-owner+w=401wt.eu-S1753197AbYKARHZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197AbYKARHZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 13:07:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751818AbYKARHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 13:07:11 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56763 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403AbYKARHJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 13:07:09 -0400
Date: Sat, 1 Nov 2008 18:06:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [git pull] x86 fixes
Message-ID: <20081101170659.GA31603@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

 Thanks,

	Ingo

------------------>
Ingo Molnar (1):
      x86: build fix

Venki Pallipadi (1):
      x86: fix AMDC1E and XTOPOLOGY conflict in cpufeature


 arch/x86/include/asm/cpufeature.h |    2 +-
 arch/x86/kernel/cpu/common.c      |    1 +
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index f73e95d..cfdf8c2 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -91,7 +91,7 @@
 #define X86_FEATURE_11AP	(3*32+19) /* "" Bad local APIC aka 11AP */
 #define X86_FEATURE_NOPL	(3*32+20) /* The NOPL (0F 1F) instructions */
 #define X86_FEATURE_AMDC1E	(3*32+21) /* AMD C1E detected */
-#define X86_FEATURE_XTOPOLOGY	(3*32+21) /* cpu topology enum extensions */
+#define X86_FEATURE_XTOPOLOGY	(3*32+22) /* cpu topology enum extensions */
 
 /* Intel-defined CPU features, CPUID level 0x00000001 (ecx), word 4 */
 #define X86_FEATURE_XMM3	(4*32+ 0) /* "pni" SSE-3 */
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 003a653..b9c9ea0 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -20,6 +20,7 @@
 #include <asm/pat.h>
 #include <asm/asm.h>
 #include <asm/numa.h>
+#include <asm/smp.h>
 #ifdef CONFIG_X86_LOCAL_APIC
 #include <asm/mpspec.h>
 #include <asm/apic.h>
