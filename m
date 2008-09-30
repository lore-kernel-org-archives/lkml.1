Return-Path: <linux-kernel-owner+w=401wt.eu-S1753975AbYI3WG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975AbYI3WG6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 18:06:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752938AbYI3WGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 18:06:49 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:36992 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558AbYI3WGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 18:06:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=MUcXkefu+bcHWQhBadmTTALdyQcQ6/GqDgP87KclLHi9n7Li8aF1+/2hWKzbBQ03IL
         KxQeEzntSFDRJ6uOjl2027oroULBtMndt4EwiQYzQctB8/2MQf0F9hAq+i4SGLUbFh2U
         y96EsaDH/YkQvg955sand9E4PBLJMk5IGKVzA=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH] x86: mtrr_cleanup update command line and doc mtrr-cleanup-debug v2
Date: Tue, 30 Sep 2008 15:06:10 -0700
Message-Id: <1222812370-16188-1-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

change enable_mtrr_cleanup to mtrr-cleanup, disable_mtrr_cleanup to nomtrr-cleanup.
so doc mtrr-cleanup-debug.

v2: some _ to -

and change MTRR_SANITIZER to def_bool y

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 Documentation/kernel-parameters.txt |    7 +++++--
 arch/x86/Kconfig                    |    6 +++---
 arch/x86/kernel/cpu/mtrr/main.c     |    6 +++---
 3 files changed, 11 insertions(+), 8 deletions(-)

Index: linux-2.6/Documentation/kernel-parameters.txt
===================================================================
--- linux-2.6.orig/Documentation/kernel-parameters.txt
+++ linux-2.6/Documentation/kernel-parameters.txt
@@ -614,12 +614,15 @@ and is between 256 and 4096 characters.
 			See drivers/char/README.epca and
 			Documentation/digiepca.txt.
 
-	disable_mtrr_cleanup [X86]
-	enable_mtrr_cleanup [X86]
+	nomtrr-cleanup [X86]
+	mtrr-cleanup [X86]
 			The kernel tries to adjust MTRR layout from continuous
 			to discrete, to make X server driver able to add WB
 			entry later. This parameter enables/disables that.
 
+	mtrr-cleanup-debug [X86]
+			print out more debug info for mtrr cleanup.
+
 	mtrr_chunk_size=nn[KMG] [X86]
 			used for mtrr cleanup. It is largest continous chunk
 			that could hold holes aka. UC entries.
Index: linux-2.6/arch/x86/Kconfig
===================================================================
--- linux-2.6.orig/arch/x86/Kconfig
+++ linux-2.6/arch/x86/Kconfig
@@ -1243,18 +1243,18 @@ config MTRR
 	  See <file:Documentation/x86/mtrr.txt> for more information.
 
 config MTRR_SANITIZER
-	bool
+	def_bool y
 	prompt "MTRR cleanup support"
 	depends on MTRR
 	help
 	  Convert MTRR layout from continuous to discrete, so X drivers can
 	  add writeback entries.
 
-	  Can be disabled with disable_mtrr_cleanup on the kernel command line.
+	  Can be disabled with nomtrr-cleanup on the kernel command line.
 	  The largest mtrr entry size for a continous block can be set with
 	  mtrr_chunk_size.
 
-	  If unsure, say N.
+	  If unsure, say Y.
 
 config MTRR_SANITIZER_ENABLE_DEFAULT
 	int "MTRR cleanup enable value (0-1)"
Index: linux-2.6/arch/x86/kernel/cpu/mtrr/main.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/mtrr/main.c
+++ linux-2.6/arch/x86/kernel/cpu/mtrr/main.c
@@ -826,7 +826,7 @@ static int __init disable_mtrr_cleanup_s
 		enable_mtrr_cleanup = 0;
 	return 0;
 }
-early_param("disable_mtrr_cleanup", disable_mtrr_cleanup_setup);
+early_param("nomtrr-cleanup", disable_mtrr_cleanup_setup);
 
 static int __init enable_mtrr_cleanup_setup(char *str)
 {
@@ -834,14 +834,14 @@ static int __init enable_mtrr_cleanup_se
 		enable_mtrr_cleanup = 1;
 	return 0;
 }
-early_param("enable_mtrr_cleanup", enable_mtrr_cleanup_setup);
+early_param("mtrr-cleanup", enable_mtrr_cleanup_setup);
 
 static int __init mtrr_cleanup_debug_setup(char *str)
 {
 	debug_print = 1;
 	return 0;
 }
-early_param("mtrr_cleanup_debug", mtrr_cleanup_debug_setup);
+early_param("mtrr-cleanup-debug", mtrr_cleanup_debug_setup);
 
 struct var_mtrr_state {
 	unsigned long	range_startk;
