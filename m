Return-Path: <linux-kernel-owner+w=401wt.eu-S1751875AbZGFP2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751875AbZGFP2S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 11:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751183AbZGFP2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 11:28:11 -0400
Received: from lvps87-230-0-242.dedicated.hosteurope.de ([87.230.0.242]:38933
	"EHLO lvps87-230-0-242.dedicated.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751118AbZGFP2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 11:28:10 -0400
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Message-Id: <11EC5046-5F30-4CB6-BDAF-0DAA2C69929B@it-loops.com>
From: Michael Guntsche <mike@it-loops.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
In-Reply-To: <20090706083119.GA17782@gondor.apana.org.au>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v935.3)
Subject: Re: BUG: scheduling while atomic
Date: Mon, 6 Jul 2009 17:28:06 +0200
References: <23AED400-6DA5-462F-94F0-BEE34AC08A7A@it-loops.com> <20090627140643.7140f6a9@lxorguk.ukuu.org.uk> <33C7D336-F062-47B3-9033-D3DC465F793C@it-loops.com> <20090706074333.GA17276@gondor.apana.org.au> <20090706083119.GA17782@gondor.apana.org.au>
X-Mailer: Apple Mail (2.935.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 6, 2009, at 10:31, Herbert Xu wrote:

> On Mon, Jul 06, 2009 at 03:43:33PM +0800, Herbert Xu wrote:
>>
>> I think the first backtrace is bogus, this is where the real
>> problem is.  So what see here is that on xmit from the network,
>> PPP will call pty_write from BH context which eventually leads
>> to tty_throttle and the sleep.
>
> Here's the stupidest possible fix for this, changing the mutex
> to a spin lock.  We should also revert the other commit that
> tried to fix this, a6540f731d506d9e82444cf0020e716613d4c46c as
> those unthrottles are really needed
<snip>

Just to confirm.
I reverted the commit and applied the patch on-top of 2.6.31-rc2.
Up to now I was not able to reproduce the crashes I had before on my  
setup here.


Kind regards,
Michael
