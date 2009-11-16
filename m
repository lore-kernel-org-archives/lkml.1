Return-Path: <linux-kernel-owner+w=401wt.eu-S1752087AbZKPJw5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752087AbZKPJw5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 04:52:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751445AbZKPJw4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 04:52:56 -0500
Received: from gir.skynet.ie ([193.1.99.77]:60222 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750761AbZKPJw4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 04:52:56 -0500
Date: Mon, 16 Nov 2009 09:52:58 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Karol Lewandowski <karol.k.lewandowski@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Frans Pop <elendil@planet.nl>,
       Jiri Kosina <jkosina@suse.cz>,
       Sven Geggus <lists@fuchsschwanzdomain.de>,
       Tobias Oetiker <tobi@oetiker.ch>, linux-kernel@vger.kernel.org,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Stephan von Krawczynski <skraw@ithnet.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [PATCH 0/5] Reduce GFP_ATOMIC allocation failures, candidate
	fix V3
Message-ID: <20091116095258.GS29804@csn.ul.ie>
References: <1258054235-3208-1-git-send-email-mel@csn.ul.ie> <20091115120721.GA7557@bizet.domek.prywatny>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20091115120721.GA7557@bizet.domek.prywatny>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 15, 2009 at 01:07:21PM +0100, Karol Lewandowski wrote:
> On Thu, Nov 12, 2009 at 07:30:30PM +0000, Mel Gorman wrote:
> 
> > [Bug #14265] ifconfig: page allocation failure. order:5, mode:0x8020 w/ e100
> 
> > Patches 1-3 should be tested first. The testing I've done shows that the
> > page allocator and behaviour of congestion_wait() is more in line with
> > 2.6.30 than the vanilla kernels.
> > 
> > It'd be nice to have 2 more tests, applying each patch on top noting any
> > behaviour change. i.e. ideally there would be results for
> > 
> >  o patches 1+2+3
> >  o patches 1+2+3+4
> >  o patches 1+2+3+4+5
> > 
> > Of course, any tests results are welcome. The rest of the mail is the
> > results of my own tests.
> 
> I've tried testing 3+4+5 against 2.6.32-rc7 (1+2 seem to be in
> mainline) and got failure.  I've noticed something strange (I think).
> I was unable to trigger failures when system was under heavy memory
> pressure (i.e. my testing - gitk, firefoxes, etc.).  When I killed
> almost all memory hogs, put system into sleep and resumed -- it
> failed.  free(1) showed:
> 
>              total       used       free     shared    buffers     cached
> Mem:        255240     194052      61188          0       4040      49364
> -/+ buffers/cache:     140648     114592
> Swap:       514040      72712     441328
> 
> 
> Is that ok?  Wild guess -- maybe kswapd doesn't take fragmentation (or
> other factors) into account as hard as it used to in 2.6.30?
> 

That's a lot of memory free. I take it the order-5 GFP_ATOMIC allocation
failed. What was the dmesg for it please?

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
