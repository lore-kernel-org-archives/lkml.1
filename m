Return-Path: <linux-kernel-owner+w=401wt.eu-S1755479AbXLVNvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479AbXLVNvY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 08:51:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752274AbXLVNvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 08:51:16 -0500
Received: from [212.12.190.74] ([212.12.190.74]:59609 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750959AbXLVNvP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 08:51:15 -0500
From: Al Boldi <a1426z@gawab.com>
To: David Brownell <david-b@pacbell.net>, jengelh@computergmbh.de
Subject: Re: [RFC] USB Kconfig: Declutter USB Kconfig Menu
Date: Sat, 22 Dec 2007 16:49:55 +0300
User-Agent: KMail/1.5
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, greg@kroah.com
References: <200712211630.03426.a1426z@gawab.com> <200712220951.57634.a1426z@gawab.com> <20071222072208.A0960230DE8@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
In-Reply-To: <20071222072208.A0960230DE8@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200712221649.55831.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Brownell wrote:
> > > Which is why my suggestion was to have them both move up a level, with
> > > host and peripheral side menus nested normally:
> > >
> > > 	Device Drivers:
> > > 		...
> > > 		[ ] HID devices
> > > 		< > Host side USB
> > > 		< > Peripheral side USB
> > > 		< > MMC/SD/SDIO card support
> > > 		[ ] LED support
> > > 		...
> > >
> > > That way both host and peripheral side support would have their own
> > > menu, and that pointless nesting would be reduced.
> >
> > You mean:
> >  		[ ] Host side USB
> >  		[ ] Peripheral side USB
> >
> > Right?
>
> Both of those subsystems are already set up with the main choice
> as tristate "< >/<M>/<*>".  If we're simplifying the navigation,
> I can't see a point to requiring *two* menu actions not one.

There is a point, but it's a weak one: you want it to unfold in the same menu 
as you select the option.  So, if you unfold the sub-options in a separate 
sub-menu, you better use [ ] (or just blank), as this will allow you to 
enter the sub-menu, and see the unfold take place inside the same menu.

IMHO, I prefer < >, but newbies probably prefer [ ], as it is less abstract.

Provided there is agreement, and we go with < >, it would mean a slight 
change to Host side USB, like this (note new USB Core Config sub-menu):

      --- Support for Host-side USB                                      
      [ ]   USB Core Config  --->                                       
      [ ]   USB Host Controller Drivers  --->                        
      ---   NOTE: USB_STORAGE needs SCSI, and 'SCSI disk support' may
      ---   also be needed; see USB_STORAGE Help for more information
      < >   USB Mass Storage support  --->                          
      [ ]   The shared table of common (or usual) storage devices    
      [ ]   USB Monitor                                               
      < >   USS720 parport driver                               
      < >   USB Serial Converter support  --->                        
      < >   USB DSL modem support  --->                                
      [ ]   USB Device Class drivers  --->                            
      [ ]   USB Imaging devices  --->                                 
      [ ]   USB Miscellaneous drivers  --->                                         


Thanks!

--
Al

