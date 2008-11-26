Return-Path: <linux-kernel-owner+w=401wt.eu-S1753917AbYKZOQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917AbYKZOQU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 09:16:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752260AbYKZOQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 09:16:11 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36421 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752303AbYKZOQK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 09:16:10 -0500
Date: Wed, 26 Nov 2008 15:15:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: eranian@googlemail.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, x86@kernel.org,
       andi@firstfloor.org, eranian@gmail.com, sfr@canb.auug.org.au
Subject: Re: [patch 00/24] perfmon: introduction
Message-ID: <20081126141544.GH6562@elte.hu>
References: <492d0bd3.1ade660a.31f9.5137@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <492d0bd3.1ade660a.31f9.5137@mx.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


please remove all this debug crap from the patches:

+	PFM_DBG_ovfl("pfm_arch_write_pmc(0x%lx, 0x%Lx)",
+	PFM_DBG_ovfl("pfm_arch_write_pmd(0x%lx, 0x%Lx)",
+	PFM_DBG_ovfl("pfm_arch_read_pmd(0x%lx) = 0x%Lx",
+	PFM_DBG_ovfl("pfm_arch_read_pmc(0x%lx) = 0x%016Lx",
+		PFM_DBG("clear cr4.pce");
+		PFM_DBG("set cr4.pce");
+	PFM_DBG_ovfl("state=%d", ctx->state);
+		PFM_DBG_ovfl("no ctx");
+		PFM_DBG_ovfl("no ovfl");
+	PFM_DBG("LTVPC=0x%lx using_nmi=%d",
+			PFM_DBG("pmc%d(%s) already used", i, d->desc);
+	PFM_DBG("nlost=%d info_flags=0x%x\n", nlost, pmu_info->flags);
+			PFM_DBG("pmd%d(%s) already used", i, d->desc);
+		PFM_DBG("pmc%u released", i);
+		PFM_DBG("pmd%u released", i);
+		PFM_DBG("acquired Northbridge event access globally");
+		PFM_DBG("global NorthBridge event conflict");
+		PFM_DBG("released NorthBridge events globally");
+	PFM_DBG("global=0x%llx set to 0x%llx",
+	PFM_DBG("global_ctrl restored to 0x%llx\n",
+#define _PFM_DBG(lm, f, x...) \
+#define PFM_DBG(f, x...) _PFM_DBG(0x1, f, ##x)
+#define PFM_DBG_ovfl(f, x...) _PFM_DBG(0x2, f, ##x)
+#define PFM_DBG(f, x...)	do {} while (0)
+#define PFM_DBG_ovfl(f, x...)	do {} while (0)
+	PFM_DBG("ctx_task=[%d] ctx_state=%d is_system=%d",
+	PFM_DBG("pid=%d",  task->pid);
+		PFM_DBG("load_pid=%d has a context "
+	PFM_DBG("novfls=%u", num_ovfls);
+		PFM_DBG("pmd%u val=0x%llx",
+	PFM_DBG("ctx_state=%d task [%d]",
+		PFM_DBG("released ownership");
+	PFM_DBG("state=%d is_self=%d", ctx->state, ctx->flags.is_self);
+		PFM_DBG("[%d] has no ctx", current->pid);
+	PFM_DBG("work_type=%d", type);
+		PFM_DBG("unkown type=%d", type);
+	PFM_DBG("context is zombie, bailing out");
+	PFM_DBG("free ctx @0x%p", ctx);
+		PFM_DBG("user group not allowed to create a task context");
+			PFM_DBG("pmc%u=0x%llx",
+	PFM_DBG("alloc ctx @0x%p", ctx);
+		PFM_DBG("no usable PMU registers");
+	PFM_DBG("flags=0x%x fd=%d", ctx_flags, fd);
+	PFM_DBG("state=%d", state);
+		PFM_DBG("zombie ctx for [%d]", ctx->task->pid);
+	PFM_DBG("called filp=%p", filp);
+	PFM_DBG("pfm_file_ops");
+	PFM_DBG("pfm_read called");
+	PFM_DBG("pfm_write called");
+	PFM_DBG("pfm_ioctl called");
+	PFM_DBG("new inode ino=%ld @%p", inode->i_ino, inode);
+		PFM_DBG_ovfl("pmd%u ovfl=%s new=0x%llx old=0x%llx "
+	PFM_DBG_ovfl("intr_pmds=0x%llx npend=%u ip=%p u_pmds=0x%llx",
+	PFM_DBG_ovfl("ctx is zombie, converted to spurious");
+		PFM_DBG_ovfl("no ctx");
+		PFM_DBG_ovfl("spurious: not owned by current task");
+		PFM_DBG_ovfl("spurious: monitoring non active");
+		PFM_DBG_ovfl("no npend_ovfls");
+	PFM_DBG("pmu_acquired=%d", pfm_pmu_acquired);
+			PFM_DBG("regs_all.pmcs=0x%llx",
+			PFM_DBG("PMU acquired: %u PMCs, %u PMDs, %u counters",
+	PFM_DBG("pmu_acquired=%d", pfm_pmu_acquired);
+		PFM_DBG("PMU released");
+	PFM_DBG("in  thread=%u",
+	PFM_DBG("out thread=%u ret=%d",
+	PFM_DBG("in thread=%u",
+	PFM_DBG("out thread=%u",
+	PFM_DBG("in  sys=%u task=%u",
+		PFM_DBG("already some system-wide sessions");
+		PFM_DBG("%u conflicting thread_sessions",
+	PFM_DBG("out sys=%u task=%u",
+	PFM_DBG("in  sys=%u task=%u",
+	PFM_DBG("out sys=%u task=%u",
+	PFM_DBG("u_pmds=0x%llx nu_pmds=%u u_pmcs=0x%llx nu_pmcs=%u",
+			PFM_DBG("pmd%u is not available", cnum);
+		PFM_DBG("pmd%u=0x%llx a_pmu=%d "
+			PFM_DBG("pmc%u is not available", cnum);
+		PFM_DBG("pmc%u=0x%llx a_pmu=%d "
+			PFM_DBG("pmd%u is not implemented/unaccessible", cnum);
+			PFM_DBG("pmd%u cannot read, because not used", cnum);
+		PFM_DBG("pmd%u=0x%llx ",
+		PFM_DBG("cannot attach to kernel thread [%d]", task->pid);
+		PFM_DBG("cannot attach to zombie/dead task [%d]", task->pid);
+		PFM_DBG("task not found %d", pid);
+	PFM_DBG("may_attach=%d check_attach=%d", ret1, ret);
+	PFM_DBG("state=%d check_mask=0x%x task=[%d]",
+		PFM_DBG("state=%d, cmd needs context unloaded", state);
+			PFM_DBG("old_state=%d new_state=%d",
+	PFM_DBG("ret=%d",ret);
+		PFM_DBG("argument too big %zu max=%zu",
+		PFM_DBG("invalid fd %d", fd);
+		PFM_DBG("fd %d not related to perfmon", fd);
+		PFM_DBG("invalid type=%d", type);
+		PFM_DBG("invalid size=%zu for type=%d", sz, type);
+	PFM_DBG("sz=%zu sz_type=%zu count=%zu",
+	PFM_DBG("flags=0x%x sif=%p", flags, ureq);
+		PFM_DBG("no flags accepted yet");
+	PFM_DBG("fd=%d flags=0x%x type=%d req=%p sz=%zu",
+		PFM_DBG("no flags defined");
+		PFM_DBG("invalid type=%d", type);
+	PFM_DBG("fd=%d flags=0x%x type=%d req=%p sz=%zu",
+		PFM_DBG("no flags defined");
+		PFM_DBG("invalid type=%d", type);
+	PFM_DBG("fd=%d uflags=0x%x state=0x%x", fd, uflags, state);
+		PFM_DBG("no flags defined");
+		PFM_DBG("invalid state=0x%x", state);
+	PFM_DBG("fd=%d uflags=0x%x target=%d", fd, uflags, target);
+		PFM_DBG("invalid flags");

they are used way too frequently and obscures the structure and 
purpose of the code. We wouldnt mind in a driver but this is core 
kernel code.

	Ingo
