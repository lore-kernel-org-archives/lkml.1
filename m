Return-Path: <linux-kernel-owner+w=401wt.eu-S1757122AbYGCPAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757122AbYGCPAk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 11:00:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752993AbYGCPAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 11:00:31 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:49950 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751445AbYGCPAb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 11:00:31 -0400
Date: Thu, 3 Jul 2008 18:00:00 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Oliver Neukum <oliver@neukum.org>
Cc: Adam Williamson <awilliamson@mandriva.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@redhat.com>, bugme-daemon@bugzilla.kernel.org,
       Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org,
       Matthias Geissert <matthias.geissert@web.de>
Subject: Re: [Bug 10868] Oops on loading ipaq module since 2.6.26, prevents
	use of device
Message-ID: <20080703150000.GD11254@cs181140183.pp.htv.fi>
References: <RzbtSgMztjP.A.jRD._spXIB@albercik> <200807031608.46457.oliver@neukum.org> <20080703142025.GC11254@cs181140183.pp.htv.fi> <200807031626.50531.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200807031626.50531.oliver@neukum.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 03, 2008 at 04:26:48PM +0200, Oliver Neukum wrote:
> Am Donnerstag 03 Juli 2008 16:20:30 schrieb Adrian Bunk:
> > On Thu, Jul 03, 2008 at 04:08:44PM +0200, Oliver Neukum wrote:
> > > Am Donnerstag 03 Juli 2008 10:57:33 schrieb Adrian Bunk:
> 
> > > > --- a/drivers/usb/serial/ipaq.c
> > > > +++ b/drivers/usb/serial/ipaq.c
> > > > @@ -571,9 +571,9 @@ static struct usb_serial_driver ipaq_device = {
> > > >  	.usb_driver = 		&ipaq_driver,
> > > >  	.id_table =		ipaq_id_table,
> > > >  	.num_interrupt_in =	NUM_DONT_CARE,
> > > > -	.num_bulk_in =		1,
> > > > -	.num_bulk_out =		1,
> > > > -	.num_ports =		1,
> > > > +	.num_bulk_in =		NUM_DONT_CARE,
> > > > +	.num_bulk_out =		NUM_DONT_CARE,
> > > 
> > > This is good.
> > 
> > These fields are removed by a later commit in 2.6.26...  8-)
> 
> Well, NUM_DONT_CARE is default, so it makes no difference, but a comment
> would have been nice.

They were removed from struct usb_serial_driver in 
include/linux/usb/serial.h since the checks they were used for caused 
more problems than they solved.

But you are right that the effects of the removal are the same as 
NUM_DONT_CARE.

> 	Regards
> 		Oliver

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

