Return-Path: <linux-kernel-owner+w=401wt.eu-S1757246AbYAEVJ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757246AbYAEVJ4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 16:09:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757371AbYAEVJj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 16:09:39 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:35987 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757285AbYAEVJi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 16:09:38 -0500
Date: Sat, 5 Jan 2008 22:09:40 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Al Boldi <a1426z@gawab.com>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/5] USB Kconfig: Select SCSI for USB Mass Storage support
Message-ID: <20080105210940.GA10302@uranus.ravnborg.org>
References: <200801051546.SAA08947@raad.intranet> <20080105113024.209485f5.randy.dunlap@oracle.com> <20080105210330.GC22232@does.not.exist>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080105210330.GC22232@does.not.exist>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 05, 2008 at 11:03:30PM +0200, Adrian Bunk wrote:
> On Sat, Jan 05, 2008 at 11:30:24AM -0800, Randy Dunlap wrote:
> > On Sat, 5 Jan 2008 18:41:39 +0300 Al Boldi wrote:
> > 
> > > 
> > > Select SCSI for USB Mass Storage support.
> > > 
> > > 
> > > Cc: David Brownell <david-b@pacbell.net>
> > > Cc: Greg KH <greg@kroah.com>
> > > Cc: Andrew Morton <akpm@linux-foundation.org>
> > > Signed-off-by: Al Boldi <a1426z@gawab.com>
> > > 
> > > ---
> > > 
> > > --- 23.a/drivers/usb/storage/Kconfig
> > > +++ 23.b/drivers/usb/storage/Kconfig
> > > @@ -2,14 +2,10 @@
> > >  # USB Storage driver configuration
> > >  #
> > >  
> > > -comment "NOTE: USB_STORAGE needs SCSI, and 'SCSI disk support' may"
> > > -	depends on USB
> > > -comment "also be needed; see USB_STORAGE Help for more information"
> > > -	depends on USB
> > > -
> > >  menuconfig USB_STORAGE
> > >  	tristate "USB Mass Storage support"
> > > -	depends on USB && SCSI
> > > +	depends on USB
> > > +	select SCSI
> > 
> > We try not to use 'select' on subsystems and try to limit its use
> > to library-like code that is relatively small.  Selecting SCSI
> > breaks both of those efforts.
> >...
> 
> _You_ are trying to do this.
> 
> For kconfig users, "select" is _much_ better than sending them through 
> different menus.
Only if used within the current limitations of Kconfig.
And that requires you to use select only to select symbols with
no dependencies.

In this case we do not know if BLOCK is enabled or not.

	Sam
