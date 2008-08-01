Return-Path: <linux-kernel-owner+w=401wt.eu-S1758060AbYHAHB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758060AbYHAHB6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 03:01:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753755AbYHAHBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 03:01:47 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42968
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753325AbYHAHBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 03:01:46 -0400
Date: Fri, 01 Aug 2008 00:01:46 -0700 (PDT)
Message-Id: <20080801.000146.246099981.davem@davemloft.net>
To: jarkao2@gmail.com
Cc: johannes@sipsolutions.net, netdev@axxeo.de, peterz@infradead.org,
       Larry.Finger@lwfinger.net, kaber@trash.net,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, mingo@redhat.com
Subject: Re: Kernel WARNING: at net/core/dev.c:1330
 __netif_schedule+0x2c/0x98()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080801070150.GB4435@ff.dom.local>
References: <20080731.052932.110299354.davem@davemloft.net>
	<20080801064810.GA4435@ff.dom.local>
	<20080801070150.GB4435@ff.dom.local>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jarek Poplawski <jarkao2@gmail.com>
Date: Fri, 1 Aug 2008 07:01:50 +0000

> On Fri, Aug 01, 2008 at 06:48:10AM +0000, Jarek Poplawski wrote:
> > On Thu, Jul 31, 2008 at 05:29:32AM -0700, David Miller wrote:
> ...
> > > diff --git a/net/core/dev.c b/net/core/dev.c
> > > index 63d6bcd..69320a5 100644
> > > --- a/net/core/dev.c
> > > +++ b/net/core/dev.c
> > > @@ -4200,6 +4200,7 @@ static void netdev_init_queues(struct net_device *dev)
> > >  {
> > >  	netdev_init_one_queue(dev, &dev->rx_queue, NULL);
> > >  	netdev_for_each_tx_queue(dev, netdev_init_one_queue, NULL);
> > > +	spin_lock_init(&dev->tx_global_lock);
> > 
> > This will probably need some lockdep annotations similar to
> > _xmit_lock.
> 
> ...BTW, we probably could also consider some optimization here: the
> xmit_lock of the first queue could be treated as special, and only
> the owner could do such a freezing. This would save changes of
> functionality to non mq devices. On the other hand, it would need
> remembering about this special treatment (so, eg. a separate lockdep
> initialization than all the others).

I think special casing the zero's queue's lock is a bad idea.
Having a real top-level synchronizer is a powerful tool and
we could use it for other things.
