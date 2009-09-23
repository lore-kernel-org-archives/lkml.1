Return-Path: <linux-kernel-owner+w=401wt.eu-S1753989AbZIWCJv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989AbZIWCJv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 22:09:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753963AbZIWCJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 22:09:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40489 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753962AbZIWCJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 22:09:50 -0400
Date: Tue, 22 Sep 2009 19:09:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "richard@rsk.demon.co.uk" <richard@rsk.demon.co.uk>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>
Subject: Re: regression in page writeback
Message-Id: <20090922190915.a472fb7c.akpm@linux-foundation.org>
In-Reply-To: <20090923020104.GA11918@localhost>
References: <1253606965.8439.281.camel@twins>
	<20090922082427.GA24888@localhost>
	<1253608335.8439.283.camel@twins>
	<20090922155259.GL10825@think>
	<20090923002220.GA6382@localhost>
	<20090922175452.d66400dd.akpm@linux-foundation.org>
	<20090923011758.GC6382@localhost>
	<20090922182832.28e7f73a.akpm@linux-foundation.org>
	<20090923013236.GA10885@localhost>
	<20090922184726.b3669515.akpm@linux-foundation.org>
	<20090923020104.GA11918@localhost>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Sep 2009 10:01:04 +0800 Wu Fengguang <fengguang.wu@intel.com> wrote:

> > If there's still outstanding dirty data for any of those queues, both
> > wb_kupdate() and background_writeout() will take a teeny sleep and then
> > will re-poll the queues.
> > 
> > Did that logic get broken?
> 
> No, but the "teeny sleep" is normally much smaller. When io queue is
> not congested, every io completion event will wakeup the congestion
> waiters. Also A's event could wake up B's waiters.
> 
> __freed_request() always calls blk_clear_queue_congested() if under
> congestion threshold which in turn wakes up congestion waiters:
> 
>         if (rl->count[sync] < queue_congestion_off_threshold(q))
>                 blk_clear_queue_congested(q, sync);
> 

Yes.  Have any problems been demonstrated due to that?

And what's _sufficiently_ wrong with that to justify adding potentially
thousands of kernel threads?  It was always a design objective to avoid
doing that.

