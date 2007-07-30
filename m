Return-Path: <linux-kernel-owner+w=401wt.eu-S968420AbXG3UDa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968420AbXG3UDa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 16:03:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966993AbXG3UDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 16:03:05 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:55768 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967738AbXG3UDE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 16:03:04 -0400
Message-ID: <46AE43F5.8070802@garzik.org>
Date: Mon, 30 Jul 2007 16:03:01 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Yoann Padioleau <padator@wanadoo.fr>
CC: kernel-janitors@vger.kernel.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dev->priv to netdev_priv(dev), drivers/net/tokenring/
References: <87r6mzmf6q.fsf@wanadoo.fr>
In-Reply-To: <87r6mzmf6q.fsf@wanadoo.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Yoann Padioleau wrote:
> Replacing accesses to dev->priv to netdev_priv(dev). The replacment
> is safe when netdev_priv is used to access a private structure that is
> right next to the net_device structure in memory. 
> Cf http://groups.google.com/group/comp.os.linux.development.system/browse_thread/thread/de19321bcd94dbb8/0d74a4adcd6177bd
> This is the case when the net_device structure was allocated with
> a call to alloc_netdev or one of its derivative.
> 
> Here is an excerpt of the semantic patch that performs the transformation
> 
> @ rule1 @
> type T;
> struct net_device *dev;
> @@
> 
>  dev = 
> (
>         alloc_netdev
> | 
>         alloc_etherdev
> |
>         alloc_trdev
> )
>    (sizeof(T), ...)
> 
> @ rule1bis @
> struct net_device *dev;
> expression E;
> @@
>  dev->priv = E
> 
> @ rule2 depends on rule1 && !rule1bis  @
> struct net_device *dev;
> type rule1.T;
> @@
> 
> - (T*) dev->priv
> + netdev_priv(dev)
> 
> 
> PS: I have performed the same transformation on the whole kernel
> and it affects around 70 files, most of them in drivers/net/.
> Should I split my patch for each subnet directories ? (wireless/, wan/, etc)

applied.  splitting up by sub-directory would be helpful.


