Return-Path: <linux-kernel-owner+w=401wt.eu-S1756159AbZCDRk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159AbZCDRk0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 12:40:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753620AbZCDRkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 12:40:13 -0500
Received: from hera.kernel.org ([140.211.167.34]:35602 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751639AbZCDRkL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 12:40:11 -0500
Date: Wed, 4 Mar 2009 17:39:32 GMT
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1236175192.5330.7585.camel@laptop>
References: <1236175192.5330.7585.camel@laptop>
Subject: [tip:core/locking] lockdep: remove extra "irq" string
Message-ID: <tip-26575e28df5eb2050c02369843faba38cecb4d8c@git.kernel.org>
Git-Commit-ID: 26575e28df5eb2050c02369843faba38cecb4d8c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 04 Mar 2009 17:39:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  26575e28df5eb2050c02369843faba38cecb4d8c
Gitweb:     http://git.kernel.org/tip/26575e28df5eb2050c02369843faba38cecb4d8c
Author:     "Peter Zijlstra" <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 4 Mar 2009 14:53:24 +0100
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 4 Mar 2009 18:38:34 +0100

lockdep: remove extra "irq" string

Impact: clarify lockdep printk text

print_irq_inversion_bug() gets handed state strings of the form

  "HARDIRQ", "SOFTIRQ", "RECLAIM_FS"

and appends "-irq-{un,}safe" to them, which is either redudant for *IRQ or
confusing in the RECLAIM_FS case.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1236175192.5330.7585.camel@laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/lockdep.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index ef6584f..02014f7 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -1900,9 +1900,9 @@ print_irq_inversion_bug(struct task_struct *curr, struct lock_class *other,
 		curr->comm, task_pid_nr(curr));
 	print_lock(this);
 	if (forwards)
-		printk("but this lock took another, %s-irq-unsafe lock in the past:\n", irqclass);
+		printk("but this lock took another, %s-unsafe lock in the past:\n", irqclass);
 	else
-		printk("but this lock was taken by another, %s-irq-safe lock in the past:\n", irqclass);
+		printk("but this lock was taken by another, %s-safe lock in the past:\n", irqclass);
 	print_lock_name(other);
 	printk("\n\nand interrupts could create inverse lock ordering between them.\n\n");
 
