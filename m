Return-Path: <linux-kernel-owner+w=401wt.eu-S1754177AbYLHOeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177AbYLHOeT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 09:34:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752237AbYLHOeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 09:34:09 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39515 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752187AbYLHOeI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 09:34:08 -0500
Date: Mon, 8 Dec 2008 15:33:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ken Chen <kenchen@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Paul Menage <menage@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] export percpu cpuacct cgroup stats
Message-ID: <20081208143352.GG14856@elte.hu>
References: <b040c32a0812032048x4a11dc26k184a4b279b509050@mail.gmail.com> <49376BE3.1040909@cn.fujitsu.com> <6599ad830812041502m15f54f0ckd8baa0a1792fc31e@mail.gmail.com> <b040c32a0812042344n75117b68x8de975d12dddf594@mail.gmail.com> <4938DE1C.6070608@cn.fujitsu.com> <b040c32a0812050030uff5ae65o417c599a792c800c@mail.gmail.com> <4938E7C1.9040102@cn.fujitsu.com> <20081205135253.GE27039@elte.hu> <b040c32a0812051016q7912688dw2c663a77121a8f18@mail.gmail.com> <20081206232714.4b34b2fc.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081206232714.4b34b2fc.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 5 Dec 2008 10:16:30 -0800 Ken Chen <kenchen@google.com> wrote:
> 
> > +static int cpuacct_percpu_seq_read(struct cgroup *cgroup, struct cftype *cft,
> > +				   struct seq_file *m)
> > +{
> > +	struct cpuacct *ca = cgroup_ca(cgroup);
> > +	u64 percpu;
> > +	int i;
> > +
> > +	for_each_possible_cpu(i) {
> > +		spin_lock_irq(&cpu_rq(i)->lock);
> > +		percpu = *percpu_ptr(ca->cpuusage, i);
> > +		spin_unlock_irq(&cpu_rq(i)->lock);
> > +		seq_printf(m, "%llu ", (unsigned long long) percpu);
> > +	}
> > +	seq_printf(m, "\n");
> > +	return 0;
> > +}
> 
> The locking is only needed for 32-bit, I assume?
> 
> The iteration across all possible CPUs seems a bit lame - that code
> looks pretty easy to convert to hotplug goodness.
> 
> (All of which pertains to existing code, not to this patch).

fair enough. Ken, would you mind updating it in this fashion?

	Ingo
