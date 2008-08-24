Return-Path: <linux-kernel-owner+w=401wt.eu-S1756665AbYHXJGh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665AbYHXJGh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 05:06:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755207AbYHXJDO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 05:03:14 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:44068 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755186AbYHXJDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 05:03:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=uwUIH9ApAj2I0lrwG7xrW/WQCTRmFcYLkP/lScuqSRbdRa4olEyv29BMW1FefQWK0b
         VA9MIcfxjk7sWcIkizOOQVrbeSUylw9T+S45Dbs4ATZwfJjW7Jm1sP5pq2Mq0VuZfOTp
         BajONhzMGt1lTi21KbpfjYbmdFee8r+hbczb0=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 10/18] x86: add hard_smp_prossor_id with MACRO in io_apic_xx.c
Date: Sun, 24 Aug 2008 02:01:48 -0700
Message-Id: <1219568516-681-11-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1219568516-681-1-git-send-email-yhlu.kernel@gmail.com>
References: <1219568516-681-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 arch/x86/kernel/apic_32.c |    7 +++++++
 arch/x86/kernel/apic_64.c |    2 ++
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
index cbac5ff..6fb2b45 100644
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -1600,6 +1600,13 @@ void __cpuinit generic_processor_info(int apicid, int version)
 	cpu_set(cpu, cpu_present_map);
 }
 
+#ifdef CONFIG_X86_64
+int hard_smp_processor_id(void)
+{
+	return read_apic_id();
+}
+#endif
+
 /*
  * Power management
  */
diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
index d3ec746..eeb6983 100644
--- a/arch/x86/kernel/apic_64.c
+++ b/arch/x86/kernel/apic_64.c
@@ -1612,10 +1612,12 @@ void __cpuinit generic_processor_info(int apicid, int version)
 	cpu_set(cpu, cpu_present_map);
 }
 
+#ifdef CONFIG_X86_64
 int hard_smp_processor_id(void)
 {
 	return read_apic_id();
 }
+#endif
 
 /*
  * Power management
-- 
1.5.4.5

