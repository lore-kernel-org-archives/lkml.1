Return-Path: <linux-kernel-owner+w=401wt.eu-S936822AbYEUTAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936822AbYEUTAb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 15:00:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758908AbYEUTAQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 15:00:16 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:53986 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755683AbYEUTAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 15:00:15 -0400
Date: Wed, 21 May 2008 21:01:03 +0200
From: Pavel Machek <pavel@suse.cz>
To: Jeff Garzik <jeff@garzik.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org
Subject: Re: better msleep for drivers
Message-ID: <20080521190103.GA19261@elf.ucw.cz>
References: <20080511110124.GA24187@basil.nowhere.org> <alpine.LFD.1.10.0805111408440.3197@apollo.tec.linutronix.de> <20080521104131.GA4948@ucw.cz> <48343EBC.70703@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48343EBC.70703@garzik.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

>>>> Still longer term I suppose there's really no way around having accurate
>>>> sleep functions and it's probably better to start testing earlier than later.
>>> No objections, but we should not do that with a stupid msleep
>>> replacement interface; instead we should expose a flexible in kernel
>>> variant of hrtimer_nanosleep() which lets the user utilize
>>> ABS/REL_TIME and the different clocks. A msleep helper can be built on
>>> top of this very easily.
>>
>> While you are at it... it would be cool to have
>>
>> 'mdelay(2500 msec), but it is okay to wait 100msec more' -- type
>> interface, so we could use that for nohz benefit.
>>
>> Currently, mdelay is 'it is okay to wait 10msec more' interface, and
>> it would be nice to have that explicit.
>
> eh, I think you transposed mdelay with msleep?
>
> msleep() is the "it is okay to wait longer than I said" interface, not 
> mdelay().  mdelay() has always been non-sleeping and exact (as much as the 
> delay loop allows)

Okay, I was a bit confused.

Actually, both can delay for longer... msleep() in case of scheduling
load, mdelay() in case of interrupt load...

But the above was about hrtimer_nano*sleep*(), so that "how much
latency we can tolarate" parameter would still be good.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
