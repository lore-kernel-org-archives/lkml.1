Return-Path: <linux-kernel-owner+w=401wt.eu-S1764853AbXKTVu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764853AbXKTVu7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 16:50:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758600AbXKTVuv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 16:50:51 -0500
Received: from tomts13.bellnexxia.net ([209.226.175.34]:64626 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757231AbXKTVuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 16:50:50 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAJLlQkdMROHU/2dsb2JhbACBWw
Date: Tue, 20 Nov 2007 16:50:48 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Christoph Lameter <clameter@sgi.com>, ak@suse.de,
       akpm@linux-foundation.org, travis@sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [rfc 19/45] cpu alloc: NFS statistics
Message-ID: <20071120215048.GA14522@Krystal>
References: <20071120011132.143632442@sgi.com> <20071120011336.210236732@sgi.com> <20071120130201.GE10127@Krystal> <Pine.LNX.4.64.0711201248330.26745@schroedinger.engr.sgi.com> <1195592198.7234.45.camel@heimdal.trondhjem.org> <20071120212834.GC11291@Krystal> <1195595283.7234.50.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1195595283.7234.50.camel@heimdal.trondhjem.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 16:49:26 up 17 days,  2:54,  6 users,  load average: 1.33, 1.27,
	1.48
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Trond Myklebust (trond.myklebust@fys.uio.no) wrote:
> 
> On Tue, 2007-11-20 at 16:28 -0500, Mathieu Desnoyers wrote:
> > * Trond Myklebust (trond.myklebust@fys.uio.no) wrote:
> > > 
> > > On Tue, 2007-11-20 at 12:49 -0800, Christoph Lameter wrote:
> > > > On Tue, 20 Nov 2007, Mathieu Desnoyers wrote:
> > > > 
> > > > > > Index: linux-2.6/fs/nfs/iostat.h
> > > > > > ===================================================================
> > > > > > --- linux-2.6.orig/fs/nfs/iostat.h	2007-11-15 21:17:24.391404458 -0800
> > > > > > +++ linux-2.6/fs/nfs/iostat.h	2007-11-15 21:25:33.167654066 -0800
> > > > > > @@ -123,7 +123,7 @@ static inline void nfs_inc_server_stats(
> > > > > >  	int cpu;
> > > > > >  
> > > > > >  	cpu = get_cpu();
> > > > > > -	iostats = per_cpu_ptr(server->io_stats, cpu);
> > > > > > +	iostats = CPU_PTR(server->io_stats, cpu);
> > > > > >  	iostats->events[stat] ++;
> > > > > 
> > > > > Is there a way to change this into a CPU_ADD ?
> > > > 
> > > > Yes I must have missed that.
> > > > 
> > > > Could be
> > > > 
> > > > CPU_INC(server->io_stats->events[stat]);
> > > > 
> > > > > 
> > > > > >  	put_cpu_no_resched();
> > > > > 
> > > > > Why put_cpu_no_resched here ?
> > > > 
> > > > We do not want to reschedule here? We may have already disabled interrupts 
> > > > or some such thing.
> > > 
> > > Some of these statistics are updated from inside a spinlocked
> > > environment, hence the put_no_resched().
> > > 
> > 
> > The we could use __get_cpu_var instead ? (since we know preemption is
> > _always_ disabled when we are called) ?
> 
> We don't know that. I said that _some_ of these statistics are updated
> in that way.
> 

Then my original point is valid : put_no_resched() will cause unwanted
scheduler latencies. It's designed only to be used from within the
scheduler code itself. The correct approach would be a standard
put_cpu().

Or am I missing something ?

Mathieu

> Cheers
>   Trond
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
