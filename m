Return-Path: <linux-kernel-owner+w=401wt.eu-S1756306AbYD0Www@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756306AbYD0Www (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 18:52:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752602AbYD0Ww3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 18:52:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54400 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754174AbYD0Ww2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 18:52:28 -0400
Message-ID: <48150392.6040508@zytor.com>
Date: Sun, 27 Apr 2008 15:52:02 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: jeff@garzik.org, James.Bottomley@HansenPartnership.com, mingo@elte.hu,
       tglx@linutronix.de, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: [patch] x86, voyager: fix ioremap_nocache()
References: <20080427214837.GA11631@elte.hu>	<1209335660.3801.79.camel@localhost.localdomain>	<4815009C.2010809@garzik.org> <20080427.154620.177583216.davem@davemloft.net>
In-Reply-To: <20080427.154620.177583216.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Jeff Garzik <jeff@garzik.org>
> Date: Sun, 27 Apr 2008 18:39:24 -0400
> 
>> I disagree with this semantics change.  A number of code places _and 
>> drivers_ GET IT RIGHT, and these are all broken now?
> 
> [ Note, James's patch that you quoted is about mapping DMA
>   memory, in dma_declare_coherent_memory(), rather than devices.
>   But I know what you are trying to talk about Jeff. :-) ]
> 
> Wrt. ioremap() semanics, it is important to realize that if
> the implementation of this on x86 has been giving non-cached
> I/O mappings out up until recently, you can expect that there
> are hundreds of drivers that might now be broken.
> 
> That's the sad fact of the ubiquity of x86, and it doesn't matter how
> we defined the API is some document.
> 
> Anyways, my point is that this angle should be strongly considered in
> any discussion about ioremap() behavior.
> 

There are pretty much three reasons to default to uncached, as far as I 
understand:

1. De facto historical practice (follow the MTRRs);
2. Conservatism (failure mode less drastic);
3. Compatibility with other architectures.

Arguably, the right thing is to not even have ioremap() anymore, just 
ioremap_{cache,nocache,wc} and consider any unconverted ioremap() as a 
flag to audit that particular piece of code.

I don't think that can be done "instantly", though, so defaulting 
ioremap() to uncached (as it apparently has been on other arches 
already?) is the conservative option in the meantime.

	-hpa
