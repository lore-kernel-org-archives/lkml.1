Return-Path: <linux-kernel-owner+w=401wt.eu-S932774AbXAYLc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932774AbXAYLc6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 06:32:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932831AbXAYLc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 06:32:58 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:46812 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932774AbXAYLc5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 06:32:57 -0500
Date: Thu, 25 Jan 2007 12:32:33 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>, Greg KH <gregkh@suse.de>
Subject: Re: [patch] suspend/resume debugging: device filter
Message-ID: <20070125113233.GC23343@elf.ucw.cz>
References: <20070125110501.GA25151@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070125110501.GA25151@elte.hu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Subject: [patch] suspend/resume debugging: device filter
> From: Ingo Molnar <mingo@elte.hu>
> 
> this patch implements the /sys/power/filter attribute, which takes a 
> string. If a device's name matches the filter string (exactly), then 
> that device is excluded from suspend/resume.
> 
> this can be helpful in a number of ways when debugging suspend and 
> resume problems:
> 
>  - if CONFIG_DISABLE_CONSOLE_SUSPEND is used then the serial
>    console is still suspended after which point there's no
>    log output. Doing "echo serial > /sys/power/filter" keeps
>    the serial port active, so any messages (and crash info)
>    after that point is displayed.
> 
>  - if a device is suspected to be the reason of resume failure
>    then it can be excluded via the filter. That device obviously
>    wont work, but users can thus help us debug resume problems
>    in combination with pm_trace, without having to hack the kernel.
> 
> (note that you can obvious break suspend/resume via the filter, by 
> excluding a vital device - so it is only to be used when suspend or 
> resume is broken to begin with.)

Should this go to Documentation/power?

> it might be better to do this centrally in sysfs, via a per-device 
> attribute, to individually enable suspend and resume on a per device 
> basis, but my sysfs-fu is not strong enough for that now ;-)

Yep, I think it should go to per-device attribute. Also it would be
nice to name it somehow like debug_suspend_filter or something, so
that people have less tendency to play with it.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
