Return-Path: <linux-kernel-owner+w=401wt.eu-S1752348AbYJYEkM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752348AbYJYEkM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 00:40:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750843AbYJYEj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 00:39:59 -0400
Received: from ozlabs.org ([203.10.76.45]:36565 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750840AbYJYEj6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 00:39:58 -0400
Subject: Re: [Cbe-oss-dev] [PATCH] Cell OProfile: Incorrect local array
	size in	activate spu profiling function
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Carl Love <cel@us.ibm.com>
Cc: oprofile-list@lists.sourceforge.net, linuxppc-dev@ozlabs.org,
       cel@linux.vnet.ibm.com, cbe-oss-dev@ozlabs.org,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1224874049.20229.5.camel@carll-linux-desktop>
References: <1224874049.20229.5.camel@carll-linux-desktop>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-goAnwqUhVQcsSHJT7Fwc"
Date: Sat, 25 Oct 2008 15:39:55 +1100
Message-Id: <1224909595.16090.5.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-goAnwqUhVQcsSHJT7Fwc
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-10-24 at 11:47 -0700, Carl Love wrote:
> The size of the pm_signal_local array should be equal to the
> number of SPUs being configured in the call.  Currently, the
> array is of size 4 (NR_PHYS_CTRS) but being indexed by a for=20
> loop from 0 to 7 (NUM_SPUS_PER_NODE). =20

While you're at it you should change to using ARRAY_SIZE() in the for
loop, and use sizeof in the rtas call - that way you'll only have the
size in one place.

I notice pm_rtas_activate_signals() also allocates a pm_signal_local on
the stack and iterates over it. I take it something guarantees that
count in that routine will not exceed NR_PHYS_CTRS ?

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-goAnwqUhVQcsSHJT7Fwc
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBJAqMbdSjSd0sB4dIRAuYWAKCrP8k5mTBtcLW85GtifYOQo5yn1wCdHA51
kvozrYa7Yo0yGBLr6CliTdE=
=H/n2
-----END PGP SIGNATURE-----

--=-goAnwqUhVQcsSHJT7Fwc--

