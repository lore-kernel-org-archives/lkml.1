Return-Path: <linux-kernel-owner+w=401wt.eu-S1758003AbYJ3VHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758003AbYJ3VHn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 17:07:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753509AbYJ3VHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 17:07:15 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:55858 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752826AbYJ3VHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 17:07:13 -0400
Subject: [PATCH] fix compile breakage caused by x86: add ->pre_time_init to
	x86_quirks
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>
Content-Type: text/plain
Date: Thu, 30 Oct 2008 16:07:11 -0500
Message-Id: <1225400831.19324.21.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From da69eaed98248bf4b29e94d62a4e01a5c3758669 Mon Sep 17 00:00:00 2001
From: James Bottomley <James.Bottomley@HansenPartnership.com>
Date: Wed, 29 Oct 2008 13:14:29 -0500
Subject: [VOYAGER] x86: add voyager pre_time_init_hook

This was introduced by:

Author: Yinghai Lu <yhlu.kernel@gmail.com>
Date:   Sat Jul 19 18:02:26 2008 -0700

    x86: add ->pre_time_init to x86_quirks

In theory, voyager could also make use of the x86_quirks hooks but,
unfortunately, they're not set up correctly for that to happen yet.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 arch/x86/mach-voyager/setup.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mach-voyager/setup.c b/arch/x86/mach-voyager/setup.c
index 7c6ff1a..4cc0515 100644
--- a/arch/x86/mach-voyager/setup.c
+++ b/arch/x86/mach-voyager/setup.c
@@ -34,13 +34,23 @@ void __init intr_init_hook(void)
 	setup_irq(2, &irq2);
 }
 
-void __init pre_setup_arch_hook(void)
+static void voyager_disable_tsc(void)
 {
 	/* Voyagers run their CPUs from independent clocks, so disable
 	 * the TSC code because we can't sync them */
 	setup_clear_cpu_cap(X86_FEATURE_TSC);
 }
 
+void __init pre_setup_arch_hook(void)
+{
+	voyager_disable_tsc();
+}
+
+void __init pre_time_init_hook(void)
+{
+	voyager_disable_tsc();
+}
+
 void __init trap_init_hook(void)
 {
 }
-- 
1.5.6.5



