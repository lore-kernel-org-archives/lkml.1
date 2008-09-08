Return-Path: <linux-kernel-owner+w=401wt.eu-S1754101AbYIHRwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101AbYIHRwv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 13:52:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753070AbYIHRwn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 13:52:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37424 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480AbYIHRwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 13:52:42 -0400
Date: Mon, 8 Sep 2008 10:52:06 -0700
Message-Id: <200809081752.m88Hq6tn005080@askone.hos.anvin.org>
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: x86 maintainers <x86@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [git pull] x86 fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

 Thanks,

	-hpa

------------------>
H. Peter Anvin (1):
      x86: enable CONFIG_X86_GENERIC by default


 arch/x86/Kconfig.cpu |   19 ++++++++++---------
 1 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index 2c518fb..46d0acf 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -279,17 +279,18 @@ config GENERIC_CPU
 endchoice
 
 config X86_GENERIC
-	bool "Generic x86 support"
+	bool "Generic x86 support" if EMBEDDED
 	depends on X86_32
+	default y
 	help
-	  Instead of just including optimizations for the selected
-	  x86 variant (e.g. PII, Crusoe or Athlon), include some more
-	  generic optimizations as well. This will make the kernel
-	  perform better on x86 CPUs other than that selected.
-
-	  This is really intended for distributors who need more
-	  generic optimizations.
-
+	  Instead of just including optimizations and workarounds for
+	  the selected x86 variant (e.g. PII, Crusoe or Athlon),
+	  include some more generic optimizations and workarounds as
+	  well.  Without this option, the kernel is not guaranteed to
+	  run on anything other than the exact CPU selected.
+
+	  Disable this if you want to run the kernel on a specific CPU
+	  *only* and want maximum optimizations for that CPU.
 endif
 
 config X86_CPU
