Return-Path: <linux-kernel-owner+w=401wt.eu-S967527AbXHGVzD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967527AbXHGVzD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 17:55:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966578AbXHGVce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 17:32:34 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:60826 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966538AbXHGVcc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 17:32:32 -0400
Message-ID: <46B8E4EB.1040208@garzik.org>
Date: Tue, 07 Aug 2007 17:32:27 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Jesper Juhl <jesper.juhl@gmail.com>, Kyle McMartin <kyle@mcmartin.ca>
CC: Andrew Morton <akpm@linux-foundation.org>, Valerie Henson <val@nmt.edu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       tulip-users@lists.sourceforge.net, david@lang.hm,
       Grant Grundler <grundler@parisc-linux.org>,
       Michael Buesch <mb@bu3sch.de>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH][RESEND] Semi-pointless NULL test in uli526x driver
References: <200708042032.12317.jesper.juhl@gmail.com>	 <46B8E2BE.1050408@garzik.org> <9a8748490708071428i7aa2289bi90045a8b07fbf816@mail.gmail.com>
In-Reply-To: <9a8748490708071428i7aa2289bi90045a8b07fbf816@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jesper Juhl wrote:
> On 07/08/07, Jeff Garzik <jeff@garzik.org> wrote:
>> Jesper Juhl wrote:
>>> (resending previously submitted patch from 16/7-2007 22:40)
>>>
>>>
>>> Hi,
>>>
>>> In drivers/net/tulip/uli526x.c::uli526x_interrupt() there's a test
>>> of the function argument 'void *dev_id' against NULL. But that
>>> test is pretty pointless, since if ever 'dev_id' is NULL we'll
>>> already have crashed inside "netdev_priv(dev)".
>>>
>>> I don't think dev_id can ever actually be NULL, so the whole block
>>> inside "if (!dev) {" could probably just go away. But I guess
>>> there's a good reason someone put that ULI526X_DBUG() in there - and
>>> if 'dev_id' /can/ actually be NULL then it's nice to have and in
>>> that case this patch actually fixes a possible crash (hence the
>>> version number update).
>>> So I guess that in this case we should just move the
>>> "db = netdev_priv(dev)" assignment past that NULL test. That's what
>>> this patch does.
>>>
>>> Found by the Coverity checker.
>>> Compile tested.
>>>
>>>
>>> PS. Please keep me on Cc when replying.
>>>
>>>
>>> Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
>> Just remove the dev==NULL test...
>>
> 
> Hmm, it would seem there's some disagreement about that :
> 
> On 04/08/07, Kyle McMartin <kyle@mcmartin.ca> wrote:
> ...
>> It *can* be null, in the case of another handler being registered on the
>> same irq number, passing NULL for the cookie.
>>
>> Ack. Will apply.
>>
>> Regards,
>>         Kyle
>>
> 
> I'll let you and Kyle fight it out :-)


My official opinion (for net drivers and ATA at least):  It is pointless 
having such a check in the hottest of driver hot paths, since a large 
majority of drivers do not have such a check.

It is better to fix the extremely rare oddball that passes NULL to 
request_irq(), than to update all drivers to be slower due to the oddballs.

	Jeff


