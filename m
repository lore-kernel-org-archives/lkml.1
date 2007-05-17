Return-Path: <linux-kernel-owner+w=401wt.eu-S1762670AbXEQFPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762670AbXEQFPr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 01:15:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759317AbXEQFPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 01:15:40 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:46236 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758197AbXEQFPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 01:15:40 -0400
Date: Wed, 16 May 2007 22:14:20 -0700
From: Greg KH <greg@kroah.com>
To: art@usfltd.com
Cc: linux-kernel@vger.kernel.org, torvalds@osdl.org
Subject: Re: usb-scanner-cameras kernel-2.6.22 and udev-095 problem
Message-ID: <20070517051420.GA10934@kroah.com>
References: <20070516145822.d1bz7paab4o8gg8c@67.106.77.50>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070516145822.d1bz7paab4o8gg8c@67.106.77.50>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2007 at 02:58:22PM -0500, art@usfltd.com wrote:
>  greg
> 
>  CONFIG_SYSFS_DEPRECATED=Y
> 
>  check that we have
>  rwxrwxrwx 1 root root       15 May 16 13:43 scanner-usbdev2.12 -> 
>  bus/usb/002/012
> 
>  in /dev directory after usb-scanner connection for kernel-2.6.20
>  we don't have this for kernel-2.6.22

Who creates that?  udev?  What udev rule does that?

Can you run 'udevtest' to see what is supposed to be matching here?
Odds are you have a broken rule somehow.


> 
>  ----------------------------2.6.20 usb-scanner connect
> 
>  # /usr/sbin/udevmonitor
> 
>  UEVENT[1179340996.886805] 
>  add@/devices/pci0000:00/0000:00:0b.1/usb2/2-2/2-2.2
>  UEVENT[1179340996.886864] add@/class/usb_endpoint/usbdev2.12_ep00
>  UEVENT[1179340996.887438] 
>  add@/devices/pci0000:00/0000:00:0b.1/usb2/2-2/2-2.2/2-2.2:1.0
>  UEVENT[1179340996.887467] add@/class/usb_endpoint/usbdev2.12_ep81
>  UEVENT[1179340996.887484] add@/class/usb_endpoint/usbdev2.12_ep02
>  UEVENT[1179340996.887499] add@/class/usb_endpoint/usbdev2.12_ep83
>  UEVENT[1179340996.887514] add@/class/usb_device/usbdev2.12
>  UDEV  [1179340996.921506] 
>  add@/devices/pci0000:00/0000:00:0b.1/usb2/2-2/2-2.2
>  UDEV  [1179340996.936005] add@/class/usb_endpoint/usbdev2.12_ep00
>  UDEV  [1179340996.960144] add@/class/usb_endpoint/usbdev2.12_ep81
>  UDEV  [1179340996.963672] add@/class/usb_endpoint/usbdev2.12_ep02
>  UDEV  [1179340996.967439] add@/class/usb_endpoint/usbdev2.12_ep83
>  UDEV  [1179340997.240934] 
>  add@/devices/pci0000:00/0000:00:0b.1/usb2/2-2/2-2.2/2-2.2:1.0
>  UDEV  [1179340997.473142] add@/class/usb_device/usbdev2.12

This last device is correct, and what your udev rule should be using to
create your symlink.

You didn't answer my, "what distro are you using" question.  Also, what
package created the udev rule that creates the above symlink?

thanks,

greg k-h

