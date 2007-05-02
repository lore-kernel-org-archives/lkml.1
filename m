Return-Path: <linux-kernel-owner+w=401wt.eu-S2993509AbXEBQl4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993509AbXEBQl4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 12:41:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993512AbXEBQl4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 12:41:56 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35773 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993509AbXEBQlz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 12:41:55 -0400
Date: Wed, 2 May 2007 18:41:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vegard Nossum <vegard@peltkore.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch] CFS scheduler, -v8
Message-ID: <20070502164152.GA2521@elte.hu>
References: <20070501212223.GA29867@elte.hu> <6734.129.240.220.12.1178110713.squirrel@peltkore.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6734.129.240.220.12.1178110713.squirrel@peltkore.net>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Vegard Nossum <vegard@peltkore.net> wrote:

> The sys_sched_yield_to() is not callable from userspace on i386 
> because it is not part of the syscall table 
> (arch/i386/kernel/syscall_table.S). This causes sysenter_entry 
> (arch/i386/kernel/entry.S) to use the wrong count for nr_syscalls (320 
> instead of 321) and return with -ENOSYS.

oops, indeed - the patch below should fix this. (x86 should really adopt 
the nice x86_64 technique of building the syscall table out of the 
unistd.h enumeration definitions.)

	Ingo

Index: linux/arch/i386/kernel/syscall_table.S
===================================================================
--- linux.orig/arch/i386/kernel/syscall_table.S
+++ linux/arch/i386/kernel/syscall_table.S
@@ -319,3 +319,4 @@ ENTRY(sys_call_table)
 	.long sys_move_pages
 	.long sys_getcpu
 	.long sys_epoll_pwait
+	.long sys_sched_yield_to	/* 320 */

