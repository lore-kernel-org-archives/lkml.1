Return-Path: <linux-kernel-owner+w=401wt.eu-S1762539AbYCCR2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762539AbYCCR2b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 12:28:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759959AbYCCRP5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 12:15:57 -0500
Received: from mx1.redhat.com ([66.187.233.31]:36429 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759936AbYCCRPz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 12:15:55 -0500
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 42/52] adapt voyager's trampoline_base
Date: Mon,  3 Mar 2008 14:13:10 -0300
Message-Id: <1204564400-17636-43-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1204564400-17636-42-git-send-email-gcosta@redhat.com>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change voyager's trampoline base to unsigned char *
instead of u32. This way, it won't conflict with
the other architectures when including smp.h

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/mach-voyager/voyager_smp.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/mach-voyager/voyager_smp.c b/arch/x86/mach-voyager/voyager_smp.c
index 0b3f52a..0ab236e 100644
--- a/arch/x86/mach-voyager/voyager_smp.c
+++ b/arch/x86/mach-voyager/voyager_smp.c
@@ -210,7 +210,7 @@ static int cpucount = 0;
 /* steal a page from the bottom of memory for the trampoline and
  * squirrel its address away here.  This will be in kernel virtual
  * space */
-static __u32 trampoline_base;
+unsigned char *trampoline_base;
 
 /* The per cpu profile stuff - used in smp_local_timer_interrupt */
 static DEFINE_PER_CPU(int, prof_multiplier) = 1;
@@ -435,9 +435,9 @@ static __u32 __init setup_trampoline(void)
 	extern const __u8 trampoline_end[];
 	extern const __u8 trampoline_data[];
 
-	memcpy((__u8 *) trampoline_base, trampoline_data,
+	memcpy(trampoline_base, trampoline_data,
 	       trampoline_end - trampoline_data);
-	return virt_to_phys((__u8 *) trampoline_base);
+	return virt_to_phys(trampoline_base);
 }
 
 /* Routine initially called when a non-boot CPU is brought online */
@@ -1166,7 +1166,7 @@ void flush_tlb_all(void)
  * is sorted out */
 void __init smp_alloc_memory(void)
 {
-	trampoline_base = (__u32) alloc_bootmem_low_pages(PAGE_SIZE);
+	trampoline_base = alloc_bootmem_low_pages(PAGE_SIZE);
 	if (__pa(trampoline_base) >= 0x93000)
 		BUG();
 }
-- 
1.5.0.6

