Return-Path: <linux-kernel-owner+w=401wt.eu-S1761626AbYFIOUw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761626AbYFIOUw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 10:20:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759958AbYFIOSn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 10:18:43 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40903 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753765AbYFIOSm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 10:18:42 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu,
       hugh@veritas.com
Subject: [PATCH 07/15] x86: clearing io_apic harmless for x86_64
Date: Mon,  9 Jun 2008 11:16:50 -0300
Message-Id: <1213021018-14159-8-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1213021018-14159-7-git-send-email-gcosta@redhat.com>
References: <1213021018-14159-1-git-send-email-gcosta@redhat.com>
 <1213021018-14159-2-git-send-email-gcosta@redhat.com>
 <1213021018-14159-3-git-send-email-gcosta@redhat.com>
 <1213021018-14159-4-git-send-email-gcosta@redhat.com>
 <1213021018-14159-5-git-send-email-gcosta@redhat.com>
 <1213021018-14159-6-git-send-email-gcosta@redhat.com>
 <1213021018-14159-7-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

so remove ifdef.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/smpboot.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 0e4a44a..5a055a1 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1052,9 +1052,8 @@ static __init void disable_smp(void)
 {
 	cpu_present_map = cpumask_of_cpu(0);
 	cpu_possible_map = cpumask_of_cpu(0);
-#ifdef CONFIG_X86_32
 	smpboot_clear_io_apic_irqs();
-#endif
+
 	if (smp_found_config)
 		phys_cpu_present_map =
 				physid_mask_of_physid(boot_cpu_physical_apicid);
-- 
1.5.4.5

