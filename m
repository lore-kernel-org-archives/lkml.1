Return-Path: <linux-kernel-owner+w=401wt.eu-S1753273AbYIZMCe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273AbYIZMCe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 08:02:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751374AbYIZMCZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 08:02:25 -0400
Received: from m-relay2.rz.uni-saarland.de ([134.96.7.8]:14567 "EHLO
	eris.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318AbYIZMCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 08:02:24 -0400
From: Alexander van Heukelum <heukelum@fastmail.fm>
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>
Subject: [PATCH 1/7] traps: x86_64: add TRACE_IRQS_OFF in error_entry
Date: Fri, 26 Sep 2008 14:03:02 +0200
Message-Id: <1222430588-29072-2-git-send-email-heukelum@fastmail.fm>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1222430588-29072-1-git-send-email-heukelum@fastmail.fm>
References: <1222430588-29072-1-git-send-email-heukelum@fastmail.fm>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (eris.rz.uni-saarland.de [134.96.7.8]); Fri, 26 Sep 2008 14:02:15 +0200 (CEST)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.8.1.34; VDF: 7.0.6.215; host: AntiVir2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add TRACE_IRQS_OFF just before entering the C code.

All exceptions are taken via interrupt gates. If irq tracing is
enabled, it should be notified as soon as possible. Interrupts
are only (conditionally) re-enabled in C code.

Signed-off-by: Alexander van Heukelum <fastmail.fm>
---
 arch/x86/kernel/entry_64.S |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 89434d4..78fa552 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1058,7 +1058,8 @@ KPROBE_ENTRY(error_entry)
 	je  error_kernelspace
 error_swapgs:	
 	SWAPGS
-error_sti:	
+error_sti:
+	TRACE_IRQS_OFF
 	movq %rdi,RDI(%rsp) 	
 	CFI_REL_OFFSET	rdi,RDI
 	movq %rsp,%rdi
-- 
1.5.4.3

