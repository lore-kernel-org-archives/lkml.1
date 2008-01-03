Return-Path: <linux-kernel-owner+w=401wt.eu-S1759607AbYACEk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759607AbYACEk1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 23:40:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754832AbYACEkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 23:40:17 -0500
Received: from py-out-1112.google.com ([64.233.166.180]:4603 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753705AbYACEkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 23:40:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=H6Bz1l5y/B0NJaRTITX9iQhscgob9LYeEHFjf8X0SS+5LMTiSQfFqciB6sx0bRTx2TzWaLmEtk4ETNSYP4VrQxztclvdLnh/pHMqiFv/4km7qnKQfhuHDO7hFTvjN0/mhsFD24PTTeg2abVPMrzoOmgXFuJ3cBTwDtXR8ZtF558=
Message-ID: <386072610801022040ja4919bapa8a0712c1246c3f3@mail.gmail.com>
Date: Thu, 3 Jan 2008 12:40:14 +0800
From: "Bryan Wu" <cooloney.lkml@gmail.com>
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: [linux-usb-devel] [PATCH] : Allow embedded developers USB options normally reserved for OTG
Cc: "Robin Getz" <rgetz@blackfin.uclinux.org>,
       linux-usb-devel@lists.sourceforge.net, gregkh@suse.de,
       linux-kernel@vger.kernel.org
In-Reply-To: <200801021943.38716.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200801020948.51310.rgetz@blackfin.uclinux.org>
	 <200801021047.16036.david-b@pacbell.net>
	 <200801022203.04991.rgetz@blackfin.uclinux.org>
	 <200801021943.38716.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 3, 2008 11:43 AM, David Brownell <david-b@pacbell.net> wrote:
> On Wednesday 02 January 2008, Robin Getz wrote:
> > On Wed 2 Jan 2008 13:47, David Brownell pondered:
> > > On Wednesday 02 January 2008, Robin Getz wrote:
> > > > From: Robin Getz <rgetz@blackfin.uclinux.org>
> > > >
> > > > Allow embedded developers to turn support for USB Hubs off even if
> > > > they have a full root hub. This saves the overhead (RAM and Flash size).
> > >
> > > ISTR that it won't save very much code though ... the Linux USB
> > > stack structures all its enumeration logic around hubs.
> >
> > Today, there is an USB (Host), USB_GADGET and USB_OTG (which depends on USB &&
> > USB_GADGET).
> >
> > This just enables cutting more code out, with out having to have USB_GADGET &
> > USB_OTG enabled. When I checked - that is where most of the savings came
> > from.
>
> Right.  I'm not objecting to this at all.  Just pointing
> out that usbcore will still end up including quite a lot
> of hub functionality, because there's still going to be
> a root hub in the system and a khubd managing it.
>
> This patch might be improved slightly -- in ways that, as I
> understand things, could save some RAM on Blackfin! -- by
> having the BLACKLIST_HUB option get rid of the transaction
> translator support (changing C code not just Kconfig).
> It's pretty minimal, but won't be used...
>
> Also, as you point out, it's no longer OTG specific, so
> renaming the option would improve clarity.   Maybe to
> something along the lines of USB_HOST_NO_EXTERNAL_HUBS.
> No big deal, at least now.
>

Thanks, that's the point.
Maybe Robin can choose a good name of this option.
I am just very happy that when plug-in an external hubs or something
like that will not make our system hangs, -:)))

B.T.W, 2 questions about the MUSB driver:
1. What's the plan for mainline merge of the whole MUSB driver? maybe
I can cleanup current Blackfin ports to you guys.
2. Do you remember the PING issue I reported in OMAP list? How do you
think of that?

Best Regards,
-Bryan Wu
