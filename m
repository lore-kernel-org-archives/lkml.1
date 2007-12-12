Return-Path: <linux-kernel-owner+w=401wt.eu-S1759858AbXLLQl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759858AbXLLQl0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 11:41:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759490AbXLLQlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 11:41:08 -0500
Received: from os.eurotux.com ([216.75.63.6]:55576 "EHLO os.eurotux.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759432AbXLLQlH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 11:41:07 -0500
Date: Wed, 12 Dec 2007 16:40:59 +0000
From: Luciano Rocha <luciano@eurotux.com>
To: Alon Bar-Lev <alon.barlev@gmail.com>, ldm@flatcap.org,
       ntfs-3g-devel@lists.sourceforge.net,
       LKML <linux-kernel@vger.kernel.org>,
       linux-ntfs-dev@lists.sourceforge.net
Subject: Re: ldminfo compilation
Message-ID: <20071212164059.GA30348@bit.office.eurotux.com>
Mail-Followup-To: Luciano Rocha <luciano@eurotux.com>,
	Alon Bar-Lev <alon.barlev@gmail.com>, ldm@flatcap.org,
	ntfs-3g-devel@lists.sourceforge.net,
	LKML <linux-kernel@vger.kernel.org>,
	linux-ntfs-dev@lists.sourceforge.net
References: <9e0cf0bf0712120639r7bd5582bg63f8512164836989@mail.gmail.com> <20071212145241.GA25092@bit.office.eurotux.com> <9e0cf0bf0712120657p1a8fac7aoc5a82df1ff24daac@mail.gmail.com> <20071212152953.GA26544@bit.office.eurotux.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="y0ulUmNC+osPPQO6"
Content-Disposition: inline
In-Reply-To: <20071212152953.GA26544@bit.office.eurotux.com>
User-Agent: Mutt/1.5.14 (2007-03-31)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 12, 2007 at 03:29:55PM +0000, Luciano Rocha wrote:
> On Wed, Dec 12, 2007 at 04:57:39PM +0200, Alon Bar-Lev wrote:
> > On 12/12/07, Luciano Rocha <luciano@eurotux.com> wrote:
> > > Those are for the kernel module setting the partition tables. If you'=
re
> > > only interested in the ldminfo utility:
> > > make -C ldmutil CPP=3D'g++ -static'
> > >
> > > Substitute g++ for the C++ compiler you want to use.
> >=20
> > Hi!
> > Thank you for your reply!
> >=20
> > I don't really understand how to use the output of ldmutil in order to
> > do the dmsetup... All the instructions are for ldminfo...
>=20
> Ah, sorry. Somehow I got the impression that the ldmutil directory
> included the ldminfo binary. I'll see if I can compile the ldminfo
> statically in an older system I have.

OK, the statically compiled version is at:
ftp://gil.di.uminho.pt/pub/users/strange/ldminfo
sha1sum: 71c1451f9cbd1a4256bb072d4c930418acc8e2fb

Anyway, how to compile with the sources of:
- linux-2.4.20
- linux-ldm-0.0.8

ldm=3Dlinux-ldm-0.0.8
kernel=3Dlinux-2.4.20

1. Decompress linux-ldm-0.0.8:
   curl -s http://dl.sourceforge.net/sourceforge/linux-ntfs/$ldm.tar.bz2 \
     | tar xjf -

2. Enter the directory:
   cd $ldm

3. Decompress the Linux kernel sources:
   curl -s ftp://ftp.di.uminho.pt/pub/kernel/v2.4/$kernel.tar.bz2 \
     | tar xjf -

4. Change test/Makefile to compile ldminfo statically:
   sed -e 's/ -o/ -static &/' -i test/Makefile

5. Correct KERNEL path in Makefile:
   sed -e "s,KERNEL.*=3D.*,KERNEL =3D $PWD/$kernel," -i Makefile

6. Force i386 arch in Makefile:
   sed -e 's/-march=3D.*/-march=3Di386/' -i Makefile

7. Generate kernel's option files:
   yes n | make -C $kernel ARCH=3Di386 oldconfig dep

8. Compile ldminfo and ldmutil:
   make ARCH=3Di386

This worked on a Centos 3.8, 32bits but running x86_64 kernel, but not
on my Fedora 8. YMMV.

Shell script:

ldm=3Dlinux-ldm-0.0.8
kernel=3Dlinux-2.4.20
curl -s http://dl.sourceforge.net/sourceforge/linux-ntfs/$ldm.tar.bz2 \
     | tar xjf - &&
cd $ldm &&
curl -s ftp://ftp.di.uminho.pt/pub/kernel/v2.4/$kernel.tar.bz2 \
     | tar xjf - &&
sed -e 's/ -o/ -static &/' -i test/Makefile &&
sed -e "s,KERNEL.*=3D.*,KERNEL =3D $PWD/$kernel," -i Makefile &&
sed -e 's/-march=3D.*/-march=3Di386/' -i Makefile &&
yes n | make -C $kernel ARCH=3Di386 oldconfig dep &&
make ARCH=3Di386

--=20
Luciano Rocha <luciano@eurotux.com>
Eurotux Inform=E1tica, S.A. <http://www.eurotux.com/>

--y0ulUmNC+osPPQO6
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHYA8binSul6a7oB8RAjhCAJ44gJjkwAdSSTmT5x0nClp/uYpIPQCfdqgX
DcVKGKo1flO3m7ts7L7VPwc=
=dHUQ
-----END PGP SIGNATURE-----

--y0ulUmNC+osPPQO6--
