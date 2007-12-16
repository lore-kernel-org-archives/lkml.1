Return-Path: <linux-kernel-owner+w=401wt.eu-S1764849AbXLPWac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764849AbXLPWac (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 17:30:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760904AbXLPWaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 17:30:22 -0500
Received: from mail.tmr.com ([64.65.253.246]:53381 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760599AbXLPWaV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 17:30:21 -0500
Message-ID: <4765AAFC.3040406@tmr.com>
Date: Sun, 16 Dec 2007 17:47:24 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: herbert@gondor.apana.org.au, simon@fire.lp0.eu,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: sockets affected by IPsec always block (2.6.23)
References: <4755A21F.2020407@simon.arlott.org.uk>	<20071205001230.GA11391@gondor.apana.org.au> <20071204.223023.262159049.davem@davemloft.net>
In-Reply-To: <20071204.223023.262159049.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Herbert Xu <herbert@gondor.apana.org.au>
> Date: Wed, 5 Dec 2007 11:12:32 +1100
> 
>> [INET]: Export non-blocking flags to proto connect call
>>
>> Previously we made connect(2) block on IPsec SA resolution.  This is
>> good in general but not desirable for non-blocking sockets.
>>
>> To fix this properly we'd need to implement the larval IPsec dst stuff
>> that we talked about.  For now let's just revert to the old behaviour
>> on non-blocking sockets.
>>
>> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> We made an explicit decision not to do things this way.
> 
> Non-blocking has a meaning dependant upon the xfrm_larval_drop sysctl
> setting, and this is across the board.  If xfrm_larval_drop is zero,
> non-blocking semantics do not extend to IPSEC route resolution,
> otherwise it does.
> 
> If he sets this sysctl to "1" as I detailed in my reply, he'll
> get the behavior he wants.
> 
I think you for the hint, but I would hardly call this sentence 
"detailed" in terms of being a cookbook solution to the problem.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
