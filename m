Return-Path: <linux-kernel-owner+w=401wt.eu-S1752346AbXCFIcf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752346AbXCFIcf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 03:32:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752935AbXCFIcf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 03:32:35 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:58983 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752346AbXCFIce (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 03:32:34 -0500
Date: Tue, 6 Mar 2007 09:32:24 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Kconfig: Update swsusp description
Message-ID: <20070306083224.GE2040@elf.ucw.cz>
References: <200703041514.44680.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703041514.44680.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Index: linux-2.6.21-rc2/kernel/power/Kconfig
> ===================================================================
> --- linux-2.6.21-rc2.orig/kernel/power/Kconfig	2007-02-28 23:54:45.000000000 +0100
> +++ linux-2.6.21-rc2/kernel/power/Kconfig	2007-03-04 11:50:48.000000000 +0100
> @@ -81,30 +81,35 @@ config SOFTWARE_SUSPEND
>  	bool "Software Suspend"
>  	depends on PM && SWAP && ((X86 && (!SMP || SUSPEND_SMP)) || ((FRV || PPC32) && !SMP))
>  	---help---
> +	  Enable the suspend to disk (STD) functionality.
>  
> +	  You can suspend your machine with 'echo disk > /sys/power/state'.
> +	  Alternatively, you can use the additional userland tools available
> +	  from <http://suspend.sf.net>.
> +
> +	  In principle it does not require ACPI or APM, although for example
> +	  ACPI will be used if available.
> +
> +	  It creates an image which is saved in your active swap. Upon the next
>  	  boot, pass the 'resume=/dev/swappartition' argument to the kernel to

Actually, these days resume=... on kernel command line needs to be
there for suspend, too, IIRC.

> +	  Right now you may boot without resuming and resume later but in the
> +	  meantime you cannot use the swap partition(s)/file(s) involved in
> +	  suspending.  Also in this case you must not use the

I'd prefer not to encourage this use. It has too many traps ready for
people.

Otherwise looks ok.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
