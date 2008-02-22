Return-Path: <linux-kernel-owner+w=401wt.eu-S1759813AbYBVRNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759813AbYBVRNR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 12:13:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754011AbYBVRNF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 12:13:05 -0500
Received: from ns.protei.ru ([195.239.28.26]:37590 "EHLO mail.protei.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750802AbYBVRNE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 12:13:04 -0500
Message-ID: <47BF101F.30301@protei.ru>
Date: Fri, 22 Feb 2008 21:10:39 +0300
From: Alexey Zaytsev <zaytsev.a@protei.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: bcm43xx regression in 2.6.24 (with patch)
References: <47BEAF3B.3080809@protei.ru> <200802221513.58608.mb@bu3sch.de>
In-Reply-To: <200802221513.58608.mb@bu3sch.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Buesch wrote:
> On Friday 22 February 2008 12:17:15 Alexey Zaytsev wrote:
>> Hello.
>>
>> The bcm43xx driver won't work any more, if the b44 Ethernet
>> driver is enabled. This happens because the b44 driver
>> needlessly enables the b43_pci_bridge code, which claims
>> the same pci ids as the bcm43xx driver. The b43_pci_bridge
>> code is needed for the b43{legacy} drivers, but for the
>> b44, only the "ssb pci core" is needed.
>>
>> This patch separates the ssb b43 pci bridge and the ssb pci
>> core config options and enables only the needed ones.
> 
> Nack. Switch to b43. bcm43xx is going to be removed anyway.
> I'm not going to play these kconfig SELECT tricks anymore.
> We had _lots_ of bugs there. People submitted patches that
> obviously looked OK and still they turned out to break
> some dependencies. KConfig SELECT is a feature from hell.
> 

Sorry, I don't get it. You are going to remove the (somehow)
working driver, while there are known problems with the new
one? Why? To me it sounds like _breaking old but working code_
to get _more bug reports on the new code_. But, what was the
goal providing users with working drivers, or getting more
bug reports?

And please look at the problem from a user's view point. I'm
happily using the 2.6.23 kernel. The bcm43xx driver is the
only one available. And it works somehow (well, no s2ram).
Now I upgrade to the 2.6.24 kernel. I see there is a new 
b43 driver and try it.
For some reason it does not work, even after I follow the
firmware upgrading instructions. Not a big deal, I clearly
understand that you have to work with reverse-engineered
specs and even with good specs, bugs happen, no problem.
I'll try to debug it in the weekend and maybe will send a
bug report or patch.

But right now I have other business, sorry. The problem is,
now also the old (but not now marked as deprecated) driver
stops working.

If this is not a repgession, than I don't know what is.
And if it is a regression, it should be fixed at least in the
2.6.24.y series, do you agree?

I have provided a patch that I believe is trivial, that I have
tested with all possible config option combinations I thought
were possible, and that fixes the regression. If you have a
reason to believe it is wrong, please say it, I won't be
offended. If there is a problem with the patch, I'll gladly
fix and resend it. 

This Nack leaves me with one option - to switch back to 2.6.23.
Sorry, no testing, probably more bugs not found in 2.6.24. ;(

