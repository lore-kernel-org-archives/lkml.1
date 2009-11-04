Return-Path: <linux-kernel-owner+w=401wt.eu-S1753961AbZKDCIO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961AbZKDCIO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 21:08:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753480AbZKDCIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 21:08:13 -0500
Received: from gir.skynet.ie ([193.1.99.77]:57751 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752572AbZKDCIN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 21:08:13 -0500
Date: Wed, 4 Nov 2009 02:08:15 +0000
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
Message-ID: <20091104020815.GH22046@csn.ul.ie>
References: <1256650833-15516-1-git-send-email-mel@csn.ul.ie> <200911032301.59662.elendil@planet.nl> <20091103220808.GF22046@csn.ul.ie> <200911040101.50194.elendil@planet.nl> <20091104011811.GG22046@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20091104011811.GG22046@csn.ul.ie>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 04, 2009 at 01:18:11AM +0000, Mel Gorman wrote:
> > From vmstat for .31.1:
> > kswapd_highorder_rewakeup 20
> > kswapd_slept_prematurely_fast 307
> > kswapd_slept_prematurely_slow 105
> > 
> 
> This is useful.
> 
> The high premature_fast shows that after kswapd apparently finishes its work,
> the high waterwater marks are being breached very quickly (the fast counter
> being positive). The "slow" counter is even worse. Your machine is getting
> from the high to low watermark quickly without kswapd noticing and processes
> depending on the atomics are not waiting long enough.
> 

Sorry, that should have been

 The premature_fast shows that after kswapd finishes its work, the low
 waterwater marks are being breached very quickly as kswapd is being rewoken
 up. The "slow" counter is slightly worse. Just after kswapd sleeps, the
 high watermark is being breached again.

Either counter being positive implies that kswapd is having to do too
much work while parallel allocators are chewing up the high-order pages
quickly. The effect of the patch should still be to delay the rate high-order
pages are consumed but it assumes there are enough high-order requests that
can go to sleep.

Mentioning sleep, I'm going to get some.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
