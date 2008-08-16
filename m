Return-Path: <linux-kernel-owner+w=401wt.eu-S1753090AbYHPTWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090AbYHPTWS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 15:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751837AbYHPTVs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 15:21:48 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:19721 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbYHPTVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 15:21:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=utri1HTLk1XN01f77+OHV7DB4X58TjanBSbOYB7kAWMxghLE0ns3i9ChkNN5TlkeIj
         pSTNogFRNuZ9e0hGPvGwGQAZKjOqHG7xAj1ScVnPKRsqUupZcs10MNtGuqgcwFc3nfH2
         UgiT1TypMZ44LAGcjz2/OAueNPnOqpOPu5LPM=
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de, macro@linux-mips.org,
       linux-kernel@vger.kernel.org
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [PATCH 3/6] x86: apic - unify lapic_suspend
Date: Sat, 16 Aug 2008 23:21:52 +0400
Message-Id: <7bef3d3fb91a430ad3a461f59c8a5140fa1e9d87.1218914042.git.gorcunov@gmail.com>
X-Mailer: git-send-email 1.6.0.rc1.34.g0fe8c
In-Reply-To: <722b5bc0303212ca203cadeedae5ede3e23eccb7.1218914042.git.gorcunov@gmail.com>
References: <1218914515-26377-1-git-send-email-gorcunov@gmail.com>
 <f87881899957b7aa08b827cdc6b5dd8cf53e4730.1218914042.git.gorcunov@gmail.com>
 <722b5bc0303212ca203cadeedae5ede3e23eccb7.1218914042.git.gorcunov@gmail.com>
In-Reply-To: <f87881899957b7aa08b827cdc6b5dd8cf53e4730.1218914042.git.gorcunov@gmail.com>
References: <f87881899957b7aa08b827cdc6b5dd8cf53e4730.1218914042.git.gorcunov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---
 arch/x86/kernel/apic_32.c |    2 +-
 arch/x86/kernel/apic_64.c |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
index 3d40213..6cb8aaa 100644
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -1582,7 +1582,7 @@ static int lapic_suspend(struct sys_device *dev, pm_message_t state)
 	apic_pm_state.apic_lvterr = apic_read(APIC_LVTERR);
 	apic_pm_state.apic_tmict = apic_read(APIC_TMICT);
 	apic_pm_state.apic_tdcr = apic_read(APIC_TDCR);
-#ifdef CONFIG_X86_MCE_P4THERMAL
+#if defined(CONFIG_X86_MCE_P4THERMAL) || defined(CONFIG_X86_MCE_INTEL)
 	if (maxlvt >= 5)
 		apic_pm_state.apic_thmr = apic_read(APIC_LVTTHMR);
 #endif
diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
index e542a2d..13dea93 100644
--- a/arch/x86/kernel/apic_64.c
+++ b/arch/x86/kernel/apic_64.c
@@ -1390,10 +1390,11 @@ static int lapic_suspend(struct sys_device *dev, pm_message_t state)
 	apic_pm_state.apic_lvterr = apic_read(APIC_LVTERR);
 	apic_pm_state.apic_tmict = apic_read(APIC_TMICT);
 	apic_pm_state.apic_tdcr = apic_read(APIC_TDCR);
-#ifdef CONFIG_X86_MCE_INTEL
+#if defined(CONFIG_X86_MCE_P4THERMAL) || defined(CONFIG_X86_MCE_INTEL)
 	if (maxlvt >= 5)
 		apic_pm_state.apic_thmr = apic_read(APIC_LVTTHMR);
 #endif
+
 	local_irq_save(flags);
 	disable_local_APIC();
 	local_irq_restore(flags);
-- 
1.6.0.rc1.34.g0fe8c

