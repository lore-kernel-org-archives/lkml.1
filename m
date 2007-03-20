Return-Path: <linux-kernel-owner+w=401wt.eu-S1751955AbXCTWBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955AbXCTWBt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 18:01:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751958AbXCTWBt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 18:01:49 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:52864 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751955AbXCTWBt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 18:01:49 -0400
Date: Tue, 20 Mar 2007 23:01:43 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] swsusp: Fix SNAPSHOT_S2RAM ioctl
Message-ID: <20070320220143.GI3545@elf.ucw.cz>
References: <200703202248.08665.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703202248.08665.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> The SNAPSHOT_S2RAM ioctl does not disable the nonboot CPUs before entering
> the suspend, although it should do this.
> 
>  		} else {
> -			/* Enter S3, system is already frozen */
> -			suspend_enter(PM_SUSPEND_MEM);
> -
> +			error = disable_nonboot_cpus();
> +			if (!error) {
> +				/* Enter S3, system is already frozen */
> +				suspend_enter(PM_SUSPEND_MEM);
> +				enable_nonboot_cpus();
> +			}
>  			/* Wake up devices */
>  			device_resume();
>  		}

Looks ok to me. ACK.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
