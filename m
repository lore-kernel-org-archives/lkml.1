Return-Path: <linux-kernel-owner+w=401wt.eu-S1752299AbZLXFV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752299AbZLXFV0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 00:21:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751890AbZLXFVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 00:21:25 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:45924 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751813AbZLXFVY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 00:21:24 -0500
Date: Thu, 24 Dec 2009 16:21:17 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: kgdb tree build warning
Message-Id: <20091224162117.ac18e50f.sfr@canb.auug.org.au>
In-Reply-To: <4B32E95C.3030201@windriver.com>
References: <20091224104812.7f2495f3.sfr@canb.auug.org.au>
	<4B32E95C.3030201@windriver.com>
X-Mailer: Sylpheed 3.0.0beta3 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__24_Dec_2009_16_21_17_+1100_hIOinr=4Arubhgg1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__24_Dec_2009_16_21_17_+1100_hIOinr=4Arubhgg1
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jason,

On Wed, 23 Dec 2009 22:09:00 -0600 Jason Wessel <jason.wessel@windriver.com=
> wrote:
>
> Stephen Rothwell wrote:
> >
> > Today's linux-next build (x86_64_allmodconfig) produced this warning:
> >
> > kernel/debug/kdb/kdb_bp.c: In function 'kdb_bp':
> > kernel/debug/kdb/kdb_bp.c:434: warning: the frame size of 32880 bytes i=
s larger than 2048 bytes
> >
> > Introduced by commit 16f40ed7bd0ad29dcde7a05b8a07f5ba10937277 ("kdb: co=
re
> > for kgdb back end").
>=20
> Using gcc 4.3, I did not see this error.   What compiler or compiler
> options did you use to get this?

I use a gcc 4.4.0 cross sompiler for all the x86_64 builds.  No special
compiler options apart from those provided by the allmodconfig build.
It looks like the compiler gets -Wframe-larger-than=3D${CONFIG_FRAME_WARN}
passed to it (and presumably CONFIG_FRAME_WARN is 2048).

> I assume it means the stack space was exhausted and a casual glance at
> the code did not yield anything obvious like a large array on the stack
> or anything.  It is conceivable that there is an inline function that is
> the source of the problem, but I would like to be able to duplicate it.

OK.

That function has a kdb_bp_t on its stack which contains an NR_CPUS array
of pointers.  NR_CPUS is 4096 (in this build) and pointers are 8 bytes,
so there is 32K right there :-(

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__24_Dec_2009_16_21_17_+1100_hIOinr=4Arubhgg1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksy+k0ACgkQjjKRsyhoI8zKAwCeKiFfJ8yjf/8knM1YWHo9FjtR
Lh8AoKL0qLIVet/yJH3CGKeKd1WrXmXo
=7ZaQ
-----END PGP SIGNATURE-----

--Signature=_Thu__24_Dec_2009_16_21_17_+1100_hIOinr=4Arubhgg1--
