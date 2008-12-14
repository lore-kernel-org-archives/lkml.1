Return-Path: <linux-kernel-owner+w=401wt.eu-S1754011AbYLNElf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011AbYLNElf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 23:41:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752536AbYLNElY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 23:41:24 -0500
Received: from kroah.org ([198.145.64.141]:57696 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752533AbYLNElX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 23:41:23 -0500
Date: Sat, 13 Dec 2008 20:41:12 -0800
From: Greg KH <greg@kroah.com>
To: Keith Packard <keithp@keithp.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
Subject: Re: USB interrupt handler routine
Message-ID: <20081214044112.GA28733@kroah.com>
References: <1229056537.4137.10.camel@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1229056537.4137.10.camel@aiko.keithp.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<added linux-usb list, that's the proper place for it...)

On Thu, Dec 11, 2008 at 08:35:37PM -0800, Keith Packard wrote:
> We recently made a patch in the Intel DRM driver:
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=b60678a75d44fa9d5969f79781bd856ad5858609
> 
> This switches from non-MSI to MSI-mode.
> 
> It "should" have had no effect, but our concern is that what we're
> really seeing is interrupt sharing troubles. We've had several people
> say that they got an interrupt flood when plugging in a USB stick or
> external disk. Switching the graphics driver to MSI mode "cures" the
> bug, but that sure seems like a work-around rather than a bug fix to me.
> 
> When our driver is active, it can generate a lot of interrupts,
> potentially thousands per second. Is it possible that the UHCI or EHCI
> drivers could get confused if checking for interrupt status this often?
> 
> Eric noted that the USB driver appears to not check and ACK interrupt
> status unconditionally, preferring to check the software state
> beforehand. I'm wondering if this may open up a potential race between
> hardware state change and ISR bit setting.

Check what software state?  It shouldn't cause any race issues, but I'll
defer to David and Alan to concur this or not.

thanks,

greg k-h
