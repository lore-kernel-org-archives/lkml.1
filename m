Return-Path: <linux-kernel-owner+w=401wt.eu-S1754479AbYKDHET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479AbYKDHET (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 02:04:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752157AbYKDHEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 02:04:08 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44764 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752116AbYKDHEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 02:04:07 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Nigel Cunningham <ncunningham@crca.org.au>
Subject: Re: [linux-pm] [PATCH] hibernation should work ok with memory hotplug
Date: Tue, 4 Nov 2008 08:08:35 +0100
User-Agent: KMail/1.9.9
Cc: Dave Hansen <dave@linux.vnet.ibm.com>,
       Matt Tolentino <matthew.e.tolentino@intel.com>, linux-pm@lists.osdl.org,
       Dave Hansen <haveblue@us.ibm.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, pavel@suse.cz, Mel Gorman <mel@skynet.ie>,
       Andy Whitcroft <apw@shadowen.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <20081029105956.GA16347@atrey.karlin.mff.cuni.cz> <1225751665.12673.511.camel@nimitz> <1225771353.6755.16.camel@nigel-laptop>
In-Reply-To: <1225771353.6755.16.camel@nigel-laptop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811040808.36464.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 4 of November 2008, Nigel Cunningham wrote:
> Hi.
> 
> On Mon, 2008-11-03 at 14:34 -0800, Dave Hansen wrote:
> > A node might have a node_start_pfn=0 and a node_end_pfn=100 (and it may
> > have only one zone).  But, there may be another node with
> > node_start_pfn=10 and a node_end_pfn=20.  This loop:
> > 
> >         for_each_zone(zone) {
> > 		...
> >                 for (pfn = zone->zone_start_pfn; pfn < max_zone_pfn; pfn++)
> >                         if (page_is_saveable(zone, pfn))
> >                                 memory_bm_set_bit(orig_bm, pfn);
> >         }
> > 
> > will walk over the smaller node's pfn range multiple times.  Is this OK?
> > 
> > I think all you have to do to fix it is check page_zone(page) == zone
> > and skip out if they don't match.
> 
> So pfn 10 in the first node refers to the same memory as pfn 10 in the
> second node?

A pfn always refers to specific page frame and/or struct page, so yes.
However, in one of the nodes these pfns are sort of "invalid" (they point
to struct pages belonging to other zones).  AFAICS.

Thanks,
Rafael
