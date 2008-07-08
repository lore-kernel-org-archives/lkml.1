Return-Path: <linux-kernel-owner+w=401wt.eu-S1757478AbYGHDaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757478AbYGHDaA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 23:30:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756125AbYGHD3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 23:29:52 -0400
Received: from mail.lang.hm ([64.81.33.126]:34938 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756083AbYGHD3v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 23:29:51 -0400
Date: Mon, 7 Jul 2008 20:30:44 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: David Miller <davem@davemloft.net>, mchan@broadcom.com,
       dwmw2@infradead.org, bastian@waldi.eu.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bnx2 - use request_firmware()
In-Reply-To: <20080707221950.3dfba435@the-village.bc.nu>
Message-ID: <alpine.DEB.1.10.0807072028590.12950@asgard.lang.hm>
References: <C27F8246C663564A84BB7AB34397724201E1494B50@IRVEXCHCCR01.corp.ad.broadcom.com> <1215421413.3189.199.camel@shinybook.infradead.org> <1215456981.5532.20.camel@dell> <20080707.143803.99767036.davem@davemloft.net>
 <20080707221950.3dfba435@the-village.bc.nu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Jul 2008, Alan Cox wrote:

>> Who in the world is going to actually want request_firmware() to find
>> a firmware image other than the one which has been properly tested
>> together with the driver by the driver maintainer?
>
> That misses the point, intentionally I am sure. In the majority of cases
> the firmware doesn't change between releases so shipping a billion copies
> of is a pain in the butt.
>
>> What "use case" is there other than the desire to seperate out the
>> firmware in order to skirt the legal issues?
>
> Not shipping lots of copies
> Not leaving crap locked in kernel memory when it isn't needed
> Letting vendors issue firmware updates (which especially in enterprise
> space is a big issue and right now gets messy with compiled in firmware)
>
>> I think it is, in fact, the driver maintainer's perogative of whether
>> they want request_firmware() to be supported by their driver or not.
>> It is they who have to deal with any possible fallout.
>
> And their users and the distributors for whom it can cause enormous pain.
>
> If the two are closely tied then it makes a lot of sense to keep them
> tied, but that doesn't mean wasting a ton of kernel memory and bandwidth
> and disk space in the process. Loading the firmware and insisting on a
> specific version is quite civilised for a driver with such a tie.

so make the firmware part of the module if the driver is compiled as a 
module. this way if the driver (and firmware) end up not being used they 
don't take up any space. this seems a lot simpler (as well as more 
reliable) then adding a mandatory dependancy on a different userspace 
tool.

David Lang

> (of course we had this argument over ten years ago about modules when
> various authors couldn't be bothered to modularise their driver which
> caused endless pain to the distributions and end users. Remember the
> sound driver situation in early Red Hat. Mind you it got me a job there
> fixing it ;))
>
> Driver authors aren't God. There are other important considerations, but
> for tg3 if that means 'wrong MD5sum, no load' then fine.
>
>
> Alan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
