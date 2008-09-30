Return-Path: <linux-kernel-owner+w=401wt.eu-S1754360AbYI3Xaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360AbYI3Xaa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 19:30:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753368AbYI3XaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 19:30:20 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:39997 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812AbYI3XaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 19:30:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=RrCFq26iaAm1S7tfHTBINMRDZZqBBBhnnlywfZQPqpQxDPEeVUAgAHYTxTnMabRoF7
         2/cOgLsrHpBKTo3vTkDlbaUb2oplveh5U1sxkK1o5bu9E7fdt39Sdq26+tXppeWe3T2z
         KBEhEY2O0OqHVcJkrkkeclWkdZbf3T/Cit7Cs=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 1/3] x86: mtrr_cleanup update command line
Date: Tue, 30 Sep 2008 16:29:38 -0700
Message-Id: <1222817380-29481-1-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

change enable_mtrr_cleanup to mtrr-cleanup, disable_mtrr_cleanup to nomtrr-cleanup.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 Documentation/kernel-parameters.txt |    4 ++--
 arch/x86/Kconfig                    |    2 +-
 arch/x86/kernel/cpu/mtrr/main.c     |    4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

Index: linux-2.6/Documentation/kernel-parameters.txt
===================================================================
--- linux-2.6.orig/Documentation/kernel-parameters.txt
+++ linux-2.6/Documentation/kernel-parameters.txt
@@ -614,8 +614,8 @@ and is between 256 and 4096 characters.
 			See drivers/char/README.epca and
 			Documentation/digiepca.txt.
 
-	disable_mtrr_cleanup [X86]
-	enable_mtrr_cleanup [X86]
+	nomtrr-cleanup [X86]
+	mtrr-cleanup [X86]
 			The kernel tries to adjust MTRR layout from continuous
 			to discrete, to make X server driver able to add WB
 			entry later. This parameter enables/disables that.
Index: linux-2.6/arch/x86/Kconfig
===================================================================
--- linux-2.6.orig/arch/x86/Kconfig
+++ linux-2.6/arch/x86/Kconfig
@@ -1250,7 +1250,7 @@ config MTRR_SANITIZER
 	  Convert MTRR layout from continuous to discrete, so X drivers can
 	  add writeback entries.
 
-	  Can be disabled with disable_mtrr_cleanup on the kernel command line.
+	  Can be disabled with nomtrr-cleanup on the kernel command line.
 	  The largest mtrr entry size for a continous block can be set with
 	  mtrr_chunk_size.
 
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
@@ -834,7 +834,7 @@ static int __init enable_mtrr_cleanup_se
 		enable_mtrr_cleanup = 1;
 	return 0;
 }
-early_param("enable_mtrr_cleanup", enable_mtrr_cleanup_setup);
+early_param("mtrr-cleanup", enable_mtrr_cleanup_setup);
 
 static int __init mtrr_cleanup_debug_setup(char *str)
 {
