Return-Path: <linux-kernel-owner+w=401wt.eu-S1757446AbZEVLwM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757446AbZEVLwM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 07:52:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752577AbZEVLv7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 07:51:59 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:47811 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753455AbZEVLv6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 07:51:58 -0400
Date: Fri, 22 May 2009 13:51:50 +0200
From: Pierre Ossman <pierre@ossman.eu>
To: dsaxena@plexity.net
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MMC: Add 400ms to CAFE SD controller resume path
Message-ID: <20090522135150.7e0716d6@mjolnir.ossman.eu>
In-Reply-To: <20090513200556.GA7882@plexity.net>
References: <20090513200556.GA7882@plexity.net>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-27010-1242993113-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-27010-1242993113-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 13 May 2009 20:05:56 +0000
Deepak Saxena <dsaxena@plexity.net> wrote:

>=20
> The CAFE SD controller takes a long time to completely resume
> and w/o this patch, we do not redetect an existing card but
> instead detect it as a new one. Even with MMC_UNSAFE_RESUME
> enabled, this leads to the partition table on the device being
> wiped out.
>    =20
> See http://dev.laptop.org/ticket/6532 for gory details.
>=20
> Signed-off-by: Deepak Saxena <dsaxena@laptop.org>
>=20

Reading through that report, I don't believe you properly worked around
the bug. You only avoid bug 1339, but that's only mildly related.

What this workaround does is to make sure that MMC_UNSAFE_RESUME
actually works. But if you change cards during suspend, the VFS bug
should reappear and you'll corrupt the partition table.

And as for 1339, has there been any more work done on why this problem
doesn't appear in OFW? I'd be a lot happier if we could make things
work without artificial delays.

RGds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-27010-1242993113-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkoWkdkACgkQ7b8eESbyJLh2UwCg6XJQf33J/tolWIx+TnPxc41k
nv8AnAv6cRMBIAvZvSq0r38pZUjJjKhc
=THfJ
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-27010-1242993113-0001-2--
