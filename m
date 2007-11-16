Return-Path: <linux-kernel-owner+w=401wt.eu-S1762287AbXKPUl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762287AbXKPUl7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 15:41:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752465AbXKPUlv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 15:41:51 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:35988 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752891AbXKPUlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 15:41:50 -0500
Date: Fri, 16 Nov 2007 12:37:48 -0800
From: Greg KH <greg@kroah.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: David Woodhouse <dwmw2@infradead.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Driver core: fix race in __device_release_driver
Message-ID: <20071116203748.GA11770@kroah.com>
References: <Pine.LNX.4.44L0.0711161151340.3268-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0711161151340.3268-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2007 at 11:57:28AM -0500, Alan Stern wrote:
> This patch (as1013) was suggested by David Woodhouse; it fixes a race
> in the driver core.  If a device is unregistered at the same time as
> its driver is unloaded, the driver's code pages may be unmapped while
> the remove method is still running.  The calls to get_driver() and
> put_driver() were intended to prevent this, but they don't work if the
> driver's module count has already dropped to 0.
> 
> Instead, the patch keeps the device on the driver's list until after
> the remove method has returned.  This forces the necessary
> synchronization to occur.

Is this something that you all feel is worth getting in for 2.6.24?
Does it fix a regression that just showed up, or is just a bugfix for
something that people finally realized has always been there?

Can it wait for 2.6.25 to get some more testing in -mm?

thanks,

greg k-h
