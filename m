Return-Path: <linux-kernel-owner+w=401wt.eu-S1754225AbXIMJjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225AbXIMJjq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 05:39:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750836AbXIMJji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 05:39:38 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:41435 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbXIMJjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 05:39:37 -0400
Date: Thu, 13 Sep 2007 02:40:09 -0700
From: Greg KH <greg@kroah.com>
To: Mark Lord <lkml@rtr.ca>
Cc: Oliver Neukum <oliver@neukum.org>, Paolo Ornati <ornati@fastwebnet.it>,
       linux-usb-devel@lists.sourceforge.net,
       Alan Stern <stern@rowland.harvard.edu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@osdl.org>
Subject: Re: [linux-usb-devel] spontaneous disconnect with "usb-storage:
	implement autosuspend"
Message-ID: <20070913094009.GA25070@kroah.com>
References: <20070814131557.5653d991@localhost> <200708141746.16958.oliver@neukum.org> <20070814183857.28997de1@localhost> <200708142033.23158.oliver@neukum.org> <46E864AC.1020000@rtr.ca> <20070912234016.GA455@kroah.com> <46E8A18C.8080607@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46E8A18C.8080607@rtr.ca>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2007 at 10:33:48PM -0400, Mark Lord wrote:
> Greg KH wrote:
>>
>> There are many regressions right now, _ONLY_ if you enable
>> CONFIG_USB_SUSPEND.  If you disable that, your problems will go away,
>> right?
> ..
>> Oh, and currently no distro will enable this option due to the hardware
>> problems, so the only people that could get hit by this are those who
>> build their own kernels, and they can easily disable the option.
>
> Ubuntu has CONFIG_USB_SUSPEND=y

They also have a patch that disables suspend automatically for all
devices except USB hubs.  Same goes for Red Hat's rawhide kernel.

> There are probably lots of other distros that use it as well.

Not without the above mentioned patch they do not :)

> This new behaviour (failed operation of USB flash keys) is a *new* 
> regression
> in 2.6.23, and we still have time to fix it by either reverting the changed
> functionality, or by changing the code to default OFF.

I now agree.

> Here's my patch for 2.6.23-rc6+ :
>
> Fix USB Storage failures.
>
> Signed-Off-By:  Mark Lord <mlord@pobox.com>

That's way too simple, I want to revert the whole usb-storage suspend
logic as Oliver has found some core problems with it working properly,
even with devices that have no problems.

Is that ok for you?

thanks,

greg k-h
