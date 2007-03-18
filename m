Return-Path: <linux-kernel-owner+w=401wt.eu-S932263AbXCRUYI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932263AbXCRUYI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 16:24:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933092AbXCRUYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 16:24:08 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:15546 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932223AbXCRUYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 16:24:04 -0400
Date: Sun, 18 Mar 2007 22:24:44 +0200
From: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
To: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org, general@lists.openfabrics.org,
       Roland Dreier <rolandd@cisco.com>
Subject: Re: dst_ifdown breaks infiniband?
Message-ID: <20070318202444.GC11078@mellanox.co.il>
Reply-To: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
References: <20070318155532.GG7958@mellanox.co.il>
	<20070318191238.GA20518@ms2.inr.ac.ru>
	<20070318194638.GA11078@mellanox.co.il>
	<20070318195558.GA27004@ms2.inr.ac.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070318195558.GA27004@ms2.inr.ac.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Quoting Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>:
> Subject: Re: dst_ifdown breaks infiniband?
> 
> Hello!
> 
> > Hmm. Something I don't understand: does the code
> > in question not run on *each* device unregister?
> 
> It does.
> 
> 
> > Why do I only see this under stress?
> 
> You should have some referenced destination entries to trigger bad path.
> This should happen not only under stress.
> 
> F.e. just try to ssh to something via this device. And unregister it.
> Seems, the crash is inevitable. If you do not see crash, I will be puzzled.


I did this.
What happens is:

	neigh_setup is called
	dst_ifdown changes the neigh->dev to loopback device

But the funny thing is that this neighbour can thinkably hang
around indefinitely now, and if it does destructor won't be called
and there won't be a crash.

To trigger a crash, I did simply
	ifconfig lo down; ifconfig lo 127.0.0.1

and sure enough it crashes in drivers/infiniband/ulp/ipoib/ipoib_main.c.

-- 
MST
