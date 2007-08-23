Return-Path: <linux-kernel-owner+w=401wt.eu-S1756719AbXHWCRB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756719AbXHWCRB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 22:17:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751526AbXHWCQx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 22:16:53 -0400
Received: from threatwall.zlynx.org ([199.45.143.218]:32930 "EHLO zlynx.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751264AbXHWCQx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 22:16:53 -0400
Subject: Re: 2.6.23-rc3-mm1 - memory layout change?  - lost support for
	MAP_32BIT? - mono crashes
From: Zan Lynx <zlynx@acm.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070822020648.5ea3a612.akpm@linux-foundation.org>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-SXmfEWf0C2kEV1sgjsy+"
Date: Wed, 22 Aug 2007 20:08:25 -0600
Message-Id: <1187834905.190825.16.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
X-Envelope-From: zlynx@acm.org
X-Spam-Id: 20070822/1IO2Fe-0000GZ-TF-linux-kernel@vger.kernel.org:zlynx@acm.org:199.45.143.218
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-SXmfEWf0C2kEV1sgjsy+
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-08-22 at 02:06 -0700, Andrew Morton wrote:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc3/=
2.6.23-rc3-mm1/

After installing this new wonder kernel on my AMD-64 laptop, I
discovered that Beagle wouldn't start.  While enjoying how fast my
system felt ( :) ) I also discovered that Evolution wouldn't start
because it was built with mono integration.

Can't live without email, so I poked at it and discovered that if I run
mono applications (including Evolution) with the legacy memory layout,
they work.

Like this: setarch x86_64 -L evolution

This didn't happen on -rc2-mm2, so I think somebody changed something.
Mono claims to mmap with the MAP_32BIT option.

In -rc3-mm1 strace shows mono's mmap like this:
mmap(NULL, 65536, PROT_READ|PROT_WRITE|PROT_EXEC, MAP_PRIVATE|MAP_ANONYMOUS=
|MAP_32BIT, -1, 0) =3D 0x7fa21f5cb000

It's got MAP_32BIT, but that's not a 32-bit address...
--=20
Zan Lynx <zlynx@acm.org>

--=-SXmfEWf0C2kEV1sgjsy+
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.6 (GNU/Linux)

iD8DBQBGzOwZG8fHaOLTWwgRApzTAJ0QJq9tNhT21DVWTD1q6+IGKHeILQCfT3dG
NLl+dgWvG5SIGrjWSv/RQEU=
=DHjD
-----END PGP SIGNATURE-----

--=-SXmfEWf0C2kEV1sgjsy+--

