Return-Path: <linux-kernel-owner+w=401wt.eu-S1760165AbYBXS16@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760165AbYBXS16 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 13:27:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756884AbYBXS1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 13:27:31 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3387 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752434AbYBXS1a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 13:27:30 -0500
Date: Sun, 24 Feb 2008 19:21:21 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Pierre Ossman <drzeus-mmc@drzeus.cx>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [Bug 10030] Suspend doesn't work when SD card is inserted
Message-ID: <20080224182120.GB3886@ucw.cz>
References: <200802240119.51935.rjw@sisk.pl> <Pine.LNX.4.44L0.0802232143050.29968-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0802232143050.29968-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Index: usb-2.6/drivers/base/power/main.c
> ===================================================================
> --- usb-2.6.orig/drivers/base/power/main.c
> +++ usb-2.6/drivers/base/power/main.c
> @@ -25,6 +25,7 @@
>  #include <linux/pm.h>
>  #include <linux/resume-trace.h>
>  #include <linux/rwsem.h>
> +#include <linux/sched.h>
>  
>  #include "../base.h"
>  #include "power.h"
> @@ -59,6 +60,13 @@ static DECLARE_RWSEM(pm_sleep_rwsem);
>  
>  int (*platform_enable_wakeup)(struct device *dev, int is_on);
>  
> +static struct task_struct *suspending_task;

What locking protects this variable? What happens when suspending_task
exits? (Hmm, that would probably be bug, anyway?)

Or are we running UP when this is accessed? This at least needs a big
fat comment.

> +bool in_suspend_context(void)
> +{
> +	return (suspending_task == current);
> +}


							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
