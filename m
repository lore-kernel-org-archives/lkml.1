Return-Path: <linux-kernel-owner+w=401wt.eu-S1758122AbYAJHSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758122AbYAJHSR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 02:18:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752851AbYAJHSG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 02:18:06 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:23498 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844AbYAJHSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 02:18:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=wJ++Wy8L9+DsVFAHggJsOtGClyYL3FKkbizLfe5xzvgXithzWPw1UKt5eKFEF8w7WNAibYD/IMWLeo5OXGCHBQiuD6riOnppOIeu5NioL6gjT865LqMD1uqdz6+qxveJWPjeJtfUGswS31PlnBWEkd93qtDH6kUaD+2vT51P0Ew=
Subject: [PATCH] x86: Remove ifdef from step.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 09 Jan 2008 23:18:02 -0800
Message-Id: <1199949482.19760.9.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Similar cleanup was done when unifying kprobes_32|64.c and
wrmsr() was chosen there over wrmsrl().

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Ingo, only chose this direction based on the kprobes.c unification.

 arch/x86/kernel/step.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/step.c b/arch/x86/kernel/step.c
index 21ea22f..d73c537 100644
--- a/arch/x86/kernel/step.c
+++ b/arch/x86/kernel/step.c
@@ -148,11 +148,7 @@ static void write_debugctlmsr(struct task_struct *child, unsigned long val)
 	if (child != current)
 		return;
 
-#ifdef CONFIG_X86_64
-	wrmsrl(MSR_IA32_DEBUGCTLMSR, val);
-#else
 	wrmsr(MSR_IA32_DEBUGCTLMSR, val, 0);
-#endif
 }
 
 /*
-- 
1.5.4.rc2.1164.g6451

