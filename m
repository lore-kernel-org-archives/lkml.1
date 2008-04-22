Return-Path: <linux-kernel-owner+w=401wt.eu-S932127AbYDVP1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932127AbYDVP1n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 11:27:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934263AbYDVP1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 11:27:22 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:16174 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934257AbYDVP1U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 11:27:20 -0400
Message-Id: <480E2001.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Tue, 22 Apr 2008 16:27:29 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: separate cmpxchg8b checking from PAE checking
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

.. allowing the former to be use in non-PAE kernels, too.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/Kconfig.cpu                |    4 ++++
 include/asm-x86/required-features.h |    6 +++++-
 2 files changed, 9 insertions(+), 1 deletion(-)

--- linux-2.6.25/arch/x86/Kconfig.cpu	2008-04-17 04:49:44.000000000 +0200
+++ 2.6.25-x86-cmpxchg64/arch/x86/Kconfig.cpu	2008-04-15 10:49:20.000000000 +0200
@@ -394,6 +394,10 @@ config X86_TSC
 	def_bool y
 	depends on ((MWINCHIP3D || MWINCHIP2 || MCRUSOE || MEFFICEON || MCYRIXIII || MK7 || MK6 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || M586MMX || M586TSC || MK8 || MVIAC3_2 || MVIAC7 || MGEODEGX1 || MGEODE_LX || MCORE2) && !X86_NUMAQ) || X86_64
 
+config X86_CMPXCHG64
+	def_bool y
+	depends on X86_PAE || X86_64
+
 # this should be set for all -march=.. options where the compiler
 # generates cmov.
 config X86_CMOV
--- linux-2.6.25/include/asm-x86/required-features.h	2008-01-24 23:58:37.000000000 +0100
+++ 2.6.25-x86-cmpxchg64/include/asm-x86/required-features.h	2008-04-15 10:49:20.000000000 +0200
@@ -19,9 +19,13 @@
 
 #if defined(CONFIG_X86_PAE) || defined(CONFIG_X86_64)
 # define NEED_PAE	(1<<(X86_FEATURE_PAE & 31))
-# define NEED_CX8	(1<<(X86_FEATURE_CX8 & 31))
 #else
 # define NEED_PAE	0
+#endif
+
+#ifdef CONFIG_X86_CMPXCHG64
+# define NEED_CX8	(1<<(X86_FEATURE_CX8 & 31))
+#else
 # define NEED_CX8	0
 #endif
 



