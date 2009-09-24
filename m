Return-Path: <linux-kernel-owner+w=401wt.eu-S1752824AbZIXOP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824AbZIXOP7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 10:15:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752750AbZIXOP7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 10:15:59 -0400
Received: from tomts10-srv.bellnexxia.net ([209.226.175.54]:33609 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752746AbZIXOP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 10:15:58 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgcHAC8Zu0pMROOX/2dsb2JhbACBUoEw1AaEGwU
Date: Thu, 24 Sep 2009 10:16:00 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Jason Baron <jbaron@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: Immediate values
Message-ID: <20090924141600.GA22007@Krystal>
References: <20090924123154.GA12907@Krystal> <20090924123428.GA27282@elte.hu> <20090924140228.GA2648@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090924140228.GA2648@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 10:11:50 up 37 days,  1:01,  2 users,  load average: 0.18, 0.23,
	0.15
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jason Baron (jbaron@redhat.com) wrote:
> On Thu, Sep 24, 2009 at 02:34:28PM +0200, Ingo Molnar wrote:
> > * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> > 
> > > Hi Ingo,
> > > 
> > > Andi asked me this week when we should expect to see the "immediate 
> > > values" make it into mainline. I remember you pulled them at one 
> > > point. He would like to use them to encode some very hot-path 
> > > variables into the instruction stream.
> > > 
> > > How should I proceed to get that upstream ? Would a repost be 
> > > appropriate ?
> > 
> > Would have to see it in full context i guess, with before/after 
> > measurements, etc.
> > 
> > 	Ingo
> 
> right we've proposed an alternative to the immediate values, which I've
> been calling 'jump label', here:
> 
> http://marc.info/?l=linux-kernel&m=125200966226921&w=2
> 
> The basic idea is that gcc, 4.5 will have support for an 'asm goto'
> construct which can refer to c code labels. Thus, we can replace a nop
> in the code stream with a 'jmp' instruction to various branch targets.
> 
> In terms of a comparison between the two, IMO, I think that the syntax
> for the immediate variables can be more readable, since it just looks
> like a conditional expression.
> 
> The immediate values do a 'mov', 'test' and then a jump, whereas jump
> label can just do a jump. So in this respect, I believe jump label can
> be more optimal. Additinally, if we want to mark sections 'cold' so they
> don't impact the istruction cache, the jump label already has the labels
> for doing so. Obviously, a performance comparison would be interesting
> as well.
> 

For branches, I'm convinced that a "static jump" approach will beat
immediate values anytime, because you save the BPB hit completely.

However, there are other use-cases involving a variable read, and in
that case immediate values are useful. Andi has been bugging me for a
while to re-post this patchset, I'm pretty sure he has precise ideas
about how he would like to use it.

Until we get the static jump support mainlined in gcc, immediate values
at least save the d-cache hit. So it would be a step in the right
direction.

Thanks,

Mathieu

> thanks,
> 
> -Jason
> 
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
