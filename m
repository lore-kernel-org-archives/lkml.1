Return-Path: <linux-kernel-owner+w=401wt.eu-S1759417AbZEMLHX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759417AbZEMLHX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 07:07:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758702AbZEMLHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 07:07:04 -0400
Received: from www.tglx.de ([62.245.132.106]:50578 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758030AbZEMLHB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 07:07:01 -0400
Date: Wed, 13 May 2009 13:05:49 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: Hugo Vincent <hugo.vincent@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>,
       Frank Rowand <frank.rowand@am.sony.com>,
       Robin Gareus <robin@gareus.org>, Gregory Haskins <ghaskins@novell.com>,
       Philippe Reynes <philippe.reynes@isismpp.fr>,
       Fernando Lopez-Lezcano <nando@ccrma.stanford.edu>,
       Will Schmidt <will_schmidt@vnet.ibm.com>,
       Darren Hart <dvhltc@us.ibm.com>, Jan Blunck <jblunck@suse.de>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>
Subject: Re: [Announce] 2.6.29.3-rt12
In-Reply-To: <1242210288.26820.18.camel@twins>
Message-ID: <alpine.LFD.2.00.0905131305310.3561@localhost.localdomain>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain>  <alpine.LFD.2.00.0904031918090.12916@localhost.localdomain>  <alpine.LFD.2.00.0904081937191.21577@localhost.localdomain>  <alpine.LFD.2.00.0904092046440.21577@localhost.localdomain> 
 <alpine.LFD.2.00.0904110003370.21577@localhost.localdomain>  <alpine.LFD.2.00.0904181204420.21577@localhost.localdomain>  <alpine.LFD.2.00.0904251500150.4529@localhost.localdomain>  <alpine.LFD.2.00.0904290036500.4529@localhost.localdomain> 
 <alpine.LFD.2.00.0905012348200.3375@localhost.localdomain>  <alpine.LFD.2.00.0905130122250.3561@localhost.localdomain>  <5a7b8b7b0905121716y646a2f68qad9181362caa22f6@mail.gmail.com>  <alpine.LFD.2.00.0905131217240.3561@localhost.localdomain>
 <1242210288.26820.18.camel@twins>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 May 2009, Peter Zijlstra wrote:
> On Wed, 2009-05-13 at 12:19 +0200, Thomas Gleixner wrote:
> > On Wed, 13 May 2009, Hugo Vincent wrote:
> > > This patch resulted in a broken build for me, until I did this:
> > > 
> > > --- a/patch-2.6.29.3-rt12
> > > +++ b/patch-2.6.29.3-rt12
> > > @@ -121754,7 +121754,7 @@ Index: linux-2.6-tip/kernel/sched.c
> > >   }
> > > 
> > >   /*
> > > -@@ -2801,6 +3177,15 @@ static void update_cpu_load(struct rq *t
> > > +@@ -2801,6 +3177,17 @@ static void update_cpu_load(struct rq *t
> > >   			new_load += scale-1;
> > >   		this_rq->cpu_load[i] = (old_load*(scale-1) + new_load) >> i;
> > >   	}
> > > @@ -121765,8 +121765,10 @@ Index: linux-2.6-tip/kernel/sched.c
> > >  +	this_rq->calc_load_update += LOAD_FREQ;
> > >  +	calc_load_account_active(this_rq);
> > >  +
> > > ++#ifdef CONFIG_SMP
> > >  +	if (this_rq->cpu == calc_load_cpu)
> > >  +		calc_global_load();
> > > ++#endif
> > >   }
> > 
> > Darn. the patch is halfways right. the #ifdef needs to be only around
> > the if() line. Otherwise your /proc/loadavg values will never be
> > updated. I'll push out -rt13 with the proper fix..
> 
> if (cpu_of(this_rq) == calc_load_cpu)
> 
> to reduce if-deffery

That's what I did :)
