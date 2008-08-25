Return-Path: <linux-kernel-owner+w=401wt.eu-S1755927AbYHYJNP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927AbYHYJNP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 05:13:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753530AbYHYJM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 05:12:59 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44908 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753236AbYHYJM7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 05:12:59 -0400
Date: Mon, 25 Aug 2008 11:12:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Robert Richter <robert.richter@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Jan Beulich <jbeulich@novell.com>, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH] x86: fix: make PCI ECS for AMD CPUs hotplug capable
	(-v2)
Message-ID: <20080825091238.GA9114@elte.hu>
References: <20080823153725.GB16984@elte.hu> <1219654859-1010-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1219654859-1010-1-git-send-email-robert.richter@amd.com>
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


* Robert Richter <robert.richter@amd.com> wrote:

> Until now, PCI ECS setup was performed at boot time only and for cpus 
> that are enabled then. This patch fixes this and adds cpu hotplug.

i already had v1 applied to tip/x86/urgent, so i took the -v2 delta and 
queued it up in tip/x86/cleanups - see the commit below.

	Ingo

--------------->
>From ed21763e7b0b3fb50e4efd9d4bc17ef5b035d304 Mon Sep 17 00:00:00 2001
From: Robert Richter <robert.richter@amd.com>
Date: Fri, 22 Aug 2008 20:23:38 +0200
Subject: [PATCH] x86: cleanup in amd_cpu_notify()

small coding style fix.

Signed-off-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/pci/amd_bus.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/pci/amd_bus.c b/arch/x86/pci/amd_bus.c
index 6a0fca7..22e0576 100644
--- a/arch/x86/pci/amd_bus.c
+++ b/arch/x86/pci/amd_bus.c
@@ -580,7 +580,7 @@ static int __cpuinit amd_cpu_notify(struct notifier_block *self,
 				    unsigned long action, void *hcpu)
 {
 	int cpu = (long)hcpu;
-	switch(action) {
+	switch (action) {
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
 		smp_call_function_single(cpu, enable_pci_io_ecs, NULL, 0);
