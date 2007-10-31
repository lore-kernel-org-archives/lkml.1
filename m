Return-Path: <linux-kernel-owner+w=401wt.eu-S1758251AbXJaMQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758251AbXJaMQv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 08:16:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754473AbXJaMQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 08:16:41 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:37147 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754956AbXJaMQk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 08:16:40 -0400
Message-ID: <47287220.8050804@garzik.org>
Date: Wed, 31 Oct 2007 08:16:32 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Nick Piggin <nickpiggin@yahoo.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, netdev@vger.kernel.org, trond.myklebust@fys.uio.no
Subject: Re: [PATCH 00/33] Swap over NFS -v14
References: <20071030160401.296770000@chello.nl>	 <200710311426.33223.nickpiggin@yahoo.com.au> <1193830033.27652.159.camel@twins>
In-Reply-To: <1193830033.27652.159.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thoughts:

1) I absolutely agree that NFS is far more prominent and useful than any 
network block device, at the present time.


2) Nonetheless, swap over NFS is a pretty rare case.  I view this work 
as interesting, but I really don't see a huge need, for swapping over 
NBD or swapping over NFS.  I tend to think swapping to a remote resource 
starts to approach "migration" rather than merely swapping.  Yes, we can 
do it...  but given the lack of burning need one must examine the price.


3) You note
> Swap over network has the problem that the network subsystem does not use fixed
> sized allocations, but heavily relies on kmalloc(). This makes mempools
> unusable.

True, but IMO there are mitigating factors that should be researched and 
taken into account:

a) To give you some net driver background/history, most mainstream net 
drivers were coded to allocate RX skbs of size 1538, under the theory 
that they would all be allocating out of the same underlying slab cache. 
  It would not be difficult to update a great many of the [non-jumbo] 
cases to create a fixed size allocation pattern.

b) Spare-time experiments and anecdotal evidence points to RX and TX skb 
recycling as a potentially valuable area of research.  If you are able 
to do something like that, then memory suddenly becomes a lot more 
bounded and predictable.


So my gut feeling is that taking a hard look at how net drivers function 
in the field should give you a lot of good ideas that approach the 
shared goal of making network memory allocations more predictable and 
bounded.

	Jeff


