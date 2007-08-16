Return-Path: <linux-kernel-owner+w=401wt.eu-S938129AbXHPCuH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938129AbXHPCuH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 22:50:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760089AbXHPCtx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 22:49:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43394 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765966AbXHPCtw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 22:49:52 -0400
Date: Thu, 16 Aug 2007 04:49:49 +0200
From: Nick Piggin <npiggin@suse.de>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, dkegel@google.com,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       David Miller <davem@davemloft.net>
Subject: Re: [RFC 0/9] Reclaim during GFP_ATOMIC allocs
Message-ID: <20070816024949.GA16372@wotan.suse.de>
References: <20070814153021.446917377@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070814153021.446917377@sgi.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2007 at 08:30:21AM -0700, Christoph Lameter wrote:
> This is the extended version of the reclaim patchset. It enables reclaim from
> clean file backed pages during GFP_ATOMIC allocs. A bit invasive since
> may locks must now be taken with saving flags. But it works.
> 
> Tested by repeatedly allocating 12MB of memory from the timer interrupt.
> 
> -- 

Just to clarify... I can see how recursive reclaim can prevent memory getting
eaten up by reclaim (which thus causes allocations from interrupt handlers to
fail)...

But this patchset I don't see will do anything to prevent reclaim deadlocks,
right? (because if there is reclaimable memory at hand, then kswapd should
eventually reclaim it).
