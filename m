Return-Path: <linux-kernel-owner+w=401wt.eu-S1754837AbZFHLDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837AbZFHLDS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 07:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754392AbZFHLDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 07:03:05 -0400
Received: from gir.skynet.ie ([193.1.99.77]:51293 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753696AbZFHLDE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 07:03:04 -0400
Date: Mon, 8 Jun 2009 12:03:03 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Rik van Riel <riel@redhat.com>, Larry Finger <Larry.Finger@lwfinger.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [Bug #13319] Page allocation failures with b43 and p54usb
Message-ID: <20090608110303.GD15377@csn.ul.ie>
References: <bCxQpon4SCJ.A.RrF.yY7KKB@chimera> <D9VoutSOyXP.A.hvH.Ha7KKB@chimera> <4A2BBC30.2030300@lwfinger.net> <84144f020906070640rf5ab14nbf66d3ca7c97675f@mail.gmail.com> <4A2BCC6F.8090004@redhat.com> <84144f020906070732l31786156r5d9753a0cabfde79@mail.gmail.com> <20090608101739.GA15377@csn.ul.ie> <84144f020906080352k57f12ff9pbd696da5f332ac1a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <84144f020906080352k57f12ff9pbd696da5f332ac1a@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 08, 2009 at 01:52:05PM +0300, Pekka Enberg wrote:
> On Mon, Jun 8, 2009 at 1:17 PM, Mel Gorman<mel@csn.ul.ie> wrote:
> > Pekka, assuming the request size is 800 bytes, and SLUB is using order-1
> > pages for allocations of that size, what happened order-1 allocations
> > falling back to order-0 allocations as necessary. That logic exists,
> > right? If so, could it be broken?
> 
> That logic is in allocate_slab() and if the higher order allocation
> fails, we fall-back to struct kmem_cache ->min order. That in turn is
> set up in calculate_sizes() to get_order(size) so it seems pretty
> unlikely to me the allocation is 800 bytes. Of course, I could be
> missing something here and there's a bug in oo_make() or oo_order().
> Hmm.

Is there any chance you could hatchet together a patch
slab-allocation-failure that reports on slab allocation failures similar
to what the page allocator does? Minimally, it should tell us what
the size of the allocation was but any other information such as the
same of the slab, the size of pages it normally uses are, etc. would
also be useful.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
