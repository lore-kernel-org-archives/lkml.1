Return-Path: <linux-kernel-owner+w=401wt.eu-S1753905AbYI3PvO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905AbYI3PvO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 11:51:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751935AbYI3Pu6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 11:50:58 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:40960 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751792AbYI3Pu5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 11:50:57 -0400
Subject: Re: [PATCH] mm: show node to memory section relationship with
	symlinks in sysfs
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Gary Hade <garyhade@us.ibm.com>, linux-mm@kvack.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Badari Pulavarty <pbadari@us.ibm.com>, Mel Gorman <mel@csn.ul.ie>,
       Chris McDermott <lcm@us.ibm.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Greg KH <greg@kroah.com>,
       Nish Aravamudan <nish.aravamudan@gmail.com>
In-Reply-To: <20080930163324.44A7.E1E9C6FF@jp.fujitsu.com>
References: <20080929200509.GC21255@us.ibm.com>
	 <20080930163324.44A7.E1E9C6FF@jp.fujitsu.com>
Content-Type: text/plain
Date: Tue, 30 Sep 2008 08:50:37 -0700
Message-Id: <1222789837.17630.41.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-09-30 at 17:06 +0900, Yasunori Goto wrote:
> > +#define section_nr_to_nid(section_nr) pfn_to_nid(section_nr_to_pfn(section_nr))
> >  #endif /* CONFIG_MEMORY_HOTPLUG_SPARSE */
> 
> If the first page of the section is not valid, then this section_nr_to_nid()
> doesn't return correct value.
> 
> I tested this patch. In my box, the start_pfn of node 1 is 1200400, but 
> section_nr_to_pfn(mem_blk->phys_index) returns 1200000. As a result,
> the section is linked to node 0.

Crap, I was worried about that.

Gary, this means that we have a N:1 relationship between NUMA nodes and
sections.  This normally isn't a problem because sections don't really
care about nodes and they layer underneath them.

We'll probably need multiple symlinks in each section directory.

-- Dave

