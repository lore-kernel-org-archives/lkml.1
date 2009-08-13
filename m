Return-Path: <linux-kernel-owner+w=401wt.eu-S1753361AbZHMIjM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361AbZHMIjM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 04:39:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751880AbZHMIjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 04:39:11 -0400
Received: from gir.skynet.ie ([193.1.99.77]:51653 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751697AbZHMIjJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 04:39:09 -0400
Date: Thu, 13 Aug 2009 09:39:11 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Arnaud Faucher <arnaud.faucher@gmail.com>
Cc: Juergen Beisert <jbe@pengutronix.de>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-hotplug@vger.kernel.org
Subject: Re: Patch "page-allocator: preserve PFN ordering when __GFP_COLD
	is set" fails on my system
Message-ID: <20090813083910.GA27006@csn.ul.ie>
References: <200908111830.03224.jbe@pengutronix.de> <200908121311.35321.jbe@pengutronix.de> <20090812135036.GE19269@csn.ul.ie> <200908121735.44439.jbe@pengutronix.de> <1250102430.4912.4.camel@green>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1250102430.4912.4.camel@green>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 12, 2009 at 02:40:30PM -0400, Arnaud Faucher wrote:
> I have a rather similar problem on a driver that I try to keep
> up-to-date with recent kernel versions
> (http://code.ximeta.com/trac-ndas/ticket/1110#comment:30). The NDAS
> hardware is an ethernet-enabled disk controller on one chip, kind of a
> cheap iSCSI.
> 
> In my case there is no oops: the symptoms are that the read blocks seem
> to be swapped or full of garbage.
> 
> After investigation in the NDAS code, the bug triggers when the driver
> tries to merge adjacent requests before sending them to the controller.
> I had to disable this merge in order to restore normal behavior, at the
> expense of a reduced efficiency.
> 

That is a very interesting point and one I hadn't considered. The point
of the patch was to help drivers that merge adjacent requests if they
happen to be physically contiguous. The reported bug that led to the
patch was a regression of memory not being physically contiguous and
requests not being merged.

> > After this oops, system startup continues. Then the next oops occurs:
> > 
> > This one is new, since I try to mount the connected SD card.
> > 
> 
> Mel's buffer overrun theory seems to apply in the NDAS driver case,
> where the original requests adjacency test seems faulty.
> 
> May it also be the cause of the SD mounting crash ?
> 

It's a possibility. If it's not an overrun, it's possible that the automatic
merging code is buggy as well.

Juergen, is the disk controller on your machine capable of merging
requests? If so, can you disable it and see if the bug still occurs
please?

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
