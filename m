Return-Path: <linux-kernel-owner+w=401wt.eu-S1754214AbYFUKYO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214AbYFUKYO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 06:24:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754051AbYFUKXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 06:23:43 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:14821 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753305AbYFUKXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 06:23:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=YogTed5yLs5fFdNA0jCqTtTMmO2W8jK9bliizC1m82LWYh2j1Y0V9wnXYjT93sxKBZ
         HrZtAUlQQuTiLq+IB8NNoPvR48J/Byy2d8UmcVt5kjsRHS5RFf5hzuSCq4+u2HREtZms
         4NCnzGKXRLNqTt1sPm+8ASMLha2lXvjiXZ2w4=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] x86: change identify_cpu to static
Date: Sat, 21 Jun 2008 03:24:00 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200806180215.53755.yhlu.kernel@gmail.com> <200806191530.32354.yhlu.kernel@gmail.com> <200806210323.01590.yhlu.kernel@gmail.com>
In-Reply-To: <200806210323.01590.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806210324.01057.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] x86: change identify_cpu to static

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/cpu/common.c    |    2 +-
 arch/x86/kernel/cpu/common_64.c |    2 +-
 include/asm-x86/processor.h     |    1 -
 3 files changed, 2 insertions(+), 3 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/common_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/common_64.c
+++ linux-2.6/arch/x86/kernel/cpu/common_64.c
@@ -312,7 +312,7 @@ static void __cpuinit early_identify_cpu
 /*
  * This does the hard work of actually picking apart the CPU stuff...
  */
-void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
+static void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
 {
 	int i;
 
Index: linux-2.6/arch/x86/kernel/cpu/common.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/common.c
+++ linux-2.6/arch/x86/kernel/cpu/common.c
@@ -427,7 +427,7 @@ __setup("serialnumber", x86_serial_nr_se
 /*
  * This does the hard work of actually picking apart the CPU stuff...
  */
-void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
+static void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
 {
 	int i;
 
Index: linux-2.6/include/asm-x86/processor.h
===================================================================
--- linux-2.6.orig/include/asm-x86/processor.h
+++ linux-2.6/include/asm-x86/processor.h
@@ -155,7 +155,6 @@ static inline int hlt_works(int cpu)
 extern void cpu_detect(struct cpuinfo_x86 *c);
 
 extern void early_cpu_init(void);
-extern void identify_cpu(struct cpuinfo_x86 *);
 extern void identify_boot_cpu(void);
 extern void identify_secondary_cpu(struct cpuinfo_x86 *);
 extern void print_cpu_info(struct cpuinfo_x86 *);
