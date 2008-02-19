Return-Path: <linux-kernel-owner+w=401wt.eu-S1757296AbYBSTV7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757296AbYBSTV7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 14:21:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754441AbYBSTVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 14:21:51 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:52578 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754375AbYBSTVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 14:21:50 -0500
Date: Tue, 19 Feb 2008 11:42:48 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: Re: [PATCH 6/8] net: use numa_node in net_devcice->dev instead of
 parent
In-reply-to: <20080219.034110.191579889.davem@davemloft.net>
To: David Miller <davem@davemloft.net>
Cc: mingo@elte.hu, greg@kroah.com, akpm@linux-foundation.org, jeff@garzik.org,
       linux-kernel@vger.kernel.org
Message-id: <200802191142.48891.yinghai.lu@sun.com>
Organization: SUN
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200802190311.44404.yinghai.lu@sun.com>
 <20080219112146.GC7204@elte.hu> <20080219.034110.191579889.davem@davemloft.net>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 February 2008 03:41:10 am David Miller wrote:
> From: Ingo Molnar <mingo@elte.hu>
> Date: Tue, 19 Feb 2008 12:21:46 +0100
> 
> > 
> > * Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:
> > 
> > >  struct sk_buff *__netdev_alloc_skb(struct net_device *dev,
> > >  		unsigned int length, gfp_t gfp_mask)
> > >  {
> > > -	int node = dev->dev.parent ? dev_to_node(dev->dev.parent) : -1;
> > > +	int node = dev_to_node(&dev->dev);
> > 
> > i think this is a fix for the networking folks. (Dave Cc:-ed)
> 
> It keeps getting NAK's because it's wrong.
> 
> The author of the patch hasn't convinced folks why this is really
> necessary, and using the net_device embedded device struct is
> definitely wrong here.  It doesn't contain the NUMA node information,
> the physical device does, and that is what the parent it.

can you check the 5/8?
that will make sure every struct device get numa_node get assigned.

YH
