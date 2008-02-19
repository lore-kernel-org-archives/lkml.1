Return-Path: <linux-kernel-owner+w=401wt.eu-S1758969AbYBSIQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758969AbYBSIQs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 03:16:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752674AbYBSIQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 03:16:37 -0500
Received: from mail.free-electrons.com ([88.191.46.45]:3492 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920AbYBSIQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 03:16:36 -0500
Date: Tue, 19 Feb 2008 09:16:08 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: "Kyungmin Park" <kmpark@infradead.org>
Cc: "Linux Filesystem Mailing List" <linux-fsdevel@vger.kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: Question about synchronous write on SSD
Message-ID: <20080219091608.1da174c1@crazy>
In-Reply-To: <9c9fda240802182148m6fd632pa7988530c5387245@mail.gmail.com>
References: <9c9fda240802182148m6fd632pa7988530c5387245@mail.gmail.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/hK.EC5B879/owmBEF=6aSC/";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/hK.EC5B879/owmBEF=6aSC/
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,

Le Tue, 19 Feb 2008 14:48:18 +0900,
"Kyungmin Park" <kmpark@infradead.org> a =C3=A9crit :

> +               /* Write synchronous */
> +               bio->bi_rw |=3D (1 << BIO_RW_SYNC);

Adding BIO_RW_SYNC doesn't make generic_make_request() synchronous as
in "generic_make_request() returns only after write completion".
BIO_RW_SYNC only asks the I/O layer to unplug immediatly. But
generic_make_request() still returns before the completion of the I/O,
and the completion is notified asynchronously.

See:
 http://lxr.free-electrons.com/source/include/linux/bio.h#139

Sincerly,

Thomas
--=20
Thomas Petazzoni, Free Electrons
Free Embedded Linux Training Materials
on http://free-electrons.com/training
(More than 1500 pages!)

--Sig_/hK.EC5B879/owmBEF=6aSC/
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHupBI9lPLMJjT96cRAvJPAJwOdj8Xw+G1JpVZeEqQpwcMRhNE/ACdFLWM
o+ZIbWPj5UKRhUTbPLSzgoY=
=iuob
-----END PGP SIGNATURE-----

--Sig_/hK.EC5B879/owmBEF=6aSC/--
