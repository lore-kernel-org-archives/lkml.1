Return-Path: <linux-kernel-owner+w=401wt.eu-S1760594AbYCCRb5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760594AbYCCRb5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 12:31:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759730AbYCCRQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 12:16:17 -0500
Received: from mx1.redhat.com ([66.187.233.31]:36469 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759673AbYCCRQN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 12:16:13 -0500
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 47/52] leave irqs enabled while calibrating delay.
Date: Mon,  3 Mar 2008 14:13:15 -0300
Message-Id: <1204564400-17636-48-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1204564400-17636-47-git-send-email-gcosta@redhat.com>
References: <1204564400-17636-1-git-send-email-gcosta@redhat.com>
 <1204564400-17636-2-git-send-email-gcosta@redhat.com>
 <1204564400-17636-3-git-send-email-gcosta@redhat.com>
 <1204564400-17636-4-git-send-email-gcosta@redhat.com>
 <1204564400-17636-5-git-send-email-gcosta@redhat.com>
 <1204564400-17636-6-git-send-email-gcosta@redhat.com>
 <1204564400-17636-7-git-send-email-gcosta@redhat.com>
 <1204564400-17636-8-git-send-email-gcosta@redhat.com>
 <1204564400-17636-9-git-send-email-gcosta@redhat.com>
 <1204564400-17636-10-git-send-email-gcosta@redhat.com>
 <1204564400-17636-11-git-send-email-gcosta@redhat.com>
 <1204564400-17636-12-git-send-email-gcosta@redhat.com>
 <1204564400-17636-13-git-send-email-gcosta@redhat.com>
 <1204564400-17636-14-git-send-email-gcosta@redhat.com>
 <1204564400-17636-15-git-send-email-gcosta@redhat.com>
 <1204564400-17636-16-git-send-email-gcosta@redhat.com>
 <1204564400-17636-17-git-send-email-gcosta@redhat.com>
 <1204564400-17636-18-git-send-email-gcosta@redhat.com>
 <1204564400-17636-19-git-send-email-gcosta@redhat.com>
 <1204564400-17636-20-git-send-email-gcosta@redhat.com>
 <1204564400-17636-21-git-send-email-gcosta@redhat.com>
 <1204564400-17636-22-git-send-email-gcosta@redhat.com>
 <1204564400-17636-23-git-send-email-gcosta@redhat.com>
 <1204564400-17636-24-git-send-email-gcosta@redhat.com>
 <1204564400-17636-25-git-send-email-gcosta@redhat.com>
 <1204564400-17636-26-git-send-email-gcosta@redhat.com>
 <1204564400-17636-27-git-send-email-gcosta@redhat.com>
 <1204564400-17636-28-git-send-email-gcosta@redhat.com>
 <1204564400-17636-29-git-send-email-gcosta@redhat.com>
 <1204564400-17636-30-git-send-email-gcosta@redhat.com>
 <1204564400-17636-31-git-send-email-gcosta@redhat.com>
 <1204564400-17636-32-git-send-email-gcosta@redhat.com>
 <1204564400-17636-33-git-send-email-gcosta@redhat.com>
 <1204564400-17636-34-git-send-email-gcosta@redhat.com>
 <1204564400-17636-35-git-send-email-gcosta@redhat.com>
 <1204564400-17636-36-git-send-email-gcosta@redhat.com>
 <1204564400-17636-37-git-send-email-gcosta@redhat.com>
 <1204564400-17636-38-git-send-email-gcosta@redhat.com>
 <1204564400-17636-39-git-send-email-gcosta@redhat.com>
 <1204564400-17636-40-git-send-email-gcosta@redhat.com>
 <1204564400-17636-41-git-send-email-gcosta@redhat.com>
 <1204564400-17636-42-git-send-email-gcosta@redhat.com>
 <1204564400-17636-43-git-send-email-gcosta@redhat.com>
 <1204564400-17636-44-git-send-email-gcosta@redhat.com>
 <1204564400-17636-45-git-send-email-gcosta@redhat.com>
 <1204564400-17636-46-git-send-email-gcosta@redhat.com>
 <1204564400-17636-47-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

although i386 appearantly does not have problems with the nmi,
we leave irqs enabled, as it is common ground between it and x86_64.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/smpboot_32.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/smpboot_32.c b/arch/x86/kernel/smpboot_32.c
index 2dd95ba..8c39369 100644
--- a/arch/x86/kernel/smpboot_32.c
+++ b/arch/x86/kernel/smpboot_32.c
@@ -208,8 +208,13 @@ static void __cpuinit smp_callin(void)
 
 	/*
 	 * Get our bogomips.
+	 *
+	 * Need to enable IRQs because it can take longer and then
+	 * the NMI watchdog might kill us.
 	 */
+	local_irq_enable();
 	calibrate_delay();
+	local_irq_disable();
 	Dprintk("Stack at about %p\n",&cpuid);
 
 	/*
-- 
1.5.0.6

