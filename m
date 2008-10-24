Return-Path: <linux-kernel-owner+w=401wt.eu-S1753098AbYJXKvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098AbYJXKvU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 06:51:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751323AbYJXKvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 06:51:11 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55872 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751756AbYJXKvK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 06:51:10 -0400
Date: Fri, 24 Oct 2008 12:51:32 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       travis@sgi.com, Ingo Molnar <mingo@elte.hu>,
       Vitaly Mayatskikh <vmayatsk@redhat.com>
Subject: Re: do_boot_cpu can deadlock?
Message-ID: <20081024105132.GA8442@redhat.com>
References: <20081023005751.53973DDEFE@ozlabs.org> <20081023094036.GA7593@redhat.com> <20081023143605.GN5255@in.ibm.com> <20081023163517.GB21008@redhat.com> <20081023170212.GA22599@redhat.com> <20081023182119.GA1480@in.ibm.com> <20081023184906.GA2612@localhost> <20081024093342.GA4583@redhat.com> <20081024095336.GA17679@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081024095336.GA17679@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24, Gautham R Shenoy wrote:
>
> On Fri, Oct 24, 2008 at 11:33:42AM +0200, Oleg Nesterov wrote:
>
> > But let's suppose we boot with maxcpus=1, and then bring up another CPU.
> > Or we really add the new physical CPU (I don't really know if this is
> > possible on x86).
>
> Even I am not sure if physical hotplug is possible.
>
> But think about the virtualization case when we want to add
> additional CPU to a KVM guest at runtime? This
> is not such a rare use-case. It could dead-lock that time, No?

virtualization/KVM is a black magic to me ;) I don't know how/if it is
possible to add CPU at runtime.

Anyway, booting with maxcpus=1 allows us to bring up another CPU later,
and idle_thread_array[cpu] == NULL in that case, yes?

Perhaps smp_prepare_cpus() can do fork_idle() for_each_possible_cpu() ?
Or we can change do_boot_cpu() to use kthread_run() to create the idle
thread.

Oleg.

