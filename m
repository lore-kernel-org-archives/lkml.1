Return-Path: <linux-kernel-owner+w=401wt.eu-S1757872AbYHAG4r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757872AbYHAG4r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 02:56:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753397AbYHAG4e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 02:56:34 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:62704 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235AbYHAG4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 02:56:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=GPtkwpsfEewdONO05kka4cZq7o9S639RVYXYl8z5Nc8BTKKQ4o1xIEoVE7/lLEnnVx
         9Rz8qldFl+0u/zOy892u0eqzdcWE3QVM/xKHIVDph+P+S8kx2VMbQnLnR+SX6TI8wOYu
         qvEjvCo89oXdIsHLIr+zKLeKBuPYzQ8tvHJWY=
Date: Fri, 1 Aug 2008 07:01:50 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: johannes@sipsolutions.net, netdev@axxeo.de, peterz@infradead.org,
       Larry.Finger@lwfinger.net, kaber@trash.net,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, mingo@redhat.com
Subject: Re: Kernel WARNING: at net/core/dev.c:1330
	__netif_schedule+0x2c/0x98()
Message-ID: <20080801070150.GB4435@ff.dom.local>
References: <20080726131838.GA2873@ami.dom.local> <20080726.173434.48036095.davem@davemloft.net> <20080727203757.GA2527@ami.dom.local> <20080731.052932.110299354.davem@davemloft.net> <20080801064810.GA4435@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080801064810.GA4435@ff.dom.local>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2008 at 06:48:10AM +0000, Jarek Poplawski wrote:
> On Thu, Jul 31, 2008 at 05:29:32AM -0700, David Miller wrote:
...
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index 63d6bcd..69320a5 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -4200,6 +4200,7 @@ static void netdev_init_queues(struct net_device *dev)
> >  {
> >  	netdev_init_one_queue(dev, &dev->rx_queue, NULL);
> >  	netdev_for_each_tx_queue(dev, netdev_init_one_queue, NULL);
> > +	spin_lock_init(&dev->tx_global_lock);
> 
> This will probably need some lockdep annotations similar to
> _xmit_lock.

...BTW, we probably could also consider some optimization here: the
xmit_lock of the first queue could be treated as special, and only
the owner could do such a freezing. This would save changes of
functionality to non mq devices. On the other hand, it would need
remembering about this special treatment (so, eg. a separate lockdep
initialization than all the others).

Jarek P.
