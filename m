Return-Path: <linux-kernel-owner+w=401wt.eu-S1755277AbZIQLSX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277AbZIQLSX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 07:18:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754074AbZIQLSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 07:18:23 -0400
Received: from gir.skynet.ie ([193.1.99.77]:60974 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752311AbZIQLSW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 07:18:22 -0400
Date: Thu, 17 Sep 2009 12:18:28 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       cl@linux-foundation.org, heiko.carstens@de.ibm.com, mingo@elte.hu,
       npiggin@suse.de, sachinp@in.ibm.com
Subject: Re: [RFC/PATCH] SLQB: Mark the allocator as broken PowerPC and S390
Message-ID: <20090917111828.GB7205@csn.ul.ie>
References: <1253083059.5478.1.camel@penberg-laptop> <20090917100841.GF13002@csn.ul.ie> <1253183365.4975.20.camel@penberg-laptop> <20090917105707.GA7205@csn.ul.ie> <1253186019.4975.32.camel@penberg-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1253186019.4975.32.camel@penberg-laptop>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 17, 2009 at 02:13:39PM +0300, Pekka Enberg wrote:
> Hi Mel,
> 
> On Thu, 2009-09-17 at 11:57 +0100, Mel Gorman wrote:
> > The danger is that this isn't a PPC or s390 bug then as such, but a bug where
> > there are either memoryless nodes or when node 0 is memoryless.  Hence, there
> > is no guarantee that your Kconfig option will catch all instances where this
> > bug triggers.  Granted, the configuration is most likely a PPC machine :)
> 
> Yes, I suggested making SLQB depend on !NUMA to Nick but he didn't like
> that as it's known to be good on x86 NUMA configs.
> 

Agreed.

> On Thu, 2009-09-17 at 11:08 +0100, Mel Gorman wrote:
> > > > The danger is if SLQB is being silently disabled, it'll never be noticed
> > > > or debugged :/
> > > 
> > > Maybe, but that's not an excuse to push something that's known to break. 
> 
> On Thu, 2009-09-17 at 11:57 +0100, Mel Gorman wrote:
> > Wow, this is from back in May! Lame.
> 
> Heh, my (lame) excuse is lack of relevant hardware.... ;-)
> 

I'm not blaming you. It's just ... unfortunate :/

> On Thu, 2009-09-17 at 11:57 +0100, Mel Gorman wrote:
> > I'm against silently disabling it. Memoryless nodes are extremely rare but
> > bugs crop up there occasionally and take a long time to catch and squash. SLQB
> > breaking there is not going to cause widespread damage but force a fix to
> > be developed by the people with access to the affected machines.
> 
> Hey, if someone sends me fix for the bug well before the merge window
> closes, that would be great! But there's no way we're adding new core
> kernel code that's _known_ to break peoples configs, at least not
> through slab.git. If disabling SLQB is not acceptable and we're unable
> to fix things, we'll just have to skip this release cycle.
> 

Please consider disabling it as an option in the rc3 stage or the like.
With luck, I'll find a suitable machine in time and see what can be
done. I just don't like the idea of x86 defaulting to one allocator and
ppc defaulting to another.

> On Thu, 2009-09-17 at 11:57 +0100, Mel Gorman wrote:
> > Total aside, does anybody know handily if fake NUMA support allows the
> > creation of memoryless nodes help reproducing problems like this? If I can't
> > get a real machine, that'll be the approach I'll be trying.
> 
> That would be useful, yes.
> 

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
