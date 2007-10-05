Return-Path: <linux-kernel-owner+w=401wt.eu-S1757634AbXJELMq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757634AbXJELMq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 07:12:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752011AbXJELMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 07:12:35 -0400
Received: from mx2.suse.de ([195.135.220.15]:47654 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751940AbXJELMe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 07:12:34 -0400
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, David Chinner <dgc@sgi.com>,
       David Miller <davem@davemloft.net>, cebbert@redhat.com,
       willy@linux.intel.com, clameter@sgi.com, nickpiggin@yahoo.com.au,
       hch@lst.de, mel@skynet.ie, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com
Subject: Re: SLUB performance regression vs SLAB
References: <470554D9.2050505@redhat.com>
	<20071004.141113.08322956.davem@davemloft.net>
	<47055F84.109@redhat.com>
	<20071004.150718.95506800.davem@davemloft.net>
	<20071004222356.GH23367404@sgi.com> <20071005064853.GI5711@kernel.dk>
	<84144f020710050219k2460631cjfd556d6eae645887@mail.gmail.com>
	<20071005092822.GL5711@kernel.dk>
From: Andi Kleen <andi@firstfloor.org>
Date: 05 Oct 2007 13:12:30 +0200
In-Reply-To: <20071005092822.GL5711@kernel.dk>
Message-ID: <p73bqbd6cip.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <jens.axboe@oracle.com> writes:
> 
> Writing a small test module to exercise slub/slab in various ways
> (allocating from all cpus freeing from one, as described) should not be
> too hard. Perhaps that would be enough to find this performance
> discrepancy between slab and slub?

You could simulate that by just sending packets using unix sockets 
between threads bound to different CPUs. Sending a packet allocates; receiving 
deallocates.

But it's not clear that will really simulate the cache bounce environment
of the database test. I don't think all passing of data between CPUs 
using slub objects is slow.

-Andi
