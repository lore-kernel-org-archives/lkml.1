Return-Path: <linux-kernel-owner+w=401wt.eu-S1761607AbYCCRUM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761607AbYCCRUM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 12:20:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758108AbYCCRO5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 12:14:57 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35504 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758642AbYCCROz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 12:14:55 -0500
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 21/52] make stop_this_cpu looks exactly equal in both arches
Date: Mon,  3 Mar 2008 14:12:49 -0300
Message-Id: <1204564400-17636-22-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1204564400-17636-21-git-send-email-gcosta@redhat.com>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

with the hlt_works change, it is possible to have i386
and x86_64 stop_this_cpu() looking exactly the same. They
can, after that, be merged.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/smp_32.c |    2 +-
 arch/x86/kernel/smp_64.c |    5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/smp_32.c b/arch/x86/kernel/smp_32.c
index e4a6b66..cde3a0e 100644
--- a/arch/x86/kernel/smp_32.c
+++ b/arch/x86/kernel/smp_32.c
@@ -611,7 +611,7 @@ static void stop_this_cpu (void * dummy)
 	 */
 	cpu_clear(smp_processor_id(), cpu_online_map);
 	disable_local_APIC();
-	if (cpu_data(smp_processor_id()).hlt_works_ok)
+	if (hlt_works(smp_processor_id()))
 		for(;;) halt();
 	for (;;);
 }
diff --git a/arch/x86/kernel/smp_64.c b/arch/x86/kernel/smp_64.c
index e4494e8..4e1e2bc 100644
--- a/arch/x86/kernel/smp_64.c
+++ b/arch/x86/kernel/smp_64.c
@@ -416,8 +416,9 @@ static void stop_this_cpu(void *dummy)
 	 */
 	cpu_clear(smp_processor_id(), cpu_online_map);
 	disable_local_APIC();
-	for (;;)
-		halt();
+	if (hlt_works(smp_processor_id()))
+		for (;;) halt();
+	for (;;);
 }
 
 void smp_send_stop(void)
-- 
1.5.0.6

