Return-Path: <linux-kernel-owner+w=401wt.eu-S1765647AbZAPItj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765647AbZAPItj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 03:49:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757531AbZAPIt3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 03:49:29 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:27159 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756930AbZAPIt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 03:49:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=Uzo6okzp3TPD8gwm6ZWnYe+W11KK+888Rpe3iojNdj0lWl77Rf85lvWxjH/EGjKCzx
         1RT3xc6UFYjkHL2DiJTPW0dT1TpBZadXaE38ll+VdTnvtMTvxTGNmhPJoEllk/+DYIP7
         reqw0X2olAPmTWxZv3HZhu4HdC71dO/SP0lsY=
Date: Fri, 16 Jan 2009 09:49:19 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] trace_workqueue: use percpu data for workqueue
	stat
Message-ID: <20090116084918.GA7376@nowhere>
References: <496F25A8.5040303@cn.fujitsu.com> <c62985530901150509we244b70l4e7af5c6b6145f30@mail.gmail.com> <49704147.6000003@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49704147.6000003@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2009 at 04:11:51PM +0800, Lai Jiangshan wrote:
> Frédéric Weisbecker wrote:
> > Hi Lai,
> > 
> > 2009/1/15 Lai Jiangshan <laijs@cn.fujitsu.com>:
> >> Impact: make trace_workqueue works well on NUMA
> >>
> >> It's not correct when (num_possible_cpus() < nr_cpumask_bits):
> >>        all_workqueue_stat = kmalloc(sizeof(struct workqueue_global_stats)
> >>                                     * num_possible_cpus(), GFP_KERNEL);
> > 
> > 
> > What is the difference between num_possible_cpus() and nr_cpumask_bits actually?
> > It looks like nr_cpumask_bits binds to NR_CPUS on early time and after
> > it is set to
> > num_possible_cpus() , right?
> > In this case num_possible_cpus() seems more relevant...no?
> > 
> > (I'm pretty sure I'm wrong.... :-)
> > 
> 
> I wanted to reference to nr_cpu_ids, not nr_cpumask_bits(I made mistake yesterday)
> 
> init/main.c
> static void __init setup_nr_cpu_ids(void)
> {
> 	nr_cpu_ids = find_last_bit(cpumask_bits(cpu_possible_mask),NR_CPUS) + 1;
> }
> setup_nr_cpu_ids() is called directly in main.c, it's earlier than early_initcall.
> 
> So nr_cpu_ids is better than num_possible_cpus(), for maybe cpu_possible_mask=101B
> nr_cpu_ids=3, num_possible_cpus()=2, We will access to invalid memory when we use
> num_possible_cpus().


Ok.
But is it possible to enable a new possible cpu on runtime?

 
> but percpu data as my patch shows is better than nr_cpu_ids.


Yeah that's right. And more proper.


> Thanks, Lai.
> 
> 
> 

