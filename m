Return-Path: <linux-kernel-owner+w=401wt.eu-S1764119AbXHWRcw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764119AbXHWRcw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 13:32:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755481AbXHWRcn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 13:32:43 -0400
Received: from threatwall.zlynx.org ([199.45.143.218]:33027 "EHLO zlynx.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754089AbXHWRcm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 13:32:42 -0400
Subject: Re: 2.6.23-rc3-mm1 - memory layout change?  - lost support for
	MAP_32BIT? - mono crashes
From: Zan Lynx <zlynx@acm.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0708231126380.2460@twin.jikos.cz>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>
	 <1187834905.190825.16.camel@localhost>
	 <Pine.LNX.4.64.0708231126380.2460@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-DzqioQHIhYweFV+q8YuF"
Date: Thu, 23 Aug 2007 11:32:33 -0600
Message-Id: <1187890353.8684.2.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
X-Envelope-From: zlynx@acm.org
X-Spam-Id: 20070823/1IOGXr-0006Zq-Ew-linux-kernel@vger.kernel.org:zlynx@acm.org:199.45.143.218
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-DzqioQHIhYweFV+q8YuF
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-08-23 at 11:28 +0200, Jiri Kosina wrote:
> On Wed, 22 Aug 2007, Zan Lynx wrote:
>=20
> > After installing this new wonder kernel on my AMD-64 laptop, I=20
> > discovered that Beagle wouldn't start.  While enjoying how fast my=20
> > system felt ( :) ) I also discovered that Evolution wouldn't start=20
> > because it was built with mono integration.
> [...]
> > Mono claims to mmap with the MAP_32BIT option.
> > In -rc3-mm1 strace shows mono's mmap like this:
> > mmap(NULL, 65536, PROT_READ|PROT_WRITE|PROT_EXEC, MAP_PRIVATE|MAP_ANONY=
MOUS|MAP_32BIT, -1, 0) =3D 0x7fa21f5cb000
>=20
> Hi Zan,
>=20
> thanks for an excellent bugreport. Rather than throwing the whole=20
> pie-randomization and flexmmap support away, could you please test the=20
> patch below and let me know whether it fixes all your issues? Thanks.
>=20
>=20
> From: Jiri Kosina <jkosina@suse.cz>
>=20
> Handle MAP_32BIT flags properly in x86_64 flexmmap
>=20
> We need to handle MAP_32BIT flags of mmap() properly for 64bit=20
> applications with filexible mmap layout.
>=20
> This patch introduces x86_64-specific version of=20
> arch_get_unmapped_area_topdown() which differs from the generic one in=20
> handling of the MAP_32BIT flag -- when this flag is passed to mmap(), we=20
> stick back to the legacy layout for this particular mmap, which gives=20
> proper 32bit range.
>=20
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
[snip patch]

This does fix the mono problem.  Thank you.
--=20
Zan Lynx <zlynx@acm.org>

--=-DzqioQHIhYweFV+q8YuF
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.6 (GNU/Linux)

iD8DBQBGzcSxG8fHaOLTWwgRAg+xAJ4oLYgmjTAy+8NiC5+julu9klA7ZgCeKVe7
oCPIO2KcnmH0AANSlO/BIEY=
=BGq8
-----END PGP SIGNATURE-----

--=-DzqioQHIhYweFV+q8YuF--

