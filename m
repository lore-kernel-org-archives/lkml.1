Return-Path: <linux-kernel-owner+w=401wt.eu-S1766588AbXEDTmm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766588AbXEDTmm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 15:42:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161919AbXEDTml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 15:42:41 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45673
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1161914AbXEDTmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 15:42:39 -0400
Date: Fri, 04 May 2007 12:42:25 -0700 (PDT)
Message-Id: <20070504.124225.111205875.davem@davemloft.net>
To: dhowells@redhat.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] AF_RXRPC: Sort out MTU handling
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070504145647.19125.99441.stgit@warthog.cambridge.redhat.com>
References: <20070504145647.19125.99441.stgit@warthog.cambridge.redhat.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>
Date: Fri, 04 May 2007 15:56:47 +0100

> Sort out the MTU determination and handling in AF_RXRPC:
> 
>  (1) If it's present, parse the additional information supplied by the peer at
>      the end of the ACK packet (struct ackinfo) to determine the MTU sizes
>      that peer is willing to support.
> 
>  (2) Initialise the MTU size to that peer from the kernel's routing records.
> 
>  (3) Send ACKs rather than ACKALLs as the former carry the additional info,
>      and the latter do not.
> 
>  (4) Declare the interface MTU size in outgoing ACKs as a maximum amount of
>      data that can be stuffed into an RxRPC packet without it having to be
>      fragmented to come in this computer's NIC.
> 
>  (5) If sendmsg() is given MSG_MORE then it should allocate an skb of the
>      maximum size rather than one just big enough for the data it's got left
>      to process on the theory that there is more data to come that it can
>      append to that packet.
> 
>      This means, for example, that if AFS does a large StoreData op, all the
>      packets barring the last will be filled to the maximum unfragmented size.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>

Applied, thanks.

