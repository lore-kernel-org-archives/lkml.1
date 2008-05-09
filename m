Return-Path: <linux-kernel-owner+w=401wt.eu-S1760452AbYEIJ7P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760452AbYEIJ7P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 05:59:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754227AbYEIJ65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 05:58:57 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37855 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753376AbYEIJ64 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 05:58:56 -0400
Date: Fri, 9 May 2008 11:58:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: toralf.foerster@gmx.de, James.Bottomley@hansenpartnership.com,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Mike Travis <travis@sgi.com>
Subject: Re: build issue #380 for v2.6.26-rc1-279-g28a4acb : mach-voyager:
	multiple definition of `phys_cpu_present_map'
Message-ID: <20080509095837.GB19617@elte.hu>
References: <200805091114.00244.toralf.foerster@gmx.de> <20080509095244.GJ2543@hacking>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080509095244.GJ2543@hacking>
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


* WANG Cong <xiyou.wangcong@gmail.com> wrote:

> Sorry. Ignore previous one. This one should be correct, I think.
> 
> ---
> 
> diff --git a/arch/x86/mach-voyager/voyager_smp.c b/arch/x86/mach-voyager/voyager_smp.c
> index 8acbf0c..2e8388b 100644
> --- a/arch/x86/mach-voyager/voyager_smp.c
> +++ b/arch/x86/mach-voyager/voyager_smp.c
> @@ -74,7 +74,7 @@ EXPORT_SYMBOL(cpu_online_map);
>  
>  /* Bitmask of CPUs present in the system - exported by i386_syms.c, used
>   * by scheduler but indexed physically */
> -cpumask_t phys_cpu_present_map = CPU_MASK_NONE;
> +static cpumask_t phys_cpu_present_map = CPU_MASK_NONE;

i've got the one below queued up but it's stalled as it could easily be 
wrong and there's no ack from James yet and there's been discussion back 
and forth. James, what do you suggest?

	Ingo

-------------------->
Subject: x86, voyager: build fix
From: Ingo Molnar <mingo@elte.hu>
Date: Sun May 04 23:56:30 CEST 2008

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mach-voyager/voyager_smp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-x86.q/arch/x86/mach-voyager/voyager_smp.c
===================================================================
--- linux-x86.q.orig/arch/x86/mach-voyager/voyager_smp.c
+++ linux-x86.q/arch/x86/mach-voyager/voyager_smp.c
@@ -74,7 +74,7 @@ EXPORT_SYMBOL(cpu_online_map);
 
 /* Bitmask of CPUs present in the system - exported by i386_syms.c, used
  * by scheduler but indexed physically */
-cpumask_t phys_cpu_present_map = CPU_MASK_NONE;
+extern cpumask_t phys_cpu_present_map;
 
 /* The internal functions */
 static void send_CPI(__u32 cpuset, __u8 cpi);
