Return-Path: <linux-kernel-owner+w=401wt.eu-S1753729AbXKVSkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729AbXKVSkz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 13:40:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751764AbXKVSkq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 13:40:46 -0500
Received: from mail.issp.bas.bg ([195.96.236.10]:33870 "EHLO mail.issp.bas.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204AbXKVSkq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 13:40:46 -0500
From: Marin Mitov <mitov@issp.bas.bg>
Organization: Institute of Solid State Physics
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] 2.6.24-rc3-mm1: usb mouse doesn't work
Date: Thu, 22 Nov 2007 19:41:44 +0200
User-Agent: KMail/1.9.7
References: <Pine.LNX.4.44L0.0711221202490.31699-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0711221202490.31699-100000@netrider.rowland.org>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711221941.44646.mitov@issp.bas.bg>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 22 November 2007 07:07:00 pm you wrote:
> On Thu, 22 Nov 2007, Kirill A. Shutemov wrote:
> > > > uhci_hcd 0000:00:1d.3: UHCI Host Controller
> > > > uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 4
> > > > uhci_hcd 0000:00:1d.3: irq 7, io base 0x0000bf20
> > > > usb usb4: configuration #1 chosen from 1 choice
> > > > hub 4-0:1.0: USB hub found
> > > > hub 4-0:1.0: 2 ports detected
> > > > usb usb4: new device found, idVendor=0000, idProduct=0000
> > > > usb usb4: new device strings: Mfr=3, Product=2, SerialNumber=1
> > > > usb usb4: Product: UHCI Host Controller
> > > > usb usb4: Manufacturer: Linux 2.6.24-kas-alt1 uhci_hcd
> > > > usb usb4: SerialNumber: 0000:00:1d.3
> > > > uhci_hcd 0000:00:1d.3: FGR not stopped yet!
> > >
> > > I've had some strangenesses with USB lately.  Sometimes running `lsusb'
> > > makes the USB system notice a newly attached device.
> >
> > No. But I have new messages in dmesg:
> >
> > uhci_hcd 0000:00:1d.3: FGR not stopped yet!
> > uhci_hcd 0000:00:1d.2: FGR not stopped yet!
> > uhci_hcd 0000:00:1d.1: FGR not stopped yet!
> > uhci_hcd 0000:00:1d.0: FGR not stopped yet!
> >
> > > Is that "FGR not stopped yet!" messgae new behaviour?
> >
> > It is a new message since 2.6.24-rc3. I have never try -mm tree before.
>
> These messages could indicate a timing problem.  You can see the code
> that writes the messages near the end of wakeup_rh() in
> drivers/usb/host/uhci-hcd.c.
>
> The message gets written if the controller hardware hasn't turned off a
> particular bit after a 4-us delay.  If the udelay() function wasn't
> working right, it could cause this problem.

udelay() _is_ OK for 2.6.24-rc3, so it is not the cause of the problem

Marin Mitov
>
> Alan Stern
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


