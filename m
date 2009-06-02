Return-Path: <linux-kernel-owner+w=401wt.eu-S1758602AbZFBQfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758602AbZFBQfi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 12:35:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755151AbZFBQfb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 12:35:31 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60476 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755139AbZFBQfa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 12:35:30 -0400
Date: Tue, 2 Jun 2009 18:30:48 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
       acme@redhat.com, paulus@samba.org, hpa@zytor.com, mingo@redhat.com,
       jkacur@redhat.com, efault@gmx.de, ebiederm@xmission.com,
       mtosatti@redhat.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
Subject: Re: [tip:perfcounters/core] perf_counter: Use PID namespaces
	properly
Message-ID: <20090602163047.GA17784@redhat.com>
References: <tip-709e50cf870e61745b39552044aa6c7c38e4f9e0@git.kernel.org> <20090602154816.GA15734@redhat.com> <1243960085.13761.190.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1243960085.13761.190.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02, Peter Zijlstra wrote:
>
> On Tue, 2009-06-02 at 17:55 +0200, Oleg Nesterov wrote:
> > On 06/02, tip-bot for Peter Zijlstra wrote:
> > >
> > > +static u32 perf_counter_pid(struct perf_counter *counter, struct task_struct *p)
> > > +{
> > > +	/*
> > > +	 * only top level counters have the pid namespace they were created in
> > > +	 */
> > > +	if (counter->parent)
> > > +		counter = counter->parent;
> > > +
> > > +	return task_tgid_nr_ns(p, counter->ns);
> > > +}
> > > +
> > > +static u32 perf_counter_tid(struct perf_counter *counter, struct task_struct *p)
> > > +{
> > > +	/*
> > > +	 * only top level counters have the pid namespace they were created in
> > > +	 */
> > > +	if (counter->parent)
> > > +		counter = counter->parent;
> > > +
> > > +	return task_pid_nr_ns(p, counter->ns);
> > 
> > Perhaps this should be
> > 
> > 	return task_pid_nr_ns(p->group_leader);
> > 
> > ?
> 
> That seems to be exactly what task_tgid_nr_ns() does.

Ah, yes, I didn't notice _tgid_ above.

Oleg.

