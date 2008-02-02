Return-Path: <linux-kernel-owner+w=401wt.eu-S1764082AbYBBEFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764082AbYBBEFk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 23:05:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760808AbYBBEFD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 23:05:03 -0500
Received: from qb-out-0506.google.com ([72.14.204.226]:57479 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759670AbYBBEFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 23:05:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=rfUg00O5acUtVYwnYvNiM9b9mgzG3MORitO7gu2z6oYraXgA5GfmPWzycpEmxSy1qGxTAgqR7CCFxgtJqVUKW/HjsefpRSme3mnPSLTXvlG/YtJeJORyiIBMFU3JbyK4qx7MlmF6KMSpT7JQvIibX+sDsVTp0D4RZtYj/RUQK/M=
Subject: [PATCH 2/2] x86: add cpu mtrr init function definitions to mtrr.h
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 01 Feb 2008 20:05:03 -0800
Message-Id: <1201925103.23523.148.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mtrr.h was included everywhere needed.  Fixes the following sparse
warnings.  Also, the return types in the extern definitions were
incorrect.

arch/x86/kernel/cpu/mtrr/amd.c:113:12: warning: symbol 'amd_init_mtrr' was not declared. Should it be static?
arch/x86/kernel/cpu/mtrr/cyrix.c:268:12: warning: symbol 'cyrix_init_mtrr' was not declared. Should it be static?
arch/x86/kernel/cpu/mtrr/centaur.c:218:12: warning: symbol 'centaur_init_mtrr' was not declared. Should it be static?

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/kernel/cpu/mtrr/main.c |    4 ----
 arch/x86/kernel/cpu/mtrr/mtrr.h |    4 ++++
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c
index 822d8f9..1e27b69 100644
--- a/arch/x86/kernel/cpu/mtrr/main.c
+++ b/arch/x86/kernel/cpu/mtrr/main.c
@@ -554,10 +554,6 @@ EXPORT_SYMBOL(mtrr_del);
  * These should be called implicitly, but we can't yet until all the initcall
  * stuff is done...
  */
-extern void amd_init_mtrr(void);
-extern void cyrix_init_mtrr(void);
-extern void centaur_init_mtrr(void);
-
 static void __init init_ifs(void)
 {
 #ifndef CONFIG_X86_64
diff --git a/arch/x86/kernel/cpu/mtrr/mtrr.h b/arch/x86/kernel/cpu/mtrr/mtrr.h
index fb74a2c..2cc77eb 100644
--- a/arch/x86/kernel/cpu/mtrr/mtrr.h
+++ b/arch/x86/kernel/cpu/mtrr/mtrr.h
@@ -97,3 +97,7 @@ void mtrr_state_warn(void);
 const char *mtrr_attrib_to_str(int x);
 void mtrr_wrmsr(unsigned, unsigned, unsigned);
 
+/* CPU specific mtrr init functions */
+int amd_init_mtrr(void);
+int cyrix_init_mtrr(void);
+int centaur_init_mtrr(void);
-- 
1.5.4.rc4.1142.gf5a97

