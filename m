Return-Path: <linux-kernel-owner+w=401wt.eu-S1757214AbZJLPge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757214AbZJLPge (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 11:36:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755084AbZJLPgd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 11:36:33 -0400
Received: from adsl-67-113-118-6.dsl.sndg02.pacbell.net ([67.113.118.6]:52681
	"EHLO multivac.one-eyed-alien.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756090AbZJLPgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 11:36:33 -0400
X-Greylist: delayed 1336 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Oct 2009 11:36:32 EDT
Date: Mon, 12 Oct 2009 08:12:43 -0700
From: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ben Efros <ben@pc-doctor.com>,
       Josua Dietze <digidietze@draisberghof.de>,
       fangxiaozhi <huananhu@huawei.com>, Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>, Hugh Blemings <hugh@blemings.org>
Subject: Re: USB serial regression 2.6.31.1 -> 2.6.31.2 [PATCH]
Message-ID: <20091012151243.GF24502@one-eyed-alien.net>
Mail-Followup-To: Alan Stern <stern@rowland.harvard.edu>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Ben Efros <ben@pc-doctor.com>,
	Josua Dietze <digidietze@draisberghof.de>,
	fangxiaozhi <huananhu@huawei.com>, Greg KH <greg@kroah.com>,
	Kernel development list <linux-kernel@vger.kernel.org>,
	USB list <linux-usb@vger.kernel.org>,
	Hugh Blemings <hugh@blemings.org>
References: <1255326252.2192.110.camel@pasglop> <Pine.LNX.4.44L0.0910121052550.11420-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dWYAkE0V1FpFQHQ3"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0910121052550.11420-100000@netrider.rowland.org>
User-Agent: Mutt/1.4.2.3i
Organization: One Eyed Alien Networks
X-Copyright: (C) 2009 Matthew Dharm, all rights reserved.
X-Message-Flag: Get a real e-mail client.  http://www.mutt.org/
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (multivac.one-eyed-alien.net [127.0.0.1]); Mon, 12 Oct 2009 08:12:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dWYAkE0V1FpFQHQ3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 12, 2009 at 10:58:40AM -0400, Alan Stern wrote:
> On Mon, 12 Oct 2009, Benjamin Herrenschmidt wrote:
> >=20
> > Alan, what do you think ? I definitely don't like Ben E's most recent
> > patch with a quirk for all devices, it's simply a lot more code for
> > something that will come back and bite again when somebody does the
> > same mistake again. I'd rather have the request sense code be more
> > robust. But this patch is fine, as was my previous one.
>=20
> I agree that it seems silly to have a flag _for_ SANE_SENSE and another=
=20
> flag _against_ SANE_SENSE.  Retrying seems easier and more robust.

Dualing flags, where one is auto-set and the other quirked, is almost
guaranteed to get us into a maintance nightmare.

> > So it boils down on clearing SANE_SENSE vs. not clearing it. If we
> > clear it, we probably want to keep it cleared (via an INSANE_SENSE
> > flag ?). But on the other hand, I don't think that always going
> > for a retry when a SANE_SENSE fails is going to hurt and sounds
> > like the robust thing to do, so I don't mind that simple patch
> > from Ben. So up to you :-)
>=20
> I agree; it won't hurt much and only if the device is buggy to begin=20
> with.

I agree; the extra retry is more robust, more straightforward, and more
maintainable long-term.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

My mother not mind to die for stoppink Windows NT!  She is rememberink=20
Stalin!
					-- Pitr
User Friendly, 9/6/1998

--dWYAkE0V1FpFQHQ3
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFK00drHL9iwnUZqnkRAiN7AKClmbRO4Xd6mzhtneKwV+q8lYkl+gCgqbUs
Xyb6JL67iuTUS/Hk/gOy+LY=
=X357
-----END PGP SIGNATURE-----

--dWYAkE0V1FpFQHQ3--
