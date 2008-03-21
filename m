Return-Path: <linux-kernel-owner+w=401wt.eu-S932748AbYCUXNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932748AbYCUXNe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 19:13:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763253AbYCUWwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 18:52:34 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:41343 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762761AbYCUWwc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 18:52:32 -0400
Message-Id: <20080321224436.130837167@sous-sol.org>
References: <20080321224250.144333319@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 21 Mar 2008 15:43:48 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 58/76] x86: dont use P6_NOPs if compiling with CONFIG_X86_GENERIC
Content-Disposition: inline; filename=x86-don-t-use-p6_nops-if-compiling-with-config_x86_generic.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: H. Peter Anvin <hpa@zytor.com>

x86: don't use P6_NOPs if compiling with CONFIG_X86_GENERIC

P6_NOPs are definitely not supported on some VIA CPUs, and possibly
(unverified) on AMD K7s.  It is also the only thing that prevents a
686 kernel from running on Transmeta TM3x00/5x00 (Crusoe) series.

The performance benefit over generic NOPs is very small, so when
building for generic consumption, avoid using them.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
[cebbert@redhat.com: backport take 2, with parens this time]
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---

 include/asm-x86/processor_32.h |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/include/asm-x86/processor_32.h
+++ b/include/asm-x86/processor_32.h
@@ -712,9 +712,10 @@ static inline unsigned int cpuid_edx(uns
 #define ASM_NOP6 K7_NOP6
 #define ASM_NOP7 K7_NOP7
 #define ASM_NOP8 K7_NOP8
-#elif defined(CONFIG_M686) || defined(CONFIG_MPENTIUMII) || \
+#elif (defined(CONFIG_M686) || defined(CONFIG_MPENTIUMII) || \
       defined(CONFIG_MPENTIUMIII) || defined(CONFIG_MPENTIUMM) || \
-      defined(CONFIG_MCORE2) || defined(CONFIG_PENTIUM4)
+      defined(CONFIG_MCORE2) || defined(CONFIG_PENTIUM4)) && \
+      !defined(CONFIG_X86_GENERIC)
 #define ASM_NOP1 P6_NOP1
 #define ASM_NOP2 P6_NOP2
 #define ASM_NOP3 P6_NOP3

-- 
