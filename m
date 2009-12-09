Return-Path: <linux-kernel-owner+w=401wt.eu-S966983AbZLIA1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966983AbZLIA1R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 19:27:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966952AbZLIA1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 19:27:16 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:46141 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966786AbZLIA1P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 19:27:15 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] NOMMU: use copy_*_user_page() in access_process_vm()
Date: Tue, 8 Dec 2009 19:27:36 -0500
User-Agent: KMail/1.12.4 (Linux/2.6.31.4; KDE/4.3.4; x86_64; ; )
Cc: Jie Zhang <jie.zhang@analog.com>, uclinux-dev@uclinux.org,
       David McCullough <davidm@snapgear.com>, Greg Ungerer <gerg@uclinux.org>,
       Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
       uclinux-dist-devel@blackfin.uclinux.org
References: <4B1E568A.4020005@analog.com> <7253.1260269873@redhat.com> <9984.1260281967@redhat.com>
In-Reply-To: <9984.1260281967@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1285252.mDxeCYaWsz";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200912081927.37940.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1285252.mDxeCYaWsz
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tuesday 08 December 2009 09:19:27 David Howells wrote:
> Jie Zhang <jie.zhang@analog.com> wrote:
> > I agree on using 0 instead of NULL. But for !MMU, I think, vaddr is
> > always as same as addr. So we don't need to pass it?
>=20
> FRV flushes the vaddr because in MMU mode the cache flush instructions ta=
ke
> virtual addresses, so if we pass addr as vaddr, I can use the same cache
>  flush code for both modes.  I suspect it makes little difference to the
>  amount of code if we pass that rather than 0, as the value is already
>  computed, and either way, it's going to take one instruction to set up t=
he
>  argument.
>=20
> Note that Blackfin assumes that it may use the dst address for flushing -
>  an assumption that isn't valid in MMU mode with a VIVT cache (which I
>  presume Blackfin isn't, but other CPUs are).

the Blackfin cpu currently does not have virtual memory support at all, so =
i=20
imagine there's a bunch of things that'll need updating when that day comes

the new patch is of course fine; thanks
=2Dmike

--nextPart1285252.mDxeCYaWsz
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.13 (GNU/Linux)

iQIcBAABAgAGBQJLHu75AAoJEEFjO5/oN/WBPbIQAJRgiXyAXzm9C1oYk39fpmkj
hwrBmYw8yOPNsI+t3tJREp9LvnYWtW/1VuHdjkk5LxHzLYq5gvM1W/3aX3belAh0
5mPiOoBIR2MzAI6dYbO83qIw99CTkK9wdg+vkhkCMXstRYgPZ3hPL+Q3Cs173E6h
UALATmFanjbIcW+OviMJoRsnWQY1FPwVCt2Om4elFohU8FK3G1KVYB5aOBy/BUNw
hNO9Yv+Ljcnm4zr0T6GjbWqpLB7abVVoBAW9T8obnxQclVQ9jbaw6kZ0cp1xB8n/
R5dplIAWJNVtUmAmGbA7IB4cuEQFKbdwO7nyKVuxm9mluphJ3y/uc2e1tbwb8Pf1
pDRJrcx+FcsfwgtdPBE1LBVJMQkO0/bRZQ2dQtvYjNbgtRIWkqld8g3iyACQltCj
bXJKbtlz0rZXNbB6qAWQUhDV2bAJRmCP4Ik0rRsJd4OyZ1Jhzzqi16eeYqdDnIAr
MaFICSG5WpmNol8saLENHPzALcdhurnkgf+wyQgcVwawVS4Rn+XsHgFLD8laGQGW
UD9eZ9vAjAyl+IuSW4v+rTDnGy3wtLlnlOKV/G9kIPnrbTjHwPaTthkKe0h0I75T
fQQBy/SCUYa2Buf2fpczGIwJq1vyMUvgBxK7lkGLIf9aO7RH3hLdzdsKiykiNidE
gW4uLZTzOhd/2UHyU0f4
=hwQo
-----END PGP SIGNATURE-----

--nextPart1285252.mDxeCYaWsz--
