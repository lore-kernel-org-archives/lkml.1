Return-Path: <linux-kernel-owner+w=401wt.eu-S1756687AbYFZOVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687AbYFZOVW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 10:21:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753730AbYFZOVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 10:21:10 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34849 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752138AbYFZOVJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 10:21:09 -0400
Date: Fri, 27 Jun 2008 00:21:00 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jiri Kosina <jkosina@suse.cz>, kernel-testers@vger.kernel.org,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: linux-next: Tree for June 25
Message-Id: <20080627002100.396d5cbb.sfr@canb.auug.org.au>
In-Reply-To: <200806261249.24340.rjw@sisk.pl>
References: <20080626003554.b2623aba.sfr@canb.auug.org.au>
	<200806260859.26270.rjw@sisk.pl>
	<alpine.LRH.1.10.0806261201420.10290@twin.jikos.cz>
	<200806261249.24340.rjw@sisk.pl>
X-Mailer: Sylpheed 2.5.0rc2 (GTK+ 2.12.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__27_Jun_2008_00_21_00_+1000_JU3MZ7Lk=IY9NVDI"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__27_Jun_2008_00_21_00_+1000_JU3MZ7Lk=IY9NVDI
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 26 Jun 2008 12:49:23 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
>
> > I guess this got in through Rusty's tree, right?
> >=20
> > Does the patch below fix it please?
>=20
> Yes, it does.

I have applied this patch to today's linux-next tree.

Rusty can you put this in you tree (or amend the patch that needs this)?

> > From: Jiri Kosina <jkosina@suse.cz>
> > Subject: [PATCH] module: fix NULL pointer dereference in find_symbol()
> >=20
> > The patch that introduces each_symbol() iterator forgets to
> > test the NULL value of the output parameters (which the original
> > code did).
> >=20
> > This patch restores the correct checks.
> >=20
> > Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> > ---
> >   kernel/module.c |    6 ++++--
> >   1 files changed, 4 insertions(+), 2 deletions(-)
> >=20
> > diff --git a/kernel/module.c b/kernel/module.c
> > index 880409f..a3354ca 100644
> > --- a/kernel/module.c
> > +++ b/kernel/module.c
> > @@ -304,8 +304,10 @@ static unsigned long find_symbol(const char *name,
> >   	fsa.warn =3D warn;
> >=20
> >   	if (each_symbol(find_symbol_in_section, &fsa)) {
> > -		*owner =3D fsa.owner;
> > -		*crc =3D fsa.crc;
> > +		if (owner)
> > +			*owner =3D fsa.owner;
> > +		if (crc)
> > +			*crc =3D fsa.crc;
> >   		return fsa.value;
> >   	}

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__27_Jun_2008_00_21_00_+1000_JU3MZ7Lk=IY9NVDI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkhjpcwACgkQTgG2atn1QN8OQQCfR4bqleeGVlaCDfxcg8kl46z1
mHIAnjfbTaLwPOcVLZdclpHAAYhxL7xY
=+Jwq
-----END PGP SIGNATURE-----

--Signature=_Fri__27_Jun_2008_00_21_00_+1000_JU3MZ7Lk=IY9NVDI--
