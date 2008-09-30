Return-Path: <linux-kernel-owner+w=401wt.eu-S1754004AbYI3Tm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004AbYI3Tm0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 15:42:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753426AbYI3TmS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 15:42:18 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:51070 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753402AbYI3TmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 15:42:18 -0400
Date: Tue, 30 Sep 2008 12:41:22 -0700
From: Gary Hade <garyhade@us.ibm.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>, Gary Hade <garyhade@us.ibm.com>,
       linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
       Badari Pulavarty <pbadari@us.ibm.com>, Mel Gorman <mel@csn.ul.ie>,
       Chris McDermott <lcm@us.ibm.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Greg KH <greg@kroah.com>,
       Nish Aravamudan <nish.aravamudan@gmail.com>
Subject: Re: [PATCH] mm: show node to memory section relationship with
	symlinks in sysfs
Message-ID: <20080930194122.GA7123@us.ibm.com>
References: <20080929200509.GC21255@us.ibm.com> <20080930163324.44A7.E1E9C6FF@jp.fujitsu.com> <1222789837.17630.41.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1222789837.17630.41.camel@nimitz>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2008 at 08:50:37AM -0700, Dave Hansen wrote:
> On Tue, 2008-09-30 at 17:06 +0900, Yasunori Goto wrote:
> > > +#define section_nr_to_nid(section_nr) pfn_to_nid(section_nr_to_pfn(section_nr))
> > >  #endif /* CONFIG_MEMORY_HOTPLUG_SPARSE */
> > 
> > If the first page of the section is not valid, then this section_nr_to_nid()
> > doesn't return correct value.
> > 
> > I tested this patch. In my box, the start_pfn of node 1 is 1200400, but 
> > section_nr_to_pfn(mem_blk->phys_index) returns 1200000. As a result,
> > the section is linked to node 0.
> 
> Crap, I was worried about that.
> 
> Gary, this means that we have a N:1 relationship between NUMA nodes and
> sections.  This normally isn't a problem because sections don't really
> care about nodes and they layer underneath them.

So, using Yasunori-san's example the memory section starting at
pfn 1200000 actually resides on both node 0 and node 1.

> 
> We'll probably need multiple symlinks in each section directory.

or perhaps symlinks to the same section directory from >1 node directory.

Gary

-- 
Gary Hade
System x Enablement
IBM Linux Technology Center
503-578-4503  IBM T/L: 775-4503
garyhade@us.ibm.com
http://www.ibm.com/linux/ltc
