Return-Path: <linux-kernel-owner+w=401wt.eu-S1757657AbYIPTa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757657AbYIPTa7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 15:30:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755224AbYIPTas
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 15:30:48 -0400
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:51833 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755201AbYIPTar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 15:30:47 -0400
Message-ID: <48D0095B.40403@lwfinger.net>
Date: Tue, 16 Sep 2008 14:30:35 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Carlos Corbacho <carlos@strangeworlds.co.uk>
CC: bcm43xx-dev@lists.berlios.de, Michael Buesch <mb@bu3sch.de>,
       Adel Gadllah <adel.gadllah@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       wireless <linux-wireless@vger.kernel.org>
Subject: Re: Regression in 2.6.27-rcX caused by commit bc19d6e0b74ef03a3baf035412c95192b54dfc6f
References: <48CFC03A.8020708@lwfinger.net> <200809161742.15527.mb@bu3sch.de> <48CFE820.7010305@lwfinger.net> <200809162018.28548.carlos@strangeworlds.co.uk>
In-Reply-To: <200809162018.28548.carlos@strangeworlds.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Carlos Corbacho wrote:
> On Tuesday 16 September 2008 18:08:48 Larry Finger wrote:
>> I agree with Michael. From what I know, the only possible reason for
>> having [RFKILL_STATE_HARD_BLOCKED] would be if user space could
>> somehow affect the state of the hardware switch.
> 
> When I disable the b43 device in my laptop via acer-wmi (which in turn, calls 
> into the laptops firmware), b43 physically cannot re-enable it (a not 
> uncommon case on a lot of laptops). In which case, as far as b43 is 
> concerned, the wireless radio is then in RFKILL_STATE_HARD_BLOCKED, since b43 
> is unable to re-enable the radio on the hardware.
> 
> So yes, it is quite possible for b43 to be in RFKILL_STATE_HARD_BLOCKED.

I didn't say it was not possible. What I said is that _ONLY_ the
operator's finger could change the state, just like in your laptop.
Thus it makes absolutely no difference what state RFKILL thinks it is
in. The driver knows what state the software wants, and can read but
not write the hardware state. There has to be a bug in RFKILL that got
exposed when this commit was included. This regression needs to be
fixed ASAP, otherwise 2.6.27 will be released with it. If the RFKILL
guys want to fix their bug, I'll be happy to test code, but not now.

Larry
