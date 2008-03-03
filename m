Return-Path: <linux-kernel-owner+w=401wt.eu-S1759684AbYCCR3v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759684AbYCCR3v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 12:29:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759263AbYCCRQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 12:16:07 -0500
Received: from mx1.redhat.com ([66.187.233.31]:36440 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760013AbYCCRQB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 12:16:01 -0500
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 22/52] add reboot_force test to native_smp_send_stop
Date: Mon,  3 Mar 2008 14:12:50 -0300
Message-Id: <1204564400-17636-23-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1204564400-17636-22-git-send-email-gcosta@redhat.com>
References: <1204564400-17636-1-git-send-email-gcosta@redhat.com>
 <1204564400-17636-2-git-send-email-gcosta@redhat.com>
 <1204564400-17636-3-git-send-email-gcosta@redhat.com>
 <1204564400-17636-4-git-send-email-gcosta@redhat.com>
 <1204564400-17636-5-git-send-email-gcosta@redhat.com>
 <1204564400-17636-6-git-send-email-gcosta@redhat.com>
 <1204564400-17636-7-git-send-email-gcosta@redhat.com>
 <1204564400-17636-8-git-send-email-gcosta@redhat.com>
 <1204564400-17636-9-git-send-email-gcosta@redhat.com>
 <1204564400-17636-10-git-send-email-gcosta@redhat.com>
 <1204564400-17636-11-git-send-email-gcosta@redhat.com>
 <1204564400-17636-12-git-send-email-gcosta@redhat.com>
 <1204564400-17636-13-git-send-email-gcosta@redhat.com>
 <1204564400-17636-14-git-send-email-gcosta@redhat.com>
 <1204564400-17636-15-git-send-email-gcosta@redhat.com>
 <1204564400-17636-16-git-send-email-gcosta@redhat.com>
 <1204564400-17636-17-git-send-email-gcosta@redhat.com>
 <1204564400-17636-18-git-send-email-gcosta@redhat.com>
 <1204564400-17636-19-git-send-email-gcosta@redhat.com>
 <1204564400-17636-20-git-send-email-gcosta@redhat.com>
 <1204564400-17636-21-git-send-email-gcosta@redhat.com>
 <1204564400-17636-22-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This can be safely added to i386. After that,
functions look exactly the same for both arches

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/smp_32.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/smp_32.c b/arch/x86/kernel/smp_32.c
index cde3a0e..8be3e09 100644
--- a/arch/x86/kernel/smp_32.c
+++ b/arch/x86/kernel/smp_32.c
@@ -24,6 +24,7 @@
 #include <asm/tlbflush.h>
 #include <asm/mmu_context.h>
 #include <mach_apic.h>
+#include <asm/proto.h>
 
 /*
  *	Some notes on x86 processor bugs affecting SMP operation:
@@ -622,10 +623,14 @@ static void stop_this_cpu (void * dummy)
 
 static void native_smp_send_stop(void)
 {
-	/* Don't deadlock on the call lock in panic */
-	int nolock = !spin_trylock(&call_lock);
+	int nolock;
 	unsigned long flags;
 
+	if (reboot_force)
+		return;
+
+	/* Don't deadlock on the call lock in panic */
+	nolock = !spin_trylock(&call_lock);
 	local_irq_save(flags);
 	__smp_call_function(stop_this_cpu, NULL, 0, 0);
 	if (!nolock)
-- 
1.5.0.6

