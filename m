Return-Path: <linux-kernel-owner+w=401wt.eu-S1753844AbZEDScg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844AbZEDScg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 14:32:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751797AbZEDSc1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 14:32:27 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40482 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751791AbZEDSc1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 14:32:27 -0400
Date: Mon, 4 May 2009 20:32:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: x86: changed output in /proc/cpuinfo for siblings
Message-ID: <20090504183207.GA14220@elte.hu>
References: <20090504182859.GA29045@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090504182859.GA29045@alberich.amd.com>
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


* Andreas Herrmann <andreas.herrmann3@amd.com> wrote:

> Commit 7ad728f98162cb1af06a85b2a5fc422dddd4fb78
> (cpumask: x86: convert cpu_sibling_map/cpu_core_map to cpumask_var_t)
> changed the output of /proc/cpuinfo for siblings:
> 
> Example on an AMD Phenom:
> 
>   physical id   : 0
>   siblings : 1
>   core id	   : 3
>   cpu cores  : 4
> 
> Before that commit it was:
> 
>   physical id	: 0
>   siblings : 4
>   core id	   : 3
>   cpu cores  : 4
> 
> Instead of cpu_core_mask it now uses cpu_sibling_mask to count siblings.
> This is due to the following hunk of above commit:
> 
>   --- a/arch/x86/kernel/cpu/proc.c
>   +++ b/arch/x86/kernel/cpu/proc.c
>   @@ -14,7 +14,7 @@ static void show_cpuinfo_core(struct seq_file *m, struct cpuinf
>           if (c->x86_max_cores * smp_num_siblings > 1) {
>                   seq_printf(m, "physical id\t: %d\n", c->phys_proc_id);
>                   seq_printf(m, "siblings\t: %d\n",
>   -                          cpus_weight(per_cpu(cpu_core_map, cpu)));
>   +                          cpumask_weight(cpu_sibling_mask(cpu)));
>                   seq_printf(m, "core id\t\t: %d\n", c->cpu_core_id);
>                   seq_printf(m, "cpu cores\t: %d\n", c->booted_cores);
>                   seq_printf(m, "apicid\t\t: %d\n", c->apicid);
> 
> Was this the intention or just a mistake?

it was a mistake, because the impact-line does not mention this 
side-effect:

  Impact: reduce per-cpu size for CONFIG_CPUMASK_OFFSTACK=y

> In the latter case attached patch reverts this hunk.

applied, thanks!

	Ingo
