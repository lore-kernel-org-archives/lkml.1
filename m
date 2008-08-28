Return-Path: <linux-kernel-owner+w=401wt.eu-S1758070AbYH1WHt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758070AbYH1WHt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 18:07:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756337AbYH1WH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 18:07:28 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60435 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756246AbYH1WH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 18:07:27 -0400
Date: Thu, 28 Aug 2008 13:38:44 -0700
From: Greg KH <greg@kroah.com>
To: Marcel Janssen <korgull@home.nl>
Cc: Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oliver@neukum.org>,
       USB list <linux-usb@vger.kernel.org>,
       Stefan Kopp <stefan_kopp@agilent.com>,
       Felipe Balbi <me@felipebalbi.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] USB: add USB test and measurement class driver - round
	2
Message-ID: <20080828203844.GC20537@kroah.com>
References: <20080827183615.GA15692@kroah.com> <Pine.LNX.4.44L0.0808271451550.17771-100000@iolanthe.rowland.org> <20080827234720.GC31264@kroah.com> <200808281858.42486.korgull@home.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808281858.42486.korgull@home.nl>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2008 at 06:58:41PM +0200, Marcel Janssen wrote:
> On Thursday 28 August 2008 01:47:20 Greg KH wrote:
> > Great, all done now.
> >
> > Here's the updated version.
> 
> I've just installed this version.
> 
> Here's what I see so far :
> 
> The driver inserts well and when I connect my device it shows /dev/usbtmc0 
> with major 180 and minor 176.
> It only creates one device (Stefan's driver created two) but I'm not sure if 
> that has changed for a reason so just let you know.

Yes, the old driver had a "control and debug " channel at minor 0, which
isn't needed anymore.

> When I disconnect my device, usbtmc0 will not be destroyed. After connecting 
> the device a couple of times I have a lot of /dev/usbtmc.. files.

Hm, that's not good, something's wrong here.

Can you enable CONFIG_USB_DEBUG and rebuild the driver and send me the
kernel log messages when you plug the device in and then remove it?

> I would expect the following to work :
> echo :*IDN?>/dev/usbtmc0
> But it returns : No such device

Yeah, I would expect that to work as well.  The debug information might
be helpful here also.

> Using echo and cat to test the device is quite convenient, but is this 
> supposed to work yet ?

Yes it should.

> I checked /sys a bit and found that the endpoints are correctly found.    

Good, how about the capability information?  That should be in sysfs as
well, does that show the proper values?

thanks,

greg k-h
