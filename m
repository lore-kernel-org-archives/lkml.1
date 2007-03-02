Return-Path: <linux-kernel-owner+w=401wt.eu-S2992493AbXCBOjr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992493AbXCBOjr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 09:39:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992491AbXCBOjr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 09:39:47 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:35371 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S2992490AbXCBOjq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 09:39:46 -0500
Date: Fri, 2 Mar 2007 15:39:34 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Tim Gardner <timg@tpi.com>
Cc: nigel@nigel.suspend2.net, linux-kernel@vger.kernel.org,
       Ben Collins <ben.collins@ubuntu.com>
Subject: Re: Resume from S2R fails after dpm_resume()
Message-ID: <20070302143934.GN2156@elf.ucw.cz>
References: <45E5E799.1000502@tpi.com> <20070302141259.GJ2156@elf.ucw.cz> <45E833ED.2070402@tpi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45E833ED.2070402@tpi.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2007-03-02 07:25:49, Tim Gardner wrote:
> Pavel Machek wrote:
> > Hi!
> > 
> >> I instrumented 2.6.21-rc1 base/power/resume.c device_resume() with
> >> TRACE_RESUME(0) as the last statement in the function. Sure enough it
> >> was the last hash value in the RTC after a hard reboot when resume failed:
> >>
> >> [   12.028820]   hash matches drivers/base/power/resume.c:104
> >>
> >> The machine appears to be absolutely wedged after initiating resume by
> >> pressing the power button. The disk flashes for a half second or so,
> >> then thats it.
> >>
> >> It is a Dell XPS, BIOS rev A04. I'm using 'echo 1 > /sys/power/pm_trace;
> >> echo mem > /sys/power/state' to initiate the S2R sequence.
> >>
> >> Any suggestions on where to go from here?
> > 
> > Did it work ok in 2.6.20? Can you try to get video working/get serial
> > console/something?
> > 									Pavel
> 
> Pavel,
> 
> The last version that worked well was Ubuntu Edgy (2.6.17). It was
> broken by 2.6.18. I have not started the 'git bisect' process, instead
> I've been trying to figure out why it doesn't work in 2.6.21-rc2. Using
> the TRACE_RESUME macro I've drilled down to
> kernel/printk.c:__call_console_drivers. So far the last trace info that
> I have is just before the call to con->write(). I'm trying to figure out
> what driver has registered as the console (intel_agp or agpgart?).
> 
> Am I banging my head on a known problem?

2.6.21-rc* is known broken (in more than 1 way). I'd suggest playing
with 2.6.20.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
