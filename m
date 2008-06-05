Return-Path: <linux-kernel-owner+w=401wt.eu-S1758096AbYFERKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758096AbYFERKl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 13:10:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753851AbYFERKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 13:10:20 -0400
Received: from mail.pager.net ([209.253.16.26]:36092 "EHLO barracuda.pager.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752427AbYFERKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 13:10:17 -0400
X-ASG-Debug-ID: 1212685816-683d00390000-xx1T2L
X-Barracuda-URL: http://192.168.1.240:8000/cgi-bin/mark.cgi
From: Geoffrey Wossum <geoffrey@pager.net>
Organization: Long Range Systems
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
X-ASG-Orig-Subj: Re: AT32 ASoC Driver Patches on alsa-devel
Subject: Re: AT32 ASoC Driver Patches on alsa-devel
Date: Thu, 5 Jun 2008 12:10:47 -0500
User-Agent: KMail/1.9.9
Cc: kernel@avr32linux.org, linux-kernel@vger.kernel.org
References: <200806050851.47319.geoffrey@pager.net> <200806051000.56969.geoffrey@pager.net> <20080605182409.6285ee4b@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <20080605182409.6285ee4b@hskinnemo-gx745.norway.atmel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806051210.47986.geoffrey@pager.net>
X-Barracuda-Connect: UNKNOWN[192.168.1.1]
X-Barracuda-Start-Time: 1212685816
X-Barracuda-Virus-Scanned: by Barracuda Spam Firewall at pager.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 June 2008 11:24:09 am Haavard Skinnemoen wrote:
> Geoffrey Wossum <geoffrey@pager.net> wrote:
> > On Thursday 05 June 2008 09:22:06 am Haavard Skinnemoen wrote:
> > > Geoffrey Wossum <geoffrey@pager.net> wrote:

> > To paraphrase Andy Tanenbaum, the great thing about standards is there's
> > so many to choose from.
>
> Heh.

I quote that a lot.  Along with Philip K. Dicks's "Sometimes an appropriate 
response to reality is to go insane."

> Hmm...I take it you're talking about the SSC driver? That is supposed
> to be usable on AT91 as well, so perhaps the right thing to do is
> porting the AT91 driver over to use it.

Yes, the SSC code.  It'd be cool if it abstracted out even more, but I 
understand the difficulties in making that happen.

> I see you've added a few SSC-related constants...those should probably
> go into include/linux/atmel-ssc.h.

I wasn't sure if having these in atmel-ssc.h fit with ya'lls plans for it, but 
if it does, great.


> >  But I needed an AT32 layer quickly, and I don't
> > have any AT91 hardware, so I couldn't really go mucking about in the AT91
> > code since I wouldn't be able to test it.  I don't feel especially bad,
> > though, since at91_mci.c and atmel-mci.c commit essentially the same sin.
>
> Yeah, I guess you're right. I do have a long-term goal merging those
> two drivers, but it will be a bit difficult because the DMA interface
> is quite different.

The PDC interface is closer (if not exactly the same).  One issue is the SSC 
interface, which you have said could be used on the AT91.  After that, the 
main differences are that the DMA buffer has to be allocated differently, and 
the mmap() implementation is different.

> That's certainly a good reason, though I don't understand why reusing
> code isn't important on non-SoC platforms.

Please don't take my answer as authoritative, but I think it's because on a 
typical PC the exact CODEC being used tends to be hidden from you.  And you 
normally don't use I2S or PCM directly.  A PC sound card is more of a black 
box.

> Another good reason, but again I don't understand why power management
> isn't important on PCs.

It is important, and becoming more important all the time.  I think the main 
reasons this isn't a priority on a PC right now are:
 - I think PC sound cards tend to be black boxes regarding power consumption, 
especially those white box cards you can get at Fry's and similar places.   
 - A few extra mA aren't as important when you're plugged in, or you have a 
laptop, which has a honkin' big battery compared to a PDA type device
 - A few extra mA are dwarfed by other things in a PC, like the processor.  My 
Intel T7200 burns 34 W at full tilt.  The AT32AP7000 is going to be something 
like, what, 250 mW?  Even throttled all the way down my T7200 is going to be 
13 W.  Turning off all or part of the CODEC and saving 15 - 30 mW is a lot 
bigger deal on the AVR32 than it would be on my laptop.
 - As you say, there is more code due to the power management, which requires 
modifying a lot of working drivers, for little benefit in the forseeable 
future.

---
Geoffrey



