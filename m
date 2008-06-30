Return-Path: <linux-kernel-owner+w=401wt.eu-S1762219AbYF3P4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762219AbYF3P4w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 11:56:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753552AbYF3P4o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 11:56:44 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:37681 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753300AbYF3P4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 11:56:44 -0400
Date: Mon, 30 Jun 2008 08:56:30 -0700
From: Eric B Munson <ebmunson@us.ibm.com>
To: Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] Keep 3 high personality bytes across exec
Message-ID: <20080630155630.GA8445@us.ibm.com>
References: <20080628000813.GA19960@us.ibm.com> <18536.38684.384039.662264@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k1lZvvs/B4yU6o8G"
Content-Disposition: inline
In-Reply-To: <18536.38684.384039.662264@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--k1lZvvs/B4yU6o8G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 30 Jun 2008, Paul Mackerras wrote:

> Eric B Munson writes:
>=20
> > --- a/include/asm-powerpc/elf.h
> > +++ b/include/asm-powerpc/elf.h
> > @@ -257,7 +257,8 @@ do {								\
> >  	else							\
> >  		clear_thread_flag(TIF_ABI_PENDING);		\
> >  	if (personality(current->personality) !=3D PER_LINUX32)	\
> > -		set_personality(PER_LINUX);			\
> > +		set_personality(PER_LINUX |			\
> > +			(current->personality & PER_INHERIT));	\
>=20
> Couldn't we use ~PER_MASK here instead of PER_INHERIT?  That would
> mean we wouldn't have to modify include/linux/personality.h, and we
> wouldn't have to keep updating PER_INHERIT as more flags get added.
>=20
> (Nice patch description, BTW.  Thanks.)
>=20
> Paul.
>=20

Yeah, ~PER_MASK will work fine.  I used PER_INHERIT first because I
was not sure if there were values that should not be carried forward.
I will have an updated patch out shortly.

Eric

--k1lZvvs/B4yU6o8G
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIaQIusnv9E83jkzoRAjBzAJ9bQ+qYRJSc7v+Xnd0p2KLekE8oWQCgsDHz
UNvamXxuUJ461lmmtsQMZh4=
=yDrU
-----END PGP SIGNATURE-----

--k1lZvvs/B4yU6o8G--
