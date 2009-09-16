Return-Path: <linux-kernel-owner+w=401wt.eu-S1754338AbZIPSTP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338AbZIPSTP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 14:19:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752019AbZIPSTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 14:19:09 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:58935 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031AbZIPSTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 14:19:08 -0400
Date: Wed, 16 Sep 2009 20:19:10 +0200
From: Andreas Mohr <andi@lisas.de>
To: Oliver Neukum <oliver@neukum.org>
Cc: Andreas Mohr <andi@lisas.de>, Alan Stern <stern@rowland.harvard.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>, laurent.pinchart@skynet.be,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: usb autosuspend is history after S2R (also on 2.6.31; UVC?)
Message-ID: <20090916181910.GA28260@rhlx01.hs-esslingen.de>
References: <20090915185145.GA31490@rhlx01.hs-esslingen.de> <200909152148.29662.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200909152148.29662.oliver@neukum.org>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Sep 15, 2009 at 09:48:28PM +0200, Oliver Neukum wrote:
> Am Dienstag, 15. September 2009 20:51:45 schrieb Andreas Mohr:
> 
> > So, does the uvc driver need a bit of handholding here?
> > It likely shouldn't simply forget about its autosuspend status after
> > resume...
> 
> Can you please provide what you get when you read the "level" file
> of the device's power directory?

After boot:

# cat 5-5/product
Acer Crystal Eye webcam
# cat 5-5/power/level
on

After re-enabling disabled /etc/rc.local autosuspend tweaks:

# cat 5-5/power/level
auto

> Secondly, please verify, that it works before the STR cycle and post

It does:

Recent USB suspend statistics
Active  Device name
  0.0%  USB device  5-5 : Acer Crystal Eye webcam (SuYin)
  0.0%  USB device usb5 : EHCI Host Controller (Linux 2.6.31 ehci_hcd)
  0.0%  USB device usb4 : UHCI Host Controller (Linux 2.6.31 uhci_hcd)
  0.0%  USB device usb3 : UHCI Host Controller (Linux 2.6.31 uhci_hcd)
  0.0%  USB device usb2 : UHCI Host Controller (Linux 2.6.31 uhci_hcd)
  0.0%  USB device usb1 : UHCI Host Controller (Linux 2.6.31 uhci_hcd)

> a syslog of a suspend/resume cycle with CONFIG_USB_DEBUG and
> only this device attached if possible. Thirdly, please verify that only
> uvc is affected.

Hmmmm...

I just did the first S2R after boot, and the result is this:

Recent USB suspend statistics
Active  Device name          
  0.0%  USB device  5-5 : Acer Crystal Eye webcam (SuYin)
  0.0%  USB device usb5 : EHCI Host Controller (Linux 2.6.31 ehci_hcd)
  0.0%  USB device usb4 : UHCI Host Controller (Linux 2.6.31 uhci_hcd)
  0.0%  USB device usb3 : UHCI Host Controller (Linux 2.6.31 uhci_hcd)
  0.0%  USB device usb2 : UHCI Host Controller (Linux 2.6.31 uhci_hcd)
  0.0%  USB device usb1 : UHCI Host Controller (Linux 2.6.31 uhci_hcd)
# cat 5-5/power/level           
auto

Weird. Either it was always working and I'm just _very_ wrong,
or it's erratic and gets reset every couple S2Rs only.

Anyway, doesn't change the fact that the r8169 WOL PHY setting is toast
after every S2R as well ;)
# ethtool -s eth0 wol d
# ethtool eth0
...
        Wake-on: d
...

which then reverts to
# ethtool eth0
...
        Wake-on: g
...
thus wasting a wee bit of power(, too).

> > Or would Matthew's uvc autosuspend patch
> > http://osdir.com/ml/fedora-extras-commits/2009-07/msg06079.html
> > help here?
> 
> Please test it. It shouldn't work, but if it works there's a fundamental
> flaw.

Hmm, rebuild (of patch plus CONFIG_USB_DEBUG) would take >> 2 hours,
will have to wait until later.

Thanks,

Andreas
