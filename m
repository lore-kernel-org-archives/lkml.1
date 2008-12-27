Return-Path: <linux-kernel-owner+w=401wt.eu-S1754646AbYL0UF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646AbYL0UF6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 15:05:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753901AbYL0UFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 15:05:49 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:56477 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753886AbYL0UFt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 15:05:49 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86 byteorder.h: use __asm__/__inline__ for userspace
Date: Sat, 27 Dec 2008 15:05:42 -0500
User-Agent: KMail/1.10.3 (Linux/2.6.28; KDE/4.1.3; x86_64; ; )
Cc: Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>,
       tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org
References: <1230360604-6711-1-git-send-email-vapier@gentoo.org> <200812271421.10087.vapier@gentoo.org> <495680A7.2010900@zytor.com>
In-Reply-To: <495680A7.2010900@zytor.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart8493068.HNnT0H8NQn";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200812271505.46872.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart8493068.HNnT0H8NQn
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Saturday 27 December 2008 14:23:19 H. Peter Anvin wrote:
> Mike Frysinger wrote:
> > {su}{8,16,32,64} doesnt matter too much to me vs {u,}int_t{8,16,32,64}_=
t.
> >  as long as people stop using __{su}{8,16,32,64}.  using the latter
> > though does mean headers will more likely be "just usable" w/out needing
> > linux/types.h include.  but then people would be forced to include
> > stdint.h or similar before a linux header ... and that sucks.
>
> That is a total non-starter.  This would mean that the C library itself
> cannot use these headers without exporting additional symbols into the
> namespace, *WHICH IT IS NOT ALLOWED TO DO*.

which is already happening today you mean.  grep the kernel headers and you=
'll=20
see a ton of [u]intXX_t hits.

this logic though means that the kernel should not be defining any structur=
es=20
that the C library is defining (such as asm-generic/fcntl.h).  such structs=
=20
should get renamed the same way as __[us]XX types.
=2Dmike

--nextPart8493068.HNnT0H8NQn
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iQIcBAABAgAGBQJJVoqaAAoJEEFjO5/oN/WB/hsQAOJnNebB2/o4ubNCyAAugKfM
mXikhHTE2oIxQaMfMtsq5KnfUtjL4bBtCMjkTJk3+Wh1omwr9rlyGsyvgSqj1R+s
Kbdf+V/YyksA3t/GM2U6VemAVwraZ7MSXE4ASqtd2xn/h34WvJWAYbBaO6s2JmjF
q+nO3W/QHE1mVidMR5rsI+xr5Y2BdBZQEfXc08jxcLJmEtRznFGm53uTzD2bhuBd
eawh8Z55GmGX/HW0XOerZDxK1+kkFb8dZ5+oXE+zcgFAqKhPto+S/NjjxtE9QJw2
pWy+xf43nFmgIFsnqrb4UaYtj9C70wiv1U7y7rejk/e+r9Hlql1I/Zs17SY7GwWJ
eHCg3WqGOACidvwlQrOpOszx2CGE/g4RAtSasdIYmF0bgGeGKivW/XmmcavlLXYq
nrBnG9nQ+fWfaxTCp6qP+5QfRZxO3pQqFVunRqP3qpY2rY3GCIG6l/d7uDVnz85q
vacSz3roKCLJS+dcj2Vl/uA/9mF2/Ni6w4qOoHAW3VWP1blk7suW+OU6tTTOvTn+
1285Hwg8b6nxaCbKPagnvE6Xnb6KlzzYgQ5GJVamthFTWY8qPQnL9TktByOWzWRK
Z3+IP42axC0skUYryOepL4ePiZzLWSQu1fL/PnXe+tCZOn5ul5U9EjYhXRpFxJ3s
IatKX0raNQQnSo9Tkm5d
=bF63
-----END PGP SIGNATURE-----

--nextPart8493068.HNnT0H8NQn--
