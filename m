Return-Path: <linux-kernel-owner+w=401wt.eu-S932246AbYFIOWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932246AbYFIOWt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 10:22:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760677AbYFIOTE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 10:19:04 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40954 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754101AbYFIOTD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 10:19:03 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu,
       hugh@veritas.com, Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 12/15] x86: change naming to match x86_64
Date: Mon,  9 Jun 2008 11:16:55 -0300
Message-Id: <1213021018-14159-13-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1213021018-14159-12-git-send-email-gcosta@redhat.com>
References: <1213021018-14159-1-git-send-email-gcosta@redhat.com>
 <1213021018-14159-2-git-send-email-gcosta@redhat.com>
 <1213021018-14159-3-git-send-email-gcosta@redhat.com>
 <1213021018-14159-4-git-send-email-gcosta@redhat.com>
 <1213021018-14159-5-git-send-email-gcosta@redhat.com>
 <1213021018-14159-6-git-send-email-gcosta@redhat.com>
 <1213021018-14159-7-git-send-email-gcosta@redhat.com>
 <1213021018-14159-8-git-send-email-gcosta@redhat.com>
 <1213021018-14159-9-git-send-email-gcosta@redhat.com>
 <1213021018-14159-10-git-send-email-gcosta@redhat.com>
 <1213021018-14159-11-git-send-email-gcosta@redhat.com>
 <1213021018-14159-12-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change unmap_cpu_to_logical_apicid to numa_remove_cpu.
Besides being shorter, it is the same name x86_64 uses. We
can save an ifdef in the code this way.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 arch/x86/kernel/smpboot.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 49d2900..6316d30 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -181,13 +181,12 @@ static void map_cpu_to_logical_apicid(void)
 	map_cpu_to_node(cpu, node);
 }
 
-static void unmap_cpu_to_logical_apicid(int cpu)
+static void numa_remove_cpu(int cpu)
 {
 	cpu_2_logical_apicid[cpu] = BAD_APICID;
 	unmap_cpu_to_node(cpu);
 }
 #else
-#define unmap_cpu_to_logical_apicid(cpu) do {} while (0)
 #define map_cpu_to_logical_apicid()  do {} while (0)
 #endif
 
@@ -945,10 +944,7 @@ restore_state:
 
 	if (boot_error) {
 		/* Try to put things back the way they were before ... */
-		unmap_cpu_to_logical_apicid(cpu);
-#ifdef CONFIG_X86_64
 		numa_remove_cpu(cpu); /* was set by numa_add_cpu */
-#endif
 		cpu_clear(cpu, cpu_callout_map); /* was set by do_boot_cpu() */
 		cpu_clear(cpu, cpu_initialized); /* was set by cpu_init() */
 		cpu_clear(cpu, cpu_possible_map);
@@ -1246,7 +1242,7 @@ void cpu_exit_clear(void)
 	cpu_clear(cpu, cpu_callout_map);
 	cpu_clear(cpu, cpu_callin_map);
 
-	unmap_cpu_to_logical_apicid(cpu);
+	numa_remove_cpu(cpu);
 }
 #  endif /* CONFIG_X86_32 */
 
-- 
1.5.4.5

