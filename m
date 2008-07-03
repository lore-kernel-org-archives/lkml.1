Return-Path: <linux-kernel-owner+w=401wt.eu-S1760088AbYGCOVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760088AbYGCOVU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 10:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757297AbYGCOVD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 10:21:03 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:44036 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751861AbYGCOVB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 10:21:01 -0400
Date: Thu, 3 Jul 2008 17:20:30 +0300
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
Message-ID: <20080703142025.GC11254@cs181140183.pp.htv.fi>
References: <RzbtSgMztjP.A.jRD._spXIB@albercik> <200807031005.59691.oliver@neukum.org> <20080703085733.GB11254@cs181140183.pp.htv.fi> <200807031608.46457.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200807031608.46457.oliver@neukum.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 03, 2008 at 04:08:44PM +0200, Oliver Neukum wrote:
> Am Donnerstag 03 Juli 2008 10:57:33 schrieb Adrian Bunk:
> > On Thu, Jul 03, 2008 at 10:05:57AM +0200, Oliver Neukum wrote:
>  
> > > As far as I can tell somebody changed the ipaq driver in 2.6.26-rc6. I cannot
> > > find the exact patch that did it in Greg's directory. As it causes a regression
> > > here's a reversal.
> > 
> > 
> > It was changed by:
> 
> Thanks, did you do git magic?

I wouldn't call that "magic":

$ git-log v2.6.25.. drivers/usb/serial/ipaq.c

>...
> > --- a/drivers/usb/serial/ipaq.c
> > +++ b/drivers/usb/serial/ipaq.c
> > @@ -571,9 +571,9 @@ static struct usb_serial_driver ipaq_device = {
> >  	.usb_driver = 		&ipaq_driver,
> >  	.id_table =		ipaq_id_table,
> >  	.num_interrupt_in =	NUM_DONT_CARE,
> > -	.num_bulk_in =		1,
> > -	.num_bulk_out =		1,
> > -	.num_ports =		1,
> > +	.num_bulk_in =		NUM_DONT_CARE,
> > +	.num_bulk_out =		NUM_DONT_CARE,
> 
> This is good.

These fields are removed by a later commit in 2.6.26...  8-)

> > +	.num_ports =		2,
> 
> This is fatal.
> 
> The patch I sent reverts only this part, so this issue is solved.
> 
> 	Regards
> 		Oliver

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

