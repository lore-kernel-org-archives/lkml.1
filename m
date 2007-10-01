Return-Path: <linux-kernel-owner+w=401wt.eu-S1756821AbXJAU5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756821AbXJAU5U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 16:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753332AbXJAU5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 16:57:11 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54561
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752628AbXJAU5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 16:57:10 -0400
Date: Mon, 01 Oct 2007 13:57:10 -0700 (PDT)
Message-Id: <20071001.135710.99174896.davem@davemloft.net>
To: dada1@cosmosbay.com
Cc: nuclearcat@nuclearcat.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: 2.6.21 -> 2.6.22 & 2.6.23-rc8 performance regression
From: David Miller <davem@davemloft.net>
In-Reply-To: <4701541B.70108@cosmosbay.com>
References: <20070930223503.M8966@nuclearcat.com>
	<47008CB0.7010808@cosmosbay.com>
	<4701541B.70108@cosmosbay.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <dada1@cosmosbay.com>
Date: Mon, 01 Oct 2007 22:10:03 +0200

> So maybe the following patch is necessary...
> 
> I believe IPV6 & DCCP are immune to this problem.
> 
> Thanks again Denys for spotting this.
> 
> Eric
> 
> [PATCH] TCP : secure_tcp_sequence_number() should not use a too fast clock
> 
> TCP V4 sequence numbers are 32bits, and RFC 793 assumed a 250 KHz clock.
> In order to follow network speed increase, we can use a faster clock, but
> we should limit this clock so that the delay between two rollovers is
> greater than MSL (TCP Maximum Segment Lifetime : 2 minutes)
> 
> Choosing a 64 nsec clock should be OK, since the rollovers occur every
> 274 seconds.
> 
> Problem spotted by Denys Fedoryshchenko
> 
> Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>

Thanks a lot Eric for bringing closure to this.

I'll apply this and add a reference in the commit message to the
changeset that introduced this problem, since it might help
others who look at this.
