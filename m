Return-Path: <linux-kernel-owner+w=401wt.eu-S1757177AbZEAK0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757177AbZEAK0h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 06:26:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755060AbZEAK0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 06:26:14 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45656 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753069AbZEAK0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 06:26:13 -0400
Message-Id: <20090501102533.109867793@chello.nl>
References: <20090501102315.367605848@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 01 May 2009 12:23:17 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 2/4] perf_counter: fix nmi-watchdog interaction
Content-Disposition: inline; filename=perf_counter-fix-nmi.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we don't have any perf-counters active, don't act like we know
what the NMI is for.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/x86/kernel/cpu/perf_counter.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6/arch/x86/kernel/cpu/perf_counter.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_counter.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_counter.c
@@ -891,6 +891,9 @@ perf_counter_nmi_handler(struct notifier
 	struct pt_regs *regs;
 	int ret;
 
+	if (!atomic_read(&num_counters))
+		return NOTIFY_DONE;
+
 	switch (cmd) {
 	case DIE_NMI:
 	case DIE_NMI_IPI:

-- 

