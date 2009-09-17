Return-Path: <linux-kernel-owner+w=401wt.eu-S1753106AbZIQK5F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106AbZIQK5F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 06:57:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752256AbZIQK5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 06:57:04 -0400
Received: from gir.skynet.ie ([193.1.99.77]:40669 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751353AbZIQK5D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 06:57:03 -0400
Date: Thu, 17 Sep 2009 11:57:08 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       cl@linux-foundation.org, heiko.carstens@de.ibm.com, mingo@elte.hu,
       npiggin@suse.de, sachinp@in.ibm.com
Subject: Re: [RFC/PATCH] SLQB: Mark the allocator as broken PowerPC and S390
Message-ID: <20090917105707.GA7205@csn.ul.ie>
References: <1253083059.5478.1.camel@penberg-laptop> <20090917100841.GF13002@csn.ul.ie> <1253183365.4975.20.camel@penberg-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1253183365.4975.20.camel@penberg-laptop>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 17, 2009 at 01:29:24PM +0300, Pekka Enberg wrote:
> Hi Mel,
> 
> On Wed, Sep 16, 2009 at 09:37:39AM +0300, Pekka Enberg wrote:
> > > The SLQB allocator is known to be broken on certain PowerPC and S390
> > > configurations. Disable the allocator in Kconfig for those architectures
> > > until the issues are resolved. 
> > 
> > Can the issues be summarised?
> 
> It's a boot time crash during module load:
> 
> http://www.mail-archive.com/linuxppc-dev@lists.ozlabs.org/msg33092.html
> 
> AFAICT, it's related to a memoryless node 0. Nick suggested it could be
> a latent bug in the kernel that's triggered by SLQB.
> 

The danger is that this isn't a PPC or s390 bug then as such, but a bug where
there are either memoryless nodes or when node 0 is memoryless.  Hence, there
is no guarantee that your Kconfig option will catch all instances where this
bug triggers.  Granted, the configuration is most likely a PPC machine :)

> On Thu, 2009-09-17 at 11:08 +0100, Mel Gorman wrote:
> > The danger is if SLQB is being silently disabled, it'll never be noticed
> > or debugged :/
> 
> Maybe, but that's not an excuse to push something that's known to break.
> 

Wow, this is from back in May! Lame.

I'm against silently disabling it. Memoryless nodes are extremely rare but
bugs crop up there occasionally and take a long time to catch and squash. SLQB
breaking there is not going to cause widespread damage but force a fix to
be developed by the people with access to the affected machines.

> The other alternative is to skip this release cycle but I'm not sure
> what we'd gain with that. Nick already stated in private that he'll try
> to arrange for some time with ppc machines to debug the thing and we
> hope to be able to fix it by 2.6.32 final.
> 

I have access to a ppc machine but not necessarily one with a memoryless nodes
that can reproduce this problem.

Assuming Sachin is the reporter and we are in the same company, maybe I
have access to the machine. Sachin, can you mail me privately what this
machine is called and lets see can I get some time on that machine? By
any chance, was this bisected or did it just show up when SLQB became
the default?

Total aside, does anybody know handily if fake NUMA support allows the
creation of memoryless nodes help reproducing problems like this? If I can't
get a real machine, that'll be the approach I'll be trying.

> Btw, the code is in slqb/core branch of slab.git in case someone wants
> to take a stab at fixing the bug.
> 

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
