Return-Path: <linux-kernel-owner+w=401wt.eu-S1758443AbZA2A2w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758443AbZA2A2w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 19:28:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758904AbZA1Xra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:47:30 -0500
Received: from hera.kernel.org ([140.211.167.34]:53452 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758204AbZA1Xr1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:47:27 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 111/114] x86: move X86_VSMP from subarch menu
Date: Wed, 28 Jan 2009 23:42:57 +0000
Message-Id: <1233186180-29883-112-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:47:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move X86_VSMP out of the subarch menu - this way it can be enabled
together with standard PC support as well, in the same kernel.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/Kconfig |   19 ++++++++++---------
 1 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 2fe2982..ddddfb8 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -271,15 +271,6 @@ config X86_PC
 	help
 	  Choose this option if your computer is a standard PC or compatible.
 
-config X86_VSMP
-	bool "Support for ScaleMP vSMP"
-	select PARAVIRT
-	depends on X86_64 && PCI
-	help
-	  Support for ScaleMP vSMP systems.  Say 'Y' here if this kernel is
-	  supposed to run on these EM64T-based machines.  Only choose this option
-	  if you have one of these machines.
-
 endchoice
 
 config X86_NON_STANDARD
@@ -327,6 +318,16 @@ config X86_UV
 	  This option is needed in order to support SGI Ultraviolet systems.
 	  If you don't have one of these, you should say N here.
 
+config X86_VSMP
+	bool "Support for ScaleMP vSMP"
+	select PARAVIRT
+	depends on X86_64 && PCI
+	depends on X86_NON_STANDARD
+	help
+	  Support for ScaleMP vSMP systems.  Say 'Y' here if this kernel is
+	  supposed to run on these EM64T-based machines.  Only choose this option
+	  if you have one of these machines.
+
 config X86_ELAN
 	bool "AMD Elan"
 	depends on X86_32
-- 
1.6.0.2

