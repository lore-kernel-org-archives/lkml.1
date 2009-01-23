Return-Path: <linux-kernel-owner+w=401wt.eu-S1760386AbZAWLAT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760386AbZAWLAT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 06:00:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755749AbZAWK7w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 05:59:52 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:5663 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761035AbZAWK7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 05:59:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=uTXFGjjZhyxlk7fSA+3vo1UrgVh0eiywfX/qdiZMA9icGbBL6ZTmAIAszvzMr0hfbl
         Fnzj1DJkr6tqy7DtsOknbtlGz6WbxCfHzRHfRtS84BHXRUPo9ioKy5ltC1IkyHiJM1ZU
         ORWMbx3WoTHEKcwmLIuZ2htEmZHkTtztgtfuc=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, johnstul@us.ibm.com, gregkh@suse.de,
       roel.kluin@gmail.com, lethal@linux-sh.org, tglx@linutronix.de,
       mingo@redhat.com, Magnus Damm <magnus.damm@gmail.com>
Date: Fri, 23 Jan 2009 19:57:50 +0900
Message-Id: <20090123105750.18779.89143.sendpatchset@rx1.opensource.se>
In-Reply-To: <20090123105721.18779.80514.sendpatchset@rx1.opensource.se>
References: <20090123105721.18779.80514.sendpatchset@rx1.opensource.se>
Subject: [PATCH 002/011] sh: add plat_early_device_setup() function
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@igel.co.jp>

This patch adds the function plat_early_device_setup() which
cpu code can use for early platform device registation.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
---

 arch/sh/include/asm/device.h |    2 ++
 arch/sh/kernel/setup.c       |    7 +++++++
 2 files changed, 9 insertions(+)

--- 0001/arch/sh/include/asm/device.h
+++ work/arch/sh/include/asm/device.h	2009-01-22 17:03:40.000000000 +0900
@@ -10,3 +10,5 @@ struct platform_device;
 int platform_resource_setup_memory(struct platform_device *pdev,
 				   char *name, unsigned long memsize);
 
+void plat_early_device_setup(void);
+
--- 0001/arch/sh/kernel/setup.c
+++ work/arch/sh/kernel/setup.c	2009-01-22 17:06:39.000000000 +0900
@@ -29,6 +29,7 @@
 #include <linux/mmzone.h>
 #include <linux/clk.h>
 #include <linux/delay.h>
+#include <linux/platform_device.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
 #include <asm/page.h>
@@ -329,6 +330,10 @@ static int __init parse_elfcorehdr(char 
 early_param("elfcorehdr", parse_elfcorehdr);
 #endif
 
+void __init __attribute__ ((weak)) plat_early_device_setup(void)
+{
+}
+
 void __init setup_arch(char **cmdline_p)
 {
 	enable_mmu();
@@ -382,6 +387,8 @@ void __init setup_arch(char **cmdline_p)
 
 	parse_early_param();
 
+	plat_early_device_setup();
+
 	sh_mv_setup();
 
 	/*
