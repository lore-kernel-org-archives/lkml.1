Return-Path: <linux-kernel-owner+w=401wt.eu-S1756078AbYACDrc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078AbYACDrc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 22:47:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753318AbYACDrX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 22:47:23 -0500
Received: from py-out-1112.google.com ([64.233.166.179]:61831 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026AbYACDrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 22:47:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=UUMy5BGTePgaK2Zx4L19NqpPrviWbM+KkK1CB4KPKNJdKE8mT1u9GYhCs94luPK+nZ8Ykfye5ot2UXGyt0uE/tnmW1Eq+Cu6MwUhBxdlPWxx5w2H2k/4ZQK9JjAF870SEUlQcNd5pNnWvKQ2gHnp4aDEP4jxVr2ayv4wV+Qplfo=
Message-ID: <386072610801021947l1ea697f3p49c6411cc76c4de4@mail.gmail.com>
Date: Thu, 3 Jan 2008 11:47:19 +0800
From: "Bryan Wu" <cooloney.lkml@gmail.com>
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: [linux-usb-devel] [PATCH] : Allow embedded developers USB options normally reserved for OTG
Cc: linux-usb-devel@lists.sourceforge.net,
       "Robin Getz" <rgetz@blackfin.uclinux.org>, gregkh@suse.de,
       linux-kernel@vger.kernel.org
In-Reply-To: <200801021047.16036.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200801020948.51310.rgetz@blackfin.uclinux.org>
	 <200801021047.16036.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 3, 2008 2:47 AM, David Brownell <david-b@pacbell.net> wrote:
> On Wednesday 02 January 2008, Robin Getz wrote:
> > From: Robin Getz <rgetz@blackfin.uclinux.org>
> >
> > Allow embedded developers to turn support for USB Hubs off even if they have a
> > full root hub. This saves the overhead (RAM and Flash size).
>
> ISTR that it won't save very much code though ... the Linux USB
> stack structures all its enumeration logic around hubs.
>
>
> > Allow embedded developers the capabilities of the "otg_whitelist.h" - a
> > product whitelist, so USB peripherals not listed there will be rejected
> > during enumeration. This is the desired operation for many embedded products.
> >
> > Signed-off-by: Robin Getz <rgetz@blackfin.uclinux.org>
>
> This is probably the right thing to do.  Correct me if I'm wrong,
> but USB-IF recently put out some specs about "embedded hosts" which
> basically boil down to saying you can adopt the same functionality
> restrictions that used to be OTG-only.  Which is why now there are
> embedded developers who'd like this option.  :)
>
> - Dave
>
>

Yes, "embedded hosts" which currently not support whole USB 2.0 spec
is what Robin's patch serving for.

Although in MUSB of Blackfin can support USB_OTG and we can enable
this, some real embedded application just use the MUSB_HOST mode. So
just enable MUSB_HOST  can save some embedded space because it does
not including MUSB_PERIPHERAL code.

I believe some embedded SoC including embedded USB host controller
also need this option open for them.

Thanks
-Bryan Wu
>
>
> >
> > ---
> >
> >  drivers/usb/core/Kconfig |    7 ++++---
> >  1 file changed, 4 insertions(+), 3 deletions(-)
> >
> >
> > Index: linux-2.6.x/drivers/usb/core/Kconfig
> > ===================================================================
> > --- linux-2.6.x/drivers/usb/core/Kconfig      (revision 4074)
> > +++ linux-2.6.x/drivers/usb/core/Kconfig      (working copy)
> > @@ -95,8 +95,9 @@
> >
> >  config USB_OTG_WHITELIST
> >       bool "Rely on OTG Targeted Peripherals List"
> > -     depends on USB_OTG
> > -     default y
> > +     depends on USB_OTG || EMBEDDED
> > +     default y if USB_OTG
> > +     default n if EMBEDDED
> >       help
> >         If you say Y here, the "otg_whitelist.h" file will be used as a
> >         product whitelist, so USB peripherals not listed there will be
> > @@ -111,7 +112,7 @@
> >
> >  config USB_OTG_BLACKLIST_HUB
> >       bool "Disable external hubs"
> > -     depends on USB_OTG
> > +     depends on USB_OTG || EMBEDDED
> >       help
> >         If you say Y here, then Linux will refuse to enumerate
> >         external hubs.  OTG hosts are allowed to reduce hardware
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
