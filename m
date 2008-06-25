Return-Path: <linux-kernel-owner+w=401wt.eu-S1757832AbYFYFN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757832AbYFYFN1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 01:13:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753129AbYFYFMx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 01:12:53 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:50854 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714AbYFYFMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 01:12:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :message-id;
        b=pVaAkVV7V+vSM16qePI+pkPBkqJB0xKRJkEV4XH+vhec/t9YBdNAs5jRQmyLY1PBbn
         pMZ7iJcpvSQ3WGi+hz+AI5TYUuB0JgxNZJqcx3lBeKS8emRjyqx+5S2NXQ6iMzdWZVgi
         rdPWj5aiNYwn5Xh4B6bHRE30pVnM8sM57ZCwA=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: numa 32 using apicid_2_node to get node for logical_apicid
Date: Tue, 24 Jun 2008 22:13:15 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806242213.15310.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 include/asm-x86/mach-bigsmp/mach_apic.h  |    2 +-
 include/asm-x86/mach-default/mach_apic.h |    4 ++++
 2 files changed, 5 insertions(+), 1 deletion(-)

Index: linux-2.6/include/asm-x86/mach-bigsmp/mach_apic.h
===================================================================
--- linux-2.6.orig/include/asm-x86/mach-bigsmp/mach_apic.h
+++ linux-2.6/include/asm-x86/mach-bigsmp/mach_apic.h
@@ -81,7 +81,7 @@ static inline int multi_timer_check(int 
 
 static inline int apicid_to_node(int logical_apicid)
 {
-	return (0);
+	return apicid_2_node[hard_smp_processor_id()];
 }
 
 static inline int cpu_present_to_apicid(int mps_cpu)
Index: linux-2.6/include/asm-x86/mach-default/mach_apic.h
===================================================================
--- linux-2.6.orig/include/asm-x86/mach-default/mach_apic.h
+++ linux-2.6/include/asm-x86/mach-default/mach_apic.h
@@ -77,7 +77,11 @@ static inline void setup_apic_routing(vo
 
 static inline int apicid_to_node(int logical_apicid)
 {
+#ifdef CONFIG_SMP
+	return apicid_2_node[hard_smp_processor_id()];
+#else
 	return 0;
+#endif
 }
 #endif
 
