Return-Path: <linux-kernel-owner+w=401wt.eu-S1754997AbXE3PiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997AbXE3PiR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 11:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752172AbXE3PiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 11:38:05 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2996 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751681AbXE3PiD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 11:38:03 -0400
Date: Wed, 30 May 2007 15:37:40 +0000
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Oliver Neukum <oliver@neukum.org>
Subject: Re: [RFC][PATCH -mm 1/3] PM: Hibernation and suspend notifiers
Message-ID: <20070530153740.GA4772@ucw.cz>
References: <Pine.LNX.4.44L0.0705281155270.22682-100000@netrider.rowland.org> <200705300024.32455.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705300024.32455.rjw@sisk.pl>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> +Suspend notifiers
> +	(C) 2007 Rafael J. Wysocki <rjw@sisk.pl>, GPL
> +
> +There are some operations that device drivers may want to carry out in their
> +.suspend() routines, but shouldn't, because they can cause the hibernation or
> +suspend to fail. For example, a driver may want to allocate a substantial amount
> +of memory (like 50 MB) in .suspend(), but that shouldn't be done after the
> +swsusp's memory shrinker has run.
> +
> +Also, there may be some operations, that subsystems want to carry out before a
> +hibernation/suspend or after a restore/resume, requiring the system to be fully
> +functional, so the drivers' .suspend() and .resume() routines are not suitable
> +for this purpose.  For example, device drivers may want to upload firmware to
> +their devices after a restore from a hibernation image, but they cannot do it by
> +calling request_firmware() from their .resume() routines (user land processes
> +are frozen at this point).  The solution may be to load the firmware into
> +memory before processes are frozen and upload it from there in the .resume()
> +routine.  Of course, a hibernation notifier may be used for this purpose.
> +
> +The subsystems that have such needs can register suspend notifiers that will be
> +called upon the following events by the suspend core:
> +
> +PM_PRE_FREEZE		The system is going to hibernate or suspend, tasks will
> +			be frozen immediately

Hmm, looks like bad idea if we are going to remove freezer from
suspend...?

> +PM_POST_THAW		Tasks have just been thawed after a resume or restore
> +			from a hibernation image
> +
> +PM_HIBERNATION_PREPARE	The system is preparing for hibernation.  Tasks have
> +			been frozen, memory is going to be freed and devices
> +			are going to be suspended.

Is not PRE_FREEZE enough? We can allocate memory for drivers there,
too...

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
