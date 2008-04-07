Return-Path: <linux-kernel-owner+w=401wt.eu-S1754118AbYDGURW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118AbYDGURW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 16:17:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751883AbYDGURP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 16:17:15 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:53145 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750949AbYDGURO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 16:17:14 -0400
Message-ID: <47FA813D.6090505@garzik.org>
Date: Mon, 07 Apr 2008 16:17:01 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Bryan Wu <cooloney@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>
CC: LKML <linux-kernel@vger.kernel.org>, magnus.damm@gmail.com,
       damm@igel.co.jp, lethal@linux-sh.org, nico@cam.org,
       Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: Blackfin STAMP537 compiling error in 2.6.25-rc8
References: <386072610804070057w1eb65db5taeca77f8f3e36627@mail.gmail.com>	 <47F9D7BA.6080708@garzik.org> <386072610804070115s57dfd49fgad01218e820167b@mail.gmail.com>
In-Reply-To: <386072610804070115s57dfd49fgad01218e820167b@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bryan Wu wrote:
> On Mon, Apr 7, 2008 at 1:13 AM, Jeff Garzik <jeff@garzik.org> wrote:
>> Bryan Wu wrote:
>>
>>> We found the latest kernel compile failed with Blackfin STAMP537
>>> configuration on our daily build machine.
>>> ---
>>>  CC      drivers/net/smc91x.o
>>> drivers/net/smc91x.c: In function 'smc_rcv':
>>> drivers/net/smc91x.c:513: warning: passing argument 1 of 'insw' makes
>>> integer from pointer without a cast
>>> drivers/net/smc91x.c: In function 'smc_hardware_send_pkt':
>>> drivers/net/smc91x.c:620: warning: passing argument 1 of 'outsw' makes
>>> integer from pointer without a cast
>>> drivers/net/smc91x.c:1859:32: error: macro "SMC_GET_MAC_ADDR" requires
>>> 2 arguments, but only 1 given
>>> drivers/net/smc91x.c: In function 'smc_probe':
>>> drivers/net/smc91x.c:1859: error: 'SMC_GET_MAC_ADDR' undeclared (first
>>> use in this function)
>>> drivers/net/smc91x.c:1859: error: (Each undeclared identifier is
>>> reported only once
>>> drivers/net/smc91x.c:1859: error: for each function it appears in.)
>>> make[2]: *** [drivers/net/smc91x.o] Error 1
>>> make[1]: *** [drivers/net] Error 2
>>> make: *** [drivers] Error 2
>>> ---
>>>
>>> That is because my -mm tree fixing bug patch:
>>>
>> (http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=9e6db60825ef7e7999abc610ce256ba768e58162)
>>> was merged into mainline before the smc91x API change patch in -mm:
>>>
>> http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc5/2.6.25-rc5-mm1/broken-out/smc91x-pass-along-private-data-v2.patch
>>> Did I miss something here? or this patch is on the way before 2.6.25
>>> final release?
>>>
>>  It looks like I missed something...  I thought akpm was going to send the
>> patch for -mm in?
>>
>>  If not, let's revert this one...
>>
> 
> ok, no problem, it is ok for me.

Cool.

David or Linus, please revert 9e6db60825ef7e7999abc610ce256ba768e58162

It was merged without the API it needed, causing build breakage.

Acked-by: Jeff Garzik <jgarzik@redhat.com>



Andrew,

Since it was an arch patch to a driver I cannot build, I made the 
[mistaken] assumption that your sending it to me was an indication that 
it should actually be merged :)  Especially with a subject like "fix 
build breakage", for a platform I cannot easily build...

Are there any process tweaks that could be made here?  Maybe -mm stuff 
sent to maintainers could be tagged, noting dependencies on other -mm 
patches that are not yet upstream?

Thanks,

	Jeff


