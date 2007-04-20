Return-Path: <linux-kernel-owner+w=401wt.eu-S1754524AbXDTWwz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524AbXDTWwz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 18:52:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754525AbXDTWwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 18:52:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33339 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754524AbXDTWwy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 18:52:54 -0400
Message-ID: <46294444.1050608@redhat.com>
Date: Fri, 20 Apr 2007 18:52:52 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
CC: Andi Kleen <ak@suse.de>
Subject: [RFC PATCH 1/3] x86: use defined names for all CPU feature flags
References: <4629438C.4070209@redhat.com>
In-Reply-To: <4629438C.4070209@redhat.com>
Content-Type: multipart/mixed;
 boundary="------------020805090108050408050902"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020805090108050408050902
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit



--------------020805090108050408050902
Content-Type: text/plain;
 name="x86_name_that_flag.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x86_name_that_flag.patch"

x86: use defined names for all CPU feature flags

Don't use hard coded values for CPU flags.

Signed-off-by: Chuck Ebbert <cebbert@redhat.com>
---
 arch/i386/kernel/cpu/amd.c      |    2 +-
 arch/i386/kernel/cpu/centaur.c  |    2 +-
 arch/i386/kernel/cpu/cyrix.c    |    6 +++---
 arch/x86_64/kernel/setup.c      |    2 +-
 include/asm-i386/cpufeature.h   |    4 +++-
 include/asm-x86_64/cpufeature.h |    1 +
 6 files changed, 10 insertions(+), 7 deletions(-)

--- 2.6.21-rc7-d390.orig/arch/x86_64/kernel/setup.c
+++ 2.6.21-rc7-d390/arch/x86_64/kernel/setup.c
@@ -576,7 +576,7 @@ static void __cpuinit init_amd(struct cp
 
 	/* Bit 31 in normal CPUID used for nonstandard 3DNow ID;
 	   3DNow is IDd by bit 31 in extended CPUID (1*32+31) anyway */
-	clear_bit(0*32+31, &c->x86_capability);
+	clear_bit(X86_FEATURE_PBE, &c->x86_capability);
 	
 	/* On C+ stepping K8 rep microcode works well for copy/memset */
 	level = cpuid_eax(1);
--- 2.6.21-rc7-d390.orig/include/asm-i386/cpufeature.h
+++ 2.6.21-rc7-d390/include/asm-i386/cpufeature.h
@@ -42,6 +42,7 @@
 #define X86_FEATURE_HT		(0*32+28) /* Hyper-Threading */
 #define X86_FEATURE_ACC		(0*32+29) /* Automatic clock control */
 #define X86_FEATURE_IA64	(0*32+30) /* IA-64 processor */
+#define X86_FEATURE_PBE		(0*32+31) /* PBE */
 
 /* AMD-defined CPU features, CPUID level 0x80000001, word 1 */
 /* Don't duplicate feature flags which are redundant with Intel! */
@@ -49,6 +50,7 @@
 #define X86_FEATURE_MP		(1*32+19) /* MP Capable. */
 #define X86_FEATURE_NX		(1*32+20) /* Execute Disable */
 #define X86_FEATURE_MMXEXT	(1*32+22) /* AMD MMX extensions */
+#define X86_FEATURE_CXMMXORIG	(1*32+24) /* Cyrix MMX, initial location */
 #define X86_FEATURE_LM		(1*32+29) /* Long Mode (x86-64) */
 #define X86_FEATURE_3DNOWEXT	(1*32+30) /* AMD 3DNow! extensions */
 #define X86_FEATURE_3DNOW	(1*32+31) /* 3DNow! */
@@ -60,7 +62,7 @@
 
 /* Other features, Linux-defined mapping, word 3 */
 /* This range is used for feature bits which conflict or are synthesized */
-#define X86_FEATURE_CXMMX	(3*32+ 0) /* Cyrix MMX extensions */
+#define X86_FEATURE_CXMMX	(3*32+ 0) /* Cyrix MMX extensions, final location */
 #define X86_FEATURE_K6_MTRR	(3*32+ 1) /* AMD K6 nonstandard MTRRs */
 #define X86_FEATURE_CYRIX_ARR	(3*32+ 2) /* Cyrix ARRs (= MTRRs) */
 #define X86_FEATURE_CENTAUR_MCR	(3*32+ 3) /* Centaur MCRs (= MTRRs) */
--- 2.6.21-rc7-d390.orig/arch/i386/kernel/cpu/cyrix.c
+++ 2.6.21-rc7-d390/arch/i386/kernel/cpu/cyrix.c
@@ -192,11 +192,11 @@ static void __cpuinit init_cyrix(struct 
 
 	/* Bit 31 in normal CPUID used for nonstandard 3DNow ID;
 	   3DNow is IDd by bit 31 in extended CPUID (1*32+31) anyway */
-	clear_bit(0*32+31, c->x86_capability);
+	clear_bit(X86_FEATURE_PBE, c->x86_capability);
 
 	/* Cyrix used bit 24 in extended (AMD) CPUID for Cyrix MMX extensions */
-	if ( test_bit(1*32+24, c->x86_capability) ) {
-		clear_bit(1*32+24, c->x86_capability);
+	if ( test_bit(X86_FEATURE_CXMMXORIG, c->x86_capability) ) {
+		clear_bit(X86_FEATURE_CXMMXORIG, c->x86_capability);
 		set_bit(X86_FEATURE_CXMMX, c->x86_capability);
 	}
 
--- 2.6.21-rc7-d390.orig/include/asm-x86_64/cpufeature.h
+++ 2.6.21-rc7-d390/include/asm-x86_64/cpufeature.h
@@ -40,6 +40,7 @@
 #define X86_FEATURE_HT		(0*32+28) /* Hyper-Threading */
 #define X86_FEATURE_ACC		(0*32+29) /* Automatic clock control */
 #define X86_FEATURE_IA64	(0*32+30) /* IA-64 processor */
+#define X86_FEATURE_PBE		(0*32+31) /* PBE */
 
 /* AMD-defined CPU features, CPUID level 0x80000001, word 1 */
 /* Don't duplicate feature flags which are redundant with Intel! */
--- 2.6.21-rc7-d390.orig/arch/i386/kernel/cpu/amd.c
+++ 2.6.21-rc7-d390/arch/i386/kernel/cpu/amd.c
@@ -83,7 +83,7 @@ static void __cpuinit init_amd(struct cp
 
 	/* Bit 31 in normal CPUID used for nonstandard 3DNow ID;
 	   3DNow is IDd by bit 31 in extended CPUID (1*32+31) anyway */
-	clear_bit(0*32+31, c->x86_capability);
+	clear_bit(X86_FEATURE_PBE, c->x86_capability);
 	
 	r = get_model_name(c);
 
--- 2.6.21-rc7-d390.orig/arch/i386/kernel/cpu/centaur.c
+++ 2.6.21-rc7-d390/arch/i386/kernel/cpu/centaur.c
@@ -334,7 +334,7 @@ static void __cpuinit init_centaur(struc
 
 	/* Bit 31 in normal CPUID used for nonstandard 3DNow ID;
 	   3DNow is IDd by bit 31 in extended CPUID (1*32+31) anyway */
-	clear_bit(0*32+31, c->x86_capability);
+	clear_bit(X86_FEATURE_PBE, c->x86_capability);
 
 	switch (c->x86) {
 

--------------020805090108050408050902--
