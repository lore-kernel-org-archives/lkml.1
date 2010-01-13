Return-Path: <linux-kernel-owner+w=401wt.eu-S1756109Ab0AMRA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109Ab0AMRA6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 12:00:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756028Ab0AMRA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 12:00:57 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:57401 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756026Ab0AMRA4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 12:00:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=sqnWfxYyr8remG7/ObgkJiBVt9lc5lblIbJdzh6Q4g+cWdKLqFIM2xaP1Hkjh+R8Gz
         vq1B071bk683nYMeg3FtoFH24ByfVhPp8kgmJBkRagKHz3I+0pS4Xhkh4lnkRhXsTmQd
         kYqslAuS9M2bO11QJZnEKKHQLY7k1vCUM4wCI=
MIME-Version: 1.0
In-Reply-To: <x49ljg25cr0.fsf@segfault.boston.devel.redhat.com>
References: <4B4630C0.6090206@gmail.com> <4B467A4D.9070708@gmail.com>
	 <1263252108.29868.4774.camel@calx>
	 <20100111.155912.68138954.davem@davemloft.net>
	 <1263254625.29868.4777.camel@calx> <4B4BBDA5.8010808@gmail.com>
	 <4B4D1372.9060702@gmail.com>
	 <x49ljg25cr0.fsf@segfault.boston.devel.redhat.com>
Date: Wed, 13 Jan 2010 17:53:43 +0100
Message-ID: <6f52f5b81001130853ve852e7bl1d5e6879dc4eb545@mail.gmail.com>
Subject: Re: [PATCH] netpoll: allow execution of multiple rx_hooks per 
	interface
From: Daniel Borkmann <danborkmann@googlemail.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Matt Mackall <mpm@selenic.com>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       netdev@oss.sgi.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/1/13 Jeff Moyer <jmoyer@redhat.com>:
> Daniel Borkmann <danborkmann@googlemail.com> writes:
>
>> Daniel Borkmann wrote:
>>> Matt Mackall wrote:
>>>> On Mon, 2010-01-11 at 15:59 -0800, David Miller wrote:
>>>>> From: Matt Mackall <mpm@selenic.com>
>>>>> Date: Mon, 11 Jan 2010 17:21:48 -0600
>>>>>
>>>>>> Looks pretty good. Dave?
>>>>>>
>>>>>> Acked-by: Matt Mackall <mpm@selenic.com>
>>>>> I don't like the loop for RX ARP processing.
>>>>>
>>>>> The packet contents aren't going to change, so doing basic
>>>>> packet validation inside of the "for each RX client" loop
>>>>> of arp_reply() doesn't make any sense.
>>>> True. Dan, please help our poor compilers with some manual loop
>>>> invariant motion.
>>>
>>> Okay, true. I'll fix this by tomorrow and resend the patch.
>>
>> Here the fix of the RX ARP processing routine. Content that isn't
>> going to change is out-of-loop.
>> Successfully tested on my machines.
>
> Against what tree does this patch apply?  It doesn't apply to Linus's
> git tree.  Also, in the future, could you use the -p option to diff so
> we can see what function or data structure is being modified?  It really
> helps in reviewing.

As mentioned earlier in this thread... when I started developing the patch I
used 2.6.32.2 (latest stable from kernel.org), which might be already "old" ...
sorry for that. Ok, next time I will use -p, too. For the moment, it was diff
with -Nur. Shall I resend?

Best regards,
Daniel
