Return-Path: <linux-kernel-owner+w=401wt.eu-S1755157AbYG2RXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755157AbYG2RXT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 13:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752003AbYG2RXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 13:23:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:38955 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811AbYG2RXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 13:23:05 -0400
Date: Tue, 29 Jul 2008 10:22:51 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andi Kleen <andi@firstfloor.org>, Mike Galbraith <efault@gmx.de>,
       Frederik Deweerdt <deweerdt@free.fr>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       suresh.b.siddha@intel.com, Ingo Molnar <mingo@elte.hu>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference at
 00000002
Message-ID: <20080729102251.22ac8543@infradead.org>
In-Reply-To: <20080729163113.GP30344@one.firstfloor.org>
References: <20080725095317.GA12636@skywalker>
	<20080728222643.GA6339@slug>
	<1217305335.5553.3.camel@marge.simson.net>
	<20080729120911.GI30344@one.firstfloor.org>
	<20080729065635.27630e33@infradead.org>
	<20080729145348.GN30344@one.firstfloor.org>
	<20080729083029.094a32cb@infradead.org>
	<20080729163113.GP30344@one.firstfloor.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jul 2008 18:31:13 +0200
Andi Kleen <andi@firstfloor.org> wrote:

> > > A power saving feature that has a significant trade off between
> > > power and performance. 
> > 
> > do you have numbers to explain "significant tradeoff" ?
> 
> I don't have numbers, but from the theory it seems pretty clear. 
> When you e.g. have two processes with 6MB cache foot print and 
> you have two 2C CPUs with 6MB cache they will fit in cache, but 
> with power aware scheduler they won't because both processes will run
> on the single 6MB package.  With NUMA the effect is even worse because
> also the memory controllers are not used evenly.
> And there's the FSB bandwidth, but that's a secondary issue.

but if you have 2 threads that share a lot of data, it's the opposite.

Or if you have a bunch of things which are smaller than the cache... 
(and they do share, for example glibc will be largely shared).

it's not a clear heavy loss, it's one of those "depends" cases.
(which sucks)

> > 
> >  
> > > This means performance will go down. Perhaps it would be ok on
> > > battery, 
> > 
> > the illusion that power only matters on battery got buried a few
> > years ago ;)
> 
> My understanding was always that unless you're on battery power saving
> features that are enabled by default are not supposed to impact
> performance significantly. 

That's not what datacenter people say. As long as power gain is bigger
than performance loss.. they tend to want it.

Also "significantly" is extremely subjective, like in this case it can
be a win or a loss, depending.

> When the user says impacting performance
> is ok then doing that is fine of course, but not by default.

that's a fine kernel policy.

Distros will override this policy if their users tell them they're
willing to do the tradeoff.. they will pick that default. In fact..
that's a big part of their job.. 


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
