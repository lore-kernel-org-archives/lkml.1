Return-Path: <linux-kernel-owner+w=401wt.eu-S1758232AbYBSLkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758232AbYBSLkz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 06:40:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752958AbYBSLko
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 06:40:44 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53914
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752211AbYBSLkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 06:40:37 -0500
Date: Tue, 19 Feb 2008 03:41:10 -0800 (PST)
Message-Id: <20080219.034110.191579889.davem@davemloft.net>
To: mingo@elte.hu
Cc: Yinghai.Lu@Sun.COM, greg@kroah.com, akpm@linux-foundation.org,
       jeff@garzik.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/8] net: use numa_node in net_devcice->dev instead of
 parent
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080219112146.GC7204@elte.hu>
References: <200802190311.44404.yinghai.lu@sun.com>
	<200802190320.58561.yinghai.lu@sun.com>
	<20080219112146.GC7204@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Tue, 19 Feb 2008 12:21:46 +0100

> 
> * Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:
> 
> >  struct sk_buff *__netdev_alloc_skb(struct net_device *dev,
> >  		unsigned int length, gfp_t gfp_mask)
> >  {
> > -	int node = dev->dev.parent ? dev_to_node(dev->dev.parent) : -1;
> > +	int node = dev_to_node(&dev->dev);
> 
> i think this is a fix for the networking folks. (Dave Cc:-ed)

It keeps getting NAK's because it's wrong.

The author of the patch hasn't convinced folks why this is really
necessary, and using the net_device embedded device struct is
definitely wrong here.  It doesn't contain the NUMA node information,
the physical device does, and that is what the parent it.
