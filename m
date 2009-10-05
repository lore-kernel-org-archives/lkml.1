Return-Path: <linux-kernel-owner+w=401wt.eu-S932314AbZJEI6P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932314AbZJEI6P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 04:58:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932297AbZJEI6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 04:58:14 -0400
Received: from gir.skynet.ie ([193.1.99.77]:41838 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932139AbZJEI6N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 04:58:13 -0400
Date: Mon, 5 Oct 2009 09:57:39 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Frans Pop <elendil@planet.nl>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Reinette Chatre <reinette.chatre@intel.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>, linux-mm@kvack.org
Subject: Re: [Bug #14141] order 2 page allocation failures in iwlagn
Message-ID: <20091005085739.GB5452@csn.ul.ie>
References: <3onW63eFtRF.A.xXH.oMTxKB@chimera> <200910021111.55749.elendil@planet.nl> <200910050714.01908.elendil@planet.nl> <200910050851.02056.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <200910050851.02056.elendil@planet.nl>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 05, 2009 at 08:50:58AM +0200, Frans Pop wrote:
> On Monday 05 October 2009, Frans Pop wrote:
> > I'll dig into this a bit more as it looks like this should be
> > reproducible, probably even without the kernel build. Next step is to
> > see how .30 behaves in the same situation.
> 
> This looks conclusive. I tested .30 and .32-rc3 from clean reboots and
> only starting gitk. I only started music playing in the background
> (amarok) from an NFS share to ensure network activity.
> 
> With .32-rc3 I got 4 SKB allocation errors while starting the *second* gitk
> instance. And the system was completely frozen with music stopped until gitk
> finished loading.
> 
> With .30 I was able to start *three* gitk's (which meant 2 of them got
> (partially) swapped out) without any allocation errors. And with the system
> remaining relatively responsive. There was a short break in the music while
> I started the 2nd instance, but it just continued playing afterwards. There
> was also some mild latency in the mouse cursor, but nothing like the full
> desktop freeze I get with .32-rc3.
> 
> With .30 I looked at /proc/buddyinfo while the 3rd gitk was being started,
> and that looked fairly healthy all the time:
> Node 0, zone      DMA      5      9     22     20     21     11      0      0      0      0      1
> Node 0, zone    DMA32    579     67     25      8      5      1      1      0      1      1      0
> Node 0, zone      DMA      5      9     22     20     21     11      0      0      0      0      1
> Node 0, zone    DMA32    276     54     13     15      8     10      3      1      1      1      0
> Node 0, zone      DMA      4      9     22     20     21     11      0      0      0      0      1
> Node 0, zone    DMA32    119     45     24     18     12      4      5      2      1      1      0
> Node 0, zone      DMA      4      9     22     20     21     11      0      0      0      0      1
> Node 0, zone    DMA32    527     13      9      5      5      3      2      1      1      1      0
> Node 0, zone      DMA      5      9     22     20     21     11      0      0      0      0      1
> Node 0, zone    DMA32   1375     24      7      7      8      5      1      1      0      1      0
> Node 0, zone      DMA      5      9     22     20     21     11      0      0      0      0      1
> Node 0, zone    DMA32    329     21      3      3     17      8      5      1      0      1      0
> 
> With .32 it was obviously impossible to get that info due to the total
> freeze of the desktop. Not sure if the scheduler changes in .32 contribute
> to this. Guess I could find out by doing the same test with .31.
> 
> One thing I should mention: my swap is an LVM volume that's in a VG that's
> on a LUKS encrypted partition.
> 
> Does this give you enough info to go on, or should I try a bisection?
> 

I'll be trying to reproduce it, but it's unlikely I'll manage to
reproduce it reliably as there may be a specific combination of hardware
necessary as well. What I'm going to try is writing a module that
allocates order-5 every second GFP_ATOMIC and see can I reproduce using
scenarios similar to yours but it'll take some time with no guarantee of
success. If you could bisect it, it would be fantastic.

Thanks

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
