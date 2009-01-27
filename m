Return-Path: <linux-kernel-owner+w=401wt.eu-S1755377AbZA0AMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377AbZA0AMa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 19:12:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752526AbZA0AMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 19:12:21 -0500
Received: from mx2.redhat.com ([66.187.237.31]:54629 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751865AbZA0AMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 19:12:21 -0500
Date: Tue, 27 Jan 2009 01:09:39 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       a.p.zijlstra@chello.nl, rusty@rustcorp.com.au, mingo@redhat.com,
       davej@redhat.com, cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] work_on_cpu: Use our own workqueue.
Message-ID: <20090127000939.GA8999@redhat.com>
References: <20090125230130.bcdab2e5.akpm@linux-foundation.org> <20090126171618.GA32091@elte.hu> <20090126103529.cb124a58.akpm@linux-foundation.org> <20090126202022.GA8867@elte.hu> <20090126130046.37b8f34e.akpm@linux-foundation.org> <20090126212727.GA13670@elte.hu> <20090126133551.fab5e27a.akpm@linux-foundation.org> <20090126215049.GA3493@redhat.com> <20090126221729.GA10215@elte.hu> <497E40C4.4@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <497E40C4.4@sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26, Mike Travis wrote:
>
> Ingo Molnar wrote:
> > * Oleg Nesterov <oleg@redhat.com> wrote:
> >
> >> But "[PATCH 1/3] work_on_cpu: dont try to get_online_cpus() in
> >> work_on_cpu." removes get_online_cpus/put_online_cpus, this means the
> >> work can run on the wrong CPU anyway. Or work_on_cpu() can hang forever
> >> if CPU has already gone away before queue_work_on().
> >>
> >> Confused.
> >
> > The idea was to require work_on_cpu() users to be CPU hotplug-safe. But
> > ... Rusty pointed it out in the past that this might be fragile, and we
> > could put back the get_online_cpus()/put_online_cpus() calls.
> >
> > Rusty, what do you think?
> >
> > 	Ingo
>
>
> I believe that is the intention, in that the caller should insure that
> the cpu does not go offline.  But also as Rusty stated, the previous usages
> of set_cpus_allowed did not always insure this, so it's at least not a
> regression.

Not sure I understand.

arch/x86/kernel/cpu/mcheck/mce_amd_64.c:store_interrupt_enable() can
race with cpu_down(), but at worst work_on_cpu() returns -EINVAL.

However, after the 1/3 patch we can hang forever.

Yes, afaics the code was not correct before it was converted to use
work_on_cpu(). But now it becomes wrong again?

Oleg.

