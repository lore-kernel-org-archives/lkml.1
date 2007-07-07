Return-Path: <linux-kernel-owner+w=401wt.eu-S1755193AbXGGCkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193AbXGGCkb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 22:40:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754059AbXGGCkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 22:40:23 -0400
Received: from tomts43.bellnexxia.net ([209.226.175.110]:54860 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754010AbXGGCkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 22:40:22 -0400
Date: Fri, 6 Jul 2007 22:35:11 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Adrian Bunk <bunk@stusta.de>
Cc: Chuck Ebbert <cebbert@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
       mbligh@google.com
Subject: Re: [patch 10/10] Scheduler profiling - Use immediate values
Message-ID: <20070707023511.GA25778@Krystal>
References: <20070703164046.645090494@polymtl.ca> <20070703164516.377240547@polymtl.ca> <20070703181151.GB5800@martell.zuzino.mipt.ru> <20070703185748.GA4047@Krystal> <20070705132120.8edbc1f3.akpm@linux-foundation.org> <p73vecx21um.fsf@bingen.suse.de> <468EBEB2.4070605@redhat.com> <20070706232843.GT3492@stusta.de> <20070706234315.GA19804@Krystal> <20070707022526.GC3492@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070707022526.GC3492@stusta.de>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 22:30:23 up 5 days, 21:13,  4 users,  load average: 1.03, 0.52, 0.30
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Adrian Bunk (bunk@stusta.de) wrote:
> On Fri, Jul 06, 2007 at 07:43:15PM -0400, Mathieu Desnoyers wrote:
> > * Adrian Bunk (bunk@stusta.de) wrote:
> > > On Fri, Jul 06, 2007 at 06:14:10PM -0400, Chuck Ebbert wrote:
> > > > On 07/06/2007 07:44 AM, Andi Kleen wrote:
> > > > > I think the optimization is a good idea, although i dislike it
> > > > > that it is complicated for the dynamic markers. If it was just
> > > > > static it would be much simpler.
> > > > 
> > > > Another thing to consider is that there might be hundreds of these
> > > > probes/tracepoints active in an instrumented kernel. The overhead
> > > > adds up fast, so the gain may be worth all the pain.
> > > 
> > > Only if you want to squeeze the last bit of performance out of
> > > _debugging_ functionality.
> > > 
> > > You avoid all the pain if you simply don't use debugging functionality 
> > > on production systems.
> > > 
> > 
> > Adrian,
> > 
> > Please have a look at my markers posts, especially:
> > 
> > http://www.ussg.iu.edu/hypermail/linux/kernel/0707.0/0669.html
> > 
> > And also look into OLS 2007 proceedings for Martin Bligh's paper on
> > Debugging Google sized clusters. It basically makes the case for adding
> > functionnality to debug _user space_ problems on production systems that
> > can be turned on dynamically.
> 
> Using a different kernel for tracing still fulfills all the requirements 
> listed in section 5 of your paper...
> 

Not exactly. I assume you understand that rebooting 1000 live production
servers to find the source of a rare bug or the cause of a performance
issue is out of question.

Moreover, strategies like enabling flight recorder traces on a few nodes
on demand to detect performance problems can only be deployed in
production environment if they are part of the standard production
kernel.

Also, managing two different kernels is often out of question. Not only
is it a maintainance burden, but just switching to the "debug" kernel
can impact the system's behavior so badly that it could make the problem
disappear.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
