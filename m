Return-Path: <linux-kernel-owner+w=401wt.eu-S1759717AbXIMOwP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759717AbXIMOwP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 10:52:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755121AbXIMOv7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 10:51:59 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:47221 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754769AbXIMOv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 10:51:58 -0400
Date: Thu, 13 Sep 2007 16:52:07 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Greg KH <gregkh@suse.de>
Cc: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net,
       Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oneukum@suse.de>
Subject: Re: [GIT PATCH] USB autosuspend fixes for 2.6.23-rc6
Message-ID: <20070913145207.GF3563@stusta.de>
References: <20070913133321.GA6362@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070913133321.GA6362@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2007 at 06:33:21AM -0700, Greg KH wrote:
> It turns out that USB devices suck when it comes to powermanagement
> issues :(
> 
> A number of patches have been submitted near the end of this kernel
> release cycle that add new device ids to the quirk table in the kernel
> to disable autosuspend for specific devices.  However, a number of
> developers are very worried that even with the testing that has been
> done, once 2.6.23 is released, we are going to get a whole raft of angry
> users when their devices break in nasty ways.
> 
> As an example, it seems that almost 2/3 of all USB printers just can not
> handle autosuspend.  And there's a _lot_ of USB printers out there...
> 
> When researching how other operating systems handle this, it was found
> out that they use a whitelist of devices that are able to properly
> suspend.  So, in the future, that is how we are going to handle this.
> 
> These two patches address the need today to have users machines still
> work, even if they might draw more power than they possibly could (which
> is not any more than they did in 2.6.22.)
> 
> These patches do two things:
>   - disable USB autosuspend on all devices except for USB hubs.  This
>     can be easily overridden by userspace to turn on autosuspend for
>     devices that a user wants to.  HAL will use a whitelist in the
>     future for these types of devices.
>...

Not related to the patch for 2.6.23, but I have a gut feeling that 
something might be done the wrong way later:

If I understand you correctly, you are saying that I will have to 
install HAL for getting a whitelist for in-kernel functionality?

It is a good thing if userspace can add currently missing devices to
whitelists, but the whitelist itself should be in the kernel.

> thanks,
> 
> greg k-h
>...

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

