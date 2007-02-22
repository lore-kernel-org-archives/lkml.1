Return-Path: <linux-kernel-owner+w=401wt.eu-S1751535AbXBVSNc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751535AbXBVSNc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 13:13:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751479AbXBVSNc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 13:13:32 -0500
Received: from mail.kroah.org ([69.55.234.183]:55088 "EHLO perch.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751535AbXBVSNb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 13:13:31 -0500
Date: Thu, 22 Feb 2007 10:09:41 -0800
From: Greg KH <greg@kroah.com>
To: David Brownell <david-b@pacbell.net>
Cc: rtc-linux@googlegroups.com,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-pm@lists.osdl.org, Andrew Morton <akpm@linux-foundation.org>,
       Alessandro Zummo <alessandro.zummo@towertech.it>,
       john stultz <johnstul@us.ibm.com>
Subject: Re: [patch/rfc 0/6] rtc framework: remove class_device, use class suspend()/resume()
Message-ID: <20070222180941.GA15289@kroah.com>
References: <200702211945.15003.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702211945.15003.david-b@pacbell.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 21, 2007 at 07:45:14PM -0800, David Brownell wrote:
> Hi,
> 
> Following this message (on the RTC list) are six patches:
> 
>  - Remove the /sys/class/rtc-dev class_device, and a class_interface
>  - Use "struct rtc_device" in the external interface, not class_device
>  - Simplify the sysfs attribute handling, removing a class_interface
>  - Simplify the /proc/driver/rtc handling, removing the last class_interface
>  - Remove the class_device in "struct rtc_device"; now suspend()/resume() work
>  - Implement class suspend()/resume() so the system clock is updated on resume
> 
> The main point of this series of patches is that last one, which I'll
> circulate just a bit more widely.  (Although I think the first four are
> also nice cleanups!)   It might be the first example of a framework that
> uses the "new" class level suspend()/resume() calls to offload drivers.
> 
> Other than actually using that new PM infrastructure, this series should
> be interesting since it addresses one of the few remaining obstacles to
> having the "Generic Time-Of-Day" (GTOD) framework be fully generic, in
> the sense of working with whatever RTC is available on the platform (which
> includes ones accessed through I2C or SPI, so that spinlocked access is
> insufficient) and removing arch-specific RTC hooks.
> 
> This has been lightly tested on one of the ARMs that doesn't yet have
> new-style dynamic tick working.  I'm sure fault paths need tweaking yet.

All of these looks good to me, feel free to add an:
	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
to them if you want.

thanks for doing the class_device removal work, I appreciate it.

greg k-h
