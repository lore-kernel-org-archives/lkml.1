Return-Path: <linux-kernel-owner+w=401wt.eu-S965672AbXCBVcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965672AbXCBVcU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 16:32:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965673AbXCBVcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 16:32:20 -0500
Received: from nigel.suspend2.net ([203.171.70.205]:49333 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965672AbXCBVcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 16:32:19 -0500
Subject: Re: Resume from S2R fails after dpm_resume()
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Tim Gardner <timg@tpi.com>
Cc: Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
       Ben Collins <ben.collins@ubuntu.com>
In-Reply-To: <45E833ED.2070402@tpi.com>
References: <45E5E799.1000502@tpi.com> <20070302141259.GJ2156@elf.ucw.cz>
	 <45E833ED.2070402@tpi.com>
Content-Type: text/plain
Date: Sat, 03 Mar 2007 08:32:19 +1100
Message-Id: <1172871139.18544.87.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Fri, 2007-03-02 at 07:25 -0700, Tim Gardner wrote:
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

Tim, it's possible that the problem you're seeing is completely
different to the one Pavel is looking for. Given that you're down to
looking in console write code, I wonder if it's related to the changes
to console suspending that were done around that time. I'd suggest
either looking in LKML or Linux-PM archives for a commit related to
suspending the console, or doing your git bisect.

Regards,

Nigel

