Return-Path: <linux-kernel-owner+w=401wt.eu-S1751342AbYHKJsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751342AbYHKJsU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 05:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751400AbYHKJsD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 05:48:03 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:52373 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751200AbYHKJsB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 05:48:01 -0400
Message-ID: <48A00AB5.1030108@pobox.com>
Date: Mon, 11 Aug 2008 05:47:33 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH] net, wd.c: fix undefined reference to `NS8390p_init'
References: <20080806182828.6bfe0a16.sfr@canb.auug.org.au> <20080806172148.7fac5999.randy.dunlap@oracle.com> <Pine.LNX.4.64.0808070918510.17614@anakin> <20080807102931.1bb0607d@lxorguk.ukuu.org.uk> <20080811091105.GA8141@elte.hu>
In-Reply-To: <20080811091105.GA8141@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> 
>> On Thu, 7 Aug 2008 09:20:07 +0200 (CEST)
>> Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>>
>>> On Wed, 6 Aug 2008, Randy Dunlap wrote:
>>>> One randconfig ends with:
>>>>
>>>> drivers/built-in.o: In function `wd_probe1':
>>>> wd.c:(.init.text+0x6179): undefined reference to `NS8390p_init'
>>>> make[1]: *** [.tmp_vmlinux1] Error 1
>>> drivers/net/Makefile has:
>>>
>>> obj-$(CONFIG_WD80x3) += wd.o 8390.o
>>>
>>> So either wd_probe1() should call NS8390_init(), or obj-$(CONFIG_WD80x3)
>>> should link with 8390p.o. Don't know which is the appropriate change
>>> here (my gut feeling says the latter).
>> Safest is the latter. The shared memory interface on the wd is full 
>> speed 8 or 16bit (depending on card/jumpers) but I'm not clear about 
>> the NIC. Most of the performance hit is on the packet transfer which 
>> is private methods on this device so using 8390p won't make a big 
>> difference on this board anyway.
> 
> Alan, Jeff, i triggered this too with latest -git, please pick up the 
> fix below if you dont have it already.
> 
> 	Ingo
> 
> ------------------>
>>From c03cb1727bb4c5433436bfb0fab59fdcc00749c3 Mon Sep 17 00:00:00 2001
> From: Ingo Molnar <mingo@elte.hu>
> Date: Mon, 11 Aug 2008 11:11:42 +0200
> Subject: [PATCH] net, wd.c: fix undefined reference to `NS8390p_init'
> 
> fix:
> 
>   drivers/built-in.o: In function `wd_probe1':
>   wd.c:(.init.text+0xb247): undefined reference to `NS8390p_init'
> 
> that triggers with:
> 
>   http://redhat.com/~mingo/misc/config-Mon_Aug_11_10_40_46_CEST_2008.bad
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  drivers/net/Makefile |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

DaveM should have it AFAIK, I'll double-check and make sure it got in 
somewhere.

	Jeff



