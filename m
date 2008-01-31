Return-Path: <linux-kernel-owner+w=401wt.eu-S934348AbYAaXMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934348AbYAaXMS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 18:12:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755385AbYAaXMF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 18:12:05 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:57025 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755547AbYAaXME (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 18:12:04 -0500
Date: Fri, 1 Feb 2008 00:12:19 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: swsusp on an AMD x2-64, 2.6.24: regression?
Message-ID: <20080131231219.GA14355@elf.ucw.cz>
References: <47A24072.4090001@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47A24072.4090001@msgid.tls.msk.ru>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2008-02-01 00:41:06, Michael Tokarev wrote:
> Since I upgraded from 2.6.23 to 2.6.24, suspend to
> disk does not work anymore on this machine.  I'm
> trying to debug this now, for several hours already,
> without much luck so far.
> 
> The machine is based on AMD X2-64 (BE-2400) CPU and
> NVidia MCP51PV (GeForce 6150/NForce 430) chipset.
> 
> Up until 2.6.23 (both 32- and 64-bit kernels), suspend/
> resume worked just fine without any glitch.
> 
> With 2.6.24, it tries to suspend, saves pages to disk,
> when prints this:
> 
> ..Saving pages... done.
> Sl
> Suspending console(s)
> _
> 
> At this point, nothing more happens.  It does not
> react to keyboard or to any other external events,
> only reset/poweroff helps.  Note the "Sl" stuff -
> I guess it's a beginning of some message, but I
> don't know which one.
> 
> After a hard reboot after that, the system resumes
> from the saved image.
> 
> This happens with both 32- and 64-bits kernels, when
> using either good'old `echo disk > /sys/power/state'
> or when using s2disk from uswsusp (with 32bits kernel,
> as this utility does not work with 64bits kernel when
> compiled as 32bits application).  Note that when using
> s2disk with 2.6.24, very similar picture is shown -
> that same "Sl" line.
> 
> The only noticeable changes in my config (x86-64 one)
> compared with the one from 2.6.23 is - I enabled tickless
> (dyntics) and high-res timers, CPU_IDLE and FAIR_CGROUP_SCHED.
> I recompiled the kernel without those options (on by one), --
> the effect on suspend is exactly the same.
> 
> Is there anything I can do to further diagnose this?

no_console_suspend (sp?), nohz=off, highres=off, and try with minimum
config.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
