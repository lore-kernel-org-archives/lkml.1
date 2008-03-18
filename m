Return-Path: <linux-kernel-owner+w=401wt.eu-S1753887AbYCRLeq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887AbYCRLeq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 07:34:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753049AbYCRLeU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 07:34:20 -0400
Received: from gateway.drzeus.cx ([85.8.24.16]:41950 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753432AbYCRLeS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 07:34:18 -0400
Date: Tue, 18 Mar 2008 12:33:25 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: "Tomas Winkler" <tomasw@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>, benzizbit@gmail.com
Subject: Re: SDIO: IO-Ready Bit
Message-ID: <20080318123325.0843b854@mjolnir.drzeus.cx>
In-Reply-To: <1ba2fa240803180400y1d7a2740t2c21b8b73a755016@mail.gmail.com>
References: <1ba2fa240803180400y1d7a2740t2c21b8b73a755016@mail.gmail.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAMAAABg3Am1AAAAAXNSR0IArs4c6QAAADNQTFRFEgwFRSofeTwxZEI1h1lFl1ZHeGBetHZk24VzuZJ43p2GsbKw/Lmg2MTL/NO3/+/Q//fpWFujUwAAAk5JREFUSMeNlVcWnDAMRd0bLux/tVGxiAEzic7hZ+Zd1IU6NtbYdn8daic/cgj52CPqLQ8hOBdjzsD8G2hHsCiPBS2/nTyABi93zvsYUyql1v6KSz30AeUAJLAK1uuDUI94WA7GDsAePtRDfwFRgP7DA8vvwOgQ1R5oYQUKAwOsfwDHDcAcWH+e5xagiooey1SwSAy0L8C7BaDKdgKWoNQtIjYEfHQGzMcKwNgCpLdgBn14ZzXNSPkJWK201vjiHMkXZg7AuQWCA7G2DPTiMSIsLSZxbgEIwlqEjE+9WBu0yaWOHwDLLQE9WmMieCBgtG1IAFgBzo7tlojGtbI3wFljuU4JdL3ghPeO+tFr2QHG0DOBSuN0kofaU302zmKbcTrgAWDUywG0OvXELi6gZScAdq6WnhYgvYDGu0YQjYSZs3ROID0B4y+jjpWyAhjePWkAjKwD5o09xioNBoro/+YQZjzTg8ce1CJtwFvwAMDFBEjv6cgI0P/u0DqtGJOjNSAm4e0jABxsgDYXSADQw2wwsFyzdePCAviE48QexseKNiGcp4jgKNEVAGC7QEwY5+S6Qpf50NzujHrdYgEKH0o8ZJ/AQR8HAGiaugDjG2i4ddZx4wToPwB0gQsEfjyFRKf1M+kLQC8u5iuoX8BhxYCQJPZXQ7LQdDnQR87/BdCpQQSJpREh7EMSQOvpYwJaqbAHgrUXkWehxhmUUjpsQ+IDSHlzEvidywrtDYSpnHVioNbstBLi9o3Dn/WqZ3Nw1pUQy8bN3/QdiPiVUZfpP4cDVEKd2cXEAAAAAElFTkSuQmCC
X-Face: @{|$W51qEixc&6}dq_38NM^&.vv|'{O)ae?DMZ1%VYxuhN2}5VpQ!'gx[{V+8Xw'+cV5*491_)-SU2YT8s@4`H;@:ELS'/P(@.JxxJi/C8mG0H#A^R<JfS_l?/%fD\D/mFJ8c2M?_kIL;:txa"s`0O*d+}p/4;$lAw@/e&h-nvQ)~q-a("De+&~-{5`:T{9d%0
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_hera.drzeus.cx-1580-1205840057-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_hera.drzeus.cx-1580-1205840057-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 18 Mar 2008 13:00:34 +0200
"Tomas Winkler" <tomasw@gmail.com> wrote:

> I'm working on SDIO multi function device.  One of the subdevices  a
> system device (SYS) who's  purpose among the others is to initialize
> the whole combo, mainly it's loads the firmware of the devices and
> kick the sub devices. Each of the sub devices has it's own driver.
> This dictates the order of the driver initialization and SYS device
> has to compete it's work before other subdeivces drivers can access
> the hardware. From hardware perspective device is ready when IO-Ready
> bit in SDIO is set.

What a delightfully unfriendly design...

> The first problem is that currently there is hard code timeout  in
> sdio_enable_func instead of using TPLFE_ENABLE_TIMEOUT_VAL
> /*
> 	 * FIXME: This should timeout based on information in the CIS,
> 	 * but we don't have card to parse that yet.
> 	 */
> 	timeout =3D jiffies + HZ
>=20
> This can be probably easily fixed. The significant issue is that this
> is done in busy wait loop and that probe functions are called in
> serially.

The SDIO spec doesn't really allow such a card to exist. So it's not surpri=
sing that things break. Does any stack support this odd-ball card?

>=20
> Since we cannot ensure that enumeration of SYS devices will be first
> the other sub devices will fail in their probe functions while calling
> sido_enable_func
>=20
> One option is to move the sdio_enable_func to be called from a work
> queue kicked from probe. This still requires non-busy wait timeout on
> IO-Ready bit and we cannot fail probe func
> if something goes wrong.
> Second option would be somehow split the sdio probe function across
> the enabled timeout.

I think it's a bit more complex than that. There are likely locks all over =
the place, both in the relevant driver and the driver model core, that make=
s this very difficult. Not to mention the fact that the correct timeout wil=
l be finite, and you never know how long it will take you to load the firmw=
are.

A better approach is to simply have the drivers for your subfunctions synch=
ronize things. Make sure noone calls sdio_enable_func() until the firmware =
has been loaded. This could even be done from user space in case you want t=
o use a standard driver.

Rgds
Pierre


--=_hera.drzeus.cx-1580-1205840057-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.8 (GNU/Linux)

iEYEARECAAYFAkffqIsACgkQ7b8eESbyJLjD6QCgp5s/QWRRHb7M1qXLFKpA3fSe
gYMAoJume2iVCZ01a416xEP0mDh07h54
=NbNK
-----END PGP SIGNATURE-----

--=_hera.drzeus.cx-1580-1205840057-0001-2--
