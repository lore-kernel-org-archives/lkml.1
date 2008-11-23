Return-Path: <linux-kernel-owner+w=401wt.eu-S1757064AbYKWHaI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757064AbYKWHaI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 02:30:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751999AbYKWH3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 02:29:55 -0500
Received: from sd-green-bigip-145.dreamhost.com ([208.97.132.145]:53711 "EHLO
	spunkymail-a2.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751772AbYKWH3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 02:29:54 -0500
X-Greylist: delayed 89293 seconds by postgrey-1.27 at vger.kernel.org; Sun, 23 Nov 2008 02:29:54 EST
From: Yuval Hager <yuval@avramzon.net>
To: Michael Buesch <mb@bu3sch.de>
Subject: Re: BCM4312 Fails when xdm is started
Date: Sun, 23 Nov 2008 09:26:25 +0200
User-Agent: KMail/1.9.9
Cc: Larry Finger <Larry.Finger@lwfinger.net>, bcm43xx-dev@lists.berlios.de,
       LKML <linux-kernel@vger.kernel.org>,
       wireless <linux-wireless@vger.kernel.org>, Peter Stuge <peter@stuge.se>
References: <200811151801.02369.yuval@avramzon.net> <492825F8.6020606@lwfinger.net> <200811221654.09399.mb@bu3sch.de>
In-Reply-To: <200811221654.09399.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart6376066.XXdu72Ki2y";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200811230926.28948.yuval@avramzon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart6376066.XXdu72Ki2y
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Saturday 22 November 2008, Michael Buesch wrote:
> On Saturday 22 November 2008 16:32:08 Larry Finger wrote:
> > Michael Buesch wrote:
> > > Somebody disabled MMIO and busmastering.
> > > And somebody cleared the CACHE_LINE_SIZE register.
> >
> > Are these all the read/write bits in the configuration area? Should I
> > conclude that someone zeroed this area?
>
> Yeah well. I'm not sure. It _looks_ like someone completely cut the
> physical power line to the card and it reset its complete PCI config.
> So well, X does poke with the PCI devices. But as you said it also happens
> if X doesn't run, I'd rule that out.
> But I would not rule out a fucked BIOS, yet.
> Does the BIOS have any powersave options and/or spread-spectrum options f=
or
> the PCI-bus? Can you try to turn them all off?
> I have a machine that has PCI-slot autodetect and turns of the PCI clock,
> if it doesn't detect a card on that slot. Also turn that off, if you have
> it, too.
>
> > In case the kernel memory diagnostics don't help, is there any way to
> > trap writes to the configuration registers?
>
> Well, if we have random memory corruption, that can hit memory and MMIO.
> It doesn't hurt to turn on all debugging options. Often you get some hint
> by doing so.

I've enabled all CONFIG*DEBUG I could find relevant, and ran the system wit=
h:
'debug memory_corruption_check=3D1 devres.log=3D1 debug_objects debugpat=20
acpi.debug_layer=3D0x00410002 acpi.debug_level=3D0xffffffff'
but no hint appears in the logs during the failure.

I did find that certain events recreate the problem immediately. if I 'xset=
=20
dpms force standby' it happens on wakeup. 'xset -dpms' causes this=20
immediately as well. If I load X without DPMS support, it still happens aft=
er=20
the monitor is waken up from (hardware?) blackness.

=2D-yuval

--nextPart6376066.XXdu72Ki2y
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkkpBaQACgkQl7qmwPqEj9+5xwCePVEdxd06VeZD/7J9W4W37qro
xN8AniPoNoQykUukczuFFu11P+zm8Mom
=RM4s
-----END PGP SIGNATURE-----

--nextPart6376066.XXdu72Ki2y--
