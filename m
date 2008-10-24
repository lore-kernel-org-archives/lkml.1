Return-Path: <linux-kernel-owner+w=401wt.eu-S1756581AbYJXOXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756581AbYJXOXm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 10:23:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753910AbYJXOX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 10:23:29 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57531 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753832AbYJXOX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 10:23:28 -0400
Date: Fri, 24 Oct 2008 16:23:59 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       travis@sgi.com, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>
Subject: Re: [PATCH 1/7] work_on_cpu: helper for doing task on a CPU.
Message-ID: <20081024142359.GA20433@redhat.com>
References: <20081023005751.53973DDEFE@ozlabs.org> <20081023094036.GA7593@redhat.com> <20081023143605.GN5255@in.ibm.com> <200810241404.35932.rusty@rustcorp.com.au> <20081024072147.GA5000@in.ibm.com> <20081024102957.GC4583@redhat.com> <20081024114018.GA24080@in.ibm.com> <20081024132509.GB17708@redhat.com> <20081024134156.GA6045@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081024134156.GA6045@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24, Gautham R Shenoy wrote:
>
> On Fri, Oct 24, 2008 at 03:25:09PM +0200, Oleg Nesterov wrote:
> >
> > If we add another wq for work_on_cpu(), then we add another hard-to-maintain
> > rule: get_online_cpus() must not be used by any work which can be queued
> > on that wq. And, yet another per-cpu thread...
>
> No, we don't have that rule!
>
> Because using Rusty's function with a seperate workqueue,
> we queue the work item as follows:
>
> 	 get_online_cpus();
> 	 queue_work_on(cpu, &on_each_cpu_wq, &wfc.work);
> 	 flush_work(&wfc.work);
> 	 put_online_cpus();
>
> The very fact that we've successfully queued the work-item means that
> no cpu-hotplug operation can occur till our work item finishes
> execution.

Ah yes, thanks for correcting me.

> Yes, we end up using additional resources in the form of another per-cpu
> threads. But is that so much of an issue?

Well, don't ask me... but the only reason why we need these threads
is that we want to make work_on_cpu() useable from cpu-hotplug path,
a bit strange ;)

Oleg.

