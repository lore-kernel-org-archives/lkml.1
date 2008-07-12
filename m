Return-Path: <linux-kernel-owner+w=401wt.eu-S1758845AbYGLBpW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758845AbYGLBpW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 21:45:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756117AbYGLBox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 21:44:53 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:36256 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755628AbYGLBow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 21:44:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=pLn00DWQyzxl6NiOndxCCAoJ/X1q7dygrF8k9AvNRi2h1iLRYzaNL+JqM+UPe3P8zJ
         nf+fmd9b4onLMUFDJsmI7SOFsd6HnVs+OkjSuToG9hgc1K1/y1z4xuNm3IEWn7sf3xRm
         dVLRbXFCgCxbkgCuXhqRM+zZhAYP8evl5vQGU=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH] x86: mach_apicdef.h need to include before smp.h
Date: Fri, 11 Jul 2008 18:43:10 -0700
User-Agent: KMail/1.9.9
Cc: LKML <linux-kernel@vger.kernel.org>
References: <200807080141.05436.yhlu.kernel@gmail.com> <200807102038.26591.yhlu.kernel@gmail.com> <200807111841.55403.yhlu.kernel@gmail.com>
In-Reply-To: <200807111841.55403.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807111843.11157.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


smp.h internal has include, so need to include that at first
when genericarch use them need to have different apicdef.h

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/mach-generic/bigsmp.c |    5 ++---
 arch/x86/mach-generic/es7000.c |    3 +--
 arch/x86/mach-generic/numaq.c  |    4 ++--
 arch/x86/mach-generic/summit.c |    5 ++---
 4 files changed, 7 insertions(+), 10 deletions(-)

Index: linux-2.6/arch/x86/mach-generic/bigsmp.c
===================================================================
--- linux-2.6.orig/arch/x86/mach-generic/bigsmp.c
+++ linux-2.6/arch/x86/mach-generic/bigsmp.c
@@ -5,17 +5,16 @@
 #define APIC_DEFINITION 1
 #include <linux/threads.h>
 #include <linux/cpumask.h>
-#include <asm/smp.h>
 #include <asm/mpspec.h>
 #include <asm/genapic.h>
 #include <asm/fixmap.h>
 #include <asm/apicdef.h>
 #include <linux/kernel.h>
-#include <linux/smp.h>
 #include <linux/init.h>
 #include <linux/dmi.h>
-#include <asm/mach-bigsmp/mach_apic.h>
 #include <asm/mach-bigsmp/mach_apicdef.h>
+#include <linux/smp.h>
+#include <asm/mach-bigsmp/mach_apic.h>
 #include <asm/mach-bigsmp/mach_ipi.h>
 #include <asm/mach-default/mach_mpparse.h>
 
Index: linux-2.6/arch/x86/mach-generic/es7000.c
===================================================================
--- linux-2.6.orig/arch/x86/mach-generic/es7000.c
+++ linux-2.6/arch/x86/mach-generic/es7000.c
@@ -4,16 +4,15 @@
 #define APIC_DEFINITION 1
 #include <linux/threads.h>
 #include <linux/cpumask.h>
-#include <asm/smp.h>
 #include <asm/mpspec.h>
 #include <asm/genapic.h>
 #include <asm/fixmap.h>
 #include <asm/apicdef.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
-#include <linux/smp.h>
 #include <linux/init.h>
 #include <asm/mach-es7000/mach_apicdef.h>
+#include <linux/smp.h>
 #include <asm/mach-es7000/mach_apic.h>
 #include <asm/mach-es7000/mach_ipi.h>
 #include <asm/mach-es7000/mach_mpparse.h>
Index: linux-2.6/arch/x86/mach-generic/numaq.c
===================================================================
--- linux-2.6.orig/arch/x86/mach-generic/numaq.c
+++ linux-2.6/arch/x86/mach-generic/numaq.c
@@ -4,7 +4,6 @@
 #define APIC_DEFINITION 1
 #include <linux/threads.h>
 #include <linux/cpumask.h>
-#include <linux/smp.h>
 #include <asm/mpspec.h>
 #include <asm/genapic.h>
 #include <asm/fixmap.h>
@@ -12,8 +11,9 @@
 #include <linux/kernel.h>
 #include <linux/string.h>
 #include <linux/init.h>
-#include <asm/mach-numaq/mach_apic.h>
 #include <asm/mach-numaq/mach_apicdef.h>
+#include <linux/smp.h>
+#include <asm/mach-numaq/mach_apic.h>
 #include <asm/mach-numaq/mach_ipi.h>
 #include <asm/mach-numaq/mach_mpparse.h>
 #include <asm/mach-numaq/mach_wakecpu.h>
Index: linux-2.6/arch/x86/mach-generic/summit.c
===================================================================
--- linux-2.6.orig/arch/x86/mach-generic/summit.c
+++ linux-2.6/arch/x86/mach-generic/summit.c
@@ -4,17 +4,16 @@
 #define APIC_DEFINITION 1
 #include <linux/threads.h>
 #include <linux/cpumask.h>
-#include <asm/smp.h>
 #include <asm/mpspec.h>
 #include <asm/genapic.h>
 #include <asm/fixmap.h>
 #include <asm/apicdef.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
-#include <linux/smp.h>
 #include <linux/init.h>
-#include <asm/mach-summit/mach_apic.h>
 #include <asm/mach-summit/mach_apicdef.h>
+#include <linux/smp.h>
+#include <asm/mach-summit/mach_apic.h>
 #include <asm/mach-summit/mach_ipi.h>
 #include <asm/mach-summit/mach_mpparse.h>
 
