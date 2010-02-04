Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758135Ab0BDMr3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 07:47:29 -0500
Received: from ixro-out-rtc.ixiacom.com ([92.87.192.98]:16710 "EHLO
	ixro-ex1.ixiacom.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758081Ab0BDMr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 07:47:26 -0500
From: Octavian Purdila <opurdila@ixiacom.com>
Organization: Ixia
To: Cong Wang <amwang@redhat.com>
Subject: Re: [RFC Patch] net: reserve ports for applications using fixed port numbers
Date: Thu, 4 Feb 2010 14:44:01 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.32-trunk-686; KDE/4.3.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
       linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
       Neil Horman <nhorman@tuxdriver.com>, linux-sctp@vger.kernel.org,
       David Miller <davem@davemloft.net>
References: <20100203043332.3817.27932.sendpatchset@localhost.localdomain> <201002031312.48531.opurdila@ixiacom.com> <4B6A3DBA.1000706@redhat.com>
In-Reply-To: <4B6A3DBA.1000706@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201002041444.01897.opurdila@ixiacom.com>
X-OriginalArrivalTime: 04 Feb 2010 12:47:24.0978 (UTC) FILETIME=[336B9120:01CAA598]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 February 2010 05:23:38 you wrote:

> > I think it might be useful to allow setting individual ports as reserved,
> > not only ranges, for example by using a bitmap.
> 
> This is a good idea, but I am not sure if this will be overkill? :-/
> Also, using bitmap is not friendly to sysctl interface, I am afraid.
> 

My concern is that we can have multiple applications that require a fixed port 
and if those ports are significantly apart we will decrease the port range 
available for connect. And that will hurt the rate of which new connections 
can be opened.

As for the sysctl interface I agree, I don't think it is even possible to  
cleanly use a bitmap through sysctl.

The options I see are either enhance sysctl to support bitmaps or use a 
dedicated /proc/net entry. 

I want to give this a try, which one do you people think is better?
