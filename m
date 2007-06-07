Return-Path: <linux-kernel-owner+w=401wt.eu-S1757536AbXFGMX2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757536AbXFGMX2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 08:23:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754150AbXFGMXS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 08:23:18 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3567 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754115AbXFGMXR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 08:23:17 -0400
Date: Thu, 7 Jun 2007 12:23:04 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Olaf Dietsche <olaf+list.linux-acpi@olafdietsche.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [2.6.22-rc3][ACPI?] Resume from s2r doesn't work.
Message-ID: <20070607122303.GA8938@ucw.cz>
References: <878xb35sje.fsf@goat.bogus.local> <200706012340.54394.rjw@sisk.pl> <87hcpr2ubl.fsf@goat.bogus.local> <200706020037.16615.rjw@sisk.pl> <87wsykpweu.fsf@goat.bogus.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wsykpweu.fsf@goat.bogus.local>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Second, you can use PM_TRACE (Documentation/power/s2ram.txt) to find the
> > place where it really fails.
> 
> First I augmented my minimal config kernel with some TRACE_RESUME()s:
> 
> --- a/kernel/power/main.c	2007-05-27 23:48:05.000000000 +0200
> +++ b/kernel/power/main.c	2007-06-03 22:28:46.000000000 +0200
> @@ -223,6 +223,7 @@
>  	pr_debug("PM: Finishing wakeup.\n");
>  	suspend_finish(state);
>   Unlock:
> +	TRACE_RESUME(error);
>  	mutex_unlock(&pm_mutex);
>  	return error;
>  }
> @@ -303,6 +304,7 @@
>  		error = enter_state(state);
>  	else
>  		error = -EINVAL;
> +	TRACE_RESUME(error);
>  	return error ? error : n;
>  }
...
> I got alternating
>   hash matches drivers/base/power/resume.c:58
> and
>   hash matches kernel/power/main.c:307
> 
> > First, you can check if the patch
> >
> > http://www.sisk.pl/kernel/hibernation_and_suspend/2.6.22-rc3/patches/20-ACPI-preserve-the-ebx-value-in-acpi_copy_wakeup_routine.patch
> 
> Then I applied this patch, but it doesn't change anything.
> 
> But either way the script never reaches "shutdown -rn now". So, it
> seems, that my laptop does a full resume every other reboot, but it
> never returns to userspace.

But it returns to kernel... can you use more trace points to figure
out where it hangs?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
