Return-Path: <linux-kernel-owner+w=401wt.eu-S1757370AbZCTJwi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757370AbZCTJwi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 05:52:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751731AbZCTJw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 05:52:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:60787 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750945AbZCTJw1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 05:52:27 -0400
Date: Fri, 20 Mar 2009 09:51:37 GMT
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, sfr@canb.auug.org.au,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, tglx@linutronix.de,
       sfr@canb.auug.org.au, mingo@elte.hu
In-Reply-To: <20090320092410.30d2bac3@osiris.boeblingen.de.ibm.com>
References: <20090320092410.30d2bac3@osiris.boeblingen.de.ibm.com>
Subject: [tip:core/ipi] s390: remove arch specific smp_send_stop()
Message-ID: <tip-70f454408e68fdba2c2529ab7d6ec3c3525e59f2@git.kernel.org>
Git-Commit-ID: 70f454408e68fdba2c2529ab7d6ec3c3525e59f2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 20 Mar 2009 09:51:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  70f454408e68fdba2c2529ab7d6ec3c3525e59f2
Gitweb:     http://git.kernel.org/tip/70f454408e68fdba2c2529ab7d6ec3c3525e59f2
Author:     Heiko Carstens <heiko.carstens@de.ibm.com>
AuthorDate: Fri, 20 Mar 2009 09:24:10 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 20 Mar 2009 10:49:42 +0100

s390: remove arch specific smp_send_stop()

Impact: build fix on s390 !CONFIG_SMP

Remove arch specific smp_send_stop for !CONFIG_SMP since it conflicts
with a new generic version.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
LKML-Reference: <20090320092410.30d2bac3@osiris.boeblingen.de.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/s390/include/asm/smp.h |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/arch/s390/include/asm/smp.h b/arch/s390/include/asm/smp.h
index 024b91e..f89e2d5 100644
--- a/arch/s390/include/asm/smp.h
+++ b/arch/s390/include/asm/smp.h
@@ -97,12 +97,6 @@ extern void arch_send_call_function_ipi(cpumask_t mask);
 #endif
 
 #ifndef CONFIG_SMP
-static inline void smp_send_stop(void)
-{
-	/* Disable all interrupts/machine checks */
-	__load_psw_mask(psw_kernel_bits & ~PSW_MASK_MCHECK);
-}
-
 #define hard_smp_processor_id()		0
 #define smp_cpu_not_running(cpu)	1
 #endif
