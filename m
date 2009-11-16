Return-Path: <linux-kernel-owner+w=401wt.eu-S1752164AbZKPR5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164AbZKPR5i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 12:57:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752049AbZKPR5i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 12:57:38 -0500
Received: from gir.skynet.ie ([193.1.99.77]:50375 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751542AbZKPR5h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 12:57:37 -0500
Date: Mon, 16 Nov 2009 17:57:39 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Frans Pop <elendil@planet.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>,
       Sven Geggus <lists@fuchsschwanzdomain.de>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       Tobias Oetiker <tobi@oetiker.ch>, linux-kernel@vger.kernel.org,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Stephan von Krawczynski <skraw@ithnet.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 0/5] Reduce GFP_ATOMIC allocation failures, candidate
	fix V3
Message-ID: <20091116175739.GW29804@csn.ul.ie>
References: <1258054235-3208-1-git-send-email-mel@csn.ul.ie> <200911131004.25293.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <200911131004.25293.elendil@planet.nl>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 13, 2009 at 10:04:21AM +0100, Frans Pop wrote:
> On Thursday 12 November 2009, Mel Gorman wrote:
> > Changelog since V2
> >   o Dropped the kswapd-quickly-notice-high-order patch. In more detailed
> >     testing, it made latencies even worse as kswapd slept more on
> >     high-order congestion causing order-0 direct reclaims.
> >   o Added changes to how congestion_wait() works
> >   o Added a number of new patches altering the behaviour of reclaim
> 
> I have tested this series on top of .32-rc7. First impression is that it 
> does seem to improve my test case, but does not yet completely solve it.
> 
> My last gitk instance now loads more smoothly for most of the time it takes 
> to complete, but I still see a choke point where things freeze for a while 
> and where I get SKB allocation errors from my wireless.
> However, that choke point does seem to happen later and to be shorter than 
> without the patches.
> 

I haven't fully figured out why this makes a difference yet, but with
.32-rc7 and these patches, could you retry the test except beforehand do

cd /sys
for SYS in `find -name low_latency`; do
        echo 0 > $SYS
done

I believe the low_latency logic might be interfering with the number of
clean pages available for kswapd to reclaim.

Thanks

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
