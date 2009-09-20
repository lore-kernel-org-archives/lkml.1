Return-Path: <linux-kernel-owner+w=401wt.eu-S1755562AbZITSq7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562AbZITSq7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 14:46:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755319AbZITSq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 14:46:57 -0400
Received: from mail-fx0-f216.google.com ([209.85.220.216]:39004 "EHLO
	mail-fx0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755079AbZITSq5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 14:46:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hbxI1kdPLZKBuwMUyfBJPCwDXqVmrwvCXRuv7ph1406S9Q3WnHjNT9APtRjJzL95h1
         uv2k0iUt4j+4KVyZiC2ktqsuq3/o8LcGgzphfhhU8iJVNZD2kuVjInxHMlYQNMC/Ikqx
         0uYX4rFuUrI4si+U2ac4HM58AvxZGq5RRTwI0=
MIME-Version: 1.0
In-Reply-To: <20090920183458.GC28315@1wt.eu>
References: <c5bd819b0909180641n7c353b80tc15b9c9fe02d5c95@mail.gmail.com>
	 <20090919233536.f5fb700c.akpm@linux-foundation.org>
	 <20090920110527.39fd7af5@s6510>
	 <c5bd819b0909201116u5a84c426tdd0f298d7019505d@mail.gmail.com>
	 <20090920183458.GC28315@1wt.eu>
Date: Sun, 20 Sep 2009 20:46:59 +0200
Message-ID: <c5bd819b0909201146t35d921afh267c9430b114e23e@mail.gmail.com>
Subject: Re: sky2 rx length errors
From: Grozdan <neutrino8@gmail.com>
To: Willy Tarreau <w@1wt.eu>
Cc: linux-kernel@vger.kernel.org, shemminger@vyatta.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/9/20 Willy Tarreau <w@1wt.eu>:
> Hi guys,
>
> On Sun, Sep 20, 2009 at 08:16:02PM +0200, Grozdan wrote:
>> 2009/9/20 Stephen Hemminger <shemminger@vyatta.com>:
>>
>> >
>> > This error status occurs if the length reported by the PHY does not
>> > match the len reported by the DMA engine.  The error status is:
>> >   0x4420100 = length 1090 + broadcast packet...
>> >
>> > No idea what is on your network, but perhaps there is some MTU confusion?
>> > Since martian destination seems related, knowing more about that packet
>> > might help.
>> >
>>
>> Hi,
>>
>> Thanks for the reply. There's nothing on my home network here. It is
>> just a direct connection from my PC to my cable modem and there's
>> nothing in between. I've googled a bit and it seems others also
>> encounter this problem.
>
> I've encountered similar issues on early 8053 chips too. Those were
> soldered on motherboard of network servers bought about 4 years ago.
> No matter what trick I could try, change drivers, enable/disable flow
> control, change negociation speed, etc... the PHY would occasionally
> and randomly get mad and start shifting received frames by a few bytes,
> thus causing loss of network connectivity. The logs would also display
> martians, depending on the bytes in the frame which appeared in the
> IP header once shifted.
>
> Sometimes it would automatically get back after a chip reset, sometimes
> not. It seemed that disabling flow control helped a bit, but it was not
> fantastic. It would randomly hang every 1-30 days, which made the issue
> rather hard to debug.
>
> I don't precisely remember the rev. of the chip, but I remember that
> it was pretty old and that more recent machines had a much larger
> number that never exhibited the issue. Also, my desktop right here
> runs off a 88E8056 (~= two 8053s) and has never failed yet.
>
> So I really think that there was a horrible batch of chips in its
> early days.
>
>> I've read a few posts on the Ubuntu bugzilla
>> where people change the MTU from 1500 to 1492 and this fixes the
>> problem. However, even with this, some report that the problem is
>> still there. I did the same and it didn't change anything for me.
>
> Did not help for me either.
>
>> So I
>> disabled my onboard NIC and added a 3Com one which has been working
>> perfectly so far and I think I'll just keep using it instead of the
>> Marvell one.
>
> That's the best you can do if you happen to have one of those buggy
> chips. We had to stuff intel NICs in the servers causing trouble at
> the customer's and it solved the issue too.
>
> Regards,
> Willy
>
>

Thanks Willy :)

What I'm still wondering a bit though is the fact that I've never seen
it behave like that for the past 3 years I've been using it. Only
recently, with upgrading my kernel to 2.6.30 and later on to 2.6.31
(self-compiled, sources taken from the openSUSE build service) it
started to behave like that. In the past I also used older kernels (of
course) like 2.6.27.x and 2.6.29 and never encountered this. So I'm a
bit uncertain as to whether it's actually something in the kernel that
makes it behave like that or that there's a HW problem that suddenly
occurred or got exposed...
