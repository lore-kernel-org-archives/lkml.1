Return-Path: <linux-kernel-owner+w=401wt.eu-S1759967AbZDLKe7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759967AbZDLKe7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 06:34:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756517AbZDLKeu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 06:34:50 -0400
Received: from hera.kernel.org ([140.211.167.34]:35817 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756164AbZDLKet (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 06:34:49 -0400
Date: Sun, 12 Apr 2009 10:33:35 GMT
From: Rakib Mullick <rakib.mullick@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rakib.mullick@gmail.com, akpm@linux-foundation.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rakib.mullick@gmail.com, akpm@linux-foundation.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <b9df5fa10904102004g51265d9axc8d07278bfdb6ba0@mail.gmail.com>
References: <b9df5fa10904102004g51265d9axc8d07278bfdb6ba0@mail.gmail.com>
Subject: [tip:x86/urgent] x86: Fix section mismatches in mpparse
Message-ID: <tip-575922248c0df490843ddfbcf3bc65b54c4adb08@git.kernel.org>
Git-Commit-ID: 575922248c0df490843ddfbcf3bc65b54c4adb08
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 12 Apr 2009 10:33:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  575922248c0df490843ddfbcf3bc65b54c4adb08
Gitweb:     http://git.kernel.org/tip/575922248c0df490843ddfbcf3bc65b54c4adb08
Author:     Rakib Mullick <rakib.mullick@gmail.com>
AuthorDate: Sat, 11 Apr 2009 09:04:59 +0600
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 12 Apr 2009 12:32:18 +0200

x86: Fix section mismatches in mpparse

Impact: fix section mismatch

In arch/x86/kernel/mpparse.c, smp_reserve_bootmem() has been called
and also refers to a function which is in .init section. Thus causes
the first warning. And check_irq_src() also requires an __init,
because it refers to an .init section.

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <b9df5fa10904102004g51265d9axc8d07278bfdb6ba0@mail.gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/mpparse.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index dce99dc..70fd7e4 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -679,7 +679,7 @@ void __init get_smp_config(void)
 	__get_smp_config(0);
 }
 
-static void smp_reserve_bootmem(struct mpf_intel *mpf)
+static void __init smp_reserve_bootmem(struct mpf_intel *mpf)
 {
 	unsigned long size = get_mpc_size(mpf->physptr);
 #ifdef CONFIG_X86_32
@@ -838,7 +838,7 @@ static int  __init get_MP_intsrc_index(struct mpc_intsrc *m)
 
 static struct mpc_intsrc __initdata *m_spare[SPARE_SLOT_NUM];
 
-static void check_irq_src(struct mpc_intsrc *m, int *nr_m_spare)
+static void __init check_irq_src(struct mpc_intsrc *m, int *nr_m_spare)
 {
 	int i;
 
@@ -866,7 +866,8 @@ static void check_irq_src(struct mpc_intsrc *m, int *nr_m_spare)
 	}
 }
 #else /* CONFIG_X86_IO_APIC */
-static inline void check_irq_src(struct mpc_intsrc *m, int *nr_m_spare) {}
+static
+inline void __init check_irq_src(struct mpc_intsrc *m, int *nr_m_spare) {}
 #endif /* CONFIG_X86_IO_APIC */
 
 static int check_slot(unsigned long mpc_new_phys, unsigned long mpc_new_length,
