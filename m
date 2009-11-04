Return-Path: <linux-kernel-owner+w=401wt.eu-S1756823AbZKDPsx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756823AbZKDPsx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 10:48:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756752AbZKDPsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 10:48:53 -0500
Received: from gir.skynet.ie ([193.1.99.77]:42048 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756561AbZKDPsw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 10:48:52 -0500
Date: Wed, 4 Nov 2009 15:48:53 +0000
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
Message-ID: <20091104154853.GM22046@csn.ul.ie>
References: <1256650833-15516-1-git-send-email-mel@csn.ul.ie> <200911040101.50194.elendil@planet.nl> <20091104011811.GG22046@csn.ul.ie> <200911040305.59352.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <200911040305.59352.elendil@planet.nl>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 04, 2009 at 03:05:55AM +0100, Frans Pop wrote:
> On Wednesday 04 November 2009, Mel Gorman wrote:
> > > If you'd like me to test with the congestion_wait() revert on top of
> > > this for comparison, please let me know.
> >
> > No, there is resistance to rolling back the congestion_wait() changes
> 
> I've never promoted the revert as a solution. It just shows the cause of a 
> regression.
> 

Yeah, I still haven't managed to figure out what exactly is wrong in there
other than "something changed with timing" and writeback behaves differently. I
still don't know the why of it because I haven't digged into that area in
depth in the past and failed at reproducing this. "My desktop is fine" :/

> > from what I gather because they were introduced for sane reasons. The
> > consequence is just that the reliability of high-order atomics are
> > impacted because more processes are making forward progress where
> > previously they would have waited until kswapd had done work. Your
> > driver has already been fixed in this regard and maybe it's a case that
> > the other atomic users simply have to be fixed to "not do that".
> 
> The problem is that although my driver has been fixed so that it no longer 
> causes the SKB allocation errors, the also rather serious behavior change 
> where due to swapping my 3rd gitk takes up to twice as long to load with 
> desktop freezes of up 45 seconds or so is still there.
> 
> Although that's somewhat separate from the issue that started this whole 
> investigation, I still feel that should be sorted out as well.
> 

You're right. That behaviour sucks.

> The congestion_wait() change, even if theoretically valid, introduced a 
> very real regression IMO. Such long desktop freezes during swapping should 
> be avoided; .30 and earlier simply behaved a whole lot better in the same 
> situation.
> 

Agreed. I'll start from scratch again trying to reproduce what you're seeing
locally. I'll try breaking my network card so that it's making high-order
atomics and see where I get. Machines that were previously tied up are now
free so I might have a better chance.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
