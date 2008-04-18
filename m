Return-Path: <linux-kernel-owner+w=401wt.eu-S1755042AbYDRMUM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755042AbYDRMUM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 08:20:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752442AbYDRMT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 08:19:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57743 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752034AbYDRMT5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 08:19:57 -0400
Date: Fri, 18 Apr 2008 14:18:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       James Morris <jmorris@namei.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-pm@lists.linux-foundation.org, Greg KH <greg@kroah.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       Jack Steiner <steiner@sgi.com>, Mike Travis <travis@sgi.com>,
       Alan Mayer <ajm@sgi.com>
Subject: Re: 2.6.25-mm1: not looking good
Message-ID: <20080418121853.GA13623@elte.hu>
References: <20080417160331.b4729f0c.akpm@linux-foundation.org> <20080418005034.6e4dd9e7.akpm@linux-foundation.org> <20080418005323.7c015c42.akpm@linux-foundation.org> <20080418005733.aa3e8250.akpm@linux-foundation.org> <20080418092254.GA20661@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080418092254.GA20661@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> Subject: x86: disable preemption in native_smp_prepare_cpus

that should be the patch below.

	Ingo

------------>
Subject: x86: disable preemption in native_smp_prepare_cpus
From: Ingo Molnar <mingo@elte.hu>
Date: Fri Apr 18 11:07:10 CEST 2008

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/smpboot.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: linux-x86.q/arch/x86/kernel/smpboot.c
===================================================================
--- linux-x86.q.orig/arch/x86/kernel/smpboot.c
+++ linux-x86.q/arch/x86/kernel/smpboot.c
@@ -1181,6 +1181,7 @@ static void __init smp_cpu_index_default
  */
 void __init native_smp_prepare_cpus(unsigned int max_cpus)
 {
+	preempt_disable();
 	nmi_watchdog_default();
 	smp_cpu_index_default();
 	current_cpu_data = boot_cpu_data;
@@ -1197,7 +1198,7 @@ void __init native_smp_prepare_cpus(unsi
 	if (smp_sanity_check(max_cpus) < 0) {
 		printk(KERN_INFO "SMP disabled\n");
 		disable_smp();
-		return;
+		goto out;
 	}
 
 	preempt_disable();
@@ -1237,6 +1238,8 @@ void __init native_smp_prepare_cpus(unsi
 	printk(KERN_INFO "CPU%d: ", 0);
 	print_cpu_info(&cpu_data(0));
 	setup_boot_clock();
+out:
+	preempt_enable();
 }
 /*
  * Early setup to make printk work.
