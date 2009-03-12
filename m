Return-Path: <linux-kernel-owner+w=401wt.eu-S1755948AbZCLWpI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948AbZCLWpI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 18:45:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753195AbZCLWo5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 18:44:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:53095 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146AbZCLWo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 18:44:56 -0400
Date: Thu, 12 Mar 2009 18:44:52 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Jason Baron <jbaron@redhat.com>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, acme@ghostprotocols.net, fche@redhat.com,
       peterz@infradead.org, compudj@krystal.dyndns.org
Subject: Re: [Patch 1/2] tracepoints for softirq entry/exit - add softirq-to-name
 array
In-Reply-To: <20090312184533.GB11045@nowhere>
Message-ID: <alpine.DEB.2.00.0903121843550.3062@gandalf.stny.rr.com>
References: <20090312183336.GB3352@redhat.com> <20090312184533.GB11045@nowhere>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 12 Mar 2009, Frederic Weisbecker wrote:
> > @@ -53,6 +53,12 @@ static struct softirq_action softirq_vec[NR_SOFTIRQS] __cacheline_aligned_in_smp
> >  
> >  static DEFINE_PER_CPU(struct task_struct *, ksoftirqd);
> >  
> > +char *softirq_to_name[NR_SOFTIRQS] = {
> > +	"HI_SOFTIRQ", "TIMER_SOFTIRQ", "NET_TX_SOFTIRQ", "NET_RX_SOFTIRQ",
> > +	"BLOCK_SOFTIRQ", "TASKLET_SOFTIRQ", "SCHED_SOFTIRQ", "HRTIMER_SOFTIRQ",
> > +	"RCU_SOFTIRQ"
> > +};
> 
> 
> Hi,
> 
> May be you could abuse open_softirq() to append dynamically these entries:
> 
> char *softirq_to_name[NR_SOFTIRQS];
> 
> #define open_softirq(nr, func)	\
> 	softirq_to_name[nr] = __stringify(nr); \
> 	__open_softirq(nr, func);
> 
> So that it's a bit more scalable.
> 

Softirqs are pretty much set. If anything, they may even disappear (if the 
threaded interrupts take off). So hardcoding it should not be an issue.

-- Steve

