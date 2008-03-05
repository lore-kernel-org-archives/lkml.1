Return-Path: <linux-kernel-owner+w=401wt.eu-S1764139AbYCEIg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764139AbYCEIg0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 03:36:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754506AbYCEIgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 03:36:18 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:10589
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753947AbYCEIgR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 03:36:17 -0500
Message-Id: <47CE69B0.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 Beta 
Date: Wed, 05 Mar 2008 08:36:48 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: fix typo(?) in step.c
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TIF_DEBUGCTLMSR has no meaning in the actual MSR...

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/kernel/step.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.25-rc4/arch/x86/kernel/step.c	2008-03-05 09:26:15.000000000 +0100
+++ 2.6.25-rc4-x86-step-typo/arch/x86/kernel/step.c	2008-03-04 10:15:40.000000000 +0100
@@ -166,7 +166,7 @@ static void enable_step(struct task_stru
 				  child->thread.debugctlmsr | DEBUGCTLMSR_BTF);
 	} else {
 	    write_debugctlmsr(child,
-			      child->thread.debugctlmsr & ~TIF_DEBUGCTLMSR);
+			      child->thread.debugctlmsr & ~DEBUGCTLMSR_BTF);
 
 	    if (!child->thread.debugctlmsr)
 		    clear_tsk_thread_flag(child, TIF_DEBUGCTLMSR);
@@ -189,7 +189,7 @@ void user_disable_single_step(struct tas
 	 * Make sure block stepping (BTF) is disabled.
 	 */
 	write_debugctlmsr(child,
-			  child->thread.debugctlmsr & ~TIF_DEBUGCTLMSR);
+			  child->thread.debugctlmsr & ~DEBUGCTLMSR_BTF);
 
 	if (!child->thread.debugctlmsr)
 		clear_tsk_thread_flag(child, TIF_DEBUGCTLMSR);



