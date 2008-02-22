Return-Path: <linux-kernel-owner+w=401wt.eu-S1755717AbYBVPRg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755717AbYBVPRg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 10:17:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753487AbYBVPR2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 10:17:28 -0500
Received: from mx1.redhat.com ([66.187.233.31]:36836 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753484AbYBVPR2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 10:17:28 -0500
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       pzijlstr@redhat.com, arjan@infradead.org,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH] make c_idle.work have a static address.
Date: Fri, 22 Feb 2008 12:09:29 -0300
Message-Id: <1203692969-20788-1-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.3.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, c_idle is declared in the stack, and thus, have no static address.

Peter Zijlstra points out this simple solution, in which c_idle.work
is initializated separatedly. Note that the INIT_WORK macro has a static
declaration of a key inside.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
CC: Peter Zijlstra <pzijlstr@redhat.com>
---
 arch/x86/kernel/smpboot_64.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/smpboot_64.c b/arch/x86/kernel/smpboot_64.c
index d53bd6f..0880f2c 100644
--- a/arch/x86/kernel/smpboot_64.c
+++ b/arch/x86/kernel/smpboot_64.c
@@ -554,10 +554,10 @@ static int __cpuinit do_boot_cpu(int cpu
 	int timeout;
 	unsigned long start_rip;
 	struct create_idle c_idle = {
-		.work = __WORK_INITIALIZER(c_idle.work, do_fork_idle),
 		.cpu = cpu,
 		.done = COMPLETION_INITIALIZER_ONSTACK(c_idle.done),
 	};
+	INIT_WORK(&c_idle.work, do_fork_idle);
 
 	/* allocate memory for gdts of secondary cpus. Hotplug is considered */
 	if (!cpu_gdt_descr[cpu].address &&
-- 
1.4.2

