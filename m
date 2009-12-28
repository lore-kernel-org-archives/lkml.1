Return-Path: <linux-kernel-owner+w=401wt.eu-S1751523AbZL1KIM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751523AbZL1KIM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 05:08:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751405AbZL1KIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 05:08:10 -0500
Received: from hera.kernel.org ([140.211.167.34]:36256 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750921AbZL1KIJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 05:08:09 -0500
Date: Mon, 28 Dec 2009 10:07:32 GMT
From: tip-bot for Naga Chumbalkar <nagananda.chumbalkar@hp.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       nagananda.chumbalkar@hp.com, tglx@linutronix.de, gorcunov@gmail.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       nagananda.chumbalkar@hp.com, tglx@linutronix.de, gorcunov@gmail.com,
       mingo@elte.hu
In-Reply-To: <20091224015441.6005.4408.sendpatchset@localhost.localdomain>
References: <20091224015441.6005.4408.sendpatchset@localhost.localdomain>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] x86, perfctr: Remove unused func avail_to_resrv_perfctr_nmi()
Message-ID: <tip-fd2a50a0240f5f5b59070474eabd83a85720a406@git.kernel.org>
Git-Commit-ID: fd2a50a0240f5f5b59070474eabd83a85720a406
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fd2a50a0240f5f5b59070474eabd83a85720a406
Gitweb:     http://git.kernel.org/tip/fd2a50a0240f5f5b59070474eabd83a85720a406
Author:     Naga Chumbalkar <nagananda.chumbalkar@hp.com>
AuthorDate: Thu, 24 Dec 2009 01:54:47 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 28 Dec 2009 09:36:46 +0100

x86, perfctr: Remove unused func avail_to_resrv_perfctr_nmi()

avail_to_resrv_perfctr_nmi() is neither EXPORT'd, nor used in
the file. So remove it.

Signed-off-by: Naga Chumbalkar <nagananda.chumbalkar@hp.com>
Acked-by: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: oprofile-list@lists.sf.net
LKML-Reference: <20091224015441.6005.4408.sendpatchset@localhost.localdomain>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/nmi.h             |    1 -
 arch/x86/kernel/cpu/perfctr-watchdog.c |   11 -----------
 2 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/nmi.h b/arch/x86/include/asm/nmi.h
index 139d4c1..93da9c3 100644
--- a/arch/x86/include/asm/nmi.h
+++ b/arch/x86/include/asm/nmi.h
@@ -19,7 +19,6 @@ extern void die_nmi(char *str, struct pt_regs *regs, int do_panic);
 extern int check_nmi_watchdog(void);
 extern int nmi_watchdog_enabled;
 extern int avail_to_resrv_perfctr_nmi_bit(unsigned int);
-extern int avail_to_resrv_perfctr_nmi(unsigned int);
 extern int reserve_perfctr_nmi(unsigned int);
 extern void release_perfctr_nmi(unsigned int);
 extern int reserve_evntsel_nmi(unsigned int);
diff --git a/arch/x86/kernel/cpu/perfctr-watchdog.c b/arch/x86/kernel/cpu/perfctr-watchdog.c
index 898df97..74f4e85 100644
--- a/arch/x86/kernel/cpu/perfctr-watchdog.c
+++ b/arch/x86/kernel/cpu/perfctr-watchdog.c
@@ -115,17 +115,6 @@ int avail_to_resrv_perfctr_nmi_bit(unsigned int counter)
 
 	return !test_bit(counter, perfctr_nmi_owner);
 }
-
-/* checks the an msr for availability */
-int avail_to_resrv_perfctr_nmi(unsigned int msr)
-{
-	unsigned int counter;
-
-	counter = nmi_perfctr_msr_to_bit(msr);
-	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
-
-	return !test_bit(counter, perfctr_nmi_owner);
-}
 EXPORT_SYMBOL(avail_to_resrv_perfctr_nmi_bit);
 
 int reserve_perfctr_nmi(unsigned int msr)
