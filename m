Return-Path: <linux-kernel-owner+w=401wt.eu-S1760473AbYEXPo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760473AbYEXPo1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 11:44:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756926AbYEXPl6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 11:41:58 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:10446 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755873AbYEXPlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 11:41:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:user-agent:date:from:to:cc:subject:content-disposition:message-id;
        b=DH+R2q/PRwfRQSGPBVW5G3v6fWaU8o/Gx4rSVC80EYvs9h8H+zLb3x5EFcTK10UKy3UkmfVKlDJA1P35e9sDvwTr/VuF1iGeMZFtDg7k66zB5JPv7I7TtCcX9xK62yqBgAGdCHQvN76jSp++ylzNUPDotCdETxpBK1Kgyg86i8Y=
References: <20080524153630.669797039@gmail.com>>
User-Agent: quilt/0.46-1
Date: Sat, 24 May 2008 19:36:39 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com,
       linux-kernel@vger.kernel.org
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [patch 09/11] x86: nmi_32.c cleanup - use for_each_online_cpu helper
Content-Disposition: inline; filename=nmi-32-use-for-each-online-cpu
Message-ID: <48383741.0637560a.7c8f.3b2a@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since cpu_online_map is touched (by for_each_online_cpu)
at moment when cpu_callin_map is already filled up we can
get rid of its checking at all

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Index: linux-2.6.git/arch/x86/kernel/nmi_32.c
====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/nmi_32.c	2008-05-24 13:16:48.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/nmi_32.c	2008-05-24 13:20:13.000000000 +0400
@@ -108,13 +108,7 @@ int __init check_nmi_watchdog(void)
 	local_irq_enable();
 	mdelay((20*1000)/nmi_hz); // wait 20 ticks
 
-	for_each_possible_cpu(cpu) {
-#ifdef CONFIG_SMP
-		/* Check cpu_callin_map here because that is set
-		   after the timer is started. */
-		if (!cpu_isset(cpu, cpu_callin_map))
-			continue;
-#endif
+	for_each_online_cpu(cpu) {
 		if (!per_cpu(wd_enabled, cpu))
 			continue;
 		if (nmi_count(cpu) - prev_nmi_count[cpu] <= 5) {

-- 
