Return-Path: <linux-kernel-owner+w=401wt.eu-S1757277AbZETXTX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757277AbZETXTX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 19:19:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756866AbZETXSZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 19:18:25 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:58332 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756832AbZETXSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 19:18:23 -0400
X-Sasl-enc: p2q60ThIwPTkDm8F8IhRMRrYAkK4HZVQh1cC9HCXB0RM 1242861504
From: Alexander van Heukelum <heukelum@fastmail.fm>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Cc: Jan Beulich <JBeulich@novell.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       Alexander van Heukelum <heukelum@fastmail.fm>
Subject: [PATCH] i386, entry_32: use zeroentry for iret_exc
Date: Thu, 21 May 2009 01:18:04 +0200
Message-Id: <1242861486-7255-7-git-send-email-heukelum@fastmail.fm>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1242861486-7255-1-git-send-email-heukelum@fastmail.fm>
References: <1242861486-7255-1-git-send-email-heukelum@fastmail.fm>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

iret_exc uses the error_code path. Use the zeroentry macro here too. This
adds some dwarf2 annotations to the object file, but the executable code
is unchanged.

impact: prepare for removing indirect calls in error_code

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
---
 arch/x86/kernel/entry_32.S |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 29dcd74..407443c 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -533,10 +533,7 @@ restore_nocheck_notrace:
 irq_return:
 	INTERRUPT_RETURN
 .section .fixup,"ax"
-ENTRY(iret_exc)
-	pushl $0			# no error code
-	pushl $do_iret_error
-	jmp error_code
+zeroentry iret_exc do_iret_error
 .previous
 .section __ex_table,"a"
 	.align 4
-- 
1.6.0.4

