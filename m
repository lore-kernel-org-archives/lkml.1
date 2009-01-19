Return-Path: <linux-kernel-owner+w=401wt.eu-S1758582AbZASDs2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758582AbZASDs2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 22:48:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757953AbZASDsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 22:48:19 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:42693 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752895AbZASDsT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 22:48:19 -0500
Date: Mon, 19 Jan 2009 14:48:11 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL -tip] fix 41 'make headers_check' warnings
Message-Id: <20090119144811.d1da89a4.sfr@canb.auug.org.au>
In-Reply-To: <1232332274.3129.9.camel@localhost.localdomain>
References: <1232273454.23100.9.camel@localhost.localdomain>
	<20090119105324.fd4e9084.sfr@canb.auug.org.au>
	<1232332274.3129.9.camel@localhost.localdomain>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__19_Jan_2009_14_48_11_+1100_84KQDP02Joy8Q+we"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__19_Jan_2009_14_48_11_+1100_84KQDP02Joy8Q+we
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jaswinder,

On Mon, 19 Jan 2009 08:01:14 +0530 Jaswinder Singh Rajput <jaswinder@kernel=
.org> wrote:
>
> On Mon, 2009-01-19 at 10:53 +1100, Stephen Rothwell wrote:
> >=20
> > On Sun, 18 Jan 2009 15:40:54 +0530 Jaswinder Singh Rajput <jaswinder@ke=
rnel.org> wrote:
> > >
> > > diff --git a/include/linux/pktcdvd.h b/include/linux/pktcdvd.h
> > > index 04b4d73..277de8c 100644
> > > --- a/include/linux/pktcdvd.h
> > > +++ b/include/linux/pktcdvd.h
> > > @@ -33,11 +33,15 @@
> > >   * able to sucessfully recover with this option (drive will return g=
ood
> > >   * status as soon as the cdb is validated).
> > >   */
> > > +#ifdef __KERNEL__
> > >  #if defined(CONFIG_CDROM_PKTCDVD_WCACHE)
> > >  #define USE_WCACHING		1
> > >  #else
> > >  #define USE_WCACHING		0
> > >  #endif
> > > +#else /* __KERNEL__ */
> > > +#define USE_WCACHING		0
> > > +#endif /* __KERNEL__ */
> >=20
> > This also only has one user (drivers/block/pktcdvd.c) so maybe it should
> > be moved there.
> >=20
>=20
> Already fixed in v3 as pointed by Ingo.

I was actually suggesting that you move the whole=20

#if defined(CONFIG_CDROM_PKTCDVD_WCACHE)
#define USE_WCACHING		1
#else
#define USE_WCACHING		0
#endif

into drivers/block/pktcdvd.c as that is the only place USE_WCACHING is
used.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__19_Jan_2009_14_48_11_+1100_84KQDP02Joy8Q+we
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAklz9/sACgkQjjKRsyhoI8x80gCfd+RCatIRbgZZVYT5pCBqbTZo
xe0AnA9F3tFHZoYRHv8YSSoLyXvZ47Uh
=HwZ7
-----END PGP SIGNATURE-----

--Signature=_Mon__19_Jan_2009_14_48_11_+1100_84KQDP02Joy8Q+we--
