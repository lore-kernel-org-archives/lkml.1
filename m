Return-Path: <linux-kernel-owner+w=401wt.eu-S1755081AbYITBmB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755081AbYITBmB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 21:42:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751408AbYITBlw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 21:41:52 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:65512 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbYITBlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 21:41:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=P3mflBsZ66guNISjGoiwV6OVaKTRRCNqoEi/rrmvyq4W3FmCDDUwky1aoZ7PLW8RhM
         /6CcjQsXX5Y85cfzQW/3S87LYHx2hCOZqfcTq8fiSTB0niNGcOttvG74OQLB4R/vJbbA
         atKmcpwViBUWGleGjcxYuL8W4pt1ly4zkXCwg=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH] x86: cpu don't print duplicated vendor string
Date: Fri, 19 Sep 2008 18:41:16 -0700
Message-Id: <1221874876-12941-1-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some CPUs have vendor string in the middle of model_id instead of beginning

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/cpu/common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/arch/x86/kernel/cpu/common.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/common.c
+++ linux-2.6/arch/x86/kernel/cpu/common.c
@@ -797,7 +797,7 @@ void __cpuinit print_cpu_info(struct cpu
 	else if (c->cpuid_level >= 0)
 		vendor = c->x86_vendor_id;
 
-	if (vendor && strncmp(c->x86_model_id, vendor, strlen(vendor)))
+	if (vendor && !strstr(c->x86_model_id, vendor))
 		printk(KERN_CONT "%s ", vendor);
 
 	if (c->x86_model_id[0])
