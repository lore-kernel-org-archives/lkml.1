Return-Path: <linux-kernel-owner+w=401wt.eu-S1761577AbXFABiz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761577AbXFABiz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 21:38:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758420AbXFABis
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 21:38:48 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:48780 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757292AbXFABis (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 21:38:48 -0400
Date: Fri, 1 Jun 2007 11:38:40 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ulrich Drepper <drepper@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, torvalds@linux-foundation.org,
       Chris Zankel <chris@zankel.net>
Subject: Re: [PATCH] Introduce O_CLOEXEC (take >2)
Message-Id: <20070601113840.813463db.sfr@canb.auug.org.au>
In-Reply-To: <20070531162021.4cd4e91a.akpm@linux-foundation.org>
References: <200705311809.l4VI9F9X009556@devserv.devel.redhat.com>
	<20070531162021.4cd4e91a.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.12; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__1_Jun_2007_11_38_40_+1000_S.=vdu/5JuE8JF_M"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__1_Jun_2007_11_38_40_+1000_S.=vdu/5JuE8JF_M
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 31 May 2007 16:20:21 -0700 Andrew Morton <akpm@linux-foundation.org=
> wrote:
>
> > diff --git a/include/asm-generic/fcntl.h b/include/asm-generic/fcntl.h
> > index c154b9d..b847741 100644
> > --- a/include/asm-generic/fcntl.h
> > +++ b/include/asm-generic/fcntl.h
> > @@ -48,6 +48,9 @@
> >  #ifndef O_NOATIME
> >  #define O_NOATIME	01000000
> >  #endif
> > +#ifndef O_CLOEXEC
> > +#define O_CLOEXEC	02000000	/* set close_on_exec */
> > +#endif
> >  #ifndef O_NDELAY
> >  #define O_NDELAY	O_NONBLOCK
> >  #endif
>=20
> This will break xtensa, because that architecture (and only that
> architecture) doesn't include asm-generic/fcntl.h from asm/fcntl.h.

This also breaks Alpha (which uses 02000000 for O_DIRECT) and parisc
(which uses 02000000 for O_RSYNC).  So you ether need to choose a
different value or define O_CLOEXEC for those two architectures.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__1_Jun_2007_11_38_40_+1000_S.=vdu/5JuE8JF_M
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGX3ilFdBgD/zoJvwRAnGgAJ4wY5aryma5hCwH1gGTaKQmHq1DswCfQd4l
uqefNvYkGgEwAkQ0oF0LoYE=
=4WRx
-----END PGP SIGNATURE-----

--Signature=_Fri__1_Jun_2007_11_38_40_+1000_S.=vdu/5JuE8JF_M--
