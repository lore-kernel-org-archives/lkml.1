Return-Path: <linux-kernel-owner+w=401wt.eu-S1755860AbYJWPnG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860AbYJWPnG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 11:43:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752200AbYJWPmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 11:42:53 -0400
Received: from kroah.org ([198.145.64.141]:58922 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751561AbYJWPmw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 11:42:52 -0400
Date: Thu, 23 Oct 2008 08:22:16 -0700
From: Greg KH <greg@kroah.com>
To: "Gu, Mingkun" <Mingkun.Gu@GTECH.COM>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Help: undesired 10 seconds delay in creating USB devices
Message-ID: <20081023152216.GA3911@kroah.com>
References: <32C88E5279F5DD46B7237443CD61E67901E455B9@cspmail02.gtk.gtech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <32C88E5279F5DD46B7237443CD61E67901E455B9@cspmail02.gtk.gtech.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2008 at 11:22:08AM -0300, Gu, Mingkun wrote:
> Hi Gentlemen,
> 
> I upgraded my kernel version from 2.6.13.5 to 2.6.21.7. I noted a 10
> seconds delay in creating the device node under /dev for a hotplug USB
> device. The details are as follows:
> 
> 1) if the device driver is not loaded, the device driver will be loaded
> and a device name under /dev will be created immediately when I plug in
> my USB device (a finger button board);
> 
> 2) after the device driver has been loaded and unplugged the USB device
> from the system, a 10 seconds delay in creating a device name under /dev
> will be observed when I plug the device back into the system.

What are you using to test that a 10 second delay is present?

If you run 'udevadm monitor', does it show a 10 second delay?

Remember, for a usb-storage device, the kernel will wait at least 5
seconds before creating the block device for it as part of the "settle
the device down" delay.  If you don't like it, you can change that
parameter to be shorter, but you do so at your own risk.

thanks,

greg k-h
