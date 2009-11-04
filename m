Return-Path: <linux-kernel-owner+w=401wt.eu-S1753937AbZKDCF5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937AbZKDCF5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 21:05:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752572AbZKDCF4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 21:05:56 -0500
Received: from Cpsmtpm-eml108.kpnxchange.com ([195.121.3.12]:52756 "EHLO
	CPSMTPM-EML108.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751039AbZKDCFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 21:05:55 -0500
From: Frans Pop <elendil@planet.nl>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 3/3] vmscan: Force kswapd to take notice faster when high-order watermarks are being hit
Date: Wed, 4 Nov 2009 03:05:55 +0100
User-Agent: KMail/1.9.9
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
References: <1256650833-15516-1-git-send-email-mel@csn.ul.ie> <200911040101.50194.elendil@planet.nl> <20091104011811.GG22046@csn.ul.ie>
In-Reply-To: <20091104011811.GG22046@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911040305.59352.elendil@planet.nl>
X-OriginalArrivalTime: 04 Nov 2009 02:05:59.0677 (UTC) FILETIME=[5A63AAD0:01CA5CF3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 November 2009, Mel Gorman wrote:
> > If you'd like me to test with the congestion_wait() revert on top of
> > this for comparison, please let me know.
>
> No, there is resistance to rolling back the congestion_wait() changes

I've never promoted the revert as a solution. It just shows the cause of a 
regression.

> from what I gather because they were introduced for sane reasons. The
> consequence is just that the reliability of high-order atomics are
> impacted because more processes are making forward progress where
> previously they would have waited until kswapd had done work. Your
> driver has already been fixed in this regard and maybe it's a case that
> the other atomic users simply have to be fixed to "not do that".

The problem is that although my driver has been fixed so that it no longer 
causes the SKB allocation errors, the also rather serious behavior change 
where due to swapping my 3rd gitk takes up to twice as long to load with 
desktop freezes of up 45 seconds or so is still there.

Although that's somewhat separate from the issue that started this whole 
investigation, I still feel that should be sorted out as well.

The congestion_wait() change, even if theoretically valid, introduced a 
very real regression IMO. Such long desktop freezes during swapping should 
be avoided; .30 and earlier simply behaved a whole lot better in the same 
situation.

Cheers,
FJP
