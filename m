Return-Path: <linux-kernel-owner+w=401wt.eu-S1760756AbYGQRdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760756AbYGQRdR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 13:33:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756928AbYGQRdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 13:33:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60325 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755050AbYGQRdD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 13:33:03 -0400
Date: Thu, 17 Jul 2008 19:32:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [git pull] x86 fixes
Message-ID: <20080717173248.GA13376@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86 fixes git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

Thanks,

	Ingo

------------------>
Jack Steiner (1):
      x86: fix kernel_physical_mapping_init() for large x86 systems

Rusty Russell (1):
      x86: fix asm/e820.h for userspace inclusion

Yinghai Lu (1):
      x86: fix numaq_tsc_disable


 arch/x86/kernel/numaq_32.c |    2 +-
 arch/x86/mm/init_64.c      |    2 +-
 include/asm-x86/e820.h     |    3 ++-
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/numaq_32.c b/arch/x86/kernel/numaq_32.c
index 5b20a5e..a23e823 100644
--- a/arch/x86/kernel/numaq_32.c
+++ b/arch/x86/kernel/numaq_32.c
@@ -96,7 +96,7 @@ int __init get_memcfg_numaq(void)
 void __init numaq_tsc_disable(void)
 {
 	if (!found_numaq)
-		return -1;
+		return;
 
 	if (num_online_nodes() > 1) {
 		printk(KERN_DEBUG "NUMAQ: disabling TSC\n");
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 27de243..306049e 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -644,7 +644,7 @@ static unsigned long __init kernel_physical_mapping_init(unsigned long start,
 		unsigned long pud_phys;
 		pud_t *pud;
 
-		next = start + PGDIR_SIZE;
+		next = (start + PGDIR_SIZE) & PGDIR_MASK;
 		if (next > end)
 			next = end;
 
diff --git a/include/asm-x86/e820.h b/include/asm-x86/e820.h
index 33e793e..06633b0 100644
--- a/include/asm-x86/e820.h
+++ b/include/asm-x86/e820.h
@@ -59,6 +59,7 @@ struct e820map {
 	struct e820entry map[E820_X_MAX];
 };
 
+#ifdef __KERNEL__
 /* see comment in arch/x86/kernel/e820.c */
 extern struct e820map e820;
 extern struct e820map e820_saved;
@@ -115,7 +116,7 @@ extern void setup_memory_map(void);
 extern char *default_machine_specific_memory_setup(void);
 extern char *machine_specific_memory_setup(void);
 extern char *memory_setup(void);
-
+#endif /* __KERNEL__ */
 #endif /* __ASSEMBLY__ */
 
 #define ISA_START_ADDRESS	0xa0000
