Return-Path: <linux-kernel-owner+w=401wt.eu-S1754726AbYHUCNo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726AbYHUCNo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 22:13:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752664AbYHUCNe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 22:13:34 -0400
Received: from relay2.sgi.com ([192.48.171.30]:56475 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750801AbYHUCNd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 22:13:33 -0400
Date: Wed, 20 Aug 2008 21:13:32 -0500
From: Robin Holt <holt@sgi.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       tokunaga.keiich@jp.fujitsu.com
Subject: Re: [RFC][PATCH 0/2] Quicklist is slighly problematic.
Message-ID: <20080821021332.GA23397@sgi.com>
References: <20080820195021.12E7.KOSAKI.MOTOHIRO@jp.fujitsu.com> <48AC25E7.4090005@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48AC25E7.4090005@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2008 at 09:10:47AM -0500, Christoph Lameter wrote:
> KOSAKI Motohiro wrote:
> > Hi Cristoph,
> > 
> > Thank you for explain your quicklist plan at OLS.
> > 
> > So, I made summary to issue of quicklist.
> > if you have a bit time, Could you please read this mail and patches?
> > And, if possible, Could you please tell me your feeling?
> 
> I believe what I said at the OLS was that quicklists are fundamentally crappy
> and should be replaced by something that works (Guess that is what you meant
> by "plan"?). Quicklists were generalized from the IA64 arch code.
> 
> Good fixup but I would think that some more radical rework is needed.
> 
> Maybe some of this needs to vanish into the TLB handling logic?
> 
> Then I have thought for awhile that the main reason that quicklists exist are
> the performance problems in the page allocator. If you can make the single
> page alloc / free pass competitive in performance with quicklists then we
> could get rid of all uses.

It is more than the free/alloc cycle, the quicklist saves us from
having to zero the page.  In a sparsely filled page table, it saves time
and cache footprint.  In a heavily used page table, you end up with a
near wash.

One problem I see is somebody got rid of the node awareness.  We used
to not put pages onto a quicklist when they were being released from a
different node than the cpu is on.  Not sure where that went.  It was
done because of the trap page problem described here.

Thanks,
Robin
