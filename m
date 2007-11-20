Return-Path: <linux-kernel-owner+w=401wt.eu-S1762647AbXKTUuG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762647AbXKTUuG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 15:50:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761453AbXKTUti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 15:49:38 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:36490 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762219AbXKTUth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 15:49:37 -0500
Date: Tue, 20 Nov 2007 12:49:37 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: ak@suse.de, akpm@linux-foundation.org, travis@sgi.com,
       linux-kernel@vger.kernel.org
Subject: Re: [rfc 19/45] cpu alloc: NFS statistics
In-Reply-To: <20071120130201.GE10127@Krystal>
Message-ID: <Pine.LNX.4.64.0711201248330.26745@schroedinger.engr.sgi.com>
References: <20071120011132.143632442@sgi.com> <20071120011336.210236732@sgi.com>
 <20071120130201.GE10127@Krystal>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Nov 2007, Mathieu Desnoyers wrote:

> > Index: linux-2.6/fs/nfs/iostat.h
> > ===================================================================
> > --- linux-2.6.orig/fs/nfs/iostat.h	2007-11-15 21:17:24.391404458 -0800
> > +++ linux-2.6/fs/nfs/iostat.h	2007-11-15 21:25:33.167654066 -0800
> > @@ -123,7 +123,7 @@ static inline void nfs_inc_server_stats(
> >  	int cpu;
> >  
> >  	cpu = get_cpu();
> > -	iostats = per_cpu_ptr(server->io_stats, cpu);
> > +	iostats = CPU_PTR(server->io_stats, cpu);
> >  	iostats->events[stat] ++;
> 
> Is there a way to change this into a CPU_ADD ?

Yes I must have missed that.

Could be

CPU_INC(server->io_stats->events[stat]);

> 
> >  	put_cpu_no_resched();
> 
> Why put_cpu_no_resched here ?

We do not want to reschedule here? We may have already disabled interrupts 
or some such thing.
