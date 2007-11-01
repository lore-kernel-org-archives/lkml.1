Return-Path: <linux-kernel-owner+w=401wt.eu-S1758356AbXKAMke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758356AbXKAMke (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 08:40:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752655AbXKAMk0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 08:40:26 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48337 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751009AbXKAMk0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 08:40:26 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH] show right output for cpuinfo
Date: Thu,  1 Nov 2007 06:56:00 -0300
Message-Id: <1193910960937-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

in x86_64 smp systems, a regression was introduced a few days after 2.6.23,
on its way to 2.6.23. Bisection leads me to commit
92cb7612aee39642d109b8d935ad265e602c0563.

The problem is that the output of 'cat /proc/cpuinfo' shows 0 as the id of
all cpus of a smp system. As far as I know, this only happens on x86_64
systems.

This problem was first noticed by Ravikiran. A simple patch follows

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
Cc: Ravikiran Thirumalai <kiran@scalemp.com>
---
 arch/x86/kernel/setup_64.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/setup_64.c b/arch/x86/kernel/setup_64.c
index 0f0d9d4..eb41c99 100644
--- a/arch/x86/kernel/setup_64.c
+++ b/arch/x86/kernel/setup_64.c
@@ -858,7 +858,6 @@ void __cpuinit early_identify_cpu(struct cpuinfo_x86 *c)
 
 #ifdef CONFIG_SMP
 	c->phys_proc_id = (cpuid_ebx(1) >> 24) & 0xff;
-	c->cpu_index = 0;
 #endif
 }
 
-- 
1.4.4.2

