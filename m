Return-Path: <linux-kernel-owner+w=401wt.eu-S1422652AbXBAP7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422652AbXBAP7h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 10:59:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422656AbXBAP7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 10:59:36 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:46740 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422652AbXBAP7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 10:59:36 -0500
X-Originating-Ip: 74.109.98.130
Date: Thu, 1 Feb 2007 10:05:55 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Linux kernel mailing list <linux-kernel@vger.kernel.org>
cc: Paul Mackerras <paulus@samba.org>, benh@kernel.crashing.org,
       wli@holomorphy.com, starvik@axis.com
Subject: [PATCH] Replace arrays of SPIN_LOCK_UNLOCKED with __RAW_SPIN_LOCK_UNLOCKED.
Message-ID: <Pine.LNX.4.64.0702010958190.15224@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (cached,
	score=-16.8, required 5, ALL_TRUSTED -1.80, BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  For Sparc, PPC and CRIS, replace declarations of an array of
SPIN_LOCK_UNLOCKED with an array of __RAW_SPIN_LOCK_UNLOCKED.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

  given that the macro SPIN_LOCK_UNLOCKED is deprecated in favour of
the named version of spin locks, it would seem to make sense, if you
need to allocate an array of spin locks, to use the raw form of the
spin lock instead, as is done by PARISC and MIPS.

  but this is just a guess and i'm willing to be told i have no clue
what i'm talking about.


 arch/cris/arch-v32/kernel/smp.c       |    2 +-
 arch/powerpc/platforms/iseries/htab.c |    4 ++--
 arch/sparc/lib/atomic32.c             |    4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/cris/arch-v32/kernel/smp.c b/arch/cris/arch-v32/kernel/smp.c
index 77e655f..f5aa705 100644
--- a/arch/cris/arch-v32/kernel/smp.c
+++ b/arch/cris/arch-v32/kernel/smp.c
@@ -24,7 +24,7 @@
 #define FLUSH_ALL (void*)0xffffffff

 /* Vector of locks used for various atomic operations */
-spinlock_t cris_atomic_locks[] = { [0 ... LOCK_COUNT - 1] = SPIN_LOCK_UNLOCKED};
+raw_spinlock_t cris_atomic_locks[] = { [0 ... LOCK_COUNT - 1] = __RAW_SPIN_LOCK_UNLOCKED};

 /* CPU masks */
 cpumask_t cpu_online_map = CPU_MASK_NONE;
diff --git a/arch/powerpc/platforms/iseries/htab.c b/arch/powerpc/platforms/iseries/htab.c
index ed44dfc..713fa1e 100644
--- a/arch/powerpc/platforms/iseries/htab.c
+++ b/arch/powerpc/platforms/iseries/htab.c
@@ -19,8 +19,8 @@

 #include "call_hpt.h"

-static spinlock_t iSeries_hlocks[64] __cacheline_aligned_in_smp =
-	{ [0 ... 63] = SPIN_LOCK_UNLOCKED};
+static raw_spinlock_t iSeries_hlocks[64] __cacheline_aligned_in_smp =
+	{ [0 ... 63] = __RAW_SPIN_LOCK_UNLOCKED};

 /*
  * Very primitive algorithm for picking up a lock
diff --git a/arch/sparc/lib/atomic32.c b/arch/sparc/lib/atomic32.c
index 53ddcd9..21f407c 100644
--- a/arch/sparc/lib/atomic32.c
+++ b/arch/sparc/lib/atomic32.c
@@ -14,8 +14,8 @@
 #define ATOMIC_HASH_SIZE	4
 #define ATOMIC_HASH(a)	(&__atomic_hash[(((unsigned long)a)>>8) & (ATOMIC_HASH_SIZE-1)])

-spinlock_t __atomic_hash[ATOMIC_HASH_SIZE] = {
-	[0 ... (ATOMIC_HASH_SIZE-1)] = SPIN_LOCK_UNLOCKED
+raw_spinlock_t __atomic_hash[ATOMIC_HASH_SIZE] = {
+	[0 ... (ATOMIC_HASH_SIZE-1)] = __RAW_SPIN_LOCK_UNLOCKED
 };

 #else /* SMP */
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://www.fsdev.dreamhosters.com/wiki/index.php?title=Main_Page
========================================================================
