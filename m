Return-Path: <linux-kernel-owner+w=401wt.eu-S1758727AbZLOWls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758727AbZLOWls (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 17:41:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753301AbZLOWlr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 17:41:47 -0500
Received: from ozlabs.org ([203.10.76.45]:46683 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752684AbZLOWlq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 17:41:46 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [this_cpu_xx V7 7/8] Module handling: Use this_cpu_xx to dynamically allocate counters
Date: Wed, 16 Dec 2009 09:11:42 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-16-generic; KDE/4.3.2; i686; ; )
Cc: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@csn.ul.ie>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
References: <20091214220320.665065925@quilx.com> <20091214220342.473600725@quilx.com> <4B270AA6.3050307@kernel.org>
In-Reply-To: <4B270AA6.3050307@kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912160911.43201.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Dec 2009 02:33:50 pm Tejun Heo wrote:
> (Rusty Russell cc'd.)
> 
> On 12/15/2009 07:03 AM, Christoph Lameter wrote:
> > @@ -479,15 +467,15 @@ static inline int try_module_get(struct 
> >  	int ret = 1;
> >  
> >  	if (module) {
> > -		unsigned int cpu = get_cpu();
> >  		if (likely(module_is_live(module))) {
> > -			local_inc(__module_ref_addr(module, cpu));
> > +			preempt_disable();
> > +			__this_cpu_inc(module->refptr->count);
> >  			trace_module_get(module, _THIS_IP_,
> > -				local_read(__module_ref_addr(module, cpu)));
> > +				__this_cpu_read(module->refptr->count));
> > +			preempt_enable();
> >  		}
> >  		else
> >  			ret = 0;
> > -		put_cpu();
> 
> I think you need preemption disabled while checking whether
> module_is_live().  The state is protected by stop_machine or
> synchronize_sched().

Yes.

Thanks,
Rusty.
