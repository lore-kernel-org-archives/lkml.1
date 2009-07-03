Return-Path: <linux-kernel-owner+w=401wt.eu-S1754490AbZGCJhp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490AbZGCJhp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 05:37:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755782AbZGCJhb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 05:37:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:53561 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755754AbZGCJh2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 05:37:28 -0400
Date: Fri, 3 Jul 2009 09:36:50 GMT
From: tip-bot for Jaswinder Singh Rajput <jaswinder@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, andi@firstfloor.org, jaswinder@kernel.org,
       jaswinderrajput@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       andi@firstfloor.org, yinghai@kernel.org, jaswinder@kernel.org,
       jaswinderrajput@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1246554335.2242.29.camel@jaswinder.satnam>
References: <1246554335.2242.29.camel@jaswinder.satnam>
Subject: [tip:x86/urgent] x86: Remove unused function lapic_watchdog_ok()
Message-ID: <tip-87a7ed62d5324ef4f356e436ca6a8522151fdff1@git.kernel.org>
Git-Commit-ID: 87a7ed62d5324ef4f356e436ca6a8522151fdff1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 03 Jul 2009 09:36:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  87a7ed62d5324ef4f356e436ca6a8522151fdff1
Gitweb:     http://git.kernel.org/tip/87a7ed62d5324ef4f356e436ca6a8522151fdff1
Author:     Jaswinder Singh Rajput <jaswinder@kernel.org>
AuthorDate: Thu, 2 Jul 2009 22:35:35 +0530
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 3 Jul 2009 11:34:08 +0200

x86: Remove unused function lapic_watchdog_ok()

lapic_watchdog_ok() is a global function but no one is using it.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <1246554335.2242.29.camel@jaswinder.satnam>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/nmi.h             |    1 -
 arch/x86/kernel/cpu/perfctr-watchdog.c |    5 -----
 2 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/nmi.h b/arch/x86/include/asm/nmi.h
index c972644..c86e5ed 100644
--- a/arch/x86/include/asm/nmi.h
+++ b/arch/x86/include/asm/nmi.h
@@ -72,7 +72,6 @@ void lapic_watchdog_stop(void);
 int lapic_watchdog_init(unsigned nmi_hz);
 int lapic_wd_event(unsigned nmi_hz);
 unsigned lapic_adjust_nmi_hz(unsigned hz);
-int lapic_watchdog_ok(void);
 void disable_lapic_nmi_watchdog(void);
 void enable_lapic_nmi_watchdog(void);
 void stop_nmi(void);
diff --git a/arch/x86/kernel/cpu/perfctr-watchdog.c b/arch/x86/kernel/cpu/perfctr-watchdog.c
index 5c481f6..e60ed74 100644
--- a/arch/x86/kernel/cpu/perfctr-watchdog.c
+++ b/arch/x86/kernel/cpu/perfctr-watchdog.c
@@ -803,8 +803,3 @@ int __kprobes lapic_wd_event(unsigned nmi_hz)
 	wd_ops->rearm(wd, nmi_hz);
 	return 1;
 }
-
-int lapic_watchdog_ok(void)
-{
-	return wd_ops != NULL;
-}
