Return-Path: <linux-kernel-owner+w=401wt.eu-S1754967AbXJHVzE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967AbXJHVzE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 17:55:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753574AbXJHVyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 17:54:52 -0400
Received: from 209-198-142-2-host.prismnet.net ([209.198.142.2]:37310 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753294AbXJHVyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 17:54:50 -0400
Message-ID: <470AA729.2050009@opengridcomputing.com>
Date: Mon, 08 Oct 2007 16:54:49 -0500
From: Steve Wise <swise@opengridcomputing.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: mshefty@ichips.intel.com, rdreier@cisco.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: Re: [ofa-general] Re: [PATCH RFC] RDMA/CMA: Allocate PS_TCP ports
 from the host TCP port space.
References: <46B883B5.8040702@opengridcomputing.com>	<46BB61D0.4090101@opengridcomputing.com>	<46BB89C0.4040303@ichips.intel.com> <20070809.145534.102938208.davem@davemloft.net>
In-Reply-To: <20070809.145534.102938208.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



David Miller wrote:
> From: Sean Hefty <mshefty@ichips.intel.com>
> Date: Thu, 09 Aug 2007 14:40:16 -0700
> 
>> Steve Wise wrote:
>>> Any more comments?
>> Does anyone have ideas on how to reserve the port space without using a 
>> struct socket?
> 
> How about we just remove the RDMA stack altogether?  I am not at all
> kidding.  If you guys can't stay in your sand box and need to cause
> problems for the normal network stack, it's unacceptable.  We were
> told all along the if RDMA went into the tree none of this kind of
> stuff would be an issue.
> 
> These are exactly the kinds of problems for which people like myself
> were dreading.  These subsystems have no buisness using the TCP port
> space of the Linux software stack, absolutely none.
> 
> After TCP port reservation, what's next?  It seems an at least
> bi-monthly event that the RDMA folks need to put their fingers
> into something else in the normal networking stack.  No more.
> 
> I will NACK any patch that opens up sockets to eat up ports or
> anything stupid like that.

Hey Dave,

The hack to use a socket and bind it to claim the port was just for 
demostrating the idea.  The correct solution, IMO, is to enhance the 
core low level 4-tuple allocation services to be more generic (eg: not 
be tied to a struct sock).  Then the host tcp stack and the host rdma 
stack can allocate TCP/iWARP ports/4tuples from this common exported 
service and share the port space.  This allocation service could also be 
used by other deep adapters like iscsi adapters if needed.

Will you NAK such a solution if I go implement it and submit for review? 
  The dual ip subnet solution really sux, and I'm trying one more time 
to see if you will entertain the common port space solution, if done 
correctly.

Thanks,

Steve.
