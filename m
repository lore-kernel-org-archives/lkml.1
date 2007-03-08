Return-Path: <linux-kernel-owner+w=401wt.eu-S1752562AbXCHQ7O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562AbXCHQ7O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 11:59:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752570AbXCHQ7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 11:59:13 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:42102 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562AbXCHQ7N (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 11:59:13 -0500
Message-Id: <200703081657.l28GvPSm010589@turing-police.cc.vt.edu>
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Kyle Moffett <mrmacman_g4@mac.com>,
       "Michael K. Edwards" <medwards.linux@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Anton Blanchard <anton@samba.org>,
       Davide Libenzi <davidel@xmailserver.org>, Avi Kivity <avi@argo.co.il>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [patch] epoll use a single inode ...
In-Reply-To: Your message of "Thu, 08 Mar 2007 08:24:04 +0100."
             <45EFBA14.9090307@cosmosbay.com>
From: Valdis.Kletnieks@vt.edu
References: <45ED1A3C.6030707@argo.co.il> <200703071906.58405.dada1@cosmosbay.com> <Pine.LNX.4.64.0703071022390.5963@woody.linux-foundation.org> <200703071952.13219.dada1@cosmosbay.com> <20070307221401.GA16938@kryten> <Pine.LNX.4.64.0703071453080.5963@woody.linux-foundation.org> <f2b55d220703071725w7c09b93bgbf357aeb25a21c2b@mail.gmail.com> <6E1C86DF-D512-418C-B270-BC5C4316BC0A@mac.com>
            <45EFBA14.9090307@cosmosbay.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1173373045_10421P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 08 Mar 2007 11:57:25 -0500
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1173373045_10421P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On Thu, 08 Mar 2007 08:24:04 +0100, Eric Dumazet said:
>
> But what is the cost of the conditional branch you added in prefetch(x)=
 ?
>=20
> if (=21x) return;
>=20
> (correctly predicted or not, but do powerPC have a BTB ?)
>=20
> About the NULL 'potential problem', maybe we could use a dummy nil (but=
=20
> mapped) object, and use its address in lists, ie compare for &nil inste=
ad of=20
> NULL. This would avoid :
>=20
> - The conditional test in some prefetch() implementations
> - The potential TLB problem with the NULL value.

You avoid those two, but add the very high likelyhood that a statement of=
 the
form 'if (=21x) =7B....=7D' will creep back in and bug out.  I doubt that=
 changing
the form of a basic C idiom to save a few cycles is worth it, especially =
when
the (=21x) form can be tested without a memory fetch, but (x =21=3D nil) =
may require
fetching 'nil' (remember - the x86 is a very popular chipset, but registe=
r
starved - if the loop is any size at all, 'nil' may require a reload each=

time around, costing you the win you thought you had....

--==_Exmh_1173373045_10421P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFF8EB1cC3lWbTT17ARAlwdAKCJKNHDPnaWmHsU8TQQmw2kPn97/wCgz7tD
6yj26ap4fNClcEXEM58gpG0=
=2PZG
-----END PGP SIGNATURE-----

--==_Exmh_1173373045_10421P--
