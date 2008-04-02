Return-Path: <linux-kernel-owner+w=401wt.eu-S1755943AbYDBM21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943AbYDBM21 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 08:28:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753527AbYDBM2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 08:28:20 -0400
Received: from brick.kernel.dk ([87.55.233.238]:6149 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753040AbYDBM2U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 08:28:20 -0400
Date: Wed, 2 Apr 2008 14:28:15 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, paulmck@linux.vnet.ibm.com,
       Ingo Molnar <mingo@elte.hu>, Vegard Nossum <vegard.nossum@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: kmemcheck caught read from freed memory (cfq_free_io_context)
Message-ID: <20080402122814.GF12774@kernel.dk>
References: <20080402110718.GU12774@kernel.dk> <1207134536.8514.773.camel@twins> <20080402111422.GW12774@kernel.dk> <1207135212.8514.782.camel@twins> <20080402113258.GY12774@kernel.dk> <1207136230.8514.791.camel@twins> <20080402114243.GZ12774@kernel.dk> <1207136867.8514.796.camel@twins> <20080402115337.GD12774@kernel.dk> <1207138422.8514.799.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1207138422.8514.799.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02 2008, Peter Zijlstra wrote:
> On Wed, 2008-04-02 at 13:53 +0200, Jens Axboe wrote:
> 
> > > Yeah, SLAB_DESTROY_BY_RCU should have a _HUGE_ comment explaining it,
> > > I'm sure this is not the first (nor the last) time people get that
> > > wrong.
> > 
> > It should, SLAB_DESTROY_BY_RCU is definitely useful, but it is expected
> > to be an 'easier' way of doing the call_rcu() manually. So it definitely
> > needs more documentation.
> > 
> 
> Ok I gave it a go, how bad is this text?

I think it looks good. The key point is this:

"This delays freeing the SLAB page by a grace period, it does _NOT_ delay
object freeing."

which is right in the front of the text and with sample validation
below. So you can add my acked-by to that, if you want.

-- 
Jens Axboe

