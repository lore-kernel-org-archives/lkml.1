Return-Path: <linux-kernel-owner+w=401wt.eu-S1755168AbZDUINs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755168AbZDUINs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 04:13:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753910AbZDUIN3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 04:13:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:33821 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754734AbZDUINZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 04:13:25 -0400
Date: Tue, 21 Apr 2009 08:12:42 GMT
From: tip-bot for Rusty Russell <rusty@rustcorp.com.au>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, rusty@rustcorp.com.au, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rusty@rustcorp.com.au, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <alpine.DEB.2.00.0904202113520.10097@gandalf.stny.rr.com>
References: <alpine.DEB.2.00.0904202113520.10097@gandalf.stny.rr.com>
Subject: [tip:x86/urgent] x86: avoid theoretical spurious NMI backtraces with CONFIG_CPUMASK_OFFSTACK=y
Message-ID: <tip-fcc5c4a2feea3886dc058498b28508b2731720d5@git.kernel.org>
Git-Commit-ID: fcc5c4a2feea3886dc058498b28508b2731720d5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 21 Apr 2009 08:12:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fcc5c4a2feea3886dc058498b28508b2731720d5
Gitweb:     http://git.kernel.org/tip/fcc5c4a2feea3886dc058498b28508b2731720d5
Author:     Rusty Russell <rusty@rustcorp.com.au>
AuthorDate: Tue, 21 Apr 2009 16:03:41 +0930
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 21 Apr 2009 10:09:50 +0200

x86: avoid theoretical spurious NMI backtraces with CONFIG_CPUMASK_OFFSTACK=y

In theory (though not shown in practice) alloc_cpumask_var() doesn't zero
memory, so CPUs might print an "NMI backtrace for cpu %d" once on boot.

(Bug introduced in fcef8576d8a64fc603e719c97d423f9f6d4e0e8b).

[ Impact: avoid theoretical syslog noise in rare configs ]

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <alpine.DEB.2.00.0904202113520.10097@gandalf.stny.rr.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/apic/nmi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apic/nmi.c b/arch/x86/kernel/apic/nmi.c
index 2ba52f3..ce4fbfa 100644
--- a/arch/x86/kernel/apic/nmi.c
+++ b/arch/x86/kernel/apic/nmi.c
@@ -138,7 +138,7 @@ int __init check_nmi_watchdog(void)
 	if (!prev_nmi_count)
 		goto error;
 
-	alloc_cpumask_var(&backtrace_mask, GFP_KERNEL);
+	alloc_cpumask_var(&backtrace_mask, GFP_KERNEL|__GFP_ZERO);
 	printk(KERN_INFO "Testing NMI watchdog ... ");
 
 #ifdef CONFIG_SMP
