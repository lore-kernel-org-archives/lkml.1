Return-Path: <linux-kernel-owner+w=401wt.eu-S1761798AbYBSWyo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761798AbYBSWyo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 17:54:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754004AbYBSWyh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 17:54:37 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54215
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753649AbYBSWyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 17:54:36 -0500
Date: Tue, 19 Feb 2008 14:55:12 -0800 (PST)
Message-Id: <20080219.145512.142721224.davem@davemloft.net>
To: Yinghai.Lu@Sun.COM
Cc: mingo@elte.hu, greg@kroah.com, akpm@linux-foundation.org, jeff@garzik.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/8] net: use numa_node in net_devcice->dev instead of
 parent
From: David Miller <davem@davemloft.net>
In-Reply-To: <200802191142.48891.yinghai.lu@sun.com>
References: <20080219112146.GC7204@elte.hu>
	<20080219.034110.191579889.davem@davemloft.net>
	<200802191142.48891.yinghai.lu@sun.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Date: Tue, 19 Feb 2008 11:42:48 -0800

> On Tuesday 19 February 2008 03:41:10 am David Miller wrote:
> > From: Ingo Molnar <mingo@elte.hu>
> > Date: Tue, 19 Feb 2008 12:21:46 +0100
> > 
> > > 
> > > * Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:
> > > 
> > > >  struct sk_buff *__netdev_alloc_skb(struct net_device *dev,
> > > >  		unsigned int length, gfp_t gfp_mask)
> > > >  {
> > > > -	int node = dev->dev.parent ? dev_to_node(dev->dev.parent) : -1;
> > > > +	int node = dev_to_node(&dev->dev);
> > > 
> > > i think this is a fix for the networking folks. (Dave Cc:-ed)
> > 
> > It keeps getting NAK's because it's wrong.
> > 
> > The author of the patch hasn't convinced folks why this is really
> > necessary, and using the net_device embedded device struct is
> > definitely wrong here.  It doesn't contain the NUMA node information,
> > the physical device does, and that is what the parent it.
> 
> can you check the 5/8?
> that will make sure every struct device get numa_node get assigned.

Why do we need to bother with that if the parent will have the
necessary information for us here?
