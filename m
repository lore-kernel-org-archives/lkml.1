Return-Path: <linux-kernel-owner+w=401wt.eu-S1754363AbXEYXsx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363AbXEYXsx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 19:48:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752280AbXEYXsn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 19:48:43 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:59139 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752166AbXEYXsm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 19:48:42 -0400
Message-ID: <465775BE.5040306@pobox.com>
Date: Fri, 25 May 2007 19:48:14 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-net <linux-net@vger.kernel.org>
Subject: Re: rmmod e1000 hangs (Was Re: 2.6.22-rc2-mm1)
References: <20070523004233.5ae5f6fd.akpm@linux-foundation.org> <46556AA6.7040503@goop.org> <20070524104713.GA9174@gondor.apana.org.au> <20070524105403.GA9285@gondor.apana.org.au> <4655A4CD.8010901@intel.com> <20070525125413.GA29433@gondor.apana.org.au> <20070525130404.GA30071@gondor.apana.org.au> <20070525133253.GA30626@gondor.apana.org.au> <46575F5A.1030003@intel.com>
In-Reply-To: <46575F5A.1030003@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kok, Auke wrote:
> Herbert Xu wrote:
>> On Fri, May 25, 2007 at 11:04:04PM +1000, Herbert Xu wrote:
>>> [E1000]: Call netif_poll_enable in e1000_open
>>
>> Here is a better one.
>>
>> [E1000]: Restore netif_poll_enable call but make sure IRQs are off
>>
>> This restores the previously removed netif_poll_enable call in
>> e1000_open.  It's needed on all but the first call to e1000_open
>> for a NIC as e1000_close always calls netif_poll_disable.
>>
>> netif_poll_enable can only be called safely if no polls have been
>> scheduled.  This should be the case as long as we don't enter our
>> IRQ handler.
>>
>> In order to guarantee this we explicitly disable IRQs as early
>> as possible when we're probing the NIC.
>>
>> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> Ack!
> 
> this also fixes all the issues we had seen ourselves. I took a bit of 
> time to get our labs to test it.
> 
> Who can pick this patch up for us? Jeff ?

Is this for -stable or upstream?  I got confused with all the patches 
flying about.

Send it to me, if it's for upstream.

	Jeff



