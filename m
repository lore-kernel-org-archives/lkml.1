Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541Ab0BTINM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 03:13:12 -0500
Received: from hera.kernel.org ([140.211.167.34]:42734 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753358Ab0BTINJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 03:13:09 -0500
Date: Sat, 20 Feb 2010 08:12:37 GMT
From: tip-bot for Don Zickus <dzickus@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, mingo@elte.hu, dzickus@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, dzickus@redhat.com, mingo@elte.hu
In-Reply-To: <1266548212-24243-1-git-send-email-dzickus@redhat.com>
References: <1266548212-24243-1-git-send-email-dzickus@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/nmi] nmi_watchdog: Fix undefined 'apic' build bug
Message-ID: <tip-2cc4452bc31fc1cde6f0b64a4eb13269f982787d@git.kernel.org>
Git-Commit-ID: 2cc4452bc31fc1cde6f0b64a4eb13269f982787d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 20 Feb 2010 08:12:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2cc4452bc31fc1cde6f0b64a4eb13269f982787d
Gitweb:     http://git.kernel.org/tip/2cc4452bc31fc1cde6f0b64a4eb13269f982787d
Author:     Don Zickus <dzickus@redhat.com>
AuthorDate: Thu, 18 Feb 2010 21:56:52 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 19 Feb 2010 23:04:13 +0100

nmi_watchdog: Fix undefined 'apic' build bug

Ingo provided me a config that fails to compile with:

  arch/x86/built-in.o: In function
  `arch_trigger_all_cpu_backtrace': (.text+0x17e78): undefined
  reference to `apic' make: *** [.tmp_vmlinux1] Error 1

I realized I changed the compile behaviour of the nmi code by
not wrapping it with CONFIG_LOCAL_APIC.  To fix this I add a
compile check for ARCH_HAS_NMI_WATCHDOG around
arch_trigger_all_cpu_backtrace.

Signed-off-by: Don Zickus <dzickus@redhat.com>
Cc: a.p.zijlstra@chello.nl
Cc: gorcunov@gmail.com
Cc: aris@redhat.com
LKML-Reference: <1266548212-24243-1-git-send-email-dzickus@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/apic/hw_nmi.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/apic/hw_nmi.c b/arch/x86/kernel/apic/hw_nmi.c
index 312d772..0b4d205 100644
--- a/arch/x86/kernel/apic/hw_nmi.c
+++ b/arch/x86/kernel/apic/hw_nmi.c
@@ -92,6 +92,7 @@ u64 hw_nmi_get_sample_period(void)
         return cpu_khz * 1000;
 }
 
+#ifdef ARCH_HAS_NMI_WATCHDOG
 void arch_trigger_all_cpu_backtrace(void)
 {
 	int i;
@@ -108,6 +109,7 @@ void arch_trigger_all_cpu_backtrace(void)
 		mdelay(1);
 	}
 }
+#endif
 
 /* STUB calls to mimic old nmi_watchdog behaviour */
 #if defined(CONFIG_X86_LOCAL_APIC)
