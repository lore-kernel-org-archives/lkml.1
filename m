Return-Path: <linux-kernel-owner+w=401wt.eu-S1757453AbYHRQvH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757453AbYHRQvH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 12:51:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753565AbYHRQqC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 12:46:02 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:24576 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755329AbYHRQpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 12:45:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=RgktRZlxh958qBFUilwgCi7ZvdEfYU6CwFg+Oh+7tGM6ZmEaEGd/0FnTt7MIFRpRts
         fiZqL3vub4nM5uzqHQDSsXlF7rZRZWeg1opuzg1DzShs3sqpjcTqOru7aacacavCBPFR
         9HHqvNpSKwG8bcx/QUuz5ep7g8F45On1k5ZnM=
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@elte.hu, macro@linux-mips.org
Cc: hpa@zytor.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [PATCH 15/15] x86: apic - lapic_resume 32bit - unification fix
Date: Mon, 18 Aug 2008 20:46:03 +0400
Message-Id: <03de4451f6ba98351f4974309517e79907a59791.1219073223.git.gorcunov@gmail.com>
X-Mailer: git-send-email 1.6.0.rc1.34.g0fe8c
In-Reply-To: <1219077963-22883-1-git-send-email-gorcunov@gmail.com>
References: <1219077963-22883-1-git-send-email-gorcunov@gmail.com>
In-Reply-To: <8d555f8d496693d05b9e0836f18f62b1adb313c8.1219073223.git.gorcunov@gmail.com>
References: <8d555f8d496693d05b9e0836f18f62b1adb313c8.1219073223.git.gorcunov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just add parenthesis to be identical of current
64bit implementation (so diff will not complain).

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---
 arch/x86/kernel/apic_32.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
index 885e306..e975562 100644
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -1646,6 +1646,7 @@ static int lapic_resume(struct sys_device *dev)
 		enable_x2apic();
 	else
 #endif
+	{
 		/*
 		 * Make sure the APICBASE points to the right address
 		 *
@@ -1656,6 +1657,7 @@ static int lapic_resume(struct sys_device *dev)
 		l &= ~MSR_IA32_APICBASE_BASE;
 		l |= MSR_IA32_APICBASE_ENABLE | mp_lapic_addr;
 		wrmsr(MSR_IA32_APICBASE, l, h);
+	}
 
 	apic_write(APIC_LVTERR, ERROR_APIC_VECTOR | APIC_LVT_MASKED);
 	apic_write(APIC_ID, apic_pm_state.apic_id);
-- 
1.6.0.rc1.34.g0fe8c

