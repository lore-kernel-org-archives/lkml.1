Return-Path: <linux-kernel-owner+w=401wt.eu-S1751479AbXBVSNh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751479AbXBVSNh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 13:13:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751540AbXBVSNh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 13:13:37 -0500
Received: from mail.kroah.org ([69.55.234.183]:55104 "EHLO perch.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751479AbXBVSNg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 13:13:36 -0500
Date: Thu, 22 Feb 2007 10:13:15 -0800
From: Greg KH <greg@kroah.com>
To: Arkadiusz Miskiewicz <arekm@maven.pl>
Cc: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net,
       konstantin.a.karasyov@intel.com, len.brown@intel.com
Subject: Re: 2.6.21rc1 git usb mouse stops working after resume from ram
Message-ID: <20070222181315.GC15289@kroah.com>
References: <200702212314.56958.arekm@maven.pl> <20070221234905.GB7133@kroah.com> <200702221024.52551.arekm@maven.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702221024.52551.arekm@maven.pl>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 22, 2007 at 10:24:52AM +0100, Arkadiusz Miskiewicz wrote:
> On Thursday 22 of February 2007, Greg KH wrote:
> > On Wed, Feb 21, 2007 at 11:14:56PM +0100, Arkadiusz Miskiewicz wrote:
> > > Hello,
> > >
> > > Today version of Linus git tree has a problem with resuming of usb
> > > devices. My trackball is no longer working after resume from ram. It not
> > > even seen by lsusb.  Newly plugged devices are no longer detected (ie. my
> > > usb camera) after resume.
> > >
> > > Reloading all usb + ohci/ehci modules doesn't fix the problem. I need to
> > > reboot entire machine (thinkpad z60m).
> >
> > If you disable CONFIG_USB_SUSPEND, does it work properly for you?
> 
> Didn't test but I did bisecting and after reverting commits:
> 
> e8363f332757ac22395fb120cc33b3262f9ee26c
> 
> and the main problematic one:
> 
> commit 0a6139027f3986162233adc17285151e78b39cac
> Author: Konstantin Karasyov <konstantin.a.karasyov@intel.com>
> Date:   Fri Feb 16 01:47:06 2007 -0500
> 
>     ACPI: Thermal issues on HP nx6325
> 
>     The previous reference counting scheme to enable power resources
>     got confused when multiple devices were present that might
>     repeatedly enable or disable the resource and throw off the count.
> 
>     The new code simply lists the referencing devices which
>     are requesting the resource to be enabled.  When there are none,
>     then it is off.
> 
>     Signed-off-by: Konstantin Karasyov <konstantin.a.karasyov@intel.com>
>     Signed-off-by: Len Brown <len.brown@intel.com>
> 
> 
> I again have working usb after resume.

Thanks for tracking this down, I'll leave it to Len to debug now :)

greg k-h
