Return-Path: <linux-kernel-owner+w=401wt.eu-S1753840AbYKZTSQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840AbYKZTSQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 14:18:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752938AbYKZTRN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 14:17:13 -0500
Received: from gv-out-0910.google.com ([216.239.58.191]:27051 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690AbYKZTRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 14:17:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=O19rSFrD/RV7lHL7o+xTrDMxLfIPUv2eFd0boENn22v5jSFjMs+5WZvjRzFIZgrWIc
         6/r1SpDMzv98rZq93nkhVSFJbwsKNa6Riis11byjHZvsI5H9dg7rxJjK/xbCbb1zc/gT
         ueszmIOPCT7z8Thm8L7twZ9CCTTVvKEsqZteo=
From: gorcunov@gmail.com
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org, heukelum@fastmail.fm,
       Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [PATCH 3/5] x86: entry_64.S - use X86_EFLAGS_IF instead of hardcoded number
Date: Wed, 26 Nov 2008 22:17:02 +0300
Message-Id: <6bc2fd402754cfa5b69a63a529bc065584c5f375.1227725632.git.gorcunov@gmail.com>
X-Mailer: git-send-email 1.6.0.4.603.gbc9c0
In-Reply-To: <cc7949234e3ac0ddb402764be5ed620035f964a6.1227725632.git.gorcunov@gmail.com>
References: <1227727024-2281-1-git-send-email-gorcunov@gmail.com>
 <82259867e200855889261370c29bbd15a111d7fb.1227725632.git.gorcunov@gmail.com>
 <cc7949234e3ac0ddb402764be5ed620035f964a6.1227725632.git.gorcunov@gmail.com>
In-Reply-To: <82259867e200855889261370c29bbd15a111d7fb.1227725632.git.gorcunov@gmail.com>
References: <82259867e200855889261370c29bbd15a111d7fb.1227725632.git.gorcunov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cyrill Gorcunov <gorcunov@gmail.com>

Impact: cleanup

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---
 arch/x86/kernel/entry_64.S |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 7b52b0f..c409f73 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -199,7 +199,7 @@ ENTRY(native_usergs_sysret64)
 	pushq %rax /* rsp */
 	CFI_ADJUST_CFA_OFFSET	8
 	CFI_REL_OFFSET	rsp,0
-	pushq $(1<<9) /* eflags - interrupts on */
+	pushq $X86_EFLAGS_IF /* eflags - interrupts on */
 	CFI_ADJUST_CFA_OFFSET	8
 	/*CFI_REL_OFFSET	rflags,0*/
 	pushq $__KERNEL_CS /* cs */
-- 
1.6.0.4.603.gbc9c0

