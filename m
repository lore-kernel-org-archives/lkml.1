Return-Path: <linux-kernel-owner+w=401wt.eu-S1751526AbXBVJZd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751526AbXBVJZd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 04:25:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751527AbXBVJZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 04:25:33 -0500
Received: from mailmxout.mailmx.agnat.pl ([193.239.44.238]:2096 "EHLO
	mailmxout.mailmx.agnat.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525AbXBVJZb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 04:25:31 -0500
From: Arkadiusz Miskiewicz <arekm@maven.pl>
Organization: SelfOrganizing
To: Greg KH <greg@kroah.com>
Subject: Re: 2.6.21rc1 git usb mouse stops working after resume from ram
Date: Thu, 22 Feb 2007 10:24:52 +0100
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net,
       konstantin.a.karasyov@intel.com, len.brown@intel.com
References: <200702212314.56958.arekm@maven.pl> <20070221234905.GB7133@kroah.com>
In-Reply-To: <20070221234905.GB7133@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200702221024.52551.arekm@maven.pl>
X-Authenticated-Id: arekm
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 22 of February 2007, Greg KH wrote:
> On Wed, Feb 21, 2007 at 11:14:56PM +0100, Arkadiusz Miskiewicz wrote:
> > Hello,
> >
> > Today version of Linus git tree has a problem with resuming of usb
> > devices. My trackball is no longer working after resume from ram. It not
> > even seen by lsusb.  Newly plugged devices are no longer detected (ie. my
> > usb camera) after resume.
> >
> > Reloading all usb + ohci/ehci modules doesn't fix the problem. I need to
> > reboot entire machine (thinkpad z60m).
>
> If you disable CONFIG_USB_SUSPEND, does it work properly for you?

Didn't test but I did bisecting and after reverting commits:

e8363f332757ac22395fb120cc33b3262f9ee26c

and the main problematic one:

commit 0a6139027f3986162233adc17285151e78b39cac
Author: Konstantin Karasyov <konstantin.a.karasyov@intel.com>
Date:   Fri Feb 16 01:47:06 2007 -0500

    ACPI: Thermal issues on HP nx6325

    The previous reference counting scheme to enable power resources
    got confused when multiple devices were present that might
    repeatedly enable or disable the resource and throw off the count.

    The new code simply lists the referencing devices which
    are requesting the resource to be enabled.  When there are none,
    then it is off.

    Signed-off-by: Konstantin Karasyov <konstantin.a.karasyov@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>


I again have working usb after resume.

> (rest of the boot log left below for the benifit of the linux-usb-devel
> mailing list readers.)
>
> thanks,
>
> greg k-h


-- 
Arkadiusz Mi¶kiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
