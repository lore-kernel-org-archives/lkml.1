Return-Path: <linux-kernel-owner+w=401wt.eu-S1757141AbZIRRWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757141AbZIRRWR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 13:22:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756246AbZIRRWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 13:22:17 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53889
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756449AbZIRRWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 13:22:16 -0400
Date: Fri, 18 Sep 2009 10:22:34 -0700 (PDT)
Message-Id: <20090918.102234.175792545.davem@davemloft.net>
To: a.p.zijlstra@chello.nl
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, jens.axboe@oracle.com
Subject: Re: [PATCH 0/2]: Get perf counters working on D-cache aliasing
 cpus.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1253277096.8439.127.camel@twins>
References: <20090908.051045.26522683.davem@davemloft.net>
	<1253277096.8439.127.camel@twins>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Fri, 18 Sep 2009 14:31:36 +0200

> Ingo just reminded me that we might want to do splice support for perf
> stuff. My plan was to have the splice thing allocate a new page, flip
> with a filled one from the buffer and send the filled one down to the
> splice consumer.
> 
> Now having vmap'ed all that complicates stuff enourmously.
> 
> Would it also work if we use order-1 pages on your platform instead of
> order-0, so that they are properly aligned for the d-cache?

You still have to make sure the order-1 page is order-1 virtually
aligned in userspace.  But that would help only sparc64 because
SHMLBA happens to be 16K (2 * smallest supported PAGE_SIZE).

So, this won't handle sparc32 where the SHMLBA is 4MB.

MIPS has the same exact problems and has a large SHMLBA too.
