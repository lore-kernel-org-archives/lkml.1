Return-Path: <linux-kernel-owner+w=401wt.eu-S1761634AbZE0ABn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761634AbZE0ABn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 20:01:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756687AbZEZXzL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 19:55:11 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38632 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756287AbZEZXy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 19:54:57 -0400
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org, hpa@zytor.com, x86@kernel.org
Cc: Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 27/31] x86: MCE: Print header/footer only once for multiple MCEs
Date: Wed, 27 May 2009 01:54:29 +0200
Message-Id: <2a7abea3d00cb5a1508d54b45bdb7a94fead46ee.1243381848.git.ak@linux.intel.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <b464e1eb871500ad8f4f6e5e5f6d394aec97e037.1243381848.git.ak@linux.intel.com>
References: <1243382073-29338-1-git-send-email-andi@firstfloor.org>
 <c63915cfa51e24394524ddaa66a6f2cb2fcfe66f.1243381848.git.ak@linux.intel.com>
 <c1d7bf910168f07efb50d98f901f41e289a87f1f.1243381848.git.ak@linux.intel.com>
 <6c6d1f8bbbd2312884dca5a5c75aa5f5a87dae4b.1243381848.git.ak@linux.intel.com>
 <1623cd9a1c77d35fc2044d72c4bfa1246e67a1c0.1243381848.git.ak@linux.intel.com>
 <723b3fe4e35063b123cee9658c24267287eeac07.1243381848.git.ak@linux.intel.com>
 <0301db6d6dabb8bcfaffe76a907a5036646c207d.1243381848.git.ak@linux.intel.com>
 <abf61c300dec40b8e93bb5ae7154a0633c682799.1243381848.git.ak@linux.intel.com>
 <23417423c34ad949f53ebc947af8d18672a79a40.1243381848.git.ak@linux.intel.com>
 <347567c2ace55b336b1a43a67323ff8b86b80243.1243381848.git.ak@linux.intel.com>
 <3e29698799ad2c02429613323897a6e61a0a7d01.1243381848.git.ak@linux.intel.com>
 <34082fc262bae2f910f1a940622173445aea72cd.1243381848.git.ak@linux.intel.com>
 <c3a768c37edad55939c6f9391001fb95e658ffe6.1243381848.git.ak@linux.intel.com>
 <37501061dc5d5581fefcaff92c2606e39cc61913.1243381848.git.ak@linux.intel.com>
 <10e478c24139e29e7e74529edd694858ec2fb7ea.1243381848.git.ak@linux.intel.com>
 <a541b2bc620d04dd777acd27a37f564ec757fe8b.1243381848.git.ak@linux.intel.com>
 <abfc8311c5aff38314860d82db449c6c62e9e34d.1243381848.git.ak@linux.intel.com>
 <b55d8c3d2842ee10f4b06f17cc2658f81b4f7b4e.1243381848.git.ak@linux.intel.com>
 <7efad2e5492abb8f94577a81c2ca397a968064d7.1243381848.git.ak@linux.intel.com>
 <0f7e10122c48b7988b1676be5e7fc75f2c561215.1243381848.git.ak@linux.intel.com>
 <314f7c278aaaa41854bf4f0837a4ca6126160fc8.1243381848.git.ak@linux.intel.com>
 <ecbed09ba385129558d6341f6a48c64edaa164b4.1243381848.git.ak@linux.intel.com>
 <d9664a5ed1cdbfcd7888c7c7114619494114d4ab.1243381848.git.ak@linux.intel.com>
 <172ffa34ba8bc6a493e26f7e97fb7239f906b4e8.1243381848.git.ak@linux.intel.com>
 <e224e71ae8e2b578d4b4a0a079eea963445eaf91.1243381848.git.ak@linux.intel.com>
 <650bd32edc1814f1f792a07de9c5efebefc9c0b3.1243381848.git.ak@linux.intel.com>
 <b464e1eb871500ad8f4f6e5e5f6d394aec97e037.1243381848.git.ak@linux.intel.com>
In-Reply-To: <c63915cfa51e24394524ddaa66a6f2cb2fcfe66f.1243381848.git.ak@linux.intel.com>
References: <c63915cfa51e24394524ddaa66a6f2cb2fcfe66f.1243381848.git.ak@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

When multiple MCEs are printed print the "HARDWARE ERROR" header
and "This is not a software error" footer only once. This
makes the output much more compact with many CPUs.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |   27 +++++++++++++++++----------
 1 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 8c55c86..94dddc7 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -176,11 +176,13 @@ void mce_log(struct mce *mce)
 	set_bit(0, &notify_user);
 }
 
-static void print_mce(struct mce *m)
+static void print_mce(struct mce *m, int *first)
 {
-	printk(KERN_EMERG "\n"
-	       KERN_EMERG "HARDWARE ERROR\n"
-	       KERN_EMERG
+	if (*first) {
+		printk(KERN_EMERG "\n" KERN_EMERG "HARDWARE ERROR\n");
+		*first = 0;
+	}
+	printk(KERN_EMERG
 	       "CPU %d: Machine Check Exception: %16Lx Bank %d: %016Lx\n",
 	       m->extcpu, m->mcgstatus, m->bank, m->status);
 	if (m->ip) {
@@ -200,9 +202,12 @@ static void print_mce(struct mce *m)
 	printk(KERN_EMERG "PROCESSOR %u:%x TIME %llu SOCKET %u APIC %x\n",
 			m->cpuvendor, m->cpuid, m->time, m->socketid,
 			m->apicid);
-	printk(KERN_EMERG "This is not a software problem!\n");
-	printk(KERN_EMERG "Run through mcelog --ascii to decode "
-	       "and contact your hardware vendor\n");
+}
+
+static void print_mce_tail(void)
+{
+	printk(KERN_EMERG "This is not a software problem!\n"
+	       KERN_EMERG "Run through mcelog --ascii to decode and contact your hardware vendor\n");
 }
 
 #define PANIC_TIMEOUT 5 /* 5 seconds */
@@ -225,6 +230,7 @@ static void wait_for_panic(void)
 static void mce_panic(char *msg, struct mce *final, char *exp)
 {
 	int i;
+	int first = 1;
 
 	/*
 	 * Make sure only one CPU runs in machine check panic
@@ -240,7 +246,7 @@ static void mce_panic(char *msg, struct mce *final, char *exp)
 		struct mce *m = &mcelog.entry[i];
 		if ((m->status & MCI_STATUS_VAL) &&
 			!(m->status & MCI_STATUS_UC))
-			print_mce(m);
+			print_mce(m, &first);
 	}
 	/* Now print uncorrected but with the final one last */
 	for (i = 0; i < MCE_LOG_LEN; i++) {
@@ -248,12 +254,13 @@ static void mce_panic(char *msg, struct mce *final, char *exp)
 		if (!(m->status & MCI_STATUS_VAL))
 			continue;
 		if (!final || memcmp(m, final, sizeof(struct mce)))
-			print_mce(m);
+			print_mce(m, &first);
 	}
 	if (final)
-		print_mce(final);
+		print_mce(final, &first);
 	if (cpu_missing)
 		printk(KERN_EMERG "Some CPUs didn't answer in synchronization\n");
+	print_mce_tail();
 	if (exp)
 		printk(KERN_EMERG "Machine check: %s\n", exp);
 	if (mce_panic_timeout < panic_timeout)
-- 
1.6.0.2

