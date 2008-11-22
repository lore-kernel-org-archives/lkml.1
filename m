Return-Path: <linux-kernel-owner+w=401wt.eu-S1759086AbYKVRdr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759086AbYKVRdr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 12:33:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758690AbYKVRdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 12:33:36 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:55278 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758922AbYKVRdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 12:33:35 -0500
To: torvalds@linux-foundation.org
Subject: [PATCH 2/32] false __cpuinit positives on alpha
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1L3wMQ-0006GK-Hy@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sat, 22 Nov 2008 17:33:34 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


pure noise - alpha doesn't have CPU hotplug

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/alpha/kernel/smp.c   |    6 +++---
 arch/alpha/kernel/traps.c |    4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/alpha/kernel/smp.c b/arch/alpha/kernel/smp.c
--- a/arch/alpha/kernel/smp.c
+++ b/arch/alpha/kernel/smp.c
@@ -121,7 +121,7 @@ wait_boot_cpu_to_stop(int cpuid)
 /*
  * Where secondaries begin a life of C.
  */
-void __init
+void __cpuinit
 smp_callin(void)
 {
 	int cpuid = hard_smp_processor_id();
@@ -198,7 +198,7 @@ wait_for_txrdy (unsigned long cpumask)
  * Send a message to a secondary's console.  "START" is one such
  * interesting message.  ;-)
  */
-static void __init
+static void __cpuinit
 send_secondary_console_msg(char *str, int cpuid)
 {
 	struct percpu_struct *cpu;
@@ -289,7 +289,7 @@ recv_secondary_console_msg(void)
 /*
  * Convince the console to have a secondary cpu begin execution.
  */
-static int __init
+static int __cpuinit
 secondary_cpu_start(int cpuid, struct task_struct *idle)
 {
 	struct percpu_struct *cpu;
diff --git a/arch/alpha/kernel/traps.c b/arch/alpha/kernel/traps.c
--- a/arch/alpha/kernel/traps.c
+++ b/arch/alpha/kernel/traps.c
@@ -31,7 +31,7 @@
 
 static int opDEC_fix;
 
-static void __init
+static void __cpuinit
 opDEC_check(void)
 {
 	__asm__ __volatile__ (
@@ -1072,7 +1072,7 @@ give_sigbus:
 	return;
 }
 
-void __init
+void __cpuinit
 trap_init(void)
 {
 	/* Tell PAL-code what global pointer we want in the kernel.  */
