Return-Path: <linux-kernel-owner+w=401wt.eu-S1758240AbZFWIsw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758240AbZFWIsw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 04:48:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753030AbZFWIsn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 04:48:43 -0400
Received: from gir.skynet.ie ([193.1.99.77]:45472 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751543AbZFWIsm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 04:48:42 -0400
Date: Tue, 23 Jun 2009 09:48:43 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: David Miller <davem@davemloft.net>
Cc: akpm@linux-foundation.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, htd@fancy-poultry.org
Subject: Re: [PATCH 3/3] net-dccp: Suppress warning about large allocations
	from DCCP
Message-ID: <20090623084843.GB9003@csn.ul.ie>
References: <1245685414-8979-1-git-send-email-mel@csn.ul.ie> <1245685414-8979-4-git-send-email-mel@csn.ul.ie> <20090622.161502.74508182.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20090622.161502.74508182.davem@davemloft.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 22, 2009 at 04:15:02PM -0700, David Miller wrote:
> From: Mel Gorman <mel@csn.ul.ie>
> Date: Mon, 22 Jun 2009 16:43:34 +0100
> 
> > The DCCP protocol tries to allocate some large hash tables during
> > initialisation using the largest size possible.  This can be larger than
> > what the page allocator can provide so it prints a warning. However, the
> > caller is able to handle the situation so this patch suppresses the warning.
> > 
> > Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> 
> It's probably much more appropriate to make this stuff use
> alloc_large_system_hash(), like TCP does (see net/ipv4/tcp.c
> tcp_init()).
> 

I agree. In another mail I asked why it wasn't used. I guessed it might be
because of the __init tag but nothing stops that being deleted. It should
not take significant effort to make it usable by DCCP.

> All of this complicated DCCP hash table size computation code will
> simply disappear.  And it'll fix the warning too :-)
>  

It would be my preferred option :)

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
