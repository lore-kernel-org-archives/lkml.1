Return-Path: <linux-kernel-owner+w=401wt.eu-S1765534AbYBULKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765534AbYBULKv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 06:10:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758471AbYBULKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 06:10:42 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:49711 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757794AbYBULKm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 06:10:42 -0500
Date: Thu, 21 Feb 2008 22:10:35 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Paul Mackerras <paulus@samba.org>, akpm@osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] viocons: BKL locking
Message-Id: <20080221221035.3e6e263a.sfr@canb.auug.org.au>
In-Reply-To: <20080221105056.69e6678c@core>
References: <20080220203258.4b33f890@core>
	<18364.63205.933131.746580@cargo.ozlabs.ibm.com>
	<20080221105056.69e6678c@core>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__21_Feb_2008_22_10_35_+1100_Z8xK/cG4+oyLA=gG"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__21_Feb_2008_22_10_35_+1100_Z8xK/cG4+oyLA=gG
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Alan,

On Thu, 21 Feb 2008 10:50:56 +0000 Alan Cox <alan@lxorguk.ukuu.org.uk> wrot=
e:
>
> On Thu, 21 Feb 2008 14:58:29 +1100
> Paul Mackerras <paulus@samba.org> wrote:
>=20
> > Alan Cox writes:
> >=20
> > > For some weird reason I can't ascertain (translation "I think its
> > > broken") the viocons driver calls directly into the n_tty ldisc code =
even
> > > if another ldisc is in use. It'll probably break if you do that but I=
'm
> > > just fixing the locking and adding a comment that its horked.
> >=20
> > Looks to me like it (viotty_ioctl) should return -ENOIOCTLCMD instead
> > of calling n_tty_ioctl -- do you agree?
>=20
> I think that is probably what is intended. That would then bounce back
> throuh the tty layer to the right places.

The other thing to note is that viocons is deprecated (we wrote another
backend to hvc as an alternative console for legacy iSeries) and will
hopefully be removed sometime soon so don't spend any time on it.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__21_Feb_2008_22_10_35_+1100_Z8xK/cG4+oyLA=gG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHvVwwTgG2atn1QN8RAnybAJ9qYhl2OaEHUDmYsFvVg/wPzn+AaACfV+P/
JBfvI2cN8BDqJio80LGW5R0=
=kcxI
-----END PGP SIGNATURE-----

--Signature=_Thu__21_Feb_2008_22_10_35_+1100_Z8xK/cG4+oyLA=gG--
