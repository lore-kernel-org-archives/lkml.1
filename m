Return-Path: <linux-kernel-owner+w=401wt.eu-S1753047AbZLDHB4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047AbZLDHB4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 02:01:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752226AbZLDHBy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 02:01:54 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:54595 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752125AbZLDHBy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 02:01:54 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: uclinux-dev@uclinux.org
Subject: Re: [uClinux-dev] Re: [PATCH] FDPIC: respect PT_GNU_STACK exec markings when creating NOMMU stack
Date: Fri, 4 Dec 2009 02:07:08 -0500
User-Agent: KMail/1.12.4 (Linux/2.6.31.4; KDE/4.3.4; x86_64; ; )
Cc: David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
       Greg Ungerer <gerg@uclinux.org>,
       uclinux-dist-devel@blackfin.uclinux.org,
       David McCullough <davidm@snapgear.com>
References: <8bd0f97a0912021329y7be05434wc9c39d383bfb7ce4@mail.gmail.com> <7946.1259761452@redhat.com> <16680.1259863084@redhat.com>
In-Reply-To: <16680.1259863084@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2931217.eXmUOvys9Q";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200912040207.09801.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2931217.eXmUOvys9Q
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Thursday 03 December 2009 12:58:04 David Howells wrote:
> Mike Frysinger <vapier.adi@gmail.com> wrote:
> > i have seen a few apps use brk()/sbrk() to query the size of things (li=
ke
> > e2fsprogs)
>=20
> We do actually record the size of the brk segment, so maybe we could icac=
he
> flush brk as it is increased (if it is increased):
>=20
> 	diff --git a/mm/nommu.c b/mm/nommu.c
> 	index 3754b16..2ea823d 100644
> 	--- a/mm/nommu.c
> 	+++ b/mm/nommu.c
> 	@@ -432,6 +432,7 @@ SYSCALL_DEFINE1(brk, unsigned long, brk)
> 		/*
> 		 * Ok, looks good - let it rip.
> 		 */
> 	+	flush_icache_range(mm->brk, brk);
> 		return mm->brk =3D brk;
> 	 }

probably want mm->brk + brk for the second argument
=2Dmike

--nextPart2931217.eXmUOvys9Q
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.13 (GNU/Linux)

iQIcBAABAgAGBQJLGLUdAAoJEEFjO5/oN/WBHxkP/RsSu7MttrTsbQAoq+JEw1ET
EcDNEZm6mzXInFj9SsK9G4DpBV9zz7zeOl4KQd1lpQLl4qYLICda4glBwoGLpO+S
6xnUxbO7uAfePElpS4dVe49HB+0g3UlKlsuLEzpEF2AX1eltQrhZiKFOrYdUmoK+
h7xBETSv1yuDk/JgmGdj3woZbh0T7Q592tzPJUaGFoIUU6YJwRiymoZKSoOgXok8
CdtiFrlr5rfTcMxVlm/c319954DWcxIMrv6bVGKkeZL0X8MLT2yF1VoRD867pE1K
5Auma3euC9xv+wAxaW69vxqeeZpbw3zEAInKfde2nbmwx+x56Jl9nJwHoOfVkLQG
nW3KPsx0I9KMzgXT0mjoFn7VFC0udVz0L9Uf0kuFJLOTUsa8cm+24Hujox/qjOYh
5fTTOGCxhXQk0osqzUxRI4/IIWYsSr9gqYwDSwprc9raKCj/aIsWIc/7dJtz1b6U
0Lg713HUvSDSvMV0PX8gAgEWSCnAYO0yQFFDAGLJNNCTXS/kNmL3ORjZquokEeIP
QMOExpb7n+Yv8+DvU5FFKzpDU+PAJ9t7dLC+Yi+ZCyvW5Tp40No/pwJTSpvOIXg+
98lIO+IIf5vzyHMkYRUz6+/ZOQaUUqtkYOUH0uJQbH99sOkm8SXW7Ub896KpiOMa
WGn9KoFP4GVFciFdrd35
=my2j
-----END PGP SIGNATURE-----

--nextPart2931217.eXmUOvys9Q--
