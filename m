Return-Path: <linux-kernel-owner+w=401wt.eu-S1760833AbZDQVO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760833AbZDQVO3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 17:14:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759293AbZDQVMt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 17:12:49 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:53195 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759221AbZDQVMr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 17:12:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=P7k8UJWoTHYCI5yx1eqPHfZMe+v+C5WDHCDEb8yPmflh+6C4vsnhitiYinC4lufESB
         hsgbf+Js5IOV8Ek6bBt9GzrNO3zmPDjD1idSgwEMAM92kn9rxOw2YKsYHhnhFkF7dkqG
         xedVj67AgPKqcVuSotHeWg2L6XWs82xPkmzSU=
MIME-Version: 1.0
In-Reply-To: <20090417190139.GA3548@kroah.com>
References: <20090417190139.GA3548@kroah.com>
Date: Sat, 18 Apr 2009 01:12:45 +0400
Message-ID: <a4423d670904171412y323c38ech819652633e8674c5@mail.gmail.com>
Subject: Re: [GIT PATCH] USB fixes for 2.6.31-rc2
From: Alexander Beregalov <a.beregalov@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/4/17 Greg KH <gregkh@suse.de>:
> Here's a number of USB fixes for your 2.6.31-rc2 tree.
>
> Lots of little bugfixes, with the majority being in the musb driver,
> which has had a lot of patches queued up for it for quite some time now.
>
> It also cleans up the ch341 commit that Alan Cox pointed out was
> incorrect in the last USB merge.
>
> Please pull from:
>        master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/
>
> All of these patches have been in the -next and -mm releases for a while.
>
> The full patches will be sent to the linux-usb mailing list, if anyone
> wants to see them.
>
> thanks,
>
> greg k-h
>
> ------------
>
>  drivers/block/ub.c                        |   20 +-
>  drivers/isdn/hisax/st5481_usb.c           |    9 +-
>  drivers/media/video/pvrusb2/pvrusb2-hdw.c |    1 -
>  drivers/usb/class/cdc-wdm.c               |    2 +-
>  drivers/usb/core/devio.c                  |    2 +-
>  drivers/usb/core/hcd.c                    |   26 ++
>  drivers/usb/core/hcd.h                    |   14 +
>  drivers/usb/core/message.c                |   58 +++--
>  drivers/usb/core/usb.c                    |    2 +-
>  drivers/usb/gadget/u_ether.c              |    8 +-
>  drivers/usb/host/whci/asl.c               |   15 +-
>  drivers/usb/host/whci/hcd.c               |   23 ++
>  drivers/usb/host/whci/pzl.c               |   16 +-
>  drivers/usb/host/whci/qset.c              |   24 ++-
>  drivers/usb/host/whci/whcd.h              |    1 +
>  drivers/usb/host/whci/whci-hc.h           |    1 +
>  drivers/usb/musb/cppi_dma.c               |   23 +--
>  drivers/usb/musb/musb_core.c              |   12 +-
>  drivers/usb/musb/musb_gadget.c            |   33 ++-
>  drivers/usb/musb/musb_host.c              |  406 ++++++++++++++++-------------
>  drivers/usb/musb/musbhsdma.c              |   66 +++--
>  drivers/usb/serial/ftdi_sio.c             |    1 +
>  drivers/usb/serial/ftdi_sio.h             |    7 +
>  drivers/usb/serial/moto_modem.c           |    1 +
>  drivers/usb/serial/option.c               |    5 +
>  drivers/usb/serial/qcserial.c             |   21 ++
>  drivers/usb/storage/Makefile              |    3 +-
>  drivers/usb/storage/transport.c           |    4 +-
>  drivers/usb/storage/unusual_devs.h        |   14 +-
>  drivers/usb/wusbcore/devconnect.c         |   21 +-
>  drivers/usb/wusbcore/wusbhc.c             |   32 ++--
>  include/linux/usb.h                       |    9 +-
>  32 files changed, 532 insertions(+), 348 deletions(-)
>
> ---------------
>
> Alan Stern (2):
>      USB: usb-storage: augment unusual_devs entry for Simple Tech/Datafab
>      usb-storage: fix mistake in Makefile
>
> David Brownell (2):
>      USB: musb_host, minor enqueue locking fix (v2)
>      USB: musb_host, fix ep0 fifo flushing
>
> David Vrabel (6):
>      USB: add reset endpoint operations
>      USB: whci-hcd: provide a endpoint_reset method
>      USB: whci-hcd: check return value of usb_hcd_link_urb_to_ep()
>      WUSB: disconnect all devices when stopping a WUSB HCD
>      WUSB: fix oops when completing URBs for disconnected devices
>      WUSB: correct format of wusb_chid sysfs file
>
> Dr. Greg Wettstein (1):
>      USB device codes for Motorola phone.
>
> Greg Kroah-Hartman (1):
>      Revert USB: usb-serial ch341: support for DTR/RTS/CTS
>
> Jonathan McDowell (1):
>      usb gadget: fix ethernet link reports to ethtool
>
> Kim Kyuwon (1):
>      USB: musb: fix possible panic while resuming

Hi Greg
This patch should be here as well
http://marc.info/?l=linux-next&m=123996717119063&w=2
it fixes a build problem introduced by "USB: musb: fix possible panic
while resuming"
