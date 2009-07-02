Return-Path: <linux-kernel-owner+w=401wt.eu-S1753313AbZGBRGM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313AbZGBRGM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 13:06:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752741AbZGBRF7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 13:05:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:58592 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752218AbZGBRF6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 13:05:58 -0400
Subject: [PATCH -tip] x86: Remove useless function lapic_watchdog_ok()
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       Yinghai Lu <yinghai@kernel.org>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 02 Jul 2009 22:35:35 +0530
Message-Id: <1246554335.2242.29.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 (2.26.1-2.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


lapic_watchdog_ok() is a global function but no one is using it.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
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
-- 
1.6.2.5



