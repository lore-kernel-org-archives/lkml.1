Return-Path: <linux-kernel-owner+w=401wt.eu-S1753381AbYCLNzT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381AbYCLNzT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 09:55:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751508AbYCLNzH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 09:55:07 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:35170 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483AbYCLNzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 09:55:07 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: mingo@redhat.com
Cc: <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Jiri Slaby <jirislaby@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] Arch: x86_32, fix fault_msg nul termination
Date: Wed, 12 Mar 2008 14:53:53 +0100
Message-Id: <1205330034-28828-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The fault_msg text is not explictly nul terminated now in startup
assembly. Do so by converting .ascii to .asciz.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/head_32.S |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index 9e7e015..826988a 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -657,7 +657,7 @@ int_msg:
 	.asciz "Unknown interrupt or fault at EIP %p %p %p\n"
 
 fault_msg:
-	.ascii								\
+	.asciz								\
 /* fault info: */	"BUG: Int %d: CR2 %p\n"				\
 /* pusha regs: */	"     EDI %p  ESI %p  EBP %p  ESP %p\n"		\
 			"     EBX %p  EDX %p  ECX %p  EAX %p\n"		\
-- 
1.5.4.1

