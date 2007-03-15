Return-Path: <linux-kernel-owner+w=401wt.eu-S965301AbXCOFVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965301AbXCOFVo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 01:21:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965349AbXCOFRf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 01:17:35 -0400
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:35276 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965242AbXCOFQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 01:16:54 -0400
Message-Id: <20070315051532.048465011@goodmis.org>
References: <20070315051337.488091591@goodmis.org>
User-Agent: quilt/0.45-1
Date: Thu, 15 Mar 2007 01:13:51 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@muc.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [PATCH take3 14/20] intel_cacheinfo.c switch
Content-Disposition: inline; filename=15-intel_cacheinfo.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Move the intel_cacheinfo.c to the common area.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/arch/i386/kernel/cpu/Makefile b/arch/i386/kernel/cpu/Makefile
index f8eaef8..e484d74 100644
--- a/arch/i386/kernel/cpu/Makefile
+++ b/arch/i386/kernel/cpu/Makefile
@@ -8,7 +8,7 @@ obj-y	+=	amd.o
 obj-y	+=	cyrix.o
 obj-y	+=	centaur.o
 obj-y	+=	transmeta.o
-obj-y	+=	intel.o intel_cacheinfo.o
+obj-y	+=	intel.o
 obj-y	+=	rise.o
 obj-y	+=	nexgen.o
 obj-y	+=	umc.o
diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index e439cc1..6557e4a 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -1,3 +1,4 @@
+obj-y			+=	intel_cacheinfo.o
 
 obj-$(CONFIG_X86_MCE)	+=	mcheck/
 obj-$(CONFIG_MTRR)	+= 	mtrr/
diff --git a/arch/i386/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
similarity index 100%
rename from arch/i386/kernel/cpu/intel_cacheinfo.c
rename to arch/x86/kernel/cpu/intel_cacheinfo.c
diff --git a/arch/x86_64/kernel/Makefile b/arch/x86_64/kernel/Makefile
index ef1585d..0a33b03 100644
--- a/arch/x86_64/kernel/Makefile
+++ b/arch/x86_64/kernel/Makefile
@@ -36,8 +36,5 @@ obj-$(CONFIG_AUDIT)		+= audit.o
 obj-$(CONFIG_MODULES)		+= module.o
 obj-$(CONFIG_PCI)		+= early-quirks.o
 
-obj-y				+= intel_cacheinfo.o
-
 CFLAGS_vsyscall.o		:= $(PROFILING) -g0
 
-intel_cacheinfo-y		+= ../../i386/kernel/cpu/intel_cacheinfo.o

--
