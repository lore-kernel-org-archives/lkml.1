Return-Path: <linux-kernel-owner+w=401wt.eu-S932398AbXCEL1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932398AbXCEL1s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 06:27:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932627AbXCEL1s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 06:27:48 -0500
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:43595
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932398AbXCEL1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 06:27:47 -0500
From: Michael Buesch <mb@bu3sch.de>
To: greg@kroah.com
Subject: Re: 2.6.21-rc2-mm1: drivers/usb/host/ohci-ssb.c doesn't compile
Date: Mon, 5 Mar 2007 12:26:45 +0100
User-Agent: KMail/1.9.5
Cc: Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       linville@tuxdriver.com, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, dbrownell@users.sourceforge.net,
       linux-usb-devel@lists.sourceforge.net
References: <20070302030026.5eef0c92.akpm@linux-foundation.org> <200703051149.05664.mb@bu3sch.de> <200703051157.16822.mb@bu3sch.de>
In-Reply-To: <200703051157.16822.mb@bu3sch.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200703051226.46402.mb@bu3sch.de>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 March 2007 11:57, Michael Buesch wrote:
> > >   CC      drivers/usb/host/ohci-hcd.o
> > > In file included from 
> > > /home/bunk/linux/kernel-2.6/linux-2.6.21-rc2-mm1/drivers/usb/host/ohci-hcd.c:931:
> > > /home/bunk/linux/kernel-2.6/linux-2.6.21-rc2-mm1/drivers/usb/host/ohci-ssb.c:47: error: request for member 'hcd_priv_size' in something not a structure or union
> > 
> > Seems like there was a comma missing.
> > There also seems to be some Kconfig problem. will fix that.
> > 
> > > /home/bunk/linux/kernel-2.6/linux-2.6.21-rc2-mm1/drivers/usb/host/ohci-ssb.c:47: error: 'ssb_ohci_device' undeclared here (not in a function)
> > > /home/bunk/linux/kernel-2.6/linux-2.6.21-rc2-mm1/drivers/usb/host/ohci-ssb.c:52: error: 'ssb_ohci_reset' undeclared here (not in a function)
> > > /home/bunk/linux/kernel-2.6/linux-2.6.21-rc2-mm1/drivers/usb/host/ohci-ssb.c:53: error: 'ssb_ohci_start' undeclared here (not in a function)
> > > ...
> > > make[4]: *** [drivers/usb/host/ohci-hcd.o] Error 1
> > > 
> > > <--  snip  -->
> 
> Actually, it seems like I will run into other kinds of nasty problems
> due to stupid design of the HCD code. The OHCI code #includes
> the various drivers, which have a module_init each. So if you
> compile PCI and SSB support, you have two module_init for one
> OHCI module. Not sure how to fix this. Any idea?

A real problem is that the HCD core seems to have the assumption
built-in that there can only be one OHCI driver per machine/arch.
That's not the case for SSB, where we can have both PCI and SSB
bus enabled, so both ohci drivers compiled.
Any idea? Greg perhaps?

Refactoring the code that OHCI drivers register to the HCD core
instead of hard-linking it in would fix the issue. But that's pretty
intrusive to do.

-- 
Greetings Michael.
