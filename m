Return-Path: <linux-kernel-owner+w=401wt.eu-S1760110AbYBSL1M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760110AbYBSL1M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 06:27:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752823AbYBSL06
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 06:26:58 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36386 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752507AbYBSL05 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 06:26:57 -0500
Date: Tue, 19 Feb 2008 12:26:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Machek <pavel@ucw.cz>
Cc: Thomas Gleixner <tglx@linutronix.de>, jbohac@suse.cz,
       kernel list <linux-kernel@vger.kernel.org>, jikos@suse.cz,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Andrew Morton <akpm@osdl.org>
Subject: Re: notsc is ignored on common configurations
Message-ID: <20080219112632.GA10798@elte.hu>
References: <20080218133852.GA1573@elf.ucw.cz> <alpine.LFD.1.00.0802181515070.7583@apollo.tec.linutronix.de> <20080218143757.GB1960@elf.ucw.cz> <alpine.LFD.1.00.0802181545090.7583@apollo.tec.linutronix.de> <20080219100230.GA1688@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080219100230.GA1688@elf.ucw.cz>
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


* Pavel Machek <pavel@ucw.cz> wrote:

> notsc is ignored in 32-bit kernels if CONFIG_X86_TSC is on.. which is 
> bad, fix it.

thanks, applied.

> -static unsigned int ref_freq = 0;
> -static unsigned long loops_per_jiffy_ref = 0;
> -static unsigned long cpu_khz_ref = 0;
> +static unsigned int ref_freq;
> +static unsigned long loops_per_jiffy_ref;
> +static unsigned long cpu_khz_ref;

i have split these changes into the separate patch below.

	Ingo

---------------->
Subject: x86: clean up =0 initializations in arch/x86/kernel/tsc_32.c
From: Pavel Machek <pavel@ucw.cz>
Date: Tue, 19 Feb 2008 11:02:30 +0100

Signed-off-by: Pavel Machek <pavel@suse.cz>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/tsc_32.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux-x86.q/arch/x86/kernel/tsc_32.c
===================================================================
--- linux-x86.q.orig/arch/x86/kernel/tsc_32.c
+++ linux-x86.q/arch/x86/kernel/tsc_32.c
@@ -222,9 +222,9 @@ EXPORT_SYMBOL(recalibrate_cpu_khz);
  * if the CPU frequency is scaled, TSC-based delays will need a different
  * loops_per_jiffy value to function properly.
  */
-static unsigned int ref_freq = 0;
-static unsigned long loops_per_jiffy_ref = 0;
-static unsigned long cpu_khz_ref = 0;
+static unsigned int ref_freq;
+static unsigned long loops_per_jiffy_ref;
+static unsigned long cpu_khz_ref;
 
 static int
 time_cpufreq_notifier(struct notifier_block *nb, unsigned long val, void *data)
@@ -286,7 +286,7 @@ core_initcall(cpufreq_tsc);
 
 /* clock source code */
 
-static unsigned long current_tsc_khz = 0;
+static unsigned long current_tsc_khz;
 
 static cycle_t read_tsc(void)
 {
