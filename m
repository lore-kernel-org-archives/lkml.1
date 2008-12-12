Return-Path: <linux-kernel-owner+w=401wt.eu-S1757076AbYLLHX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757076AbYLLHX4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 02:23:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751920AbYLLHXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 02:23:48 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46574 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750795AbYLLHXs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 02:23:48 -0500
Date: Fri, 12 Dec 2008 08:23:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Markus Metzger <markus.t.metzger@intel.com>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       markus.t.metzger@gmail.com, roland@redhat.com,
       akpm@linux-foundation.org, eranian@googlemail.com
Subject: [PATCH] x86, bts: fix build error
Message-ID: <20081212072324.GA10705@elte.hu>
References: <20081211134959.A13599@sedona.ch.intel.com> <20081212070932.GB7589@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081212070932.GB7589@elte.hu>
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


Markus,

i fixed a build failure via the commit below - but the recursion in that 
code is really nasty. Could you please clean it all up to plain flat 
code?

	Ingo

----------------->
>From ffc2238af8431d930d2c15f16feecf1fd6d75642 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Fri, 12 Dec 2008 08:21:19 +0100
Subject: [PATCH] x86, bts: fix build error

Impact: build fix

 arch/x86/kernel/ds.c: In function 'ds_request':
 arch/x86/kernel/ds.c:236: sorry, unimplemented: inlining failed in call to 'ds_get_context': recursive inlining

but the recursion here is scary ...

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/ds.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/ds.c b/arch/x86/kernel/ds.c
index f058300..dc1e712 100644
--- a/arch/x86/kernel/ds.c
+++ b/arch/x86/kernel/ds.c
@@ -232,7 +232,7 @@ static DEFINE_PER_CPU(struct ds_context *, system_context_array);
 
 #define system_context per_cpu(system_context_array, smp_processor_id())
 
-static inline struct ds_context *ds_get_context(struct task_struct *task)
+static struct ds_context *ds_get_context(struct task_struct *task)
 {
 	struct ds_context **p_context =
 		(task ? &task->thread.ds_ctx : &system_context);
