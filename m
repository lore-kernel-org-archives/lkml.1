Return-Path: <linux-kernel-owner+w=401wt.eu-S1752289AbXH1GHK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752289AbXH1GHK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 02:07:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751045AbXH1GG5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 02:06:57 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:49021 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbXH1GGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 02:06:50 -0400
X-Originating-Ip: 72.143.66.27
Date: Tue, 28 Aug 2007 01:56:24 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: trivial@kernel.org
Subject: [PATCH] Add documentation to some preprocessor directives in init/*.c.
Message-ID: <Pine.LNX.4.64.0708280153050.28330@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Add some documentation to potentially confusing preprocessor
directives in some source files in the init/ directory to show their
proper association and nesting.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

  not all of them, just those that are sufficiently distant from their
initial tests or are nested, to make perusing the code easier.

 init/calibrate.c |    2 +-
 init/initramfs.c |    4 ++--
 init/main.c      |    6 +++---
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/init/calibrate.c b/init/calibrate.c
index 40ff3b4..783a907 100644
--- a/init/calibrate.c
+++ b/init/calibrate.c
@@ -101,7 +101,7 @@ static unsigned long __devinit calibrate_delay_direct(void)
 	       "estimate for loops_per_jiffy.\nProbably due to long platform interrupts. Consider using \"lpj=\" boot option.\n");
 	return 0;
 }
-#else
+#else /* !ARCH_HAS_READ_CURRENT_TIMER */
 static unsigned long __devinit calibrate_delay_direct(void) {return 0;}
 #endif

diff --git a/init/initramfs.c b/init/initramfs.c
index 1db02a0..2493c5b 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -539,7 +539,7 @@ skip:
 	initrd_end = 0;
 }

-#endif
+#endif /* CONFIG_BLK_DEV_INITRD */

 static int __init populate_rootfs(void)
 {
@@ -579,7 +579,7 @@ static int __init populate_rootfs(void)
 		free_initrd();
 #endif
 	}
-#endif
+#endif /* CONFIG_BLK_DEV_INITRD */
 	return 0;
 }
 rootfs_initcall(populate_rootfs);
diff --git a/init/main.c b/init/main.c
index 450e6ee..781b1fb 100644
--- a/init/main.c
+++ b/init/main.c
@@ -169,7 +169,7 @@ static int __init maxcpus(char *str)
 }

 early_param("maxcpus", maxcpus);
-#else
+#else /* !CONFIG_SMP */
 #define max_cpus NR_CPUS
 #endif

@@ -367,7 +367,7 @@ static void __init smp_init(void)
 static inline void setup_per_cpu_areas(void) { }
 static inline void smp_prepare_cpus(unsigned int maxcpus) { }

-#else
+#else /* CONFIG_SMP */

 #ifdef __GENERIC_PER_CPU
 unsigned long __per_cpu_offset[NR_CPUS] __read_mostly;
@@ -414,7 +414,7 @@ static void __init smp_init(void)
 	smp_cpus_done(max_cpus);
 }

-#endif
+#endif /* CONFIG_SMP */

 /*
  * We need to store the untouched command line for future reference.
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
