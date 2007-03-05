Return-Path: <linux-kernel-owner+w=401wt.eu-S1752800AbXCEShH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800AbXCEShH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 13:37:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752851AbXCEShG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 13:37:06 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:50712 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752800AbXCEShE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 13:37:04 -0500
Date: Mon, 5 Mar 2007 19:37:02 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Greg KH <greg@kroah.com>
Cc: Michael Buesch <mb@bu3sch.de>, Andrew Morton <akpm@linux-foundation.org>,
       linville@tuxdriver.com, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, dbrownell@users.sourceforge.net,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: 2.6.21-rc2-mm1: drivers/usb/host/ohci-ssb.c doesn't compile
Message-ID: <20070305183702.GN3441@stusta.de>
References: <20070302030026.5eef0c92.akpm@linux-foundation.org> <200703051149.05664.mb@bu3sch.de> <200703051157.16822.mb@bu3sch.de> <200703051226.46402.mb@bu3sch.de> <20070305182610.GA14113@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070305182610.GA14113@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 05, 2007 at 10:26:10AM -0800, Greg KH wrote:
> On Mon, Mar 05, 2007 at 12:26:45PM +0100, Michael Buesch wrote:
> > On Monday 05 March 2007 11:57, Michael Buesch wrote:
> > > > >   CC      drivers/usb/host/ohci-hcd.o
> > > > > In file included from 
> > > > > /home/bunk/linux/kernel-2.6/linux-2.6.21-rc2-mm1/drivers/usb/host/ohci-hcd.c:931:
> > > > > /home/bunk/linux/kernel-2.6/linux-2.6.21-rc2-mm1/drivers/usb/host/ohci-ssb.c:47: error: request for member 'hcd_priv_size' in something not a structure or union
> > > > 
> > > > Seems like there was a comma missing.
> > > > There also seems to be some Kconfig problem. will fix that.
> > > > 
> > > > > /home/bunk/linux/kernel-2.6/linux-2.6.21-rc2-mm1/drivers/usb/host/ohci-ssb.c:47: error: 'ssb_ohci_device' undeclared here (not in a function)
> > > > > /home/bunk/linux/kernel-2.6/linux-2.6.21-rc2-mm1/drivers/usb/host/ohci-ssb.c:52: error: 'ssb_ohci_reset' undeclared here (not in a function)
> > > > > /home/bunk/linux/kernel-2.6/linux-2.6.21-rc2-mm1/drivers/usb/host/ohci-ssb.c:53: error: 'ssb_ohci_start' undeclared here (not in a function)
> > > > > ...
> > > > > make[4]: *** [drivers/usb/host/ohci-hcd.o] Error 1
> > > > > 
> > > > > <--  snip  -->
> > > 
> > > Actually, it seems like I will run into other kinds of nasty problems
> > > due to stupid design of the HCD code. The OHCI code #includes
> > > the various drivers, which have a module_init each. So if you
> > > compile PCI and SSB support, you have two module_init for one
> > > OHCI module. Not sure how to fix this. Any idea?
> > 
> > A real problem is that the HCD core seems to have the assumption
> > built-in that there can only be one OHCI driver per machine/arch.
> > That's not the case for SSB, where we can have both PCI and SSB
> > bus enabled, so both ohci drivers compiled.
> > Any idea? Greg perhaps?
> 
> David has provided hints on how to do this in the past on the
> linux-usb-devel list if I remember correctly.

Is there any good reason why we can't split the OHCI drivers properly 
into separate modules?

> thanks,
> 
> greg k-h

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

