Return-Path: <linux-kernel-owner+w=401wt.eu-S1758646AbZAOJ02@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758646AbZAOJ02 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 04:26:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753045AbZAOJ0Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 04:26:16 -0500
Received: from mail-in-13.arcor-online.net ([151.189.21.53]:50579 "EHLO
	mail-in-13.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750912AbZAOJ0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 04:26:13 -0500
Message-ID: <496F012C.9020004@arcor.de>
Date: Thu, 15 Jan 2009 10:26:04 +0100
From: Thomas Dahlmann <dahlmann.thomas@arcor.de>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Vadim Lobanov <vlobanov@speakeasy.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: amd5536udc interrupts bug
References: <49661E83.2070703@arcor.de> <200901131119.54994.vlobanov@speakeasy.net> <496DDDFC.7030301@arcor.de> <200901141449.37246.vlobanov@speakeasy.net>
In-Reply-To: <200901141449.37246.vlobanov@speakeasy.net>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> It seems that the ultimate cause for all this strangeness was a mis-wired 
> board: the vendor at long last admitted that the VBUS signal is not connected 
> in the hardware. Why they didn't simply document this fact, and thereby save 
> me a lot of wasted effort, remains a mystery.
>
> As a workaround, they suggested setting bit 0x00000010 in the ctl register, 
> which is strangely enough inside the "reserved" space according to the AMD 
> data book. Worth a shot, I thought. After hacking up the amd5536udc driver 
> even more to do this operation at load time, the register states change to:
>
> cap=0x000083EA
> mux=0x00000007
> ctl=0x00000193
>
> Seems that a few other "reserved" bits also raised in response. (I still do 
> not understand exactly how they wired up the CS5536 IO chip to be different 
> from the data book, but oh well.) In this mode, the USB link is finally 
> detected, and the board is finally able to enumerate itself as a g_zero 
> device.
>   
This reserved bit seems to be an alias to the earlier mentioned PUEN bit
which allows to connect the pull up manually regardless of VBUS.
You will find that bit at page 276 in

http://www.amd.com/files/connectivitysolutions/aufamily/au1200/32798e_Au1200_ds.pdf

If you compare the registers you will find that UDC controller of
Au1200 is 99.9% compatible with UDC of CS5536. Same for
CS5536 UOC and Au1200 OTG Controller. But OTG Controller of
Au1200 has more functionality and bits.

Unfortunately this bit is not the complete solution for your problem.
When setting PUE then connect and disconnect events cannot be
detected by UDC. If you disconnect and connect again you
probably will notice that there will be no new enumeration as
expected.
> Please accept my sincere thank-you for your help. I'm hoping that everything 
> will work from now on, and that I won't send any more questions your way. :)
>   
My pleasure! It is fun for me to continue this thread.
> I'll also await an update to the irq stuff in the amd5536udc driver that we 
> talked about earlier, if you get around to making the fix for it first.
>   
I will do when I have a new CS5536 board. Thanks for your
analysis again!

Thomas


