Return-Path: <linux-kernel-owner+w=401wt.eu-S965367AbXCBO4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965367AbXCBO4c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 09:56:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965366AbXCBO4c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 09:56:32 -0500
Received: from adelie.ubuntu.com ([82.211.81.139]:36354 "EHLO
	adelie.ubuntu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965367AbXCBO4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 09:56:31 -0500
Subject: Re: Resume from S2R fails after dpm_resume()
From: Ben Collins <ben.collins@ubuntu.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Tim Gardner <timg@tpi.com>, nigel@nigel.suspend2.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070302143934.GN2156@elf.ucw.cz>
References: <45E5E799.1000502@tpi.com> <20070302141259.GJ2156@elf.ucw.cz>
	 <45E833ED.2070402@tpi.com>  <20070302143934.GN2156@elf.ucw.cz>
Content-Type: text/plain
Date: Fri, 02 Mar 2007 09:55:45 -0500
Message-Id: <1172847345.5821.42.camel@gullible>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-02 at 15:39 +0100, Pavel Machek wrote:
> On Fri 2007-03-02 07:25:49, Tim Gardner wrote:
> > Pavel Machek wrote:
> > > Hi!
> > > 
> > >> I instrumented 2.6.21-rc1 base/power/resume.c device_resume() with
> > >> TRACE_RESUME(0) as the last statement in the function. Sure enough it
> > >> was the last hash value in the RTC after a hard reboot when resume failed:
> > >>
> > >> [   12.028820]   hash matches drivers/base/power/resume.c:104
> > >>
> > >> The machine appears to be absolutely wedged after initiating resume by
> > >> pressing the power button. The disk flashes for a half second or so,
> > >> then thats it.
> > >>
> > >> It is a Dell XPS, BIOS rev A04. I'm using 'echo 1 > /sys/power/pm_trace;
> > >> echo mem > /sys/power/state' to initiate the S2R sequence.
> > >>
> > >> Any suggestions on where to go from here?
> > > 
> > > Did it work ok in 2.6.20? Can you try to get video working/get serial
> > > console/something?
> > > 									Pavel
> > 
> > Pavel,
> > 
> > The last version that worked well was Ubuntu Edgy (2.6.17). It was
> > broken by 2.6.18. I have not started the 'git bisect' process, instead
> > I've been trying to figure out why it doesn't work in 2.6.21-rc2. Using
> > the TRACE_RESUME macro I've drilled down to
> > kernel/printk.c:__call_console_drivers. So far the last trace info that
> > I have is just before the call to con->write(). I'm trying to figure out
> > what driver has registered as the console (intel_agp or agpgart?).
> > 
> > Am I banging my head on a known problem?
> 
> 2.6.21-rc* is known broken (in more than 1 way). I'd suggest playing
> with 2.6.20.

It's broken for him in 2.6.20 too, which led him to test 2.6.21-rc, and
some vanilla kernels back to 2.6.18. Everything past 2.6.17 is broken
for him.

-- 
Ubuntu:    http://www.ubuntu.com/
Linux1394: http://www.linux1394.org/

