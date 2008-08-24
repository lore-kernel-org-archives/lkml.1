Return-Path: <linux-kernel-owner+w=401wt.eu-S1756953AbYHXJH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756953AbYHXJH7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 05:07:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755234AbYHXJDX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 05:03:23 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:44109 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628AbYHXJDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 05:03:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=fm8771qKDr5+prUjkMN1ryVeSwzGeHYwtW6rmwa49306edxh7EA65WJSxvxPOj138U
         Ig1g/3OFg/pRxhCSpvOTPLcLdvyrO5E2THpP0buwyPuWAJcG+HAl5BvlaqamFnvSIfgp
         l/zVtFhCe7QWdhKvv/g2fxeZkhtSjErb4FNns=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 14/18] x86: merge header files in apic_xx.c
Date: Sun, 24 Aug 2008 02:01:52 -0700
Message-Id: <1219568516-681-15-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1219568516-681-1-git-send-email-yhlu.kernel@gmail.com>
References: <1219568516-681-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 arch/x86/kernel/apic_32.c |    8 ++++++++
 arch/x86/kernel/apic_64.c |    7 ++++++-
 2 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
index 87566a3..749adb5 100644
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -23,11 +23,13 @@
 #include <linux/mc146818rtc.h>
 #include <linux/kernel_stat.h>
 #include <linux/sysdev.h>
+#include <linux/ioport.h>
 #include <linux/cpu.h>
 #include <linux/clockchips.h>
 #include <linux/acpi_pmtmr.h>
 #include <linux/module.h>
 #include <linux/dmi.h>
+#include <linux/dmar.h>
 
 #include <asm/atomic.h>
 #include <asm/smp.h>
@@ -36,8 +38,14 @@
 #include <asm/desc.h>
 #include <asm/arch_hooks.h>
 #include <asm/hpet.h>
+#include <asm/pgalloc.h>
 #include <asm/i8253.h>
 #include <asm/nmi.h>
+#include <asm/idle.h>
+#include <asm/proto.h>
+#include <asm/timex.h>
+#include <asm/apic.h>
+#include <asm/i8259.h>
 
 #include <mach_apic.h>
 #include <mach_apicdef.h>
diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
index b7268f5..ebe417b 100644
--- a/arch/x86/kernel/apic_64.c
+++ b/arch/x86/kernel/apic_64.c
@@ -24,9 +24,11 @@
 #include <linux/kernel_stat.h>
 #include <linux/sysdev.h>
 #include <linux/ioport.h>
+#include <linux/cpu.h>
 #include <linux/clockchips.h>
 #include <linux/acpi_pmtmr.h>
 #include <linux/module.h>
+#include <linux/dmi.h>
 #include <linux/dmar.h>
 
 #include <asm/atomic.h>
@@ -34,8 +36,10 @@
 #include <asm/mtrr.h>
 #include <asm/mpspec.h>
 #include <asm/desc.h>
+#include <asm/arch_hooks.h>
 #include <asm/hpet.h>
 #include <asm/pgalloc.h>
+#include <asm/i8253.h>
 #include <asm/nmi.h>
 #include <asm/idle.h>
 #include <asm/proto.h>
@@ -43,8 +47,9 @@
 #include <asm/apic.h>
 #include <asm/i8259.h>
 
-#include <mach_ipi.h>
 #include <mach_apic.h>
+#include <mach_apicdef.h>
+#include <mach_ipi.h>
 
 /*
  * Sanity check
-- 
1.5.4.5

