Return-Path: <linux-kernel-owner+w=401wt.eu-S1755460AbZKCWIJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460AbZKCWIJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 17:08:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755348AbZKCWII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 17:08:08 -0500
Received: from gir.skynet.ie ([193.1.99.77]:56958 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755063AbZKCWIH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 17:08:07 -0500
Date: Tue, 3 Nov 2009 22:08:09 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Frans Pop <elendil@planet.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org,
       linux-kernel@vger.kernel.org, "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Jiri Kosina <jkosina@suse.cz>,
       Sven Geggus <lists@fuchsschwanzdomain.de>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       Tobias Oetiker <tobi@oetiker.ch>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Stephan von Krawczynski <skraw@ithnet.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [PATCH 3/3] vmscan: Force kswapd to take notice faster when
	high-order watermarks are being hit
Message-ID: <20091103220808.GF22046@csn.ul.ie>
References: <1256650833-15516-1-git-send-email-mel@csn.ul.ie> <200911021832.59035.elendil@planet.nl> <20091102173837.GB22046@csn.ul.ie> <200911032301.59662.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <200911032301.59662.elendil@planet.nl>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 03, 2009 at 11:01:50PM +0100, Frans Pop wrote:
> On Monday 02 November 2009, Mel Gorman wrote:
> > On Mon, Nov 02, 2009 at 06:32:54PM +0100, Frans Pop wrote:
> > > On Monday 02 November 2009, Mel Gorman wrote:
> > > > vmscan: Help debug kswapd issues by counting number of rewakeups and
> > > > premature sleeps
> > > >
> > > > There is a growing amount of anedotal evidence that high-order
> > > > atomic allocation failures have been increasing since 2.6.31-rc1.
> > > > The two strongest possibilities are a marked increase in the number
> > > > of GFP_ATOMIC allocations and alterations in timing. Debugging
> > > > printk patches have shown for example that kswapd is sleeping for
> > > > shorter intervals and going to sleep when watermarks are still not
> > > > being met.
> > > >
> > > > This patch adds two kswapd counters to help identify if timing is an
> > > > issue. The first counter kswapd_highorder_rewakeup counts the number
> > > > of times that kswapd stops reclaiming at one order and restarts at a
> > > > higher order. The second counter kswapd_slept_prematurely counts the
> > > > number of times kswapd went to sleep when the high watermark was not
> > > > met.
> > >
> > > What testing would you like done with this patch?
> >
> > Same reproduction as before except post what the contents of
> > /proc/vmstat were after the problem was triggered.
> 
> With a representative test I get 0 for kswapd_slept_prematurely.
> Tested with .32-rc6 + patches 1-3 + this patch.
> 

Assuming the problem actually reproduced, can you still retest with the
patch I posted as a follow-up and see if fast or slow premature sleeps
are happening and if the problem still occurs please? It's still
possible with the patch as-is could be timing related. After I posted
this patch, I continued testing and found I could get counts fairly
reliably if kswapd was calling printk() before making the premature
check so the window appears to be very small.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
