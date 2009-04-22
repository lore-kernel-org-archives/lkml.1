Return-Path: <linux-kernel-owner+w=401wt.eu-S1753904AbZDVITg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904AbZDVITg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 04:19:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752569AbZDVITU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 04:19:20 -0400
Received: from tomts43-srv.bellnexxia.net ([209.226.175.110]:58671 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752406AbZDVITS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 04:19:18 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuwEAINH7klMQW1W/2dsb2JhbACBT9FIg3UG
Date: Wed, 22 Apr 2009 01:47:52 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Frank Ch. Eigler" <fche@elastic.org>, Andi Kleen <andi@firstfloor.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Christoph Hellwig <hch@lst.de>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>, Jiaying Zhang <jiayingz@google.com>,
       Michael Rubin <mrubin@google.com>, Martin Bligh <mbligh@google.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Neil Horman <nhorman@tuxdriver.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: Re: [PATCH 2/8] tracing: create automated trace defines
Message-ID: <20090422054751.GA25863@Krystal>
References: <49E69E76.9030608@goop.org> <20090416234410.GA20513@Krystal> <87zlebpzmk.fsf@basil.nowhere.org> <20090421155106.GE3792@Krystal> <49EDFFE6.1080401@goop.org> <alpine.DEB.2.00.0904211320440.10097@gandalf.stny.rr.com> <20090421202828.GB32179@basil> <alpine.DEB.2.00.0904211711260.10097@gandalf.stny.rr.com> <20090421212347.GC402@elastic.org> <alpine.DEB.2.00.0904211728310.10097@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0904211728310.10097@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 01:43:26 up 53 days,  2:09,  1 user,  load average: 1.16, 0.50,
	0.34
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> 
> [ removed Pekka@firstfloor.org due to mail errors ]
> 
> On Tue, 21 Apr 2009, Frank Ch. Eigler wrote:
> 
> > Hi -
> > 
> > On Tue, Apr 21, 2009 at 05:17:17PM -0400, Steven Rostedt wrote:
> > 
> > > [...]  Perhaps we should fork off gcc and ship Linux with its own
> > > compiler. This way we can optimize it for the kernel and not worry
> > > about any userland optimizations.
> > 
> > In this regard, kernel land does not seem that unlike user land.
> > 
> > > 	if (unlikely(err)) {
> > > 		__section__(".error_sect") {
> > > 			/* put error code here */
> > > 		}
> > > 	}
> > > 
> > > And have gcc in the error section (if it is big enough perhaps) do:
> > > 	jmp .L123
> > > .L124   [...]
> > > [...]
> > > 	jmp .L124
> > 
> > > We could do the same for trace points. That is, any part of code that 
> > > really would happen once in a while (error handling for one) we can move 
> > > off to its own section and keep hot paths hot.
> > 
> > This is called -freorder-blocks or -freorder-blocks-and-partition
> > (depending on how far you would like gcc to move unlikely blocks).
> 
> That does not let us pick and choose what and where to put the code.
> 
> But still, a fork of gcc would let us optimize it for the kernel, and not 
> for generic programs.
> 
> /me has been sitting too close to the furnace and must have been taking 
> up some of those fumes, to be considering a fork of gcc a good idea ;-)
> 

I guess we should have been sitting near the same furnace then. I'm
unsure how different from the current gcc this can go, but it could be a
very interesting exercise. Just removing unneeded front ends could
probably help adding features much faster than if we have to support
Fortran, Java, etc.

Mathieu

> -- Steve
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
