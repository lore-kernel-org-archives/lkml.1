Return-Path: <linux-kernel-owner+w=401wt.eu-S1753878AbZKMNhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878AbZKMNhq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 08:37:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752454AbZKMNhj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 08:37:39 -0500
Received: from gir.skynet.ie ([193.1.99.77]:48444 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752171AbZKMNhi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 08:37:38 -0500
Date: Fri, 13 Nov 2009 13:37:41 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Tobias Oetiker <tobi@oetiker.ch>
Cc: Andrew Morton <akpm@linux-foundation.org>, Frans Pop <elendil@planet.nl>,
       Jiri Kosina <jkosina@suse.cz>,
       Sven Geggus <lists@fuchsschwanzdomain.de>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       linux-kernel@vger.kernel.org, "linux-mm@kvack.org" <linux-mm@kvack.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Stephan von Krawczynski <skraw@ithnet.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [PATCH 0/5] Reduce GFP_ATOMIC allocation failures, candidate
	fix V3
Message-ID: <20091113133740.GD29804@csn.ul.ie>
References: <1258054235-3208-1-git-send-email-mel@csn.ul.ie> <alpine.DEB.2.00.0911131346560.22447@wbuna.brgvxre.pu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0911131346560.22447@wbuna.brgvxre.pu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 13, 2009 at 01:47:35PM +0100, Tobias Oetiker wrote:
> Hi Mel,
> 
> Yesterday Mel Gorman wrote:
> 
> > Sorry for the long delay in posting another version. Testing is extremely
> > time-consuming and I wasn't getting to work on this as much as I'd have liked.
> >
> > Changelog since V2
> >   o Dropped the kswapd-quickly-notice-high-order patch. In more detailed
> >     testing, it made latencies even worse as kswapd slept more on high-order
> >     congestion causing order-0 direct reclaims.
> >   o Added changes to how congestion_wait() works
> >   o Added a number of new patches altering the behaviour of reclaim
> 
> so is there anything promissing for the order 5 allocation problems
> in this set?
> 

Yes. While the change in timing of direct reclaimers might be less
important when dm-crypt is not involved, kswapd is more pro-active about
maintaining the watermarks.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
