Return-Path: <linux-kernel-owner+w=401wt.eu-S1762696AbZAWLBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762696AbZAWLBs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 06:01:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757036AbZAWLAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 06:00:43 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:5663 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760243AbZAWLAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 06:00:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=ryK+5bxQ4DohkeaogIdJWElYEg8dJLJOqWCW+Fe/UReig3ucRaOZebkB07b8l/LTQF
         aSaVj6qURAWse5Qyvc4nfyVHJpzrX0rYab5h8jlD9ohSkd9xTuhuZ1fc1OetqUfACl9U
         sI4sC073u9pwEvB7iUUaKyCKlda6Ndc57o9C0=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: johnstul@us.ibm.com, gregkh@suse.de, roel.kluin@gmail.com,
       lethal@linux-sh.org, Magnus Damm <magnus.damm@gmail.com>,
       akpm@linux-foundation.org, mingo@redhat.com, tglx@linutronix.de
Date: Fri, 23 Jan 2009 19:58:39 +0900
Message-Id: <20090123105839.18779.23252.sendpatchset@rx1.opensource.se>
In-Reply-To: <20090123105721.18779.80514.sendpatchset@rx1.opensource.se>
References: <20090123105721.18779.80514.sendpatchset@rx1.opensource.se>
Subject: [PATCH 006/011] sh: plat_early_device_setup() for sh4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@igel.co.jp>

This patch adds sh4 code to register early platform devices
using plat_early_device_setup().

Signed-off-by: Magnus Damm <damm@igel.co.jp>
---

 arch/sh/kernel/cpu/sh4/setup-sh4-202.c |    5 +++++
 arch/sh/kernel/cpu/sh4/setup-sh7750.c  |    5 +++++
 arch/sh/kernel/cpu/sh4/setup-sh7760.c  |    5 +++++
 3 files changed, 15 insertions(+)

--- 0011/arch/sh/kernel/cpu/sh4/setup-sh4-202.c
+++ work/arch/sh/kernel/cpu/sh4/setup-sh4-202.c	2009-01-23 17:01:55.000000000 +0900
@@ -38,6 +38,11 @@ static int __init sh4202_devices_setup(v
 }
 __initcall(sh4202_devices_setup);
 
+void __init plat_early_device_setup(void)
+{
+	early_platform_add_devices(sh4202_devices, ARRAY_SIZE(sh4202_devices));
+}
+
 void __init plat_irq_setup(void)
 {
 	/* do nothing - all IRL interrupts are handled by the board code */
--- 0011/arch/sh/kernel/cpu/sh4/setup-sh7750.c
+++ work/arch/sh/kernel/cpu/sh4/setup-sh7750.c	2009-01-23 17:00:28.000000000 +0900
@@ -95,6 +95,11 @@ static int __init sh7750_devices_setup(v
 }
 __initcall(sh7750_devices_setup);
 
+void __init plat_early_device_setup(void)
+{
+	early_platform_add_devices(sh7750_devices, ARRAY_SIZE(sh7750_devices));
+}
+
 enum {
 	UNUSED = 0,
 
--- 0011/arch/sh/kernel/cpu/sh4/setup-sh7760.c
+++ work/arch/sh/kernel/cpu/sh4/setup-sh7760.c	2009-01-23 17:01:29.000000000 +0900
@@ -207,6 +207,11 @@ static int __init sh7760_devices_setup(v
 }
 __initcall(sh7760_devices_setup);
 
+void __init plat_early_device_setup(void)
+{
+	early_platform_add_devices(sh7760_devices, ARRAY_SIZE(sh7760_devices));
+}
+
 #define INTC_ICR	0xffd00000UL
 #define INTC_ICR_IRLM	(1 << 7)
 
