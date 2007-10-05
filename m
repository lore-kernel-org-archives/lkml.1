Return-Path: <linux-kernel-owner+w=401wt.eu-S1764291AbXJEUsL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764291AbXJEUsL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 16:48:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762541AbXJEUr6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 16:47:58 -0400
Received: from hobbit.corpit.ru ([81.13.94.6]:22290 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752359AbXJEUr5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 16:47:57 -0400
Message-ID: <4706A2F7.8050508@msgid.tls.msk.ru>
Date: Sat, 06 Oct 2007 00:47:51 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Icedove 1.5.0.12 (X11/20070607)
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Greg KH <gregkh@suse.de>, Alan Stern <stern@rowland.harvard.edu>,
       Jean Delvare <khali@linux-fr.org>, linux-kernel@vger.kernel.org,
       i2c@lm-sensors.org, linux-usb-devel@lists.sourceforge.net
Subject: Re: Various problems on Axis 700 Lite VIA C7
References: <Pine.LNX.4.44L0.0710051021230.4446-100000@iolanthe.rowland.org> <Pine.LNX.4.60.0710052215510.10392@poirot.grange>
In-Reply-To: <Pine.LNX.4.60.0710052215510.10392@poirot.grange>
X-Enigmail-Version: 0.94.2.0
OpenPGP: id=4F9CF57E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Guennadi Liakhovetski wrote:
> Hi
> 
> Ok, after a day of biseting, it turns out to be a compiler problem. The 
> gcc-3.3.5 produces at least these two problems (Oops on i2c-viapro probe 
> and disabled IRQs in USB), whereas 4.1.2 has no problem so far. Up to now 
> 3.3.5 had no problem compiling 2.6.20+ kernels here, for example, for P-II 
> SMP. Does it at all look realistic that such "random" run-time problems 
> are caused by a miscompilation?...

I can't say about compilers (but it looks to me somewhat possible still),
but I can say a bit about the platform/CPU.  You can find my thread titled
"VIA C7 anyone" from several months back in archives - that was my first
expirience.  Since that, I received several emails from others with similar
problems.

The things is that at least boards I'm using, but I suspect it's CPU not
the board, -- are somewhat... flaky, so to say, and their reliability (or
even ability to work) depends on several factors, starting with production
conditions (environment at a time when it has been produced) and up to
various thermal factors.

It seems there's quite significant percentage of C7-based boards that are
flaky/unreliable, replacing one with another from the same batch usually
fixes the prob.

Next, some boards are VERY sensitive to themperature, and their thermal
sensors are WRONG - it seems - 100% of the time, showing ~20% less
themperature than it really is (say, when the sensor shows 35 degrees
celsius, the themp really is about 45..50 degrees) -- when the themperature
(on SOME samples) grows above 40 degrees, the system becomes unreliable
and may crash randomly here and there.

More, due to geometry of the CPU chip, with very small square area that
touches the headsink and relatively large headsink, it's sometimes enouth
to just touch the headsink so it positions wrongly, with bad thermo-contact
between the CPU and the headsink, resulting in high themperatures and
system instability.

And even more interesting -- it seems that some sequence of instructions
are more frequently misinterpreted (under "abnormal" conditions above)
than other sequences doing the same thing.  That is, the same program
compiled with gcc-3.4 may work almost 100% correct while the same thing
compiled with gcc-4.1 may almost alway fail (usually due to segmentation
fault), or exactly the opposite.

So umm.... ;)

I'm running VIA C7 on this machine where I'm typing right now - no single
glitch since the time I replaced the failing one (at a time of mentioned
thread), it's rock-solid.  I even removed the fan from the headsink - the
themp grows up to 70..80 degrees celsius (according to lm-sensors, so actual
themperature should be higher) when I run CPU-intensive apps, and nothing
breaks.  Previous motherboard which I replaced (the same model, from the
same batch) was breaking randomly, but worked relatively stable when
placed on the street and with a large "external" fan used in rooms for
ventilation... ;)  even without any load when onboard sensors showed 35
degrees.

That to say - it may be some miscompilations, but may be some probs with
hardware itself.  If you can, try to reproduce the same on another board
(I just tried to boot 2.6.23-rc5 on this machine, compiled for PIII CPU
using gcc-4.1.2 (no other version installed, sorry) - no issues so far).

And no, I'm not trying to say "don't use ViA C7" etc -- I just love this
my box, it's very good, powerful enouth and quiet.  Just be prepared for
some... issues, which happens - rarely but still.

/mjt

