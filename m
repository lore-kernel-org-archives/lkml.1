Return-Path: <linux-kernel-owner+w=401wt.eu-S1754369AbYJ3F4n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369AbYJ3F4n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 01:56:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752839AbYJ3F4U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 01:56:20 -0400
Received: from kroah.org ([198.145.64.141]:59354 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752711AbYJ3F4T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 01:56:19 -0400
Date: Wed, 29 Oct 2008 22:54:10 -0700
From: Greg KH <greg@kroah.com>
To: Volker Armin Hemmann <volker.armin.hemmann@tu-clausthal.de>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       Libin.Yang@amd.com, Crane Cai <crane.cai@amd.com>
Subject: Re: 2.6.27: ehci bug with AMD 770nb/SB700 southbridge. usb lockup
Message-ID: <20081030055410.GB19035@kroah.com>
References: <200810300215.18792.volker.armin.hemmann@tu-clausthal.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810300215.18792.volker.armin.hemmann@tu-clausthal.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2008 at 02:15:18AM +0100, Volker Armin Hemmann wrote:
> Hi,
> 
> I have a A770Crossfire board from Asrock.
> With kernel 2.6.26.X and 2.6.27.[1,2,3,4] I have the following problem that 
> makes usb mostly unusable.
> 
> I have a 4 port hub attached. A logitech mouse receiver is inserted into one 
> of its ports - it does not matter which one. Everything works fine.
> 
> I turn on an external enclosure, which is either attached to one of the 
> mainboards ports or the hub. Everything works for a couple of seconds. I mount 
> the cdrom/harddisk partition and start copying a file - or just wait a couple 
> of seconds.
> USB completly locks up. First the mouse, then a bit later the file transfer 
> (so one was started) stops. Turning of the enclosure does not help, remving 
> the receiver and reinserting it, does not help, not using the hub does not 
> help.
> Only thing that brings back USB:
> rmmod ehci_hcd
> modprobe ehci-hcd
> 
> rmmod and modprobe usb-storage does NOT help.
> 
> after that I get another couple of seconds until it locks up again.
> 
> If I modprobe ohci-hcd I get this:
> with 2.6.26 and the mouse at ohci, enclosure at ehci, everything works - but 
> gaming (with fglrx loaded) is impossible, since the mouse is extremly jerky 
> (shared interrupts).
> with 2.6.27 both mouse and enclose are driven by ohci - and copying works 
> without locking up. Trying to 'force' ehci for the enclosure makes it lockup 
> again.
> 
> This happens with kernel.org kernels+reiser4.

This chipset was known to have bugs in it, which I think we fixed
already.  I have a laptop with this chipset and it can sustain large
ammounts of USB data just fine with the 2.6.27 kernel series, so I
wonder if something is wrong with your usb disk drive?

I've added some AMD developers on the CC: who helped develop the last
fix for this chipset.  Libin, do you know of anything in the chipset
that would cause these problems?

thanks,

greg k-h
