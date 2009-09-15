Return-Path: <linux-kernel-owner+w=401wt.eu-S1758339AbZIOSvo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758339AbZIOSvo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 14:51:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758327AbZIOSvn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 14:51:43 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:45554 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758281AbZIOSvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 14:51:43 -0400
Date: Tue, 15 Sep 2009 20:51:45 +0200
From: Andreas Mohr <andi@lisas.de>
To: Alan Stern <stern@rowland.harvard.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>, laurent.pinchart@skynet.be,
       Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: usb autosuspend is history after S2R (also on 2.6.31; UVC?)
Message-ID: <20090915185145.GA31490@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

currently running 2.6.31, and what I've been suspecting for quite some
time (several weeks) is actually true: after S2R resume
all friendly USB autosuspend settings are history and we're back
to the dreaded old 100% activity (powertop -d):

Recent USB suspend statistics
Active  Device name
100.0%  USB device  5-5 : Acer Crystal Eye webcam (SuYin)
100.0%  USB device usb5 : EHCI Host Controller (Linux 2.6.31 ehci_hcd)
  0.0%  USB device usb4 : UHCI Host Controller (Linux 2.6.31 uhci_hcd)
  0.0%  USB device usb3 : UHCI Host Controller (Linux 2.6.31 uhci_hcd)
  0.0%  USB device usb2 : UHCI Host Controller (Linux 2.6.31 uhci_hcd)
  0.0%  USB device usb1 : UHCI Host Controller (Linux 2.6.31 uhci_hcd)

Is there any fix planned for this? This is possibly even more important
(power wasted due to wakeups, I'd judge it to be up to 1.5W on this 8.5W
Aspire One machine) than any other runtime PM implementation...

OTOH this problem is probably isolated to uvc devices, since:
# lsusb -t
/:  Bus 05.Port 1: Dev 1, Class=root_hub, Driver=ehci_hcd/8p, 480M
    |__ Port 5: Dev 7, If 0, Class='bInterfaceClass 0x0e not yet handled', Driver=uvcvideo, 480M
    |__ Port 5: Dev 7, If 1, Class='bInterfaceClass 0x0e not yet handled', Driver=uvcvideo, 480M
/:  Bus 04.Port 1: Dev 1, Class=root_hub, Driver=uhci_hcd/2p, 12M
/:  Bus 03.Port 1: Dev 1, Class=root_hub, Driver=uhci_hcd/2p, 12M
/:  Bus 02.Port 1: Dev 1, Class=root_hub, Driver=uhci_hcd/2p, 12M
/:  Bus 01.Port 1: Dev 1, Class=root_hub, Driver=uhci_hcd/2p, 12M

So, does the uvc driver need a bit of handholding here?
It likely shouldn't simply forget about its autosuspend status after
resume...

Or would Matthew's uvc autosuspend patch
http://osdir.com/ml/fedora-extras-commits/2009-07/msg06079.html
help here?

Thanks,

Andreas Mohr
