Return-Path: <linux-kernel-owner+w=401wt.eu-S1752226AbZHSNbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226AbZHSNbk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 09:31:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752052AbZHSNbj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 09:31:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:43562 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751836AbZHSNbi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 09:31:38 -0400
Date: Wed, 19 Aug 2009 13:30:54 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20090819092023.812428023@chello.nl>
References: <20090819092023.812428023@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: powerpc: Support the anonimized kernel callchain bits
Message-ID: <tip-512cec5d6f2a71e04464bf4fd76a50571bd0dea1@git.kernel.org>
Git-Commit-ID: 512cec5d6f2a71e04464bf4fd76a50571bd0dea1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 19 Aug 2009 13:31:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  512cec5d6f2a71e04464bf4fd76a50571bd0dea1
Gitweb:     http://git.kernel.org/tip/512cec5d6f2a71e04464bf4fd76a50571bd0dea1
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 19 Aug 2009 11:18:25 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 19 Aug 2009 14:49:03 +0200

perf_counter: powerpc: Support the anonimized kernel callchain bits

Adds support for anonimized kernel callchains to the powerpc
callchain code.

This patch is not folded into the patch that introduces this
feature because the powerpc callchain code isn't upstream yet,
and this allows re-ordering the patches.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <20090819092023.812428023@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/powerpc/kernel/perf_callchain.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/kernel/perf_callchain.c b/arch/powerpc/kernel/perf_callchain.c
index f74b62c..21fb1ad 100644
--- a/arch/powerpc/kernel/perf_callchain.c
+++ b/arch/powerpc/kernel/perf_callchain.c
@@ -70,6 +70,11 @@ static void perf_callchain_kernel(struct pt_regs *regs,
 	lr = regs->link;
 	sp = regs->gpr[1];
 	callchain_store(entry, PERF_CONTEXT_KERNEL);
+	next_ip = perf_paranoid_anon_ip();
+	if (next_ip) {
+		callchain_store(entry, next_ip);
+		return;
+	}
 	callchain_store(entry, regs->nip);
 
 	if (!validate_sp(sp, current, STACK_FRAME_OVERHEAD))
