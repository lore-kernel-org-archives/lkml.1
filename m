Return-Path: <linux-kernel-owner+w=401wt.eu-S1756602AbZCEQzR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756602AbZCEQzR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 11:55:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756716AbZCEQyr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 11:54:47 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44857 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692AbZCEQyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 11:54:46 -0500
Date: Thu, 5 Mar 2009 17:54:30 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][PATCH 1/2] PM: Split up sysdev_[suspend|resume] from
	device_power_[down|up]
Message-ID: <20090305165430.GC1379@ucw.cz>
References: <200902221837.49396.rjw@sisk.pl> <200902221838.51548.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902221838.51548.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Move the sysdev_suspend/resume from the callee to the callers, with
> no real change in semantics, so that we can rework the disabling of
> interrupts during suspend/hibernation.
> 
> This is based on an earlier patch from Linus.

> Index: linux-2.6/drivers/base/power/main.c
> ===================================================================
> --- linux-2.6.orig/drivers/base/power/main.c
> +++ linux-2.6/drivers/base/power/main.c
> @@ -333,7 +333,6 @@ static void dpm_power_up(pm_message_t st
>   */
>  void device_power_up(pm_message_t state)
>  {
> -	sysdev_resume();
>  	dpm_power_up(state);
>  }

And at this point we can rename dpm_power_up -> device_power_up. Good.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
