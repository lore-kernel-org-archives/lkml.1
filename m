Return-Path: <linux-kernel-owner+w=401wt.eu-S934908AbYBHBWZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934908AbYBHBWZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 20:22:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759018AbYBHBWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 20:22:16 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43831
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758917AbYBHBWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 20:22:15 -0500
Date: Thu, 07 Feb 2008 17:22:46 -0800 (PST)
Message-Id: <20080207.172246.31415231.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: mingo@elte.hu, jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       Alan.Brunelle@hp.com, arjan@linux.intel.com, dgc@sgi.com,
       npiggin@suse.de, akpm@linux-foundation.org, vegard.nossum@gmail.com,
       penberg@gmail.com
Subject: Re: [patch] block layer: kmemcheck fixes
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.1.00.0802070940230.2883@woody.linux-foundation.org>
References: <20080207103136.GG15220@kernel.dk>
	<20080207104901.GF16735@elte.hu>
	<alpine.LFD.1.00.0802070940230.2883@woody.linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 7 Feb 2008 09:42:56 -0800 (PST)

> Can we please just stop doing these one-by-one assignments, and just do 
> something like
> 
> 	memset(rq, 0, sizeof(*rq));
> 	rq->q = q;
> 	rq->ref_count = 1;
> 	INIT_HLIST_NODE(&rq->hash);
> 	RB_CLEAR_NODE(&rq->rb_node);
> 
> instead?
> 
> The memset() is likely faster and smaller than one-by-one assignments 
> anyway, even if the one-by-ones can avoid initializing some field or there 
> ends up being a double initialization..

The problem is store buffer compression.  At least a few years
ago this made a huge difference in sk_buff initialization in the
networking.

Maybe cpus these days have so much store bandwith that doing
things like the above is OK, but I doubt it :-)
