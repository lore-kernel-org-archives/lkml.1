Return-Path: <linux-kernel-owner+w=401wt.eu-S1751434AbXA0RF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751434AbXA0RF0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 12:05:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751881AbXA0RF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 12:05:26 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1996 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751614AbXA0RF0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 12:05:26 -0500
Date: Sat, 27 Jan 2007 13:17:29 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: David Brownell <david-b@pacbell.net>, linux-kernel@vger.kernel.org,
       gregkh@suse.de
Subject: Re: [PATCH] Fix /sys/device/.../power/state regression
Message-ID: <20070127131728.GB3942@ucw.cz>
References: <20061219185223.GA13256@srcf.ucam.org> <200612201318.06976.david-b@pacbell.net> <20061221012924.GC32625@srcf.ucam.org> <200612201904.28681.david-b@pacbell.net> <20061221040648.GA1499@srcf.ucam.org> <20070125050009.GA8672@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070125050009.GA8672@srcf.ucam.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> In 2.6.19, support for splitting driver suspend and resume callbacks 
> into interrupt and non-interrupt contexts was added. Unfortunately, this 
> broke /sys/device/.../power/state support for all devices. In the long 
> run, this should be obsoleted by power management support in the 
> individual drivers - however, in the case of network drivers (for 
> example), currently only three drivers implement any sort of useful 
> run-time power management.

Well... solution seems to be 'implement useful pm for more drivers'
not 'discourage people from doing so by re-enabling broken interface'.

> --- a/Documentation/feature-removal-schedule.txt
> +++ b/Documentation/feature-removal-schedule.txt
> @@ -9,7 +9,8 @@ be removed from this file.
>  What:	/sys/devices/.../power/state
>  	dev->power.power_state
>  	dpm_runtime_{suspend,resume)()
> -When:	July 2007
> +	bus->pm_has_noirq_stage()
> +When:	Once alternative functionality has been implemented

.../power/state never worked properly. You have been warned and it is
going to be removed. It oopses kernels... while 'only' providing power
savings. If you are interested in power savings, please help doing
them right.

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
