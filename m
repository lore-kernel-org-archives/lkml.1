Return-Path: <linux-kernel-owner+w=401wt.eu-S1758209AbXGDQyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758209AbXGDQyT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 12:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753620AbXGDQyE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 12:54:04 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:40941 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754552AbXGDQyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 12:54:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mFg0FMTsR8f8i5+gXGsyL5bs12YHou1epUQafBuAASMa8+JvA+YFmdNPIYsA/bFYg4AheH50YypAUXmUusP+YebCafcVkTDHWD3g5oXe3tY+WTyO/Qf7nz2CqtXN3XKBFq5hQLDu1WgMC2GOP0YPN7ml0ZuDfNqpwS3e1L/N3+M=
Message-ID: <86802c440707040954w409c50b5qf9016db7f567479e@mail.gmail.com>
Date: Wed, 4 Jul 2007 09:54:00 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: [PATCH 2/4] net: use numa_node in net_devcice->dev instead of parent
Cc: hch@infradead.org, shemminger@linux-foundation.org,
       akpm@linux-foundation.org, ak@suse.de, greg@kroah.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <20070704.033530.105423846.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070703143407.7e4232f8@freepuppy.localdomain.hemminger.net>
	 <200707031730.51677.yinghai.lu@sun.com>
	 <20070704085120.GB19515@infradead.org>
	 <20070704.033530.105423846.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/4/07, David Miller <davem@davemloft.net> wrote:
> From: Christoph Hellwig <hch@infradead.org>
> Date: Wed, 4 Jul 2007 09:51:20 +0100
>
> > On Tue, Jul 03, 2007 at 05:30:51PM -0700, Yinghai Lu wrote:
> > > [PATCH 2/4] net: use numa_node in net_devcice->dev instead of parent
> > >
> > > Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
> > > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > > index 27cfe5f..005cc1c 100644
> > > --- a/net/core/skbuff.c
> > > +++ b/net/core/skbuff.c
> > > @@ -217,7 +217,7 @@ nodata:
> > >  struct sk_buff *__netdev_alloc_skb(struct net_device *dev,
> > >             unsigned int length, gfp_t gfp_mask)
> > >  {
> > > -   int node = dev->dev.parent ? dev_to_node(dev->dev.parent) : -1;
> > > +   int node = dev_to_node(&dev->dev);
> >
> > This looks wrong to me unless the device model has once again changed
> > silently.  When I wrote this code &dev->dev was a device allocated
> > as part of the netdevice and the parent is the pci (or whatever) device
> > that has the node information.
>
> Correct, this change is completely bogus.
> -

please check that with

http://lkml.org/lkml/2007/7/3/419

[PATCH 1/4] try parent numa_node at first before using default

YH
