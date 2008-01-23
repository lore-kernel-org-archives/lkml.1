Return-Path: <linux-kernel-owner+w=401wt.eu-S1753876AbYAWPBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876AbYAWPBy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 10:01:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751023AbYAWPBo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 10:01:44 -0500
Received: from tomts10-srv.bellnexxia.net ([209.226.175.54]:43429 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750767AbYAWPBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 10:01:43 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAIDllkdMROHU/2dsb2JhbACBV5AZnDo
Date: Wed, 23 Jan 2008 10:01:40 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Jon Masters <jcm@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Hellwig <hch@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: CONFIG_MARKERS
Message-ID: <20080123150140.GA14066@Krystal>
References: <1201029235.18144.62.camel@perihelion> <y0modbdnt4e.fsf@ton.toronto.redhat.com> <20080123031005.GA16766@Krystal> <1201061860.25284.28.camel@perihelion> <20080123131442.GA6562@redhat.com> <20080123144811.GA12296@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080123144811.GA12296@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:59:14 up 80 days, 20:04,  5 users,  load average: 0.52, 0.67,
	0.57
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mathieu Desnoyers (mathieu.desnoyers@polymtl.ca) wrote:
> * Frank Ch. Eigler (fche@redhat.com) wrote:
> > Hi -
> > 
> > On Tue, Jan 22, 2008 at 11:17:40PM -0500, Jon Masters wrote:
> > > On Tue, 2008-01-22 at 22:10 -0500, Mathieu Desnoyers wrote:
> > > > [...]
> > > > > > Is this an attempt to not set a marker for proprietary modules? [...]
> > > > > 
> > > > > I can't seem to find any discussion about this aspect.  If this is the
> > > > > intent, it seems misguided to me.  There may instead be a relationship
> > > > > to TAINT_FORCED_{RMMOD,MODULE}.  Mathieu?
> > 
> > > > On my part, its mostly a matter of not crashing the kernel when someone
> > > > tries to force modprobe of a proprietary module (where the checksums
> > > > doesn't match) on a kernel that supports the markers. Not doing so
> > > > causes the markers to try to find the marker-specific information in
> > > > struct module which doesn't exist and OOPSes.
> > 
> > But you have the wrong target: it is not proprietary modules that have
> > this risk but those built out-of-tree without checksums.  Maybe
> > oopsing in this case is not so bad; or the check could just limit itself to
> > FORCED_MODULE.
> > 
> 
> I guess that for this one I could have a :
> 
> if (!mod->taints & TAINT_FORCED_MODULE)
>  ...
> 

as one could notice: missing parenthesis
if (!(mod->taints & TAINT_FORCED_MODULE))

> 
> > 
> > > > Christoph's point of view is rather more drastic than mine : it's not
> > > > interesting for the kernel community to help proprietary modules writers,
> > > > so it's a good idea not to give them marker support. (I CC'ed him so he
> > > > can clarify his position).
> > > Right. I thought that was your collective opinion
> > 
> > Another way of looking at this though is that by allowing/encouraging
> > proprietary module writers to include markers, we and their users get
> > new diagnostic capabilities.  It constitutes a little bit of opening
> > up, which IMO we should reward rather than punish.
> > 
> > 
> 
> This specific one is a kernel policy matter, and I personally don't
> have a strong opinion about it. I agree that you raise a good counter
> argument : it can be useful to proprietary modules users to be able to
> extract tracing information from those modules to argue with their
> vendors that their driver/hardware is broken (a tracer is _very_ useful
> in that kind of situation). However, it is also useful to proprieraty
> module writers who can benefit from the merged kernel/modules traces.
> Do we want to give them this ability ? It would surely help writing
> better proprieraty kernel modules. Do we want this, or rather prefer to
> put more pressure on them so they open their code ?
> 
> I will let others fight in the mud on this one. :)
> 
> for this one, we could add, instead :
> 
> if (!mod->taints & (TAINT_FORCED_MODULE | TAINT_PROPRIETARY_MODULE))
> 

here too
if (!(mod->taints & (TAINT_FORCED_MODULE | TAINT_PROPRIETARY_MODULE)))

Which remembers me to never write code before my first coffee in the
morning ;)

Mathieu

> Mathieu
> 
> > - FChE
> 
> -- 
> Mathieu Desnoyers
> Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
