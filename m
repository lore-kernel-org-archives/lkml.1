Return-Path: <linux-kernel-owner+w=401wt.eu-S1756167AbZAWPPg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167AbZAWPPg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 10:15:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752307AbZAWPP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 10:15:28 -0500
Received: from ns.suse.de ([195.135.220.2]:39867 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751185AbZAWPP1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 10:15:27 -0500
Date: Fri, 23 Jan 2009 16:15:25 +0100
From: Nick Piggin <npiggin@suse.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lin Ming <ming.m.lin@intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Subject: Re: [patch] SLQB slab allocator
Message-ID: <20090123151525.GL19986@wotan.suse.de>
References: <20090121143008.GV24891@wotan.suse.de> <87hc3qcpo1.fsf@basil.nowhere.org> <20090123112555.GF19986@wotan.suse.de> <20090123115731.GO15750@one.firstfloor.org> <20090123131800.GH19986@wotan.suse.de> <20090123140406.GR15750@one.firstfloor.org> <20090123142753.GK19986@wotan.suse.de> <20090123150632.GS15750@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090123150632.GS15750@one.firstfloor.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2009 at 04:06:32PM +0100, Andi Kleen wrote:
> On Fri, Jan 23, 2009 at 03:27:53PM +0100, Nick Piggin wrote:
> >  
> > > Although I think I would prefer alloc_percpu, possibly with
> > > per_cpu_ptr(first_cpu(node_to_cpumask(node)), ...)
> > 
> > I don't think we have the NUMA information available early enough
> > to do that. 
> 
> How early? At mem_init time it should be there because bootmem needed
> it already. It meaning the architectural level NUMA information.

node_to_cpumask(0) returned 0 at kmem_cache_init time.

 
> > OK, but if it is _possible_ for the node to gain memory, then you
> > can't do that of course. 
> 
> In theory it could gain memory through memory hotplug.

Yes.

 
> > The cache_line_size() change wouldn't change slqb code significantly.
> > I have no problem with it, but I simply won't have time to do it and
> > test all architectures and get them merged and hold off merging
> > SLQB until they all get merged.
> 
> I was mainly refering to the sysfs code here.

OK.


> > > Could you perhaps mark all the code you don't want to change?
> > 
> > Primarily the debug code from SLUB.
> 
> Ok so you could fix the sysfs code? @)
> 
> Anyways, if you have such shared pieces perhaps it would be better
> if you just pull them all out into a separate file. 

I'll see. I do plan to try making improvements to this peripheral
code but it just has to wait a little bit for other improvements
first.

