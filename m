Return-Path: <linux-kernel-owner+w=401wt.eu-S1755145AbYKKIBh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755145AbYKKIBh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 03:01:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752899AbYKKIB3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 03:01:29 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56874 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751884AbYKKIB2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 03:01:28 -0500
Date: Tue, 11 Nov 2008 09:01:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
       linux-kernel@vger.kernel.org, Ken Chen <kenchen@google.com>
Subject: Re: 2.6.28-rc4-mmotm1110 - you gotta be kidding me...
Message-ID: <20081111080112.GA29901@elte.hu>
References: <30622.1226372137@turing-police.cc.vt.edu> <20081110193713.d94ed39a.akpm@linux-foundation.org> <20081111155844.7414bad8.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081111155844.7414bad8.sfr@canb.auug.org.au>
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


* Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> This came from commit a87d091434ed2a34d647979ab12084139ee1fe41 
> ("x86, sched: enable wchan config menu item on 64-bit").  We have 
> had CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER for some time on various 
> architectures, this commit just made it available on x86_64 (by 
> changing its dependency from X86_32 to X86).

correct. The SCHED_NO_NO name comes from ancient history. Nevertheless 
i just renamed it to CONFIG_SCHED_OMIT_FRAME_POINTER in 
tip/sched/core, and pushed out a new auto-sched-next with that rename 
in place. We can get rid of it completely once Ken's /proc/<pid>/stack 
hits upstream. (as the superior replacement for wchan)

	Ingo

----------------->
>From ae1e9130bfb9ad55eb97ec3fb17a122b7a118f98 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Tue, 11 Nov 2008 09:05:16 +0100
Subject: [PATCH] sched: rename SCHED_NO_NO_OMIT_FRAME_POINTER => SCHED_OMIT_FRAME_POINTER

Impact: cleanup, change .config option name

We had this ugly config name for a long time for hysteric raisons.
Rename it to a saner name.

We still cannot get rid of it completely, until /proc/<pid>/stack
usage replaces WCHAN usage for good.

We'll be able to do that in the v2.6.29/v2.6.30 timeframe.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/ia64/Kconfig         |    2 +-
 arch/m32r/Kconfig         |    2 +-
 arch/mips/Kconfig         |    2 +-
 arch/powerpc/Kconfig      |    2 +-
 arch/x86/Kconfig          |    2 +-
 include/asm-m32r/system.h |    2 +-
 kernel/Makefile           |    2 +-
 7 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index 27eec71..59d1278 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -99,7 +99,7 @@ config GENERIC_IOMAP
 	bool
 	default y
 
-config SCHED_NO_NO_OMIT_FRAME_POINTER
+config SCHED_OMIT_FRAME_POINTER
 	bool
 	default y
 
diff --git a/arch/m32r/Kconfig b/arch/m32r/Kconfig
index dbaed4a..29047d5 100644
--- a/arch/m32r/Kconfig
+++ b/arch/m32r/Kconfig
@@ -273,7 +273,7 @@ config GENERIC_CALIBRATE_DELAY
 	bool
 	default y
 
-config SCHED_NO_NO_OMIT_FRAME_POINTER
+config SCHED_OMIT_FRAME_POINTER
         bool
         default y
 
diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index f4af967..a5255e7 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -653,7 +653,7 @@ config GENERIC_CMOS_UPDATE
 	bool
 	default y
 
-config SCHED_NO_NO_OMIT_FRAME_POINTER
+config SCHED_OMIT_FRAME_POINTER
 	bool
 	default y
 
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 525c13a..adb23ea 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -141,7 +141,7 @@ config GENERIC_NVRAM
 	bool
 	default y if PPC32
 
-config SCHED_NO_NO_OMIT_FRAME_POINTER
+config SCHED_OMIT_FRAME_POINTER
 	bool
 	default y
 
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 1d5550d..74db682 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -364,7 +364,7 @@ config X86_RDC321X
 	  as R-8610-(G).
 	  If you don't have one of these chips, you should say N here.
 
-config SCHED_NO_NO_OMIT_FRAME_POINTER
+config SCHED_OMIT_FRAME_POINTER
 	def_bool y
 	prompt "Single-depth WCHAN output"
 	depends on X86
diff --git a/include/asm-m32r/system.h b/include/asm-m32r/system.h
index 70a57c8..c980f5b 100644
--- a/include/asm-m32r/system.h
+++ b/include/asm-m32r/system.h
@@ -23,7 +23,7 @@
  */
 
 #if defined(CONFIG_FRAME_POINTER) || \
-	!defined(CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER)
+	!defined(CONFIG_SCHED_OMIT_FRAME_POINTER)
 #define M32R_PUSH_FP "	push fp\n"
 #define M32R_POP_FP  "	pop  fp\n"
 #else
diff --git a/kernel/Makefile b/kernel/Makefile
index e1af039..46e67a3 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -91,7 +91,7 @@ obj-$(CONFIG_FUNCTION_TRACER) += trace/
 obj-$(CONFIG_TRACING) += trace/
 obj-$(CONFIG_SMP) += sched_cpupri.o
 
-ifneq ($(CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER),y)
+ifneq ($(CONFIG_SCHED_OMIT_FRAME_POINTER),y)
 # According to Alan Modra <alan@linuxcare.com.au>, the -fno-omit-frame-pointer is
 # needed for x86 only.  Why this used to be enabled for all architectures is beyond
 # me.  I suspect most platforms don't need this, but until we know that for sure
