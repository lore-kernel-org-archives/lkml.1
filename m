Return-Path: <linux-kernel-owner+w=401wt.eu-S1755440AbYEXPoL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440AbYEXPoL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 11:44:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756674AbYEXPl6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 11:41:58 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:10483 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755845AbYEXPly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 11:41:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:user-agent:date:from:to:cc:subject:content-disposition:message-id;
        b=g3duqjjs3zgii8VAeTL4lv4I08e3sJ/BzjAou4N0k9W+ghETyKrpbHKw+PFjM6f72e0xk4eBllY+Q0xInHBT4N1rI2njR+RkdlilyTJq7r2gmyuGJn37CiLxgF6dNhwlKWz+xb8tUBeJr+GHpJ8i7hHs+Tbjb5G6FjKZvQpySYE=
References: <20080524153630.669797039@gmail.com>>
User-Agent: quilt/0.46-1
Date: Sat, 24 May 2008 19:36:38 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com,
       linux-kernel@vger.kernel.org
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [patch 08/11] x86: nmi_64.c - use for_each_possible_cpu helper instead of for statement
Content-Disposition: inline; filename=nmi-64-use-for-each-possible-cpu
Message-ID: <48383741.0b38560a.1840.ffff8258@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Index: linux-2.6.git/arch/x86/kernel/nmi_64.c
====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/nmi_64.c	2008-05-24 13:09:27.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/nmi_64.c	2008-05-24 13:17:59.000000000 +0400
@@ -98,7 +98,7 @@ int __init check_nmi_watchdog(void)
 		smp_call_function(nmi_cpu_busy, (void *)&endflag, 0, 0);
 #endif
 
-	for (cpu = 0; cpu < NR_CPUS; cpu++)
+	for_each_possible_cpu(cpu)
 		prev_nmi_count[cpu] = cpu_pda(cpu)->__nmi_count;
 	local_irq_enable();
 	mdelay((20*1000)/nmi_hz); // wait 20 ticks

-- 
