Return-Path: <linux-kernel-owner+w=401wt.eu-S1763649AbXKTV1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763649AbXKTV1V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 16:27:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760965AbXKTV0z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 16:26:55 -0500
Received: from tomts5-srv.bellnexxia.net ([209.226.175.25]:50006 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760104AbXKTV0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 16:26:54 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAC7gQkdMROHU/2dsb2JhbACBWw
Date: Tue, 20 Nov 2007 16:26:51 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Christoph Lameter <clameter@sgi.com>
Cc: ak@suse.de, akpm@linux-foundation.org, travis@sgi.com,
       linux-kernel@vger.kernel.org
Subject: Re: [rfc 19/45] cpu alloc: NFS statistics
Message-ID: <20071120212651.GB11291@Krystal>
References: <20071120011132.143632442@sgi.com> <20071120011336.210236732@sgi.com> <20071120130201.GE10127@Krystal> <Pine.LNX.4.64.0711201248330.26745@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0711201248330.26745@schroedinger.engr.sgi.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 16:24:16 up 17 days,  2:29,  6 users,  load average: 1.61, 2.06,
	1.84
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter (clameter@sgi.com) wrote:
> On Tue, 20 Nov 2007, Mathieu Desnoyers wrote:
> 
> > > Index: linux-2.6/fs/nfs/iostat.h
> > > ===================================================================
> > > --- linux-2.6.orig/fs/nfs/iostat.h	2007-11-15 21:17:24.391404458 -0800
> > > +++ linux-2.6/fs/nfs/iostat.h	2007-11-15 21:25:33.167654066 -0800
> > > @@ -123,7 +123,7 @@ static inline void nfs_inc_server_stats(
> > >  	int cpu;
> > >  
> > >  	cpu = get_cpu();
> > > -	iostats = per_cpu_ptr(server->io_stats, cpu);
> > > +	iostats = CPU_PTR(server->io_stats, cpu);
> > >  	iostats->events[stat] ++;
> > 
> > Is there a way to change this into a CPU_ADD ?
> 
> Yes I must have missed that.
> 
> Could be
> 
> CPU_INC(server->io_stats->events[stat]);
> 
> > 
> > >  	put_cpu_no_resched();
> > 
> > Why put_cpu_no_resched here ?
> 
> We do not want to reschedule here? We may have already disabled interrupts 
> or some such thing.

Well, if interrupts are disabled, then the preempt check will see it and
won't trigger the reschedule. On the other hand, if this code is called
when preemption is enabled, we can add important scheduler latencies by
not checking if a resched must be done at the end of this region.

So if we are so sure that interrupts are always disbled or that
preemption is already disabled when this function is called, why do we
disable preemption here at all ?

(this is not introduced by your patch, it just happens to be how the
code was before)

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
