Return-Path: <linux-kernel-owner+w=401wt.eu-S1759916AbXENKET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759916AbXENKET (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 06:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756054AbXENKEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 06:04:09 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41955
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755952AbXENKEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 06:04:07 -0400
Date: Mon, 14 May 2007 03:04:12 -0700 (PDT)
Message-Id: <20070514.030412.104035740.davem@davemloft.net>
To: djohnson+linux-kernel@sw.starentnetworks.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] improved locking performance in rt_run_flush()
From: David Miller <davem@davemloft.net>
In-Reply-To: <17989.60703.575698.491592@zeus.sw.starentnetworks.com>
References: <17989.60703.575698.491592@zeus.sw.starentnetworks.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Johnson <djohnson+linux-kernel@sw.starentnetworks.com>
Date: Sat, 12 May 2007 12:36:47 -0400

> 
> While testing adding/deleting large numbers of interfaces, I found
> rt_run_flush() was the #1 cpu user in a kernel profile by far.
> 
> The below patch changes rt_run_flush() to only take each spinlock
> protecting the rt_hash_table once instead of taking a spinlock for
> every hash table bucket (and ending up taking the same small set 
> of locks over and over).
> 
> Deleting 256 interfaces on a 4-way SMP system with 16K buckets reduced
> overall cpu-time more than 50% and reduced wall-time about 33%.  I
> suspect systems with large amounts of memory (and more buckets) will
> see an even greater benefit.
> 
> Note there is a small change in that rt_free() is called while the
> lock is held where before it was called without the lock held.  I
> don't think this should be an issue.
> 
> Signed-off-by: Dave Johnson <djohnson+linux-kernel@sw.starentnetworks.com>

Thanks for this patch.

I'm not ignoring it I'm just trying to brainstorm whether there
is a better way to resolve this inefficiency. :-)
