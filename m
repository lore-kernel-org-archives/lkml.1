Return-Path: <linux-kernel-owner+w=401wt.eu-S1758259AbYBRKy1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758259AbYBRKy1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 05:54:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755417AbYBRKyU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 05:54:20 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:57742 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754654AbYBRKyT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 05:54:19 -0500
Date: Mon, 18 Feb 2008 11:54:41 +0100
From: Pavel Machek <pavel@ucw.cz>
To: David Brownell <david-b@pacbell.net>
Cc: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: WARN_ON(): proc_dir_entry 'rtc' already registered
Message-ID: <20080218105441.GE7198@elf.ucw.cz>
References: <20080212132626.GA1534@elf.ucw.cz> <200802121029.08007.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802121029.08007.david-b@pacbell.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > I'm getting this during bootup:
> > 
> > PM: Adding info for No Bus:event6
> > PM: Adding info for No Bus:uinput
> > PM: Adding info for No Bus:rtc0
> > proc_dir_entry 'rtc' already registered
> > Pid: 1, comm: swapper Not tainted 2.6.25-rc1 #125
> >  ... deletia
> >  =======================
> > rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
> > rtc0: alarms up to one month, y3k
> > PM: Adding info for platform:coretemp.0
> > PM: Adding info for No Bus:hwmon1
> > 
> > ... .config attached.
> 
> Which shows:
> 
>  CONFIG_GEN_RTC=y
>  CONFIG_GEN_RTC_X=y
> 
> Disable that, then those warnings will vanish.  (I'm told that
> having proc_register() return a fault code is off the table,
> much like impeachment.)

Ok.

> How to fix ... how about:  instead of just warning folk
> off such legacy RTC drivers [1] we just wrap them with
> an "if RTC_LIB != n" so this mistake won't be possible.

Yes, disabling bad configs in Kconfig seems like way to go.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
