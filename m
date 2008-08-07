Return-Path: <linux-kernel-owner+w=401wt.eu-S1755276AbYHGLJF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276AbYHGLJF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 07:09:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752455AbYHGJWn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 05:22:43 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54083 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbYHGJWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 05:22:43 -0400
Date: Thu, 7 Aug 2008 11:22:42 +0200
From: Pavel Machek <pavel@suse.cz>
To: Huang Ying <ying.huang@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, nigel@nigel.suspend2.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vivek Goyal <vgoyal@redhat.com>, mingo@elte.hu,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [PATCH 4/6] kexec jump: in sync with hibernation implementation
Message-ID: <20080807092241.GE372@atrey.karlin.mff.cuni.cz>
References: <1218099932.5164.35.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1218099932.5164.35.camel@caritas-dev.intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Add device_pm_lock() and device_pm_unlock() in kernel_kexec() to be
> in sync with current hibernation implementation.
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>
> 
> ---
>  kernel/kexec.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> --- a/kernel/kexec.c
> +++ b/kernel/kexec.c
> @@ -1457,6 +1457,7 @@ int kernel_kexec(void)
>  		error = disable_nonboot_cpus();
>  		if (error)
>  			goto Resume_devices;
> +		device_pm_lock();
>  		local_irq_disable();
>  		/* At this point, device_suspend() has been called,
>  		 * but *not* device_power_down(). We *must*
> @@ -1485,6 +1486,7 @@ int kernel_kexec(void)
>  		device_power_up(PMSG_RESTORE);
>   Enable_irqs:
>  		local_irq_enable();
> +		device_pm_unlock();
>  		enable_nonboot_cpus();
>   Resume_devices:
>  		device_resume(PMSG_RESTORE);
> 

Would it be possible to create common function for hibernation and
kexec? Keeping complex stuff like this in sync is ugly.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
