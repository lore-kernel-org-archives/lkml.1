Return-Path: <linux-kernel-owner+w=401wt.eu-S1754743AbXE0OLM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743AbXE0OLM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 10:11:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752900AbXE0OK7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 10:10:59 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:53348 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689AbXE0OK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 10:10:58 -0400
Subject: Re: udev regression? lsusb silent (no output) since 2.6.22-rc2 at 
	least
From: Kay Sievers <kay.sievers@vrfy.org>
To: bert hubert <bert.hubert@netherlabs.nl>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de
In-Reply-To: <20070527092546.GA10912@outpost.ds9a.nl>
References: <20070526201854.GA20758@outpost.ds9a.nl>
	 <1180233755.3131.4.camel@lov.localdomain>
	 <20070527092546.GA10912@outpost.ds9a.nl>
Content-Type: text/plain
Date: Sun, 27 May 2007 16:10:01 +0200
Message-Id: <1180275001.3131.28.camel@lov.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1+VH3EEdChTdUXHHE8lmHz4MAP5oFiINJ1Wl//
 o68M2tQQMA2wBq1DQiM5z3rVoizRaUaeZEMp2HhY6juKBvMFaJ
 dp7na46gpo5y7K5aiZeXiHcu3P10+6g
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-05-27 at 11:25 +0200, bert hubert wrote:
> On Sun, May 27, 2007 at 04:42:35AM +0200, Kay Sievers wrote:
> > > Any clues? Please let me know how I can help solve this problem!
> > 
> > It works fine for me here. Do you have CONFIG_USB_DEVICE_CLASS=y set?
> 
> Ah, I have not. However, this setting was not present in 2.6.21-rc3, from
> which configuration I ran 'make oldconfig'.
> 
> Make oldconfig does ask for this feature:
>   USB device class-devices (DEPRECATED) (USB_DEVICE_CLASS) [N/y/?] (NEW) 
> 
> And I chose the default, breaking (my version of) lsusb, on Ubuntu Edgy Eft.
> I enabled USB_DEVICE_CLASS, and lsusb worked again.
> 
> Thank you both for your quick answers!
> 
> Please consider this patch which clarifies the need for USB_DEVICE_CLASS:
> 
> --- ./drivers/usb/core/Kconfig~	2007-05-27 11:22:22.000000000 +0200
> +++ ./drivers/usb/core/Kconfig	2007-05-27 11:22:22.000000000 +0200
> @@ -54,7 +54,8 @@
>  	  device of the interface and therefore easily accessible from the interface
>  	  event.
>  
> -	  This option provides backward compatibility if needed.
> +	  This option provides backward compatibility and is required on
> +	  many distributions to keep lsusb working.

Yeah, a bit more text may be helpful. Many systems still use usbfs and
should work just fine without that option. Adding a udev rule will also
work.
The next version of HAL will depend on that udev rule. We have seen too
many unpredictable event timing problems with the usb_device class, and
will switch to the nodes provided directly by the usb-device instead of
the separate class device. How does that help text sound?

  This option provides backward compatibility for systems where
  usbfs is not mounted, and no udev rule like this exists:
    SUBSYSTEM=="usb", ACTION=="add", ENV{DEVTYPE}=="usb_device", \
      NAME="bus/usb/$env{BUSNUM}/$env{DEVNUM}", MODE="0644"

Thanks,
Kay

