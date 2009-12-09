Return-Path: <linux-kernel-owner+w=401wt.eu-S1757070AbZLISpw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757070AbZLISpw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 13:45:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757103AbZLISpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 13:45:36 -0500
Received: from mail.perches.com ([173.55.12.10]:1046 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757044AbZLISpb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 13:45:31 -0500
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] i8254.c: Add pr_fmt(fmt)
Date: Wed,  9 Dec 2009 10:45:35 -0800
Message-Id: <bbd4de532f18bb7c11f64ba20d224c08291cb126.1260383912.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
In-Reply-To: <cover.1260383912.git.joe@perches.com>
References: <20091209072630.GA8187@elte.hu> <cover.1260383912.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add pr_fmt(fmt) "pit: " fmt
Strip pit: prefixes from pr_debug

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/x86/kvm/i8254.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index fab7440..296aba4 100644
--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -29,6 +29,8 @@
  *   Based on QEMU and Xen.
  */
 
+#define pr_fmt(fmt) "pit: " fmt
+
 #include <linux/kvm_host.h>
 
 #include "irq.h"
@@ -262,7 +264,7 @@ void __kvm_migrate_pit_timer(struct kvm_vcpu *vcpu)
 
 static void destroy_pit_timer(struct kvm_timer *pt)
 {
-	pr_debug("pit: execute del timer!\n");
+	pr_debug("execute del timer!\n");
 	hrtimer_cancel(&pt->timer);
 }
 
@@ -284,7 +286,7 @@ static void create_pit_timer(struct kvm_kpit_state *ps, u32 val, int is_period)
 
 	interval = muldiv64(val, NSEC_PER_SEC, KVM_PIT_FREQ);
 
-	pr_debug("pit: create pit timer, interval is %llu nsec\n", interval);
+	pr_debug("create pit timer, interval is %llu nsec\n", interval);
 
 	/* TODO The new value only affected after the retriggered */
 	hrtimer_cancel(&pt->timer);
@@ -309,7 +311,7 @@ static void pit_load_count(struct kvm *kvm, int channel, u32 val)
 
 	WARN_ON(!mutex_is_locked(&ps->lock));
 
-	pr_debug("pit: load_count val is %d, channel is %d\n", val, channel);
+	pr_debug("load_count val is %d, channel is %d\n", val, channel);
 
 	/*
 	 * The largest possible initial count is 0; this is equivalent
@@ -395,8 +397,8 @@ static int pit_ioport_write(struct kvm_io_device *this,
 	mutex_lock(&pit_state->lock);
 
 	if (val != 0)
-		pr_debug("pit: write addr is 0x%x, len is %d, val is 0x%x\n",
-			  (unsigned int)addr, len, val);
+		pr_debug("write addr is 0x%x, len is %d, val is 0x%x\n",
+			 (unsigned int)addr, len, val);
 
 	if (addr == 3) {
 		channel = val >> 6;
-- 
1.6.6.rc0.57.gad7a

