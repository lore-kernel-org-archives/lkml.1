Return-Path: <linux-kernel-owner+w=401wt.eu-S1755526AbYGZOuL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526AbYGZOuL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 10:50:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752181AbYGZOt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 10:49:59 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34367 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752162AbYGZOt6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 10:49:58 -0400
Date: Sat, 26 Jul 2008 16:49:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] cpumask: Change cpumask_of_cpu to use
	cpumask_of_cpu_map V2
Message-ID: <20080726144941.GA6614@elte.hu>
References: <20080725012128.805332000@polaris-admin.engr.sgi.com> <20080726144133.GA27011@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080726144133.GA27011@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> i've applied it to tip/cpus4096 and started testing it. This is the 
> topic where the problem originates from, so we can reuse it for 
> linux-next.

fixlet below.

	Ingo

-------------->
>From 5a7a201c51c324876d00a54e7208af6af12d1ca4 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Sat, 26 Jul 2008 16:50:47 +0200
Subject: [PATCH] cpumask: export cpumask_of_cpu_map

fix:

 ERROR: "cpumask_of_cpu_map" [drivers/acpi/processor.ko] undefined!
 ERROR: "cpumask_of_cpu_map" [arch/x86/kernel/microcode.ko] undefined!
 ERROR: "cpumask_of_cpu_map" [arch/x86/kernel/cpu/cpufreq/speedstep-ich.ko] undefined!
 ERROR: "cpumask_of_cpu_map" [arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.ko] undefined!

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/cpu.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index 9d4e1c2..a35d899 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -572,3 +572,5 @@ __initdata
 };
 
 const cpumask_t *cpumask_of_cpu_map = cpumask_map;
+
+EXPORT_SYMBOL_GPL(cpumask_of_cpu_map);
