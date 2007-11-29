Return-Path: <linux-kernel-owner+w=401wt.eu-S932857AbXK2TBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932857AbXK2TBo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 14:01:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759497AbXK2TBf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 14:01:35 -0500
Received: from rtr.ca ([76.10.145.34]:2859 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758684AbXK2TBe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 14:01:34 -0500
Message-ID: <474F0C8D.3090604@rtr.ca>
Date: Thu, 29 Nov 2007 14:01:33 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Raymano Garibaldi <raymano@faunos.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>,
       kirk@faunos.com
Subject: Re: [linux-usb-devel] [BUG] USB_PERSIST
References: <Pine.LNX.4.44L0.0711291102290.4516-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0711291102290.4516-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> On Thu, 29 Nov 2007, Raymano Garibaldi wrote:
> 
>> The feature does work as long as the device remains plugged in and
>> that is what I have said in my previous postings too. What I'm saying
>> that should work and worked under 2.6.21 and is not working currently
>> is the ability to unplug and plug back in the device while the
>> computer is suspended before resuming without losing the mount.
> 
> Okay, guess I misunderstood what you wrote before.
> 
> The patch below for 2.6.23 should do what you want (and more besides).  
> It forces the USB Persist feature to apply to all persist-enabled 
> devices, whether they were unplugged or not.
> 
> There's no chance of this getting accepted into the official kernel in 
> such a simple form, but at least it will allow you to do what you want.
> 
> Alan Stern
> 
> 
> --- 2.6.23/drivers/usb/core/driver.c1	2007-11-29 10:57:36.000000000 -0500
> +++ 2.6.23/drivers/usb/core/driver.c	2007-11-29 11:01:44.000000000 -0500
> @@ -1550,6 +1550,9 @@
>  		if (!(udev->reset_resume && udev->do_remote_wakeup))
>  			return -EPERM;
>  	}
> +
> +	/* Force all system resumes to be reset-resumes */
> +	udev->reset_resume = 1;
>  	return usb_external_resume_device(udev);
>  }
..

Mmm.. how about a nice sysfs attr that the suspend scripts can write
that value to as needed ?
