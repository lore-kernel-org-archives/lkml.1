Return-Path: <linux-kernel-owner+w=401wt.eu-S1752935AbYHPTXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935AbYHPTXb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 15:23:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752031AbYHPTVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 15:21:52 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:19721 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786AbYHPTVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 15:21:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=DSPsGqtrFCjbkSh4vb9IAygEaldc67ZX27uusuOciTZj2lZYIhGRMpgfe0II+0dS2Y
         Ntj2mGixGAVm1mYn2XirbbV5pyWlLYMMGWCgfwKI+FGmSZmcacuvOuIjcHgIProH8c47
         Eq7XYDclwrVCcuEahdM39gCsgoZfo/k5oRUKw=
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de, macro@linux-mips.org,
       linux-kernel@vger.kernel.org
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [PATCH 5/6] x86: apic - unify lapic_is_integrated
Date: Sat, 16 Aug 2008 23:21:54 +0400
Message-Id: <2d50651150912bee93e30485c0307eeb74ab1143.1218914042.git.gorcunov@gmail.com>
X-Mailer: git-send-email 1.6.0.rc1.34.g0fe8c
In-Reply-To: <e752642559f71f83b08df6bc44864a5946147279.1218914042.git.gorcunov@gmail.com>
References: <1218914515-26377-1-git-send-email-gorcunov@gmail.com>
 <f87881899957b7aa08b827cdc6b5dd8cf53e4730.1218914042.git.gorcunov@gmail.com>
 <722b5bc0303212ca203cadeedae5ede3e23eccb7.1218914042.git.gorcunov@gmail.com>
 <7bef3d3fb91a430ad3a461f59c8a5140fa1e9d87.1218914042.git.gorcunov@gmail.com>
 <e752642559f71f83b08df6bc44864a5946147279.1218914042.git.gorcunov@gmail.com>
In-Reply-To: <f87881899957b7aa08b827cdc6b5dd8cf53e4730.1218914042.git.gorcunov@gmail.com>
References: <f87881899957b7aa08b827cdc6b5dd8cf53e4730.1218914042.git.gorcunov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---
 arch/x86/kernel/apic_32.c |    4 ++++
 arch/x86/kernel/apic_64.c |    6 +++++-
 2 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
index 9e8702e..41134d4 100644
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -128,7 +128,11 @@ static inline int lapic_get_version(void)
  */
 static inline int lapic_is_integrated(void)
 {
+#ifdef CONFIG_X86_64
+	return 1;
+#else
 	return APIC_INTEGRATED(lapic_get_version());
+#endif
 }
 
 /*
diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
index 46523c0..18c0b8c 100644
--- a/arch/x86/kernel/apic_64.c
+++ b/arch/x86/kernel/apic_64.c
@@ -111,11 +111,15 @@ static inline int lapic_get_version(void)
 }
 
 /*
- * Check, if the APIC is integrated or a seperate chip
+ * Check, if the APIC is integrated or a separate chip
  */
 static inline int lapic_is_integrated(void)
 {
+#ifdef CONFIG_X86_64
 	return 1;
+#else
+	return APIC_INTEGRATED(lapic_get_version());
+#endif
 }
 
 /*
-- 
1.6.0.rc1.34.g0fe8c

