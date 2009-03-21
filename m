Return-Path: <linux-kernel-owner+w=401wt.eu-S1758424AbZCUQly@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758424AbZCUQly (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 12:41:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753634AbZCUQlp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 12:41:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:59350 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277AbZCUQlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 12:41:45 -0400
Date: Sat, 21 Mar 2009 12:41:42 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Anton Vorontsov <avorontsov@ru.mvista.com>,
       Steven Rostedt <srostedt@redhat.com>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tracing: Fix TRACING_SUPPORT dependency
In-Reply-To: <20090321163328.GH11183@elte.hu>
Message-ID: <alpine.DEB.2.00.0903211239170.13615@gandalf.stny.rr.com>
References: <20090320150914.GA22769@oksana.dev.rtsoft.ru> <20090320190428.GD6224@elte.hu> <20090320193904.GA13707@oksana.dev.rtsoft.ru> <20090320195743.GA25147@elte.hu> <20090320202247.GA30654@oksana.dev.rtsoft.ru> <20090321161814.GC11183@elte.hu>
 <alpine.DEB.2.00.0903211230580.13615@gandalf.stny.rr.com> <20090321163328.GH11183@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 21 Mar 2009, Ingo Molnar wrote:
> > > 
> > > Hm, do all the tracers even compile on ppc32 with your patch?
> > > 
> > > We had periodic build failures on weird, unmaintained architectures 
> > > that had no irqflags-tracing support and hence didnt know the 
> > > raw_irqs_save/restore primitives ...
> > > 
> > > I'm not trying to make things more difficult for you (and we can 
> > > apply your patch if it builds fine and does not cause problems 
> > > elsewhere), but there were some real downsides to not having proper 
> > > irq APIs ...
> > 
> > Note, the issue is not with the hooks into local_irq_save/restore, 
> > but with the entry.S code. That code is very sensitive where the 
> > irqs are enabled and disabled.
> 
> i know. What i'm talking about is that non-lockdep architectures 
> have the habit of not defining raw_local_irq_save() - which the 
> tracing core relies on.

Since we know that's not an issue with PPC32, perhaps we should add (I 
hate to do this)...


	depends on TRACE_IRQFLAGS_SUPPORT || PPC32

And document that the "|| PPC32" should go when PowerPC32 gets its act
together.  :-/

-- Steve

