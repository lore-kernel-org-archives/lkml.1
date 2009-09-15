Return-Path: <linux-kernel-owner+w=401wt.eu-S1758493AbZIOTIh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758493AbZIOTIh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 15:08:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758481AbZIOTId
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 15:08:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45199 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758378AbZIOTHg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 15:07:36 -0400
Date: Tue, 15 Sep 2009 12:00:45 -0700
From: Greg KH <gregkh@suse.de>
To: Andreas Mohr <andi@lisas.de>
Cc: Alan Stern <stern@rowland.harvard.edu>, laurent.pinchart@skynet.be,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: usb autosuspend is history after S2R (also on 2.6.31; UVC?)
Message-ID: <20090915190045.GA734@suse.de>
References: <20090915185145.GA31490@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090915185145.GA31490@rhlx01.hs-esslingen.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 15, 2009 at 08:51:45PM +0200, Andreas Mohr wrote:
> Hi,
> 
> currently running 2.6.31, and what I've been suspecting for quite some
> time (several weeks) is actually true: after S2R resume
> all friendly USB autosuspend settings are history and we're back
> to the dreaded old 100% activity (powertop -d):
> 
> Recent USB suspend statistics
> Active  Device name
> 100.0%  USB device  5-5 : Acer Crystal Eye webcam (SuYin)
> 100.0%  USB device usb5 : EHCI Host Controller (Linux 2.6.31 ehci_hcd)
>   0.0%  USB device usb4 : UHCI Host Controller (Linux 2.6.31 uhci_hcd)
>   0.0%  USB device usb3 : UHCI Host Controller (Linux 2.6.31 uhci_hcd)
>   0.0%  USB device usb2 : UHCI Host Controller (Linux 2.6.31 uhci_hcd)
>   0.0%  USB device usb1 : UHCI Host Controller (Linux 2.6.31 uhci_hcd)
> 
> Is there any fix planned for this? This is possibly even more important
> (power wasted due to wakeups, I'd judge it to be up to 1.5W on this 8.5W
> Aspire One machine) than any other runtime PM implementation...
> 
> OTOH this problem is probably isolated to uvc devices, since:
> # lsusb -t
> /:  Bus 05.Port 1: Dev 1, Class=root_hub, Driver=ehci_hcd/8p, 480M
>     |__ Port 5: Dev 7, If 0, Class='bInterfaceClass 0x0e not yet handled', Driver=uvcvideo, 480M
>     |__ Port 5: Dev 7, If 1, Class='bInterfaceClass 0x0e not yet handled', Driver=uvcvideo, 480M
> /:  Bus 04.Port 1: Dev 1, Class=root_hub, Driver=uhci_hcd/2p, 12M
> /:  Bus 03.Port 1: Dev 1, Class=root_hub, Driver=uhci_hcd/2p, 12M
> /:  Bus 02.Port 1: Dev 1, Class=root_hub, Driver=uhci_hcd/2p, 12M
> /:  Bus 01.Port 1: Dev 1, Class=root_hub, Driver=uhci_hcd/2p, 12M
> 
> So, does the uvc driver need a bit of handholding here?
> It likely shouldn't simply forget about its autosuspend status after
> resume...
> 
> Or would Matthew's uvc autosuspend patch
> http://osdir.com/ml/fedora-extras-commits/2009-07/msg06079.html

Could you try that?  A certian hardware manufacturer is insisting that
this patch solves problems, which I have not been able to validate, and
it would be good to get some independant tests.

thanks,

greg k-h
