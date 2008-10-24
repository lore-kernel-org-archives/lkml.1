Return-Path: <linux-kernel-owner+w=401wt.eu-S1753696AbYJXK3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696AbYJXK3r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 06:29:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751087AbYJXK3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 06:29:37 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57805 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750778AbYJXK3g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 06:29:36 -0400
Date: Fri, 24 Oct 2008 12:29:57 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       travis@sgi.com, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 1/7] work_on_cpu: helper for doing task on a CPU.
Message-ID: <20081024102957.GC4583@redhat.com>
References: <20081023005751.53973DDEFE@ozlabs.org> <20081023094036.GA7593@redhat.com> <20081023143605.GN5255@in.ibm.com> <200810241404.35932.rusty@rustcorp.com.au> <20081024072147.GA5000@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081024072147.GA5000@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24, Gautham R Shenoy wrote:
>
> On Fri, Oct 24, 2008 at 02:04:35PM +1100, Rusty Russell wrote:
> >
> > I think we should BUG_ON(per_cpu(cpu_state, cpuid) != CPU_DEAD) to ensure we
> > never use work_on_cpu in the hotplug cpu path.  Then we use
> > smp_call_function() for that hard intel_cacheinfo case.  Finally, we fix the
> > cpu hotplug path to use schedule_work_on() itself rather than playing games
> > with cpumask.
> >
> > If you agree, I'll spin the patches...
>
> How about the following?
>
> We go with this method, but instead of piggybacking on
> the generic kevents workqueue, we create our own on_each_cpu_wq, for this
> purpose.

Gautham, Rusty, I am a bit lost on this discussion...

Why should we care about this deadlock? Just do not use work_on_cpu() from
the hotplug cpu path, that is all.

Once again, the "cpu_hotplug_begin()" lock is not special. You can't use
work_on_cpu() under (say) rtnl_lock() for the same reason, this lock is
used by work->func() too.

Perhaps I missed something, and work_on_cpu() is really important for
cpu-hotplug path?

Oleg.

