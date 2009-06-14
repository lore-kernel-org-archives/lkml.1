Return-Path: <linux-kernel-owner+w=401wt.eu-S1757678AbZFNKzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757678AbZFNKzu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 06:55:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756697AbZFNKzm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 06:55:42 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:49698 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755216AbZFNKzm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 06:55:42 -0400
Date: Sun, 14 Jun 2009 12:55:37 +0200
From: Pierre Ossman <pierre@ossman.eu>
To: Harald Welte <HaraldWelte@viatech.com>
Cc: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       JosephChan@via.com.tw, Bruce Chang <BruceChang@via.com.tw>
Subject: Re: [PATCH] mmc: Add new via-sdmmc host controller driver
Message-ID: <20090614125537.065d706a@mjolnir.ossman.eu>
In-Reply-To: <20090614065256.GJ2854@prithivi.gnumonks.org>
References: <20090612075930.GB30843@prithivi.gnumonks.org>
	<20090613134328.0c168205@mjolnir.ossman.eu>
	<20090614065256.GJ2854@prithivi.gnumonks.org>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-13829-1244976941-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-13829-1244976941-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 14 Jun 2009 14:52:56 +0800
Harald Welte <HaraldWelte@viatech.com> wrote:

> >=20
> > You need to do the removal as the first step=20
>=20
> Thanks, I've fixed this in my tree.=20
>=20
> Looking at other drivers, imxmmc seems to get this wrong, too.
>=20

Quite right. I suppose someone should have a look at that...

> > and you might need to explicitly kill any ongoing requests.
>=20
> you mean something like the snippet in sdhci.c:
> =3D=3D=3D=3D=3D=3D
>        if (dead) {
>                 spin_lock_irqsave(&host->lock, flags);
>=20
>                 host->flags |=3D SDHCI_DEVICE_DEAD;
>=20
>                 if (host->mrq) {
>                         printk(KERN_ERR "%s: Controller removed during "
>                                 " transfer!\n", mmc_hostname(host->mmc));
>=20
>                         host->mrq->cmd->error =3D -ENOMEDIUM;
>                         tasklet_schedule(&host->finish_tasklet);
>                 }
>=20
>                 spin_unlock_irqrestore(&host->lock, flags);
>         }
> =3D=3D=3D=3D=3D=3D
>=20
> Why is sdhci about the only driver that does it?  What decides if we need
> to kill ongoing requests or not?
>=20

I guess I haven't kept an eye on it so the others are simply buggy.

> Also, you stated that mmc_remove_host needs to be the first step.  Howeve=
r,
> sdhci first kills the ongoing rquest (if "dead"), and then removes the ho=
st.
>=20

Right, because the reason you need to end the request is that failure
to do so will wedge the MMC system and mmc_remove_host() will never
return.

Normally the requests will eventually be completed by interrupts coming
from the hardware, but if it got removed then that might not happen.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-13829-1244976941-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAko01y0ACgkQ7b8eESbyJLjeYACgprofQm4ssqwIKQkrhMEQYuqn
X6wAoPxeuboHqBzVKBFuBgpsnBCPkJo1
=hX8R
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-13829-1244976941-0001-2--
