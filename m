Return-Path: <linux-kernel-owner+w=401wt.eu-S1760091AbYENDAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760091AbYENDAz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 23:00:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757803AbYENDAq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 23:00:46 -0400
Received: from ns2.suse.de ([195.135.220.15]:53216 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757945AbYENDAp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 23:00:45 -0400
Date: Tue, 13 May 2008 19:59:47 -0700
From: Greg KH <gregkh@suse.de>
To: Michael Krufky <mkrufky@linuxtv.org>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Chuck Ebbert <cebbert@redhat.com>, Domenico Andreoli <cavokz@gmail.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Hans-Frieder Vogt <hfvogt@gmx.net>,
       Felix Apitzsch <F.Apitzsch@soz.uni-frankfurt.de>,
       Antti Palosaari <crope@iki.fi>,
       Albert Comerma <albert.comerma@gmail.com>,
       Patrick Boettcher <pb@linuxtv.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Michel Morisot <mmorisot.abonnement@belcenter.com>
Subject: Re: [patch 01/37] V4L/DVB (7473): PATCH for various Dibcom based
	devices
Message-ID: <20080514025947.GA2736@suse.de>
References: <20080513200453.064446337@mini.kroah.org> <20080513201053.GA31167@suse.de> <20080513201120.GB31167@suse.de> <37219a840805131827v5faf7710pf0b3f67e570bdc7f@mail.gmail.com> <20080514020333.GA30079@suse.de> <37219a840805131934j4d35b56at1e90fbd26446e022@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37219a840805131934j4d35b56at1e90fbd26446e022@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2008 at 10:34:13PM -0400, Michael Krufky wrote:
> On Tue, May 13, 2008 at 10:03 PM, Greg KH <gregkh@suse.de> wrote:
> > On Tue, May 13, 2008 at 09:27:30PM -0400, Michael Krufky wrote:
> >  > On Tue, May 13, 2008 at 4:11 PM, Greg KH <gregkh@suse.de> wrote:
> >  > > 2.6.25-stable review patch.  If anyone has any objections, please let us know.
> >  > >
> >  > >  ------------------
> >  > >
> >  > >  From: Albert Comerma <albert.comerma@gmail.com>
> >  > >
> >  > >  patch 6ca8f0b97473dcef3a754bab5239dcfcdd00b244 upstream
> >  > >
> >  > >  This patch introduces support for dvb-t for the following DiBcom based cards:
> >  > >
> >  > >  - Terratec Cinergy HT USB XE (USB-ID: 0ccd:0058)
> >  > >  - Terratec Cinergy HT Express (USB-ID: 0ccd:0060)
> >  > >  - Pinnacle 320CX (USB-ID: 2304:022e)
> >  > >  - Pinnacle PCTV72e (USB-ID: 2304:0236)
> >  > >  - Pinnacle PCTV73e (USB-ID: 2304:0237)
> >  > >  - Yuan EC372S (USB-ID: 1164:1edc)
> >  > >
> >  > >  Signed-off-by: Hans-Frieder Vogt <hfvogt@gmx.net>
> >  > >  Signed-off-by: Felix Apitzsch <F.Apitzsch@soz.uni-frankfurt.de>
> >  > >  Signed-off-by: Antti Palosaari <crope@iki.fi>
> >  > >  Signed-off-by: Albert Comerma <albert.comerma@gmail.com>
> >  > >  Signed-off-by: Patrick Boettcher <pb@linuxtv.org>
> >  > >  Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
> >  > >  Cc: Michel Morisot <mmorisot.abonnement@belcenter.com>
> >  > >  Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> >  > >
> >  > >  ---
> >  > >   drivers/media/dvb/dvb-usb/dib0700_devices.c |  259 ++++++++++++++++++++++++----
> >  > >   drivers/media/dvb/dvb-usb/dvb-usb-ids.h     |    9
> >  > >   2 files changed, 238 insertions(+), 30 deletions(-)
> >  >
> >  >
> >  > This patch is entirely inappropriate for -stable
> >
> >  Why do you say that?  It adds new device ids for devices to a driver,
> >  which is find for stable.
> 
> It is much larger than a 100 line patch.  I know that this is not a
> _strict_ requirement, but upon closer inspection, I see that the
> majority of this is codingstyle cleanup.  The codingstyle cleanups
> should have been removed from this patch before backporting to
> -stable, in my opinion.
> 
> >  > I usually send in the v4l-dvb backports for -stable, and this was
> >  > never in my queue, not to mention that it doesn't qualify, based on
> >  > the -stable rules.
> >
> >  I think it does qualify and I've been asking for feedback about this for
> >  the past week to everyone on the signed-off-lines above with no real
> >  objections :)
> >
> >  openSUSE had a user that requested this patch be added as they had
> >  hardware that needed this patch to work properly on 2.6.25.  As it only
> >  added device ids, I didn't see the problem with it.
> >
> >  Does it cause any problems that you can see?
> 
> The patch is fine, and there is nothing wrong with it.
> 
> The only problem is that all of the cosmetic cleanups are unnecessary,
> and they have caused the patch to appear like a larger change than it
> actually is.

Yes, it does make it appear that way, but it is much simpler to just
take the exact same upstream patch for something like this than to have
to pick and choose it by hand.  It reduces the potential for error and
I'm lazy :)

thanks,

greg k-h
