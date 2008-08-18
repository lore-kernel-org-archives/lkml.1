Return-Path: <linux-kernel-owner+w=401wt.eu-S1754170AbYHRTxz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170AbYHRTxz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 15:53:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754338AbYHRTwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 15:52:51 -0400
Received: from gir.skynet.ie ([193.1.99.77]:60112 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754268AbYHRTwt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 15:52:49 -0400
Date: Mon, 18 Aug 2008 20:52:47 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Adam Litke <agl@us.ibm.com>, linux-mm <linux-mm@kvack.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       nacc <nacc@linux.vnet.ibm.com>, apw <apw@shadowen.org>,
       agl <agl@linux.vnet.ibm.com>
Subject: Re: [BUG] __GFP_THISNODE is not always honored
Message-ID: <20080818195246.GA22601@csn.ul.ie>
References: <1218837685.12953.11.camel@localhost.localdomain> <48A9CBB3.6030700@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <48A9CBB3.6030700@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (18/08/08 14:21), Christoph Lameter didst pronounce:
> Adam Litke wrote:
> >
> > So far my debugging has led me to get_page_from_freelist() inside the
> > for_each_zone_zonelist() loop.  When buffered_rmqueue() returns a page I
> > compare the value of page_to_nid(page), zone->node and the node that the
> > hugetlb code requested with __GFP_THISNODE.  These all match -- except when the
> > problem triggers.  In that case, zone->node matches the node we asked for but
> > page_to_nid() does not.
> 
> Uhhh.. A page that was just taken off the freelist? So we may have freed or
> coalesced a page to the wrong zone? Looks like there is something more
> fundamental that broke here.
> 

It's still a bit hard to tell but I don't believe we are coalescing wrong
at the moment. buffered_rmqueue() is pretty high in the call chain for the
page allocator. The problem could have been explained if the zonelist walking
for __GFP_THISNODE was screwed but the dmesg output seems to show that's
ok at least. It could also be something really wacky like the page
linkages don't match the zone->node linkages.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
