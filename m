Return-Path: <linux-kernel-owner+w=401wt.eu-S1758897AbYBTHwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758897AbYBTHwZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 02:52:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752440AbYBTHwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 02:52:18 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:42461 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370AbYBTHwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 02:52:17 -0500
Date: Tue, 19 Feb 2008 23:50:35 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: Re: [PATCH] mm: fix dma_poor_create
In-reply-to: <20080220065230.GG7493@elte.hu>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>
Message-id: <200802192350.36247.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200802191845.28802.yinghai.lu@sun.com>
 <20080220065230.GG7493@elte.hu>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 February 2008 10:52:30 pm Ingo Molnar wrote:
> 
> * Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:
> 
> > dev_to_node could return node that without RAM. So check it before use 
> > it in kmalloc_node
> 
> > -	retval = kmalloc_node(sizeof(*retval), GFP_KERNEL, dev_to_node(dev));
> > +	node = dev_to_node(dev);
> > +	if (node == -1 || !node_online(node))
> > +		node = numa_node_id();
> > +
> > +	retval = kmalloc_node(sizeof(*retval), GFP_KERNEL, node);
> 
> so this is about not crashing during bootup on nodes that have CPUs but 
> which have no node-specific memory attached, right?
> 
> Shouldnt kmalloc_node() be made more robust instead? I.e. push the same 
> code into kmalloc_node() - and make sure it will allocate _something_? 
> That would probably also fix a similar bug in net/core/skbuff.c's 
> __netdev_alloc_skb(), which too passes a dev_to_node() result to an 
> allocator.

sound good idea to update the dev_to_node to make sure it will return -1 or the one is online.

Will send updated one.

YH
