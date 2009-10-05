Return-Path: <linux-kernel-owner+w=401wt.eu-S1758250AbZJEA62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758250AbZJEA62 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 20:58:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758216AbZJEA60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 20:58:26 -0400
Received: from mail.perches.com ([173.55.12.10]:1727 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758247AbZJEAzT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 20:55:19 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, kvm@vger.kernel.org
Subject: [PATCH 11/21] i8254.c: Add pr_fmt(fmt)
Date: Sun,  4 Oct 2009 17:53:38 -0700
Message-Id: <fe4d04ce8259611e9592e400032494a110d81286.1254701151.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1254701151.git.joe@perches.com>
References: <cover.1254701151.git.joe@perches.com>
In-Reply-To: <cover.1254701151.git.joe@perches.com>
References: <cover.1254701151.git.joe@perches.com>
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
index 82ad523..fa83a15 100644
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
1.6.3.1.10.g659a0.dirty

