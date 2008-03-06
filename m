Return-Path: <linux-kernel-owner+w=401wt.eu-S1762990AbYCFT0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762990AbYCFT0A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 14:26:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753211AbYCFTZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 14:25:53 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:42486 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823AbYCFTZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 14:25:52 -0500
Subject: Re: [PATCH 1/5] generic __remove_pages() support
From: Badari Pulavarty <pbadari@us.ibm.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       paulus@samba.org, Yasunori Goto <y-goto@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20080306110847.11d7cb26.randy.dunlap@oracle.com>
References: <1204829673.7939.59.camel@dyn9047017100.beaverton.ibm.com>
	 <1204829734.7939.61.camel@dyn9047017100.beaverton.ibm.com>
	 <20080306110847.11d7cb26.randy.dunlap@oracle.com>
Content-Type: text/plain
Date: Thu, 06 Mar 2008 11:29:11 -0800
Message-Id: <1204831751.6272.6.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-03-06 at 11:08 -0800, Randy Dunlap wrote:
> On Thu, 06 Mar 2008 10:55:34 -0800 Badari Pulavarty wrote:
> 
> > Generic helper function to remove section mappings and sysfs entries
> > for the section of the memory we are removing.  offline_pages() correctly 
> > adjusted zone and marked the pages reserved.
> 
> Such generic (exported, non-static) interfaces could use some
> (kernel-)docs, please.

Sure. Will do.

> > Issue: If mem_map, usemap allocation could come from different places -
> > kmalloc, vmalloc, alloc_pages or bootmem. There is no easy way
> > to find and free up bootmem allocations.
> > 
> > Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>
> > 
> > ---
> >  include/linux/memory_hotplug.h |    4 +++
> >  mm/memory_hotplug.c            |   44 +++++++++++++++++++++++++++++++++++++++++
> >  mm/sparse.c                    |   43 +++++++++++++++++++++++++++++++++++++---
> >  3 files changed, 88 insertions(+), 3 deletions(-)
> 
> > Index: linux-2.6.25-rc2/include/linux/memory_hotplug.h
> > ===================================================================
> > --- linux-2.6.25-rc2.orig/include/linux/memory_hotplug.h	2008-02-27 12:58:17.000000000 -0800
> > +++ linux-2.6.25-rc2/include/linux/memory_hotplug.h	2008-02-27 13:00:04.000000000 -0800
> > @@ -64,6 +65,8 @@ extern int offline_pages(unsigned long, 
> >  /* reasonably generic interface to expand the physical pages in a zone  */
> >  extern int __add_pages(struct zone *zone, unsigned long start_pfn,
> >  	unsigned long nr_pages);
> > +extern int __remove_pages(struct zone *zone, unsigned long start_pfn,
> > +	unsigned long nr_pages);
> >  
> >  /*
> >   * Walk thorugh all memory which is registered as resource.
> 
>            through :)

I will fix that.

Thanks,
Badari

