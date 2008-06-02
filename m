Return-Path: <linux-kernel-owner+w=401wt.eu-S1760186AbYFBMeI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760186AbYFBMeI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 08:34:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754203AbYFBMdz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 08:33:55 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:60126 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327AbYFBMdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 08:33:54 -0400
Subject: Re: Wireless-testing's b43 panics in b43_generate_txhdr on packet
	transmit
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Pavel Roskin <proski@gnu.org>,
       Stefanik =?ISO-8859-1?Q?G=E1bor?= <netrolller.3d@gmail.com>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       "bcm43xx-dev@lists.berlios.de" <bcm43xx-dev@lists.berlios.de>,
       linux-kernel@vger.kernel.org
In-Reply-To: <200805311954.46639.mb@bu3sch.de>
References: <69e28c910805310723j2b721030x2609cc9e866abafa@mail.gmail.com>
	 <200805311841.46740.mb@bu3sch.de> <1212252636.2766.10.camel@rd>
	 <200805311954.46639.mb@bu3sch.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-IjDgBDMMHmhzueiPQcun"
Date: Mon, 02 Jun 2008 09:47:07 +0200
Message-Id: <1212392827.4148.11.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-IjDgBDMMHmhzueiPQcun
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-05-31 at 19:54 +0200, Michael Buesch wrote:
> On Saturday 31 May 2008 18:50:36 Pavel Roskin wrote:
> > On Sat, 2008-05-31 at 18:41 +0200, Michael Buesch wrote:
> > > On Saturday 31 May 2008 18:34:29 Stefanik G=C3=A1bor wrote:
> > > > "BUG: unable to handle kernel NULL pointer dereference at 00000004
> > > > IP: [<f8dd3a99>] :b43:b43_generate_txhdr+0x6a9/0x790
> > >=20
> > > So can you put a few printks into the function to see where it derefe=
rences
> > > a NULL pointer? (or use gdb to lookup the offset).
> >=20
> > u8 key_idx =3D info->control.hw_key->hw_key_idx;
> >=20
> > info->control.hw_key is NULL.
>=20
> Is a NULL pointer supposed to tell "do not encrypt", or is this a mac8021=
1 bug?

It looks like a mac80211 bug, but I can't see how we get there.

If you look at mac80211's tx.c, you'll see, in
ieee80211_tx_h_select_key:

        if (!tx->key || !(tx->key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE))
                info->flags |=3D IEEE80211_TX_CTL_DO_NOT_ENCRYPT;

Hence, I haven't got a clue how you can possibly get into the situation
we have here, even with packet injection. Unless it's a different
version of mac80211 or something.

johannes

--=-IjDgBDMMHmhzueiPQcun
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASEOleqVg1VMiehFYAQJRNA//UIM8hY1Ph5sp270OCuhTHz4F8Y+nrXde
kZmwVw4W14TQN042ILwJApp6lwnuxw2Mmc6C0Ugnfo2nC1dM7kLfqgWxDJEnH00v
CFV82x80zN7tzYL1YV/N/XlgoFvOVFPV3ensSE9GLyKs9g5NnEE/4JmxZ6SgjCg1
zfm8bDmJOmq824/h9X3roAp4tkpKZZSIXsbDP01cbcYqk1OfWPg0hMYI00fhnzXi
jMZl0LwtIvdyky2EKP1UPAgNJmyavKBE/eRIVq+6UocfBZbIXUxvNgqi9UwB0Dc0
Qojrpgvlkmu+qRjN4aBXHTKZKJjdeTE80MtX5f1FHFSvIjUleZ4iYsXadu0aAui6
Uu3+iWlEN7POmbTiKiXhx6SwJnm9iQVYmXWSMhpTLX1Nw9OdbsoT0uGjAoDk/bh2
gbEsEPqf62dq4zZ2WTbrONMALoJNydu0vnPI+id670jAqQQ75L+a+NsQlyOS8cbk
mHUC/WbQK/eKg8PFvWgeb6Cok5QtohQvNanRrWEknS1cJXT9A671KhFek9umqYe/
4M1R6scWv7uMXiJFqfgATruqr2DgCinRMOx4G4Fidefkxtm2jJtKlXgpcGrSvFXb
8jJrSyUK+a3cwGBp1mnFDUYKcOyaA8qwj36dCZ2CyZR6JmwjwYiKEwhTMTIeD+R0
+OvpKMBHBrU=
=zdeU
-----END PGP SIGNATURE-----

--=-IjDgBDMMHmhzueiPQcun--

