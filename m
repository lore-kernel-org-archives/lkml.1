Return-Path: <linux-kernel-owner+w=401wt.eu-S1754856AbYIWREX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856AbYIWREX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 13:04:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754734AbYIWREF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 13:04:05 -0400
Received: from zrtps0kn.nortel.com ([47.140.192.55]:60657 "EHLO
	zrtps0kn.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580AbYIWREB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 13:04:01 -0400
Message-ID: <48D92174.5010902@nortel.com>
Date: Tue, 23 Sep 2008 11:03:48 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       jens.axboe@oracle.com, steffen.klassert@secunet.com
Subject: Re: [PATCH 0/2]: Remote softirq invocation infrastructure.
References: <20080919.234824.223177211.davem@davemloft.net> <48D80C9C.2070108@nortel.com> <20080922.151233.229805934.davem@davemloft.net>
In-Reply-To: <20080922.151233.229805934.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Sep 2008 17:03:49.0793 (UTC) FILETIME=[595AC910:01C91D9E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: "Chris Friesen" <cfriesen@nortel.com>
> Date: Mon, 22 Sep 2008 15:22:36 -0600
> 
>> I'm not sure this belongs in this particular thread but I was
>> interested in how you're planning on doing this?
> 
> Something like this patch which I posted last week on
> netdev.

That patch basically just picks an arbitrary cpu for each flow.  This 
would spread the load out across cpus, but it doesn't allow any input 
from userspace.

We have a current application where there are 16 cores and 16 threads. 
They would really like to be able to pin one thread to each core and 
tell the kernel what packets they're interested in so that the kernel 
can process those packets on that core to gain the maximum caching 
benefit as well as reduce reordering issues.  In our case the hardware 
supports filtering for multiqueues, so we could pass this information 
down to the hardware to avoid software filtering.

Either way, it requires some way for userspace to indicate interest in a 
particular flow.  Has anyone given any thought to what an API like this 
would look like?

I suppose we could automatically look at bound network sockets owned by 
tasks that are affined to single cpus.  This would simplify userspace 
but would reduce flexibility for things like packet sockets with socket 
filters applied.

Chris
