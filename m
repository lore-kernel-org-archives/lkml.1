Return-Path: <linux-kernel-owner+w=401wt.eu-S1760838AbYDWKCh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760838AbYDWKCh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 06:02:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751788AbYDWJxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 05:53:32 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:59539 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755924AbYDWJxb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 05:53:31 -0400
Date: Wed, 23 Apr 2008 12:52:51 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Erik Bosman <ejbosman@cs.vu.nl>, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] x86: make enable_TSC() static
Message-ID: <20080423095251.GP28933@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global enable_TSC() static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 arch/x86/kernel/process_32.c |    2 +-
 arch/x86/kernel/process_64.c |    2 +-
 include/asm-x86/tsc.h        |    1 -
 3 files changed, 2 insertions(+), 3 deletions(-)

4628dd5f4a92b7b7f86eab04e5bdaf4c411ca8e2 diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 7adad08..77de848 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -550,7 +550,7 @@ static void hard_enable_TSC(void)
 	write_cr4(read_cr4() & ~X86_CR4_TSD);
 }
 
-void enable_TSC(void)
+static void enable_TSC(void)
 {
 	preempt_disable();
 	if (test_and_clear_thread_flag(TIF_NOTSC))
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 891af1a..131c2ee 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -562,7 +562,7 @@ static void hard_enable_TSC(void)
 	write_cr4(read_cr4() & ~X86_CR4_TSD);
 }
 
-void enable_TSC(void)
+static void enable_TSC(void)
 {
 	preempt_disable();
 	if (test_and_clear_thread_flag(TIF_NOTSC))
diff --git a/include/asm-x86/tsc.h b/include/asm-x86/tsc.h
index 0434bd8..d2d8eb5 100644
--- a/include/asm-x86/tsc.h
+++ b/include/asm-x86/tsc.h
@@ -18,7 +18,6 @@ extern unsigned int cpu_khz;
 extern unsigned int tsc_khz;
 
 extern void disable_TSC(void);
-extern void enable_TSC(void);
 
 static inline cycles_t get_cycles(void)
 {

