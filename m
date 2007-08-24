Return-Path: <linux-kernel-owner+w=401wt.eu-S1756653AbXHXPgk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756653AbXHXPgk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 11:36:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751245AbXHXPga
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 11:36:30 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:50092 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877AbXHXPga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 11:36:30 -0400
Message-ID: <46CEFB03.5040302@bull.net>
Date: Fri, 24 Aug 2007 17:36:35 +0200
From: Laurent Vivier <Laurent.Vivier@bull.net>
Organization: Bull S.A.S.
User-Agent: Thunderbird 1.5.0.2 (X11/20060420)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Avi Kivity <avi@qumranet.com>
Subject: [PATCH] export i386 smp_call_function_mask() to modules
X-Enigmail-Version: 0.94.0.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 24/08/2007 17:41:48,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 24/08/2007 17:41:49,
	Serialize complete at 24/08/2007 17:41:49
Content-Type: multipart/mixed;
 boundary="------------010301080004060803080204"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010301080004060803080204
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1

This patch export i386 smp_call_function_mask() with EXPORT_SYMBOL().

This function is needed by KVM to call a function on a set of CPUs.

 arch/i386/kernel/smp.c |    7 +++++++
 include/asm-i386/smp.h |    9 +++------
 2 files changed, 10 insertions(+), 6 deletions(-)

Signed-off-by: Laurent Vivier <Laurent.Vivier@bull.net>

--------------010301080004060803080204
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
 name="smp_call_function_mask-i386"
Content-Disposition: inline;
 filename="smp_call_function_mask-i386"

Index: kvm/arch/i386/kernel/smp.c
===================================================================
--- kvm.orig/arch/i386/kernel/smp.c	2007-08-24 17:09:46.000000000 +0200
+++ kvm/arch/i386/kernel/smp.c	2007-08-24 17:09:48.000000000 +0200
@@ -705,3 +705,10 @@ struct smp_ops smp_ops = {
 	.smp_send_reschedule = native_smp_send_reschedule,
 	.smp_call_function_mask = native_smp_call_function_mask,
 };
+
+int smp_call_function_mask(cpumask_t mask, void (*func) (void *info),
+			   void *info, int wait)
+{
+	return smp_ops.smp_call_function_mask(mask, func, info, wait);
+}
+EXPORT_SYMBOL(smp_call_function_mask);
Index: kvm/include/asm-i386/smp.h
===================================================================
--- kvm.orig/include/asm-i386/smp.h	2007-08-24 17:09:46.000000000 +0200
+++ kvm/include/asm-i386/smp.h	2007-08-24 17:10:34.000000000 +0200
@@ -92,12 +92,9 @@ static inline void smp_send_reschedule(i
 {
 	smp_ops.smp_send_reschedule(cpu);
 }
-static inline int smp_call_function_mask(cpumask_t mask,
-					 void (*func) (void *info), void *info,
-					 int wait)
-{
-	return smp_ops.smp_call_function_mask(mask, func, info, wait);
-}
+extern int smp_call_function_mask(cpumask_t mask,
+				  void (*func) (void *info), void *info,
+				  int wait);
 
 void native_smp_prepare_boot_cpu(void);
 void native_smp_prepare_cpus(unsigned int max_cpus);

--------------010301080004060803080204--
