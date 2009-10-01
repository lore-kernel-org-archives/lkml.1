Return-Path: <linux-kernel-owner+w=401wt.eu-S1753623AbZJAW1A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753623AbZJAW1A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 18:27:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753479AbZJAW07
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 18:26:59 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60985
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753467AbZJAW07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 18:26:59 -0400
Date: Thu, 01 Oct 2009 15:27:17 -0700 (PDT)
Message-Id: <20091001.152717.187318570.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: eric.dumazet@gmail.com, jgunthorpe@obsidianresearch.com, vl@samba.org,
       opurdila@ixiacom.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Subject: Re: SPLICE_F_NONBLOCK semantics...
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.2.01.0910011516390.6996@localhost.localdomain>
References: <20091001.151102.09812927.davem@davemloft.net>
	<alpine.LFD.2.01.0910011516390.6996@localhost.localdomain>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 1 Oct 2009 15:21:44 -0700 (PDT)

> On Thu, 1 Oct 2009, David Miller wrote:
>> 
>> It depends upon our interpretation of how you intended the
>> SPLICE_F_NONBLOCK flag to work when you added it way back
>> when.
>> 
>> Linus introduced  SPLICE_F_NONBLOCK in commit 29e350944fdc2dfca102500790d8ad6d6ff4f69d
>> (splice: add SPLICE_F_NONBLOCK flag )
>> 
>>   It doesn't make the splice itself necessarily nonblocking (because the
>>   actual file descriptors that are spliced from/to may block unless they
>>   have the O_NONBLOCK flag set), but it makes the splice pipe operations
>>   nonblocking.
>> 
>> Linus intention was clear : let SPLICE_F_NONBLOCK control the splice pipe mode only
> 
> Ack. The original intent was for the flag to affect the buffering, not the 
> end points.

Great, thanks for reviewing.

> Although the more I think about it, the more I suspect that the
> whole NONBLOCK thing should probably have been two bits, and simply
> been about "nonblocking input" vs "nonblocking output" (so that you
> could control both sides on a call-by-call basis).

I think we could still extend things in this way if we wanted to.
So if you specify the explicit input and/or output nonblock flag,
it takes precedence over the SPLICE_F_NONBLOCK thing.

Anyways, just an idea.
