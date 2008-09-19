Return-Path: <linux-kernel-owner+w=401wt.eu-S1757347AbYISIt1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757347AbYISIt1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 04:49:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750961AbYISItS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 04:49:18 -0400
Received: from metis.extern.pengutronix.de ([83.236.181.26]:43930 "EHLO
	metis.extern.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750868AbYISItR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 04:49:17 -0400
Date: Fri, 19 Sep 2008 10:49:14 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: "Hans J. Koch" <hjk@linutronix.de>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de
Subject: Re: [PATCH] [UIO] Add alignment warnings for uio-mem
Message-ID: <20080919084914.GA4307@pengutronix.de>
References: <20080918144615.GD4226@pengutronix.de> <20080918215318.GD2991@local>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yrj/dFKFPuw6o+aM"
Content-Disposition: inline
In-Reply-To: <20080918215318.GD2991@local>
User-Agent: Mutt/1.5.16 (2007-06-11)
X-SA-Exim-Connect-IP: 10.1.0.71
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.extern.pengutronix.de); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yrj/dFKFPuw6o+aM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Hans,

On Thu, Sep 18, 2008 at 11:53:18PM +0200, Hans J. Koch wrote:

> With your approach, sysfs would report a base address of 0x12345000 and
> a size of 0x90. Both is a lie. We don't want to encourage the user to
> access addresses outside the 16 bytes range the driver author originally
> announced.

True. It's actually quite dangerous to be able to write outside that
region at all, but I guess this can't be helped due to the nature of
mmap.

> UIO drivers are often used in embedded devices, where developers usually
> know the physical addresses of their devices and have them hardcoded in
> a #define. It's confusing if sysfs suddenly reports something different.
>=20
> The userspace part of the driver expects a 16 bytes range but is told
> there are 0x90 bytes at his disposal. It has to guess where the devices
> registers are (or if this is a completely different device...). It might
> also check the physical base address and find that this is wrong, too.
>=20
> The situation becomes even worse if you have two such chips on your
> board, and each reports a different size. If their addresses were in the
> same page, both would have the same base address, but different sizes...

ACK.

> Let's leave it to userspace. All userspace needs is the "offset"
> information you calculate in your patch. If we add a new sysfs attribute
> for that, userspace can simply add it to the address returned by mmap().
> This way, the userspace part of the driver will always work, no matter
> if the memory is page aligned or not. The "addr" and "size" attributes
> still report the true physical base address and size. _Every_ userspace
> driver, existing or yet to be written, can (and should) simply do
> something like
>=20
> base_addr =3D address_returned_by_mmap + offset_from_sysfs;
>=20
> What do you think about this? If you think this might work for you,
> could you please test the patch below? I haven't got such a hardware
> handy at the moment, so my patch is just compile-tested (but it looks
> obvious).

I'm perfectly fine with this approach. I tested it and it worked as
expected. The only thing I'd like to add is that 'offset' could be
renamed to 'map_offset' or 'mmap_offset' to be a bit more precise what
this value is about.

> Thanks again for pointing this out,

You're welcome. Thanks for dealing with the issue.

All the best,

   Wolfram

--=20
  Dipl.-Ing. Wolfram Sang | http://www.pengutronix.de
 Pengutronix - Linux Solutions for Science and Industry

--yrj/dFKFPuw6o+aM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFI02eKD27XaX1/VRsRAn7QAKDEP0wWwp+PRRk2gGZKQOy0fMcB2ACfdRVs
UQGSV7jgxNPHUmoh0njq3P0=
=bfMx
-----END PGP SIGNATURE-----

--yrj/dFKFPuw6o+aM--
