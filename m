Return-Path: <linux-kernel-owner+w=401wt.eu-S1752908AbZDNAKO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908AbZDNAKO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 20:10:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751976AbZDNAJ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 20:09:59 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38084 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751626AbZDNAJ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 20:09:59 -0400
Date: Tue, 14 Apr 2009 02:09:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Tony Luck <tony.luck@intel.com>
Cc: mingo@redhat.com, hpa@zytor.com, ego@in.ibm.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/urgent] sched: Print sched_group::__cpu_power in
	sched_domain_debug
Message-ID: <20090414000934.GN817@elte.hu>
References: <20090330045520.2869.24777.stgit@sofia.in.ibm.com> <tip-46e0bb9c12f4bab539736f1714cbf16600f681ec@git.kernel.org> <12c511ca0904131153g39b99ec6n6c6ec2e7de3f7ea6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <12c511ca0904131153g39b99ec6n6c6ec2e7de3f7ea6@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tony Luck <tony.luck@intel.com> wrote:

> > --- a/kernel/sched.c
> > +++ b/kernel/sched.c
> > @@ -6963,7 +6963,8 @@ static int sched_domain_debug_one(struct sched_domain *sd, int cpu, int level,
> >                cpumask_or(groupmask, groupmask, sched_group_cpus(group));
> >
> >                cpulist_scnprintf(str, sizeof(str), sched_group_cpus(group));
> > -               printk(KERN_CONT " %s", str);
> > +               printk(KERN_CONT " %s (__cpu_power = %d)", str,
> > +                                               group->__cpu_power);
> 
> This has added a lot of clutter to the console log during boot
> (especially on large systems).
> 
> Here is the start of the diff output comparing old and new console
> messages on a 16 cpu machine:
> 
> 77c77
> <   groups: 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
> ---
> >   groups: 0 (__cpu_power = 1024) 1 (__cpu_power = 1024) 2 (__cpu_power = 1024) 3 (__cpu_power = 1024) 4 (__cpu_power = 1024) 5 (__cpu_power = 1024) 6 (__cpu_power = 1024) 7 (__cpu_power = 1024) 8 (
> __cpu_power = 1024) 9 (__cpu_power = 1024) 10 (__cpu_power = 1024) 11
> (__cpu_power = 1024) 12 (__cpu_power = 1024) 13 (__cpu_power = 1024)
> 14 (__cpu_power = 1024) 15 (__cpu_power = 1024)
> 80c80

indeed ...

I think we should skip the printout in the default (power==1024) 
case. Gautham?

	Ingo
