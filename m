Return-Path: <linux-kernel-owner+w=401wt.eu-S1755955AbXHSTcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755955AbXHSTcZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 15:32:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752487AbXHSTcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 15:32:14 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56296
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752193AbXHSTcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 15:32:13 -0400
Date: Sun, 19 Aug 2007 12:32:12 -0700 (PDT)
Message-Id: <20070819.123212.13769462.davem@davemloft.net>
To: felix@chelsio.com
Cc: sean.hefty@intel.com, netdev@vger.kernel.org, rdreier@cisco.com,
       general@lists.openfabrics.org, linux-kernel@vger.kernel.org,
       jeff@garzik.org
Subject: Re: [ofa-general] Re: [PATCH RFC] RDMA/CMA: Allocate
 PS_TCPportsfrom the host TCP port space.
From: David Miller <davem@davemloft.net>
In-Reply-To: <8A71B368A89016469F72CD08050AD334018E208F@maui.asicdesigners.com>
References: <000001c7e22e$b7b90f00$29c8180a@amr.corp.intel.com>
	<20070819.002337.06589160.davem@davemloft.net>
	<8A71B368A89016469F72CD08050AD334018E208F@maui.asicdesigners.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Felix Marti" <felix@chelsio.com>
Date: Sun, 19 Aug 2007 10:33:31 -0700

> I know that you don't agree that TSO has drawbacks, as outlined by
> Roland, but its history showing something else: the addition of TSO
> took a fair amount of time and network performance was erratic for
> multiple kernel revisions and the TSO code is sprinkled across the
> network stack.

This thing you call "sprinkled" is a necessity of any hardware
offload when it is possible for a packet to later get "steered"
to a device which cannot perform the offload.

Therefore we need a software implementation of TSO so that those
packets can still get output to the non-TSO-capable device.

We do the same thing for checksum offloading.

And for free we can use the software offloading mechanism to
get batching to arbitrary network devices, even those which cannot
do TSO.

What benefits does RDMA infrastructure give to non-RDMA capable
devices?  None?  I see, that's great.

And again the TSO bugs and issues are being overstated and, also for
the second time, these issues are more indicative of my bad
programming skills then they are of intrinsic issues of TSO.  The
TSO implementation was looking for a good design, and it took me
a while to find it because I personally suck.

Face it, stateless offloads are always going to be better in the long
term.  And this is proven.

You RDMA folks really do live in some kind of fantasy land.
