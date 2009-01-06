Return-Path: <linux-kernel-owner+w=401wt.eu-S1753956AbZAFPVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956AbZAFPVi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 10:21:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751927AbZAFPV0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 10:21:26 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56737 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750950AbZAFPVZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 10:21:25 -0500
Date: Tue, 6 Jan 2009 16:21:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, travis@sgi.com
Subject: Re: tip: IA64 build error
Message-ID: <20090106152111.GA11114@elte.hu>
References: <20090106233758L.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090106233758L.fujita.tomonori@lab.ntt.co.jp>
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


* FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> I got the followings with tip/master:
> 
> drivers/pci/probe.c: In function 'pci_bus_show_cpuaffinity':
> drivers/pci/probe.c:56: error: implicit declaration of function 'cpumask_from_node'
> drivers/pci/probe.c:56: warning: pointer/integer type mismatch in conditional expression
> make[3]: *** [drivers/pci/probe.o] Error 1
> make[2]: *** [drivers/pci] Error 2
> 
> 
> it's due to the typo in arch/ia64/include/asm/topology.h, I guess.

yeah. Does the patch below fix it for you?

	Ingo

---------------->
>From 36c401a44abcc389a00f9cd14892c9cf9bf0780d Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Tue, 6 Jan 2009 16:19:22 +0100
Subject: [PATCH] [IA64] fix typo in cpumask_of_pcibus()

Impact: build fix

Fujita Tomonori reported:

 drivers/pci/probe.c: In function 'pci_bus_show_cpuaffinity':
 drivers/pci/probe.c:56: error: implicit declaration of function 'cpumask_from_node'
 drivers/pci/probe.c:56: warning: pointer/integer type mismatch in conditional expression
 make[3]: *** [drivers/pci/probe.o] Error 1
 make[2]: *** [drivers/pci] Error 2

FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/ia64/include/asm/topology.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/ia64/include/asm/topology.h b/arch/ia64/include/asm/topology.h
index 76a33a9..32f3af1 100644
--- a/arch/ia64/include/asm/topology.h
+++ b/arch/ia64/include/asm/topology.h
@@ -124,7 +124,7 @@ extern void arch_fix_phys_package_id(int num, u32 slot);
 
 #define cpumask_of_pcibus(bus)	(pcibus_to_node(bus) == -1 ?		\
 				 cpu_all_mask :				\
-				 cpumask_from_node(pcibus_to_node(bus)))
+				 cpumask_of_node(pcibus_to_node(bus)))
 
 #include <asm-generic/topology.h>
 
