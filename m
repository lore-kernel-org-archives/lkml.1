Return-Path: <linux-kernel-owner+w=401wt.eu-S1757183AbZIRR0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757183AbZIRR0Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 13:26:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756733AbZIRR0Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 13:26:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:46488 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756364AbZIRR0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 13:26:24 -0400
Subject: Re: [PATCH 0/2]: Get perf counters working on D-cache aliasing
 cpus.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, jens.axboe@oracle.com
In-Reply-To: <20090918.102234.175792545.davem@davemloft.net>
References: <20090908.051045.26522683.davem@davemloft.net>
	 <1253277096.8439.127.camel@twins>
	 <20090918.102234.175792545.davem@davemloft.net>
Content-Type: text/plain
Date: Fri, 18 Sep 2009 19:26:19 +0200
Message-Id: <1253294779.10538.39.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-18 at 10:22 -0700, David Miller wrote:
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Fri, 18 Sep 2009 14:31:36 +0200
> 
> > Ingo just reminded me that we might want to do splice support for perf
> > stuff. My plan was to have the splice thing allocate a new page, flip
> > with a filled one from the buffer and send the filled one down to the
> > splice consumer.
> > 
> > Now having vmap'ed all that complicates stuff enourmously.
> > 
> > Would it also work if we use order-1 pages on your platform instead of
> > order-0, so that they are properly aligned for the d-cache?
> 
> You still have to make sure the order-1 page is order-1 virtually
> aligned in userspace.  But that would help only sparc64 because
> SHMLBA happens to be 16K (2 * smallest supported PAGE_SIZE).
> 
> So, this won't handle sparc32 where the SHMLBA is 4MB.
> 
> MIPS has the same exact problems and has a large SHMLBA too.

Ah, ok, vmalloc it is then. I'll have to come up with another scheme for
splice() then.

Thanks!

