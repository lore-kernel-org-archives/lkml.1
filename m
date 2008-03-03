Return-Path: <linux-kernel-owner+w=401wt.eu-S1751488AbYCCRdj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751488AbYCCRdj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 12:33:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759752AbYCCRQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 12:16:24 -0500
Received: from mx1.redhat.com ([66.187.233.31]:36498 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760051AbYCCRQV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 12:16:21 -0500
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 50/52] provide an end_local_APIC_setup function
Date: Mon,  3 Mar 2008 14:13:18 -0300
Message-Id: <1204564400-17636-51-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1204564400-17636-50-git-send-email-gcosta@redhat.com>
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
 <1204564400-17636-23-git-send-email-gcosta@redhat.com>
 <1204564400-17636-24-git-send-email-gcosta@redhat.com>
 <1204564400-17636-25-git-send-email-gcosta@redhat.com>
 <1204564400-17636-26-git-send-email-gcosta@redhat.com>
 <1204564400-17636-27-git-send-email-gcosta@redhat.com>
 <1204564400-17636-28-git-send-email-gcosta@redhat.com>
 <1204564400-17636-29-git-send-email-gcosta@redhat.com>
 <1204564400-17636-30-git-send-email-gcosta@redhat.com>
 <1204564400-17636-31-git-send-email-gcosta@redhat.com>
 <1204564400-17636-32-git-send-email-gcosta@redhat.com>
 <1204564400-17636-33-git-send-email-gcosta@redhat.com>
 <1204564400-17636-34-git-send-email-gcosta@redhat.com>
 <1204564400-17636-35-git-send-email-gcosta@redhat.com>
 <1204564400-17636-36-git-send-email-gcosta@redhat.com>
 <1204564400-17636-37-git-send-email-gcosta@redhat.com>
 <1204564400-17636-38-git-send-email-gcosta@redhat.com>
 <1204564400-17636-39-git-send-email-gcosta@redhat.com>
 <1204564400-17636-40-git-send-email-gcosta@redhat.com>
 <1204564400-17636-41-git-send-email-gcosta@redhat.com>
 <1204564400-17636-42-git-send-email-gcosta@redhat.com>
 <1204564400-17636-43-git-send-email-gcosta@redhat.com>
 <1204564400-17636-44-git-send-email-gcosta@redhat.com>
 <1204564400-17636-45-git-send-email-gcosta@redhat.com>
 <1204564400-17636-46-git-send-email-gcosta@redhat.com>
 <1204564400-17636-47-git-send-email-gcosta@redhat.com>
 <1204564400-17636-48-git-send-email-gcosta@redhat.com>
 <1204564400-17636-49-git-send-email-gcosta@redhat.com>
 <1204564400-17636-50-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It splits setup_local_APIC in two, providing a function corresponding
to the ending part of it. As a side effect, smp_callin looks the same
between i386 and x86_64.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/apic_32.c    |    7 ++++++-
 arch/x86/kernel/smpboot_32.c |    1 +
 2 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
index 4a754ee..6d132a9 100644
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -1064,9 +1064,13 @@ void __cpuinit setup_local_APIC(void)
 	if (!integrated)		/* 82489DX */
 		value |= APIC_LVT_LEVEL_TRIGGER;
 	apic_write_around(APIC_LVT1, value);
+}
 
-	lapic_setup_esr();
+void __cpuinit end_local_APIC_setup(void)
+{
+	unsigned long value;
 
+	lapic_setup_esr();
 	/* Disable the local apic timer */
 	value = apic_read(APIC_LVTT);
 	value |= (APIC_LVT_MASKED | LOCAL_TIMER_VECTOR);
@@ -1256,6 +1260,7 @@ int __init APIC_init_uniprocessor(void)
 
 	setup_local_APIC();
 
+	end_local_APIC_setup();
 #ifdef CONFIG_X86_IO_APIC
 	if (smp_found_config)
 		if (!skip_ioapic_setup && nr_ioapics)
diff --git a/arch/x86/kernel/smpboot_32.c b/arch/x86/kernel/smpboot_32.c
index 8c39369..4a08822 100644
--- a/arch/x86/kernel/smpboot_32.c
+++ b/arch/x86/kernel/smpboot_32.c
@@ -204,6 +204,7 @@ static void __cpuinit smp_callin(void)
 	Dprintk("CALLIN, before setup_local_APIC().\n");
 	smp_callin_clear_local_apic();
 	setup_local_APIC();
+	end_local_APIC_setup();
 	map_cpu_to_logical_apicid();
 
 	/*
-- 
1.5.0.6

