Return-Path: <linux-kernel-owner+w=401wt.eu-S1753212AbYL2QS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212AbYL2QS0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 11:18:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751836AbYL2QSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 11:18:15 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:41495 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751807AbYL2QSN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 11:18:13 -0500
Date: Mon, 29 Dec 2008 17:18:10 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: gregkh@suse.de, dbrownell@users.sourceforge.net, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 10/13] drivers/usb/gadget: use USB API functions rather
 than constants
In-Reply-To: <Pine.LNX.4.44L0.0812291111581.2250-100000@iolanthe.rowland.org>
Message-ID: <Pine.LNX.4.64.0812291715170.9555@pc-004.diku.dk>
References: <Pine.LNX.4.44L0.0812291111581.2250-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Dec 2008, Alan Stern wrote:

> On Mon, 29 Dec 2008, Julia Lawall wrote:
> 
> > > ...
> > > 
> > > > diff --git a/drivers/usb/gadget/file_storage.c b/drivers/usb/gadget/file_storage.c
> > > > index 88fedd0..c44092b 100644
> > > > --- a/drivers/usb/gadget/file_storage.c
> > > > +++ b/drivers/usb/gadget/file_storage.c
> > > > @@ -248,6 +248,7 @@
> > > >  #include <linux/freezer.h>
> > > >  #include <linux/utsname.h>
> > > >  
> > > > +#include <linux/usb.h>
> > > >  #include <linux/usb/ch9.h>
> > > >  #include <linux/usb/gadget.h>
> > > 
> > > While there's nothing wrong with this part of the patch, it hardly 
> > > seems necessary.  Was there any reason for including it?
> > 
> > The new functions are defined in usb.h. I have added the include in 
> > this file and in the file epautoconf.c that this file includes.  If it is 
> > removed from both, then the code does not compile (after make 
> > allyesconfig):
> > 
> > In file included from drivers/usb/gadget/file_storage.c:268:
> > drivers/usb/gadget/epautoconf.c: In function 'ep_matches':
> > drivers/usb/gadget/epautoconf.c:79: error: implicit declaration of 
> > function 'usb_endpoint_type'
> > drivers/usb/gadget/epautoconf.c:122: error: implicit declaration of 
> > function 'usb_endpoint_dir_in'
> > make[1]: *** [drivers/usb/gadget/file_storage.o] Error 1
> > make: *** [drivers/usb/gadget/file_storage.o] Error 2
> > 
> > While putting it in epautoconf.c would be sufficient, the includes
> > 
> > #include <linux/usb/ch9.h>
> > #include <linux/usb/gadget.h>
> > 
> > are already repeated in both, so it would seem reasonable to repeat usb.h 
> > in both as well.
> 
> Ah, but the declarations in ch9.h and gadget.h are used by both files, 
> whereas the declarations in usb.h are used only by epautoconf.c.  Hence 
> it seems most reasonable to #include usb.h only in epautoconf.c.

Oops, I didn't notice that.  Just ignore that part of the patch then.  Or 
I can send another one if that would be more convenient.

A bit further down, the same is true of drivers/usb/gadget/gmidi.c and 
drivers/usb/gadget/printer.c

julia
