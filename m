Return-Path: <linux-kernel-owner+w=401wt.eu-S1753884AbZKCP5B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884AbZKCP5B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 10:57:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752713AbZKCP5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 10:57:00 -0500
Received: from hera.kernel.org ([140.211.167.34]:41978 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752597AbZKCP47 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 10:56:59 -0500
Date: Tue, 3 Nov 2009 15:54:38 GMT
From: tip-bot for Arjan van de Ven <arjan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       arjan@linux.intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       arjan@linux.intel.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20091102165915.4a980fc0@infradead.org>
References: <20091102165915.4a980fc0@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/debug] x86: Make sure we also print a Code: line for show_regs()
Message-ID: <tip-a489ca355efaf9efa4990b0f8f30ab650a206273@git.kernel.org>
Git-Commit-ID: a489ca355efaf9efa4990b0f8f30ab650a206273
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a489ca355efaf9efa4990b0f8f30ab650a206273
Gitweb:     http://git.kernel.org/tip/a489ca355efaf9efa4990b0f8f30ab650a206273
Author:     Arjan van de Ven <arjan@linux.intel.com>
AuthorDate: Mon, 2 Nov 2009 16:59:15 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 3 Nov 2009 16:50:22 +0100

x86: Make sure we also print a Code: line for show_regs()

show_regs() is called as a mini BUG() equivalent in some places,
specifically for the "scheduling while atomic" case.

Unfortunately right now it does not print a Code: line unlike
a real bug/oops.

This patch changes the x86 implementation of show_regs() so that
it calls the same function as oopses do to print the registers
as well as the Code: line.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
LKML-Reference: <20091102165915.4a980fc0@infradead.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/process_32.c |    2 +-
 arch/x86/kernel/process_64.c |    3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 4cf7956..e658331 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -187,7 +187,7 @@ void __show_regs(struct pt_regs *regs, int all)
 
 void show_regs(struct pt_regs *regs)
 {
-	__show_regs(regs, 1);
+	show_registers(regs);
 	show_trace(NULL, regs, &regs->sp, regs->bp);
 }
 
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index ad535b6..2386999 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -226,8 +226,7 @@ void __show_regs(struct pt_regs *regs, int all)
 
 void show_regs(struct pt_regs *regs)
 {
-	printk(KERN_INFO "CPU %d:", smp_processor_id());
-	__show_regs(regs, 1);
+	show_registers(regs);
 	show_trace(NULL, regs, (void *)(regs + 1), regs->bp);
 }
 
