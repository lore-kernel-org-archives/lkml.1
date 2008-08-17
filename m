Return-Path: <linux-kernel-owner+w=401wt.eu-S1753363AbYHQH5I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363AbYHQH5I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 03:57:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751846AbYHQH44
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 03:56:56 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:50204 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814AbYHQH4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 03:56:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=EEoBmAn0ok/6Uc9pqzjBZdoUOYNFstF8AYl7/l2AK1Xy/uLpP4gLHDebsC9A5mFPgv
         grw6dCr9lxz/NuWW7Ei1xs3sJcF+n7DDwJd5QRPU3j4N75K4JxikTps3Zo/JZmSgq/ta
         f+/fj6XrwgjX/aTf+0wRlur8qT+bDZJCGEAeo=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH] x86: print local APIC of APs one by one
Date: Sun, 17 Aug 2008 00:56:06 -0700
Message-Id: <1218959766-13653-1-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

instead of print that of all APs at the time

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/io_apic.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

Index: linux-2.6/arch/x86/kernel/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/io_apic.c
+++ linux-2.6/arch/x86/kernel/io_apic.c
@@ -1784,7 +1784,12 @@ __apicdebuginit(void) print_local_APIC(v
 
 __apicdebuginit(void) print_all_local_APICs(void)
 {
-	on_each_cpu(print_local_APIC, NULL, 1);
+	int cpu;
+
+	preempt_disable();
+	for_each_online_cpu(cpu)
+		smp_call_function_single(cpu, print_local_APIC, NULL, 1);
+	preempt_enable();
 }
 
 __apicdebuginit(void) print_PIC(void)
