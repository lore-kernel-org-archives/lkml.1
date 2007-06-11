Return-Path: <linux-kernel-owner+w=401wt.eu-S1763037AbXFKFBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763037AbXFKFBy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 01:01:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761296AbXFKFBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 01:01:37 -0400
Received: from an-out-0708.google.com ([209.85.132.246]:41078 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764101AbXFKFBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 01:01:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=eONKyIJutj2VbCZUQrSRtc87Qck9OO/jaEmmm+aRnOc6QEd8IHspUMVwtvCwQ39ymV/D2RCweoWrpPiAcCXsbBDYyQX2F+15Zppr5IZbfH0bsKsVBoPBFWCh+2JtPPg6KXqowIv27zT23gM8uWiEoLNbRV9WTf5uJ36ZvYviROU=
Message-ID: <e9c3a7c20706102201y536de24ft2daf8fbed066e28f@mail.gmail.com>
Date: Sun, 10 Jun 2007 22:01:34 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.22-rc4-mm1
Cc: "Herbert Xu" <herbert@gondor.apana.org.au>,
       "Jan Engelhardt" <jengelh@linux01.gwdg.de>,
       "Mariusz Kozlowski" <m.kozlowski@tuxland.pl>,
       linux-kernel@vger.kernel.org, "Neil Brown" <neilb@suse.de>,
       "Leech, Christopher" <christopher.leech@intel.com>,
       "Jeff Garzik" <jeff@garzik.org>, davem@davemloft.net,
       "Wolfgang Denk" <wd@denx.de>
In-Reply-To: <20070607001218.742c0ba5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070606020737.4663d686.akpm@linux-foundation.org>
	 <200706062132.37430.m.kozlowski@tuxland.pl>
	 <20070606132439.3f59f0cf.akpm@linux-foundation.org>
	 <20070606212831.GA1534@gondor.apana.org.au>
	 <20070606164202.a3dcd176.akpm@linux-foundation.org>
	 <Pine.LNX.4.61.0706070852580.1547@yvahk01.tjqt.qr>
	 <20070607070108.GA8013@gondor.apana.org.au>
	 <20070607001218.742c0ba5.akpm@linux-foundation.org>
X-Google-Sender-Auth: 1ab6b4a0ca6d2ab9
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/7/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Thu, 7 Jun 2007 17:01:08 +1000 Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> > On Thu, Jun 07, 2007 at 08:54:50AM +0200, Jan Engelhardt wrote:
> > >
> > > /me points at Herbert
> > > Andrew would not add options between the "menuconfig CRYPTO" and
> > > the "if CRYPTO" line... :)
> >
> > Actually this patch is not even in my tree :)
>
> uh, OK, sorry.
>
> > > Index: linux-2.6.22-rc4/crypto/Kconfig
> > > ===================================================================
> > > --- linux-2.6.22-rc4.orig/crypto/Kconfig
> > > +++ linux-2.6.22-rc4/crypto/Kconfig
> > > @@ -7,6 +7,8 @@ menuconfig CRYPTO
> > >     help
> > >       This option provides the core Cryptographic API.
> > >
> > > +if CRYPTO
> > > +
> > >  #
> > >  # Generic algorithms support
> > >  #
> > > @@ -18,8 +20,6 @@ config XOR_BLOCKS
> > >  #
> > >  source "crypto/async_tx/Kconfig"
> >
> > Andrew, do you want me to pick the async_tx stuff up instead?
> >
>
It would be very helpful to have a clear merge path for dmaengine
changes and the async offload api.  Neil has been extremely helpful
reviewing the raid specific changes, and I received his "Acked-by" for
the changes to MD[1].  However I have thus far been unable to attract
someone to 'ack/nak' the async_tx api and the changes to drivers/dma/
[2].  Jeff commented on an early revision...

I have recently gravitated to Herbert and the crypto directory since
async_tx and crypto have some structural similarities [3].

> I wouldn't recommend it.  It's an ongoing source of bustage frankly, has a
> habit of getting unpleasantly tangled with git-ioat.patch and afaik is
> still awaiting a go-ahead from Neil.
>

Sorry, the crypto/Kconfig bustage was a goof on my part as I moved the
async_tx files from drivers/dma/, to the top-level directory, and
finally to crypto/.  Hopefully these recent build breakages I have
caused in -mm have not put the series in too negative a light...

I was hoping the git-ioat.patch situation would be solved by me
rebasing my series on a version of mainline with Chris' changes
merged, but his attempts over the past two merge windows were ignored.
 Should my series wait outside of -mm until git-ioat.patch makes
forward progress?

Overall, I feel that async_tx is perhaps justifiably receiving the
silent treatment because offload engines are not a mainstream
occurrence.  Currently only people with an Xscale IOP or a PPC 440spe
[4] will notice that mainline lacks support for all the features of
their platform.  I see async_tx as a nod to the embedded space where
offload engines act to make up for the absence of multi-Ghz CPUs with
streaming SIMD instructions.

Herbert's offer is greatly appreciated as it will give guidance to the
parts of the series outside of Neil's purview.

Regards,
Dan

[1]: The ack from Neil was in an offlist message for the MD specific
portion of the series
[2]: I asked DaveM and netdev to take a look at the two patches in the
series that change drivers/dma/ and net/core/dev.c since that was the
original merge path for I/OAT and dmaengine
[3]: async_tx is similar to crypto in that they both provide a library
of memory transforms that can in some cases be carried out by
hardware.
[4]: async_tx has attracted at least one other developer that I know
about to write a driver for their engines:
http://marc.info/?l=linux-raid&m=117400143317440&w=2
