Return-Path: <linux-kernel-owner+w=401wt.eu-S1754399AbYJPPvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754399AbYJPPvg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 11:51:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754274AbYJPPv0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 11:51:26 -0400
Received: from mail.phnxsoft.com ([195.227.45.4]:1693 "EHLO
	posthamster.phnxsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753693AbYJPPv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 11:51:26 -0400
Message-ID: <48F762CA.4080608@imap.cc>
Date: Thu, 16 Oct 2008 17:50:34 +0200
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de-AT; rv:1.8.1.17) Gecko/20080829 SeaMonkey/1.1.12
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       Hansjoerg Lipp <hjlipp@web.de>
Subject: Re: [PATCH 72/80] tty: fix up gigaset a bit
References: <20081013092758.21645.2359.stgit@localhost.localdomain> <20081013094438.21645.30934.stgit@localhost.localdomain>
In-Reply-To: <20081013094438.21645.30934.stgit@localhost.localdomain>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigB0E586D197C17E86E7CDAD47"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigB0E586D197C17E86E7CDAD47
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Am 13.10.2008 11:44 schrieb Alan Cox:
> From: Alan Cox <alan@redhat.com>
>=20
> Stephen's fixes reminded me that gigaset is still rather broken so fix =
it up
> a bit
>=20
> Signed-off-by: Alan Cox <alan@redhat.com>

Acked-by: Tilman Schmidt <tilman@imap.cc>

Thanks, Alan, for these improvements.
I'm now looking into the FIXME comments you added.

> @@ -571,6 +571,7 @@ gigaset_tty_close(struct tty_struct *tty)
>  	}
> =20
>  	/* prevent other callers from entering ldisc methods */
> +	/* FIXME: should use the tty state flags */
>  	tty->disc_data =3D NULL;
> =20
>  	if (!cs->hw.ser)

Do you know of an example line discipline that has got this right?
My model for this code was drivers/net/ppp_async.c but now it seems
that this was not as exemplary as I had hoped.

> @@ -680,6 +675,8 @@ gigaset_tty_ioctl(struct tty_struct *tty, struct fi=
le *file,
>  /*
>   * Poll on the tty.
>   * Unused, always return zero.
> + *
> + * FIXME: should probably return an exception - especially on hangup
>   */
>  static unsigned int
>  gigaset_tty_poll(struct tty_struct *tty, struct file *file, poll_table=
 *wait)

Looking around, I see that many LDs don't even provide a poll method.
So I'm thinking of just dropping this one. Would that be ok?

Thanks,
Tilman

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=C3=B6ffnet mindestens haltbar bis: (siehe R=C3=BCckseite)


--------------enigB0E586D197C17E86E7CDAD47
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.4 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFI92LSQ3+did9BuFsRAsU5AJwJJxBS/7Jt2Taad78R6fmM7rpE6gCeIXyK
2Ri88TzX1AhtLjY7uFj4jHA=
=1lOU
-----END PGP SIGNATURE-----

--------------enigB0E586D197C17E86E7CDAD47--
