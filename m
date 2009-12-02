Return-Path: <linux-kernel-owner+w=401wt.eu-S1754800AbZLBPzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800AbZLBPzi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 10:55:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754641AbZLBPzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 10:55:37 -0500
Received: from gir.skynet.ie ([193.1.99.77]:58859 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754604AbZLBPzg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 10:55:36 -0500
Date: Wed, 2 Dec 2009 15:55:38 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: David John <davidjon@xenontk.org>, linux-kernel@vger.kernel.org,
       Jonathan Miles <jon@cybus.co.uk>, Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: OOM kernel behaviour
Message-ID: <20091202155537.GH1457@csn.ul.ie>
References: <4B1402FC.80307@cybus.co.uk> <4B1537CA.7020107@xenontk.org> <alpine.DEB.2.00.0912011007360.8841@router.home> <4B154E10.7050300@xenontk.org> <alpine.DEB.2.00.0912011124490.10426@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0912011124490.10426@router.home>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 01, 2009 at 11:26:37AM -0600, Christoph Lameter wrote:
> On Tue, 1 Dec 2009, David John wrote:
> 
> > Here are three logs from three days. Log3.txt is today's log and the OOM
> > killer murdered Thunderbird as I was attempting to write this message.
> > The kernel config is also attached.
> 
> Hmmm... This is all caused by the HIGHMEM zone freecount going beyond min
> which then triggers reclaim which for some reason fails (should not there
> is sufficient material there to reclaim). There is enough memory in the
> NORMAL zone. Wonder if something broke in 2.6.31 in reclaim? Mel?
> 

I'm not aware of breakage of that level, nor do I believe the page
allocator problems are related to this bug.

However, I just took a look at the logs from the three days and I see
things like

Nov 25 23:58:53 avalanche kernel: Free swap  = 0kB
Nov 25 23:58:53 avalanche kernel: Total swap = 2048248kB


Something on that system is leaking badly. Do something like

ps aux --sort vsz

and see what process has gone mental and is consuming all of swap. It's
possible that the OOM killer is triggering too easily but it's possible
that a delayed triggering of the OOM killer would have been just that -
a delay. Eventually all memory and all swap would be used.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
