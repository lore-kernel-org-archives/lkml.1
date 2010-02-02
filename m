Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827Ab0BBKhp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 05:37:45 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:58686 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755114Ab0BBKho (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 05:37:44 -0500
Date: Tue, 2 Feb 2010 21:37:32 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Takashi Iwai <tiwai@suse.de>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: linux-next: sound tree build failure
Message-Id: <20100202213732.586a3566.sfr@canb.auug.org.au>
In-Reply-To: <20100202102609.GA6566@rakim.wolfsonmicro.main>
References: <20100202124711.d8cdc220.sfr@canb.auug.org.au>
	<20100202102609.GA6566@rakim.wolfsonmicro.main>
X-Mailer: Sylpheed 3.0.0beta6 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__2_Feb_2010_21_37_32_+1100_mmkSNkwxy/poS3rn"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__2_Feb_2010_21_37_32_+1100_mmkSNkwxy/poS3rn
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mark,

On Tue, 2 Feb 2010 10:26:10 +0000 Mark Brown <broonie@opensource.wolfsonmic=
ro.com> wrote:
>
> This looks really odd - all those headers are present in the linux-next
> tree (and have been for a few days) as far as I can tell, and I can't
> see any way they could not be found without serious breakage elsewhere.
> Could you please re-run your build with V=3D1 to show the kernel command
> line used to build the driver?  I can't reproduce this here and like I
> say I can't see how this could happen given that those files are there
> in -next and it's hard to see how this could happen.

The sound tree is merged before the mfd tree, and the commit that adds
those is only in the mfd tree.  So the sound tree, on its own, is
broken.  This driver will only build if you merge the mfd tree as well.

> > Caused by commit 9e6e96a197a03752d39a63e4f83e0b707ccedad7 ("ASoC: Add
> > WM8994 CODEC driver").  I presume that this commit depends on commits
> > currently only in the mfd tree ...
>=20
> Not exactly, there's a Kconfig dependency which should keep track of
> things but the wrong one got merged over when things got split out to go
> into the several trees.  Though for allmodconfig that will not be
> relevant since the dependency will be satisfied anyway and the headers
> don't need Kconfig to pull them in.
>=20
> Like I say, everything required is in the MFD tree in -next anyway.

yes, but I do builds between merging trees ...

> > I have used the sound tree from next-20100201 for today.
>=20
> > To fix this, the relevant commits from the mfd tree could be put into a
> > "never to be rebased" branch (or separate git tree) and then this branch
> > merged into both the sound and mfd trees.
>=20
> This is not needed, Kconfig will handle it.

Kconfig has nothing to do with it, sorry.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__2_Feb_2010_21_37_32_+1100_mmkSNkwxy/poS3rn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktoAGwACgkQjjKRsyhoI8z0iwCeJdmhi+uRKgFRhS+iM5+3zSWb
3wgAnjD9j8Pc245rBmnNEHq1tcLVgAAm
=V0kj
-----END PGP SIGNATURE-----

--Signature=_Tue__2_Feb_2010_21_37_32_+1100_mmkSNkwxy/poS3rn--
