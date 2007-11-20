Return-Path: <linux-kernel-owner+w=401wt.eu-S1763650AbXKTVrq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763650AbXKTVrq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 16:47:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759332AbXKTVrg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 16:47:36 -0500
Received: from pat.uio.no ([129.240.10.15]:51643 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761950AbXKTVrf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 16:47:35 -0500
Subject: Re: [rfc 19/45] cpu alloc: NFS statistics
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Christoph Lameter <clameter@sgi.com>, ak@suse.de,
       akpm@linux-foundation.org, travis@sgi.com, linux-kernel@vger.kernel.org
In-Reply-To: <20071120212834.GC11291@Krystal>
References: <20071120011132.143632442@sgi.com>
	 <20071120011336.210236732@sgi.com> <20071120130201.GE10127@Krystal>
	 <Pine.LNX.4.64.0711201248330.26745@schroedinger.engr.sgi.com>
	 <1195592198.7234.45.camel@heimdal.trondhjem.org>
	 <20071120212834.GC11291@Krystal>
Content-Type: text/plain
Date: Tue, 20 Nov 2007 16:48:03 -0500
Message-Id: <1195595283.7234.50.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-ClamAV-Virus: No
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.4, required=12.0, autolearn=disabled, AWL=-0.385)
X-UiO-Scanned: 4F0262A794EC0F7F55035836768562BD54A2C462
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: -3 maxlevel 200 minaction 2 bait 0 mail/h: 822 total 5263086 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2007-11-20 at 16:28 -0500, Mathieu Desnoyers wrote:
> * Trond Myklebust (trond.myklebust@fys.uio.no) wrote:
> > 
> > On Tue, 2007-11-20 at 12:49 -0800, Christoph Lameter wrote:
> > > On Tue, 20 Nov 2007, Mathieu Desnoyers wrote:
> > > 
> > > > > Index: linux-2.6/fs/nfs/iostat.h
> > > > > ===================================================================
> > > > > --- linux-2.6.orig/fs/nfs/iostat.h	2007-11-15 21:17:24.391404458 -0800
> > > > > +++ linux-2.6/fs/nfs/iostat.h	2007-11-15 21:25:33.167654066 -0800
> > > > > @@ -123,7 +123,7 @@ static inline void nfs_inc_server_stats(
> > > > >  	int cpu;
> > > > >  
> > > > >  	cpu = get_cpu();
> > > > > -	iostats = per_cpu_ptr(server->io_stats, cpu);
> > > > > +	iostats = CPU_PTR(server->io_stats, cpu);
> > > > >  	iostats->events[stat] ++;
> > > > 
> > > > Is there a way to change this into a CPU_ADD ?
> > > 
> > > Yes I must have missed that.
> > > 
> > > Could be
> > > 
> > > CPU_INC(server->io_stats->events[stat]);
> > > 
> > > > 
> > > > >  	put_cpu_no_resched();
> > > > 
> > > > Why put_cpu_no_resched here ?
> > > 
> > > We do not want to reschedule here? We may have already disabled interrupts 
> > > or some such thing.
> > 
> > Some of these statistics are updated from inside a spinlocked
> > environment, hence the put_no_resched().
> > 
> 
> The we could use __get_cpu_var instead ? (since we know preemption is
> _always_ disabled when we are called) ?

We don't know that. I said that _some_ of these statistics are updated
in that way.

Cheers
  Trond

