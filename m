Return-Path: <linux-kernel-owner+w=401wt.eu-S1751773AbZHaLEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751773AbZHaLEb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 07:04:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751329AbZHaLEa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 07:04:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30261 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751184AbZHaLEa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 07:04:30 -0400
From: Glauber Costa <glommer@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, avi@redhat.com
Subject: [PATCH] use __pa_symbol to calculate the address of a C symbol.
Date: Mon, 31 Aug 2009 03:04:31 -0400
Message-Id: <1251702271-4797-1-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The use of __pa() to calculate the address of a C-visible symbol
is wrong, and can lead to unpredictable results. See arch/x86/include/asm/page.h
for details.

It should be replaced with __pa_symbol(), that does the correct math here,
by taking relocations into account.

Signed-off-by: Glauber Costa <glommer@redhat.com>
---
 arch/x86/kernel/kvmclock.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index 223af43..e5efcdc 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -50,8 +50,8 @@ static unsigned long kvm_get_wallclock(void)
 	struct timespec ts;
 	int low, high;
 
-	low = (int)__pa(&wall_clock);
-	high = ((u64)__pa(&wall_clock) >> 32);
+	low = (int)__pa_symbol(&wall_clock);
+	high = ((u64)__pa_symbol(&wall_clock) >> 32);
 	native_write_msr(MSR_KVM_WALL_CLOCK, low, high);
 
 	vcpu_time = &get_cpu_var(hv_clock);
-- 
1.6.2.2

