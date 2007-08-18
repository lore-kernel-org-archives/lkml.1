Return-Path: <linux-kernel-owner+w=401wt.eu-S1760878AbXHRAAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760878AbXHRAAo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 20:00:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753901AbXHRAAf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 20:00:35 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43242
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753091AbXHRAAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 20:00:34 -0400
Date: Fri, 17 Aug 2007 17:00:33 -0700 (PDT)
Message-Id: <20070817.170033.63993876.davem@davemloft.net>
To: rdreier@cisco.com
Cc: tom@opengridcomputing.com, jeff@garzik.org, swise@opengridcomputing.com,
       mshefty@ichips.intel.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: Re: [ofa-general] Re: [PATCH RFC] RDMA/CMA: Allocate PS_TCP ports
 from the host TCP port space.
From: David Miller <davem@davemloft.net>
In-Reply-To: <adafy2hyc04.fsf@cisco.com>
References: <adaodh6x7js.fsf@cisco.com>
	<20070817.142756.65194845.davem@davemloft.net>
	<adafy2hyc04.fsf@cisco.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roland Dreier <rdreier@cisco.com>
Date: Fri, 17 Aug 2007 16:31:07 -0700

>  > >  > When using RDMA you lose the capability to do packet shaping,
>  > >  > classification, and all the other wonderful networking facilities
>  > >  > you've grown to love and use over the years.
>  > > 
>  > > Same thing with TSO and LRO and who knows what else.
>  > 
>  > Not true at all.  Full classification and filtering still is usable
>  > with TSO and LRO.
> 
> Well, obviously with TSO and LRO the packets that the stack sends or
> receives are not the same as what's on the wire.  Whether that breaks
> your wonderful networking facilities or not depends on the specifics
> of the particular facility I guess -- for example shaping is clearly
> broken by TSO.  (And people can wonder what the packet trains TSO
> creates do to congestion control on the internet, but the netdev crowd
> has already decided that TSO is "good" and RDMA is "bad")

This is also a series of falsehoods.  All packet filtering,
queue management, and packet scheduling facilities work perfectly
fine and as designed with both LRO and TSO.

When problems come up, they are bugs, and we fix them.

Please stop spreading this FUD about TSO and LRO.

The fact is that RDMA bypasses the whole stack so that supporting
these facilities is not even _POSSIBLE_.  With stateless offloads it
is possible to support all of these facilities, and we do.
