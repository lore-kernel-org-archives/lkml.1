Return-Path: <linux-kernel-owner+w=401wt.eu-S1763580AbYF3SLc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763580AbYF3SLc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 14:11:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932214AbYF3SLU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 14:11:20 -0400
Received: from gw.goop.org ([64.81.55.164]:55768 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932202AbYF3SLS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 14:11:18 -0400
Message-ID: <486921AD.8010409@goop.org>
Date: Mon, 30 Jun 2008 11:10:53 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86_64/paravirt: fix compile errors with IA32_EMULATION off
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/kernel/paravirt.c |    4 ++++
 1 file changed, 4 insertions(+)

===================================================================
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -349,9 +349,13 @@
 	.write_idt_entry = native_write_idt_entry,
 	.load_sp0 = native_load_sp0,
 
+#if defined(CONFIG_X86_32) || defined(CONFIG_IA32_EMULATION)
 	.irq_enable_sysexit = native_irq_enable_sysexit,
+#endif
 #ifdef CONFIG_X86_64
+#ifdef CONFIG_IA32_EMULATION
 	.usergs_sysret32 = native_usergs_sysret32,
+#endif
 	.usergs_sysret64 = native_usergs_sysret64,
 #endif
 	.iret = native_iret,


