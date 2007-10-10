Return-Path: <linux-kernel-owner+w=401wt.eu-S1757225AbXJJXFG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757225AbXJJXFG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 19:05:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756723AbXJJXEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 19:04:53 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:32939
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756707AbXJJXEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 19:04:52 -0400
Date: Wed, 10 Oct 2007 16:04:54 -0700 (PDT)
Message-Id: <20071010.160454.25158026.davem@davemloft.net>
To: mshefty@ichips.intel.com
Cc: swise@opengridcomputing.com, rdreier@cisco.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: Re: [ofa-general] Re: [PATCH RFC] RDMA/CMA: Allocate PS_TCP ports
 from the host TCP port space.
From: David Miller <davem@davemloft.net>
In-Reply-To: <470D3D93.2020606@ichips.intel.com>
References: <20070809.145534.102938208.davem@davemloft.net>
	<470AA729.2050009@opengridcomputing.com>
	<470D3D93.2020606@ichips.intel.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sean Hefty <mshefty@ichips.intel.com>
Date: Wed, 10 Oct 2007 14:01:07 -0700

> > The hack to use a socket and bind it to claim the port was just for 
> > demostrating the idea.  The correct solution, IMO, is to enhance the 
> > core low level 4-tuple allocation services to be more generic (eg: not 
> > be tied to a struct sock).  Then the host tcp stack and the host rdma 
> > stack can allocate TCP/iWARP ports/4tuples from this common exported 
> > service and share the port space.  This allocation service could also be 
> > used by other deep adapters like iscsi adapters if needed.
> 
> Since iWarp runs on top of TCP, the port space is really the same. 
> FWIW, I agree that this proposal is the correct solution to support iWarp.

But you can be sure it's not going to happen, sorry.

It would mean that we'd need to export the entire TCP socket table so
then when iWARP connections are created you can search to make sure
there is not an existing full 4-tuple that is the same.

It is not just about local TCP ports.

iWARP needs to live in it's seperate little container and not
contaminate the rest of the networking, this is the deal.  Any
suggested such change which breaks that deal will be NACK'd by all of
the core networking developers.
