Return-Path: <linux-kernel-owner+w=401wt.eu-S936729AbYEBUhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936729AbYEBUhk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 16:37:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936843AbYEBUg5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 16:36:57 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:46281 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936839AbYEBUgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 16:36:55 -0400
Date: Fri, 2 May 2008 22:36:38 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Brownell <david-b@pacbell.net>, lkml <linux-kernel@vger.kernel.org>,
       Trent Piepho <tpiepho@freescale.com>,
       hartleys <hartleys@visionengravers.com>,
       Ben Nizette <bn@niasdigital.com>, Mike Frysinger <vapier.adi@gmail.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: Re: [patch/rfc 2.6.25-git] gpio: sysfs interface
Message-ID: <20080502203637.GG3956@ucw.cz>
References: <200804281239.51729.david-b@pacbell.net> <20080428134649.44cf239c.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080428134649.44cf239c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Simple sysfs interface for GPIOs.
> > 
> >     /sys/class/gpio
> >         /gpio-N ... for each exported GPIO #N
> > 	    /value ... always readable, writes fail except for output GPIOs
> > 	    /direction ... writable as: in, out (default low), high, low
> >     	/control ... to request a GPIO be exported or unexported
> > 
> > GPIOs may be exported by kernel code using gpio_export(), which should
> > be most useful for driver debugging.  Userspace may also ask that they
> > be exported by writing to the sysfs control file, helping to cope with
> > incomplete board support:
> > 
> >   echo "export 23" > /sys/class/gpio/control
> > 	... will gpio_request(23, "sysfs") and gpio_export(23); use
> > 	/sys/class/gpio/gpio-23/direction to configure it.
> >   echo "unexport 23" > /sys/class/gpio/control
> > 	... will gpio_free(23)
> 
> hm, does ths sysfs one-value-per-file rule apply to writes?

Having seen ibm acpi interface... yes, that rule should be aplied for
writes, too.

What about mkdir gpio-N to export it?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
