Return-Path: <linux-kernel-owner+w=401wt.eu-S1765295AbZA2A1L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765295AbZA2A1L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 19:27:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758897AbZA1XrX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:47:23 -0500
Received: from hera.kernel.org ([140.211.167.34]:53443 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758630AbZA1XrV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:47:21 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 107/114] x86: cleanup, introduce CONFIG_NON_STANDARD_PLATFORMS
Date: Wed, 28 Jan 2009 23:42:53 +0000
Message-Id: <1233186180-29883-108-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:47:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a Y/N Kconfig option for non-PC x86 platforms.

Make VisWS, RDC321 and SGI/UV depend on this.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/Kconfig |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 38ed1a6..b090e5a 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -349,9 +349,23 @@ config X86_VSMP
 
 endchoice
 
+config X86_NON_STANDARD
+	bool "Support for non-standard x86 platforms"
+	help
+	  If you disable this option then the kernel will only support
+	  standard PC platforms. (which covers the vast majority of
+	  systems out there.)
+
+	  If you enable this option then you'll be able to select a number
+	  of less common non-PC x86 platforms: VisWS, RDC321, SGI/UV.
+
+	  If you have one of these systems, or if you want to build a
+	  generic distribution kernel, say Y here - otherwise say N.
+
 config X86_VISWS
 	bool "SGI 320/540 (Visual Workstation)"
 	depends on X86_32 && PCI && X86_MPPARSE && PCI_GODIRECT
+	depends on X86_NON_STANDARD
 	help
 	  The SGI Visual Workstation series is an IA32-based workstation
 	  based on SGI systems chips with some legacy PC hardware attached.
@@ -364,6 +378,7 @@ config X86_VISWS
 config X86_RDC321X
 	bool "RDC R-321x SoC"
 	depends on X86_32
+	depends on X86_NON_STANDARD
 	select M486
 	select X86_REBOOTFIXUPS
 	help
@@ -374,6 +389,7 @@ config X86_RDC321X
 config X86_UV
 	bool "SGI Ultraviolet"
 	depends on X86_64
+	depends on X86_NON_STANDARD
 	help
 	  This option is needed in order to support SGI Ultraviolet systems.
 	  If you don't have one of these, you should say N here.
-- 
1.6.0.2

