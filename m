Return-Path: <linux-kernel-owner+w=401wt.eu-S1761924AbXILGAu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761924AbXILGAu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 02:00:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754461AbXILGAm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 02:00:42 -0400
Received: from mail3.cyberdogtech.com ([209.40.194.40]:41843 "EHLO
	mail3.cyberdogtech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754623AbXILGAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 02:00:41 -0400
Date: Wed, 12 Sep 2007 02:00:35 -0400
From: Matt LaPlante <kernel1@cyberdogtech.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
Subject: Re: Problem charging blackberry 8700c with berry_charge (2.6.22.6)
Message-Id: <20070912020035.b581c167.kernel1@cyberdogtech.com>
In-Reply-To: <20070911063502.GK27404@kroah.com>
References: <20070908220229.6e669e62.kernel1@cyberdogtech.com>
	<20070909105212.GA14929@kroah.com>
	<20070909144356.cdf6a5b3.kernel1@cyberdogtech.com>
	<20070911063502.GK27404@kroah.com>
X-Mailer: Sylpheed 2.4.4 (GTK+ 2.10.13; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Sep 2007 23:35:02 -0700
Greg KH <greg@kroah.com> wrote:

> 
> > Sep  9 13:49:01 prizm kernel: [  584.407498] drivers/usb/core/inode.c: creating file '003'
> > Sep  9 13:49:01 prizm kernel: [  584.407509] hub 5-0:1.0: state 7 ports 8 chg 0000 evt 0004
> > Sep  9 13:49:01 prizm kernel: [  584.407520] hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0004
> > Sep  9 13:49:03 prizm kernel: [  586.405512] usb 1-2: usb auto-suspend
> > Sep  9 13:49:03 prizm kernel: [  586.421471] hub 5-0:1.0: hub_suspend
> > Sep  9 13:49:03 prizm kernel: [  586.421481] ehci_hcd 0000:00:10.4: suspend root hub
> > Sep  9 13:49:03 prizm kernel: [  586.421496] usb usb5: usb auto-suspend
> > Sep  9 13:49:05 prizm kernel: [  588.421351] hub 1-0:1.0: hub_suspend
> > Sep  9 13:49:05 prizm kernel: [  588.421361] usb usb1: suspend_rh
> > Sep  9 13:49:05 prizm kernel: [  588.421481] usb usb1: usb auto-suspend
> 
> Ah, oh wait, now we just turned the power off.
> 
> Try disabling CONFIG_USB_SUSPEND and see if that fixes this issue.  Or
> you can manually turn the power back on to your blackberry by writing to
> the autosuspend file for the usb device in sysfs, but that can be a
> pain.
> 
> Let me know if just changing that config option works for you.
> 

And now for the dramatic conclusion...

To begin, I have no access to the original machine at the moment, as I'm now out of that area for a couple weeks.  I built a similar kernel (same version) on another box that I have at my current location.  The new machine is different hardware, so some kernel re-configuring was required, but I kept with the same USB settings (and similar overall design).  Interestingly, this machine didn't reproduce the "magic command failed" error, but it did fail very similarly to the original at charging the device.  I disabled CONFIG_USB_SUSPEND as suggested, and lo and behold, it now charges the berry.  Looks like an excellent diagnosis to me, doctor.  

Thanks! :)

> thanks,
> 
> greg k-h

-- 
Matt
