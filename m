Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796Ab0CCVyC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 16:54:02 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:37181 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756707Ab0CCVx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 16:53:56 -0500
Date: Wed, 3 Mar 2010 22:53:47 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Frantisek Rysanek <Frantisek.Rysanek@post.cz>
Cc: Mikael Pettersson <mikpe@it.uu.se>, linux-kernel@vger.kernel.org
Subject: Re: Dynticks on Vortex86SX ? (Cx486SLC + just the standard i8254
	PC timer)
Message-ID: <20100303215347.GD2579@ucw.cz>
References: <19335.44648.623680.272844@pilspetsen.it.uu.se> <4B87FBC3.23033.45BDAB1@Frantisek.Rysanek.post.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B87FBC3.23033.45BDAB1@Frantisek.Rysanek.post.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Select HZ=100.
> >
> right
> 1) to make the numbers decadic
> 2) seems like the only true way for me to decrease the rate of PC 
> timer interrupts :-)

Try HZ=20 :-).

> I am aware that the PC timer has a limited resolution (16 bits for 
> the single i8254 channel) and thus the maximum time you can possibly 
> sleep without an interrupt is about 55 ms (18 Hz). Based on all the 
> PR publicity the dynticks patch used to receive in its time, 
> I thought that even on my puny hardware, the PC timer would 
> automatically flex towards that maximum period. Apparently this is 
> not the case...

I guess nohz needs apic timer or something like that.

> And perhaps the hunt for dynticks is not really worth the bother,
> if the wakeup to serve IRQ0 comes once every 3 million CPU cycles :-)
> (This board clocks the CPU at 300 MHz.) How many CPU cycles does it 
> take before the idle loop calls HLT again? a hundred maybe?  So 
> that's 1/30000 of time running out of HLT? :-)

Well, on modern cpus, entering/exiting halt state takes *lomg* time.
You are lucky.

> There's another power-saving feature of the Vortex SoC: it can 
> decrease the core clock down to 1/8th of the nominal clock. This can 
> be configured by a simple IO instruction. This way, you can decrease 
> consumption of the whole SoC by maybe 6.5% (= down to 93% of full 
> throttle), at the cost of throttling the core clock by 87%. The 
> standard PC104 boards don't have a Vcore regulator, so it just 
> doesn't get any better than that. I can do the underclocking from 
> userspace using IOperm, I was wondering how nice it would be to have 
> a "clockmod" driver, but ultimately I guess saving 125 mW is not 
> worth the bother, as the whole setup including some peripherials eats 
> over 3 Watts...

Yep, hooking it to cpufreq would be nice.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
