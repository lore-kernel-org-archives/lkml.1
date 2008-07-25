Return-Path: <linux-kernel-owner+w=401wt.eu-S1754824AbYGYUAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824AbYGYUAn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 16:00:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751223AbYGYUAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 16:00:30 -0400
Received: from ik-out-1112.google.com ([66.249.90.180]:21965 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357AbYGYUA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 16:00:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=HSc7STkS4to6Iku2GKDOTTDRUBqUehCk4YeEHvwILP4fHhlz4wLRFcH6EbZEdMsmR3
         oC1S/I1y7KOarN+iitTkIB73yL6B8bfNvZd/7uyH7P4A/YPPekhB8IOAi7E+gOjmpe0O
         dwWc0NOL0n9ySqNytdQxI2QH9n2IoBrJAXLI4=
Date: Fri, 25 Jul 2008 22:01:37 +0200
From: Jarek Poplawski <jarkao2@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Ingo Oeser <netdev@axxeo.de>, David Miller <davem@davemloft.net>,
       peterz@infradead.org, Larry.Finger@lwfinger.net, kaber@trash.net,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, mingo@redhat.com
Subject: Re: Kernel WARNING: at net/core/dev.c:1330
	__netif_schedule+0x2c/0x98()
Message-ID: <20080725200137.GC3107@ami.dom.local>
References: <1216806614.7257.152.camel@twins> <1216810696.7257.175.camel@twins> <20080723.131441.200166513.davem@davemloft.net> <200807251904.37302.netdev@axxeo.de> <20080725183622.GA3107@ami.dom.local> <1217013384.4758.5.camel@johannes.berg> <20080725193416.GB3107@ami.dom.local> <1217014575.4758.7.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217014575.4758.7.camel@johannes.berg>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2008 at 09:36:15PM +0200, Johannes Berg wrote:
> On Fri, 2008-07-25 at 21:34 +0200, Jarek Poplawski wrote:
> 
> > > Umm, of course it cannot, because then we'd have to take the mutex in
> > > the TX path, which we cannot. We cannot have another lock in the TX
> > > path, what's so hard to understand about? We need to be able to lock all
> > > queues to lock out multiple tx paths at once in some (really) slow paths
> > > but not have any extra lock overhead for the tx path, especially not a
> > > single lock.
> > 
> > But this mutex doesn't have to be mutex. And it's not for the tx path,
> > only for "service" just like netif_tx_lock(). The fast path needs only
> > queue->tx_lock.
> 
> No, we need to be able to lock out multiple TX paths at once.

IMHO, it can do the same. We could e.g. insert a locked spinlock into
this noop_tx_handler(), to give everyone some waiting.

Jarek P.
