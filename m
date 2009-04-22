Return-Path: <linux-kernel-owner+w=401wt.eu-S1755480AbZDVRPJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480AbZDVRPJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 13:15:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752435AbZDVROz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 13:14:55 -0400
Received: from gir.skynet.ie ([193.1.99.77]:35822 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752612AbZDVROz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 13:14:55 -0400
Date: Wed, 22 Apr 2009 18:14:52 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 18/22] Use allocation flags as an index to the zone
	watermark
Message-ID: <20090422171451.GG15367@csn.ul.ie>
References: <1240408407-21848-1-git-send-email-mel@csn.ul.ie> <1240408407-21848-19-git-send-email-mel@csn.ul.ie> <1240420313.10627.85.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1240420313.10627.85.camel@nimitz>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 22, 2009 at 10:11:53AM -0700, Dave Hansen wrote:
> On Wed, 2009-04-22 at 14:53 +0100, Mel Gorman wrote:
> >  struct zone {
> >         /* Fields commonly accessed by the page allocator */
> > -       unsigned long           pages_min, pages_low, pages_high;
> > +       union {
> > +               struct {
> > +                       unsigned long   pages_min, pages_low, pages_high;
> > +               };
> > +               unsigned long pages_mark[3];
> > +       };
> 
> Why the union?  It's a bit obfuscated for me.  Why not just have a
> couple of these:
> 
> static inline unsigned long zone_pages_min(struct zone *zone)
> {
> 	return zone->pages_mark[ALLOC_WMARK_MIN];
> }
> 
> and s/zone->pages_min/zone_pages_min(zone)/
> 
> ?
> 

Preference of taste really. When I started a conversion to accessors, it
changed something recognised to something new that looked uglier to me.
Only one place cares about the union enough to access is via an array so
why spread it everywhere.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
