Return-Path: <linux-kernel-owner+w=401wt.eu-S1753888AbYGYTde@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888AbYGYTde (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 15:33:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751357AbYGYTdW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 15:33:22 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:46812 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319AbYGYTdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 15:33:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=FkrNNACLKc6gYzEhpXcyWDQHt6u/+dj+S/k5ME5lGxVEnXmMDoFJ3w8ts7JYQuAuw0
         4AJss1QruMoj5YKa2rU+7wUPyZD3Rm9crR8dZ8EYrOSK4TUyz13ljj8kDsmnDtRns0tZ
         F6BOISMGoTLi9Ty0r0byONXy0lGiFFGc/hAr8=
Date: Fri, 25 Jul 2008 21:34:16 +0200
From: Jarek Poplawski <jarkao2@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Ingo Oeser <netdev@axxeo.de>, David Miller <davem@davemloft.net>,
       peterz@infradead.org, Larry.Finger@lwfinger.net, kaber@trash.net,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, mingo@redhat.com
Subject: Re: Kernel WARNING: at net/core/dev.c:1330
	__netif_schedule+0x2c/0x98()
Message-ID: <20080725193416.GB3107@ami.dom.local>
References: <1216806614.7257.152.camel@twins> <1216810696.7257.175.camel@twins> <20080723.131441.200166513.davem@davemloft.net> <200807251904.37302.netdev@axxeo.de> <20080725183622.GA3107@ami.dom.local> <1217013384.4758.5.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217013384.4758.5.camel@johannes.berg>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2008 at 09:16:24PM +0200, Johannes Berg wrote:
> On Fri, 2008-07-25 at 20:36 +0200, Jarek Poplawski wrote:
> > On Fri, Jul 25, 2008 at 07:04:36PM +0200, Ingo Oeser wrote:
> > ...
> > > I'm sure as hell, I miss sth. but can't it be done by this pseudo-code:
> > 
> > ...And I really doubt it can't be done like this.
> 
> Umm, of course it cannot, because then we'd have to take the mutex in
> the TX path, which we cannot. We cannot have another lock in the TX
> path, what's so hard to understand about? We need to be able to lock all
> queues to lock out multiple tx paths at once in some (really) slow paths
> but not have any extra lock overhead for the tx path, especially not a
> single lock.

But this mutex doesn't have to be mutex. And it's not for the tx path,
only for "service" just like netif_tx_lock(). The fast path needs only
queue->tx_lock.

Jarek P.
