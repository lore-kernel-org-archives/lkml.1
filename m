Return-Path: <linux-kernel-owner+w=401wt.eu-S932098Ab0ARThB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098Ab0ARThB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 14:37:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752001Ab0ARTg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 14:36:59 -0500
Received: from hera.kernel.org ([140.211.167.34]:36898 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751948Ab0ARTg6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 14:36:58 -0500
Date: Mon, 18 Jan 2010 19:36:33 GMT
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       zach@vmware.com, suresh.b.siddha@intel.com, akataria@vmware.com,
       tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       suresh.b.siddha@intel.com, zach@vmware.com, tglx@linutronix.de,
       akataria@vmware.com
In-Reply-To: <20100114002118.436172066@sbs-t61.sc.intel.com>
References: <20100114002118.436172066@sbs-t61.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, vmi: Fix vmi_get_timer_vector() to use IRQ0_VECTOR
Message-ID: <tip-722b3654852e48b93367a63f8ada9ee1cd43f2d3@git.kernel.org>
Git-Commit-ID: 722b3654852e48b93367a63f8ada9ee1cd43f2d3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 18 Jan 2010 19:36:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  722b3654852e48b93367a63f8ada9ee1cd43f2d3
Gitweb:     http://git.kernel.org/tip/722b3654852e48b93367a63f8ada9ee1cd43f2d3
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Wed, 13 Jan 2010 16:19:10 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 18 Jan 2010 10:59:50 -0800

x86, vmi: Fix vmi_get_timer_vector() to use IRQ0_VECTOR

FIRST_DEVICE_VECTOR is going away and it looks like a bad hack to steal
FIRST_DEVICE_VECTOR / FIRST_EXTERNAL_VECTOR, when it looks like it needs
IRQ0_VECTOR.

Fix vmi_get_timer_vector() to use IRQ0_VECTOR.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
LKML-Reference: <20100114002118.436172066@sbs-t61.sc.intel.com>
Cc: Alok N Kataria <akataria@vmware.com>
Cc: Zach Amsden <zach@vmware.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/vmiclock_32.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/vmiclock_32.c b/arch/x86/kernel/vmiclock_32.c
index 74c92bb..1268d99 100644
--- a/arch/x86/kernel/vmiclock_32.c
+++ b/arch/x86/kernel/vmiclock_32.c
@@ -79,11 +79,7 @@ unsigned long vmi_tsc_khz(void)
 
 static inline unsigned int vmi_get_timer_vector(void)
 {
-#ifdef CONFIG_X86_IO_APIC
-	return FIRST_DEVICE_VECTOR;
-#else
-	return FIRST_EXTERNAL_VECTOR;
-#endif
+	return IRQ0_VECTOR;
 }
 
 /** vmi clockchip */
@@ -239,8 +235,6 @@ void __init vmi_time_init(void)
 
 	vmi_time_init_clockevent();
 	setup_irq(0, &vmi_clock_action);
-	for_each_possible_cpu(cpu)
-		per_cpu(vector_irq, cpu)[vmi_get_timer_vector()] = 0;
 }
 
 #ifdef CONFIG_X86_LOCAL_APIC
