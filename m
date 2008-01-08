Return-Path: <linux-kernel-owner+w=401wt.eu-S1756303AbYAHJQ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756303AbYAHJQ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 04:16:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750768AbYAHJQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 04:16:45 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50965 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750711AbYAHJQn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 04:16:43 -0500
Date: Tue, 8 Jan 2008 10:15:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: akpm@linux-foundation.org, lkml <linux-kernel@vger.kernel.org>,
       Jim Keniston <jkenisto@us.ibm.com>, mhiramat@redhat.com,
       davem@davemloft.net, hskinnemoen@atmel.com
Subject: Re: [PATCH] Kprobes: Add kprobes smoke tests that run on boot
Message-ID: <20080108091550.GC27671@elte.hu>
References: <20080108063334.GA29385@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080108063334.GA29385@in.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ananth N Mavinakayanahalli <ananth@in.ibm.com> wrote:

> From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> 
> Here is a quick and naive smoke test for kprobes. This is intended to 
> just verify if some unrelated change broke the *probes subsystem. It 
> is self contained, architecture agnostic and isn't of any great use by 
> itself.
> 
> This needs to be built in the kernel and runs a basic set of tests to 
> verify if kprobes, jprobes and kretprobes run fine on the kernel. In 
> case of an error, it'll print out a message with a "BUG" prefix.

yay! Picked this up into x86.git for testing.

small detail: i moved the kernel/Makefile change to another spot (see 
below), this way it integrates without rejects with rcu-preempt and with 
the kgdb changes.

	Ingo

Index: linux-x86.q/kernel/Makefile
===================================================================
--- linux-x86.q.orig/kernel/Makefile
+++ linux-x86.q/kernel/Makefile
@@ -43,6 +43,7 @@ obj-$(CONFIG_CPUSETS) += cpuset.o
 obj-$(CONFIG_CGROUP_NS) += ns_cgroup.o
 obj-$(CONFIG_IKCONFIG) += configs.o
 obj-$(CONFIG_STOP_MACHINE) += stop_machine.o
+obj-$(CONFIG_KPROBES_SANITY_TEST) += test_kprobes.o
 obj-$(CONFIG_AUDIT) += audit.o auditfilter.o
 obj-$(CONFIG_AUDITSYSCALL) += auditsc.o
 obj-$(CONFIG_AUDIT_TREE) += audit_tree.o
