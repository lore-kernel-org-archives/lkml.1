Return-Path: <linux-kernel-owner+w=401wt.eu-S1755451AbZITSe6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451AbZITSe6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 14:34:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754197AbZITSe5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 14:34:57 -0400
Received: from 1wt.eu ([62.212.114.60]:49150 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751971AbZITSe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 14:34:56 -0400
Date: Sun, 20 Sep 2009 20:34:58 +0200
From: Willy Tarreau <w@1wt.eu>
To: Grozdan <neutrino8@gmail.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>, linux-kernel@vger.kernel.org
Subject: Re: sky2 rx length errors
Message-ID: <20090920183458.GC28315@1wt.eu>
References: <c5bd819b0909180641n7c353b80tc15b9c9fe02d5c95@mail.gmail.com> <20090919233536.f5fb700c.akpm@linux-foundation.org> <20090920110527.39fd7af5@s6510> <c5bd819b0909201116u5a84c426tdd0f298d7019505d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c5bd819b0909201116u5a84c426tdd0f298d7019505d@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

On Sun, Sep 20, 2009 at 08:16:02PM +0200, Grozdan wrote:
> 2009/9/20 Stephen Hemminger <shemminger@vyatta.com>:
> 
> >
> > This error status occurs if the length reported by the PHY does not
> > match the len reported by the DMA engine.  The error status is:
> >   0x4420100 = length 1090 + broadcast packet...
> >
> > No idea what is on your network, but perhaps there is some MTU confusion?
> > Since martian destination seems related, knowing more about that packet
> > might help.
> >
> 
> Hi,
> 
> Thanks for the reply. There's nothing on my home network here. It is
> just a direct connection from my PC to my cable modem and there's
> nothing in between. I've googled a bit and it seems others also
> encounter this problem.

I've encountered similar issues on early 8053 chips too. Those were
soldered on motherboard of network servers bought about 4 years ago.
No matter what trick I could try, change drivers, enable/disable flow
control, change negociation speed, etc... the PHY would occasionally
and randomly get mad and start shifting received frames by a few bytes,
thus causing loss of network connectivity. The logs would also display
martians, depending on the bytes in the frame which appeared in the
IP header once shifted.

Sometimes it would automatically get back after a chip reset, sometimes
not. It seemed that disabling flow control helped a bit, but it was not
fantastic. It would randomly hang every 1-30 days, which made the issue
rather hard to debug.

I don't precisely remember the rev. of the chip, but I remember that
it was pretty old and that more recent machines had a much larger
number that never exhibited the issue. Also, my desktop right here
runs off a 88E8056 (~= two 8053s) and has never failed yet.

So I really think that there was a horrible batch of chips in its
early days.

> I've read a few posts on the Ubuntu bugzilla
> where people change the MTU from 1500 to 1492 and this fixes the
> problem. However, even with this, some report that the problem is
> still there. I did the same and it didn't change anything for me.

Did not help for me either.

> So I
> disabled my onboard NIC and added a 3Com one which has been working
> perfectly so far and I think I'll just keep using it instead of the
> Marvell one.

That's the best you can do if you happen to have one of those buggy
chips. We had to stuff intel NICs in the servers causing trouble at
the customer's and it solved the issue too.

Regards,
Willy

