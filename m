Return-Path: <linux-kernel-owner+w=401wt.eu-S1757304AbZKWLxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757304AbZKWLxv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 06:53:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757237AbZKWLxu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 06:53:50 -0500
Received: from hera.kernel.org ([140.211.167.34]:56053 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757254AbZKWLxt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 06:53:49 -0500
Date: Mon, 23 Nov 2009 11:53:28 GMT
From: tip-bot for Jan Beulich <JBeulich@novell.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jbeulich@novell.com, JBeulich@novell.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jbeulich@novell.com, JBeulich@novell.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <4B06AEFE02000078000211F4@vpn.id2.novell.com>
References: <4B06AEFE02000078000211F4@vpn.id2.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/debug] x86: Suppress stack overrun message for init_task
Message-ID: <tip-0e7810be30f66e9f430c4ce2cd3b14634211690f@git.kernel.org>
Git-Commit-ID: 0e7810be30f66e9f430c4ce2cd3b14634211690f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0e7810be30f66e9f430c4ce2cd3b14634211690f
Gitweb:     http://git.kernel.org/tip/0e7810be30f66e9f430c4ce2cd3b14634211690f
Author:     Jan Beulich <JBeulich@novell.com>
AuthorDate: Fri, 20 Nov 2009 14:00:14 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 23 Nov 2009 11:45:34 +0100

x86: Suppress stack overrun message for init_task

init_task doesn't get its stack end location set to
STACK_END_MAGIC, and hence the message is confusing
rather than helpful in this case.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
LKML-Reference: <4B06AEFE02000078000211F4@vpn.id2.novell.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/fault.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index f4cee90..071eee6 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -658,7 +658,7 @@ no_context(struct pt_regs *regs, unsigned long error_code,
 	show_fault_oops(regs, error_code, address);
 
 	stackend = end_of_stack(tsk);
-	if (*stackend != STACK_END_MAGIC)
+	if (tsk != &init_task && *stackend != STACK_END_MAGIC)
 		printk(KERN_ALERT "Thread overran stack, or stack corrupted\n");
 
 	tsk->thread.cr2		= address;
