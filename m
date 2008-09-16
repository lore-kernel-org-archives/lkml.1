Return-Path: <linux-kernel-owner+w=401wt.eu-S1757162AbYIPT0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757162AbYIPT0A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 15:26:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754578AbYIPTZu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 15:25:50 -0400
Received: from bu3sch.de ([62.75.166.246]:48770 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754148AbYIPTZt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 15:25:49 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Carlos Corbacho <carlos@strangeworlds.co.uk>
Subject: Re: Regression in 2.6.27-rcX caused by commit bc19d6e0b74ef03a3baf035412c95192b54dfc6f
Date: Tue, 16 Sep 2008 21:25:18 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: bcm43xx-dev@lists.berlios.de, Larry Finger <Larry.Finger@lwfinger.net>,
       Adel Gadllah <adel.gadllah@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       wireless <linux-wireless@vger.kernel.org>
References: <48CFC03A.8020708@lwfinger.net> <48CFE820.7010305@lwfinger.net> <200809162018.28548.carlos@strangeworlds.co.uk>
In-Reply-To: <200809162018.28548.carlos@strangeworlds.co.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809162125.18978.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 16 September 2008 21:18:27 Carlos Corbacho wrote:
> On Tuesday 16 September 2008 18:08:48 Larry Finger wrote:
> > I agree with Michael. From what I know, the only possible reason for
> > having [RFKILL_STATE_HARD_BLOCKED] would be if user space could
> > somehow affect the state of the hardware switch.
> 
> When I disable the b43 device in my laptop via acer-wmi (which in turn, calls 
> into the laptops firmware), b43 physically cannot re-enable it (a not 
> uncommon case on a lot of laptops). In which case, as far as b43 is 
> concerned, the wireless radio is then in RFKILL_STATE_HARD_BLOCKED, since b43 
> is unable to re-enable the radio on the hardware.
> 
> So yes, it is quite possible for b43 to be in RFKILL_STATE_HARD_BLOCKED.

Sure it is. It's the common case, if there's a button.

But I don't know how to tell the rfkill subsystem about the states and
I do not _want_ to. See, that crap code _always_ blew up for every single
patch we did. I'm tired of this and I am not interested in that anymore.
Please revert that patch and if that makes it work I'm fine with it.

I'm still waiting for the sane rfkill API where we have three functions
rfkill-allocate
rfkill-hw-state-changed
rfkill-free

That's all I need. All that input stuff, which was _the_ way to go some
months ago, but is now deprecated it seems (but I don't know what it it
replaced by) is just so really confusing.

-- 
Greetings Michael.
