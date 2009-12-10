Return-Path: <linux-kernel-owner+w=401wt.eu-S1755364AbZLJInv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364AbZLJInv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 03:43:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755382AbZLJInp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 03:43:45 -0500
Received: from hera.kernel.org ([140.211.167.34]:51713 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753803AbZLJIno (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 03:43:44 -0500
Date: Thu, 10 Dec 2009 08:43:04 GMT
From: tip-bot for Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       joe@perches.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       joe@perches.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <bbd4de532f18bb7c11f64ba20d224c08291cb126.1260383912.git.joe@perches.com>
References: <bbd4de532f18bb7c11f64ba20d224c08291cb126.1260383912.git.joe@perches.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: i8254.c: Add pr_fmt(fmt)
Message-ID: <tip-a78d9626f4f6fa7904bfdb071205080743125983@git.kernel.org>
Git-Commit-ID: a78d9626f4f6fa7904bfdb071205080743125983
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a78d9626f4f6fa7904bfdb071205080743125983
Gitweb:     http://git.kernel.org/tip/a78d9626f4f6fa7904bfdb071205080743125983
Author:     Joe Perches <joe@perches.com>
AuthorDate: Wed, 9 Dec 2009 10:45:35 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 10 Dec 2009 08:57:50 +0100

x86: i8254.c: Add pr_fmt(fmt)

- Add pr_fmt(fmt) "pit: " fmt
 - Strip pit: prefixes from pr_debug

Signed-off-by: Joe Perches <joe@perches.com>
LKML-Reference: <bbd4de532f18bb7c11f64ba20d224c08291cb126.1260383912.git.joe@perches.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
