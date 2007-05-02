Return-Path: <linux-kernel-owner+w=401wt.eu-S1767186AbXEBW4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767186AbXEBW4h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 18:56:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767184AbXEBW4h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 18:56:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60580 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767177AbXEBW4g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 18:56:36 -0400
Message-ID: <46391716.9040001@redhat.com>
Date: Wed, 02 May 2007 18:56:22 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: Marcos Pinto <markybob@gmail.com>, Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alessandro Zummo <a.zummo@towertech.it>
Subject: Re: Mysterious RTC hangs on x86_64 - fixed, sort of
References: <46391253.30201@vmware.com>
In-Reply-To: <46391253.30201@vmware.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden wrote:
> With this patch, /sbin/hwclock no longer hangs my AMD64 machine when run
> after reaching multiuser.  What I don't understand is why.  I have the
> RTC based sound sequencer timer as a module, but not loaded, and the
> error message I added to indicate broken rtc control does not fire.
> 
> So why is it that if I stop taking the rtc_task_lock and issuing the
> callbacks which should never be held or exist that my system no longer
> hard freezes?
> 
> --- /tmp/a      2007-05-03 15:36:07.451256181 -0700
> +++ drivers/char/rtc.c  2007-05-03 15:27:49.000000000 -0700
> @@ -265,10 +265,10 @@
>         spin_unlock (&rtc_lock);
>  
>         /* Now do the rest of the actions */
> -       spin_lock(&rtc_task_lock);
> -       if (rtc_callback)
> -               rtc_callback->func(rtc_callback->private_data);
> -       spin_unlock(&rtc_task_lock);
> +/*     spin_lock(&rtc_task_lock); */
> +//     if (rtc_callback)
> +//             rtc_callback->func(rtc_callback->private_data);
> +/*     spin_unlock(&rtc_task_lock); */
>         wake_up_interruptible(&rtc_wait);       

Try leaving the spinlocks and just disabling the callbacks. And maybe
enable spinlock debugging...

> 
> CONFIG_HPET_EMULATE_RTC=y

Did you try without that?

