Return-Path: <linux-kernel-owner+w=401wt.eu-S938772AbXHIFmh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938772AbXHIFmh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 01:42:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755628AbXHIFma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 01:42:30 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:49955 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752858AbXHIFm3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 01:42:29 -0400
Date: Thu, 9 Aug 2007 15:42:21 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, lguest <lguest@ozlabs.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jes Sorensen <jes@sgi.com>, Carsten Otte <cotte@de.ibm.com>,
       Andi Kleen <ak@suse.de>
Subject: Re: [PATCH 5/5 -v2] Move the lguest files that are i386 specific
Message-Id: <20070809154221.2175efd4.sfr@canb.auug.org.au>
In-Reply-To: <20070809044125.610944971@goodmis.org>
References: <20070809043626.830486783@goodmis.org>
	<20070809044125.610944971@goodmis.org>
X-Mailer: Sylpheed 2.4.4 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__9_Aug_2007_15_42_21_+1000_5Kh/rGPsytsw17Gk"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__9_Aug_2007_15_42_21_+1000_5Kh/rGPsytsw17Gk
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Steven,

On Thu, 09 Aug 2007 00:36:31 -0400 Steven Rostedt <rostedt@goodmis.org>
wrote:
>
> Well, some may be merged with x86_64 later, but for now we move them
> out of the way.  Later on we can start seeing how we can combine
> some of these files to be arch generic.
>=20
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  drivers/lguest/Makefile                    |    7 +-
>  drivers/lguest/core.c                      |  771 -------------------
>  drivers/lguest/hypercalls.c                |  300 --------
>  drivers/lguest/i386/Makefile               |    7 +
>  drivers/lguest/i386/core.c                 |  771 +++++++++++++++++++
>  drivers/lguest/i386/hypercalls.c           |  300 ++++++++
>  drivers/lguest/i386/interrupts_and_traps.c |  440 +++++++++++
>  drivers/lguest/i386/lguest.c               | 1097 ++++++++++++++++++++++=
++++++
>  drivers/lguest/i386/lguest_asm.S           |   93 +++
>  drivers/lguest/i386/lguest_user.c          |  382 ++++++++++
>  drivers/lguest/i386/page_tables.c          |  680 +++++++++++++++++
>  drivers/lguest/i386/segments.c             |  229 ++++++
>  drivers/lguest/i386/switcher.S             |  347 +++++++++
>  drivers/lguest/interrupts_and_traps.c      |  440 -----------
>  drivers/lguest/lguest.c                    | 1097 ----------------------=
------
>  drivers/lguest/lguest_asm.S                |   93 ---
>  drivers/lguest/lguest_user.c               |  382 ----------
>  drivers/lguest/page_tables.c               |  680 -----------------
>  drivers/lguest/segments.c                  |  229 ------
>  drivers/lguest/switcher.S                  |  347 ---------
>  20 files changed, 4348 insertions(+), 4344 deletions(-)

if you add -C or -M to "git diff --stat" this looks much better:

$ git diff --stat -C HEAD^
 drivers/lguest/Makefile                          |    7 ++-----
 drivers/lguest/i386/Makefile                     |    7 +++++++
 drivers/lguest/{ =3D> i386}/core.c                 |    0=20
 drivers/lguest/{ =3D> i386}/hypercalls.c           |    0=20
 drivers/lguest/{ =3D> i386}/interrupts_and_traps.c |    0=20
 drivers/lguest/{ =3D> i386}/lguest.c               |    0=20
 drivers/lguest/{ =3D> i386}/lguest_asm.S           |    0=20
 drivers/lguest/{ =3D> i386}/lguest_user.c          |    0=20
 drivers/lguest/{ =3D> i386}/page_tables.c          |    0=20
 drivers/lguest/{ =3D> i386}/segments.c             |    0=20
 drivers/lguest/{ =3D> i386}/switcher.S             |    0=20
 11 files changed, 9 insertions(+), 5 deletions(-)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__9_Aug_2007_15_42_21_+1000_5Kh/rGPsytsw17Gk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGuqlBTgG2atn1QN8RArhxAJ0cmG52QmMjq4Fty7ELF/Zlv+RS5wCgg+I2
s3VhlINPLGZiHjaCQkiUwdM=
=Yxzu
-----END PGP SIGNATURE-----

--Signature=_Thu__9_Aug_2007_15_42_21_+1000_5Kh/rGPsytsw17Gk--
