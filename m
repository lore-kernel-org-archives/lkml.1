Return-Path: <linux-kernel-owner+w=401wt.eu-S1755338AbYADHa6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338AbYADHa6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 02:30:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752884AbYADHat
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 02:30:49 -0500
Received: from mx38.mail.ru ([194.67.23.16]:65111 "EHLO mx38.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752248AbYADHas (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 02:30:48 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Andrew Patterson <andrew.patterson@hp.com>
Subject: Re: Error returns not =?utf-8?q?handled=09correctly=09by=09sysfs=2Ec=3Asubsys=5Fattr=5Fstore?=()
Date: Fri, 4 Jan 2008 10:30:35 +0300
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: Tejun Heo <teheo@suse.de>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-hotplug@vger.kernel.org, bjorn.helgaas@hp.com
References: <1195683419.16019.225.camel@grinch> <1199405830.7025.33.camel@bluto.andrew> <1199408174.7025.40.camel@bluto.andrew>
In-Reply-To: <1199408174.7025.40.camel@bluto.andrew>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1403395.XD3rqxXn6z";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200801041030.43494.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1403395.XD3rqxXn6z
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Friday 04 January 2008, Andrew Patterson wrote:
> On Thu, 2008-01-03 at 17:17 -0700, Andrew Patterson wrote:
> > On Fri, 2008-01-04 at 09:07 +0900, Tejun Heo wrote:
> > > Hello,
> > >=20
> > > Andrew Patterson wrote:
> > > > It looks like this is a shell issue.  After looking through the sys=
fs
> > > > code, I realized that this problem seems to be driven from user-lan=
d.
> > > > So I performed some experiments:
> > > >=20
> > > >      1. Wrote a simple program that just used write(2) to write to =
the
> > > >         sysfs entry. This works fine.
> > > >      2. Used /bin/echo instead of the built-in echo command.  This =
too
> > > >         works fine.
> > > >      3. Tried several shells.  Zsh and Bash both fail.  Csh works f=
ine.
> > > >=20
> > > > I then ran strace on the following shell-script:
> > > >=20
> > > > #!/bin/bash
> > > >=20
> > > > echo x > allow_restart
> > > > echo y > allow_restart
> > > > echo z > allow_restart
> > > >=20
> > > > and got:
> > > >=20
> > > > # strace -e trace=3Dwrite ~/tmp/tester.sh=20
> > > > write(1, "x\n", 2)                      =3D -1 EINVAL (Invalid argu=
ment)
> > > > write(1, "x\n", 2)                      =3D -1 EINVAL (Invalid argu=
ment)
> > > > write(2, "/home/andrew/tmp/tester.sh: line"...,=20
72/home/andrew/tmp/tester.sh: line 4: echo: write error: Invalid argument
> > > > ) =3D 72
> > > > write(1, "x\ny\n", 4)                   =3D -1 EINVAL (Invalid argu=
ment)
> > > > write(1, "x\ny\n", 4)                   =3D -1 EINVAL (Invalid argu=
ment)
> > > > write(2, "/home/andrew/tmp/tester.sh: line"...,=20
72/home/andrew/tmp/tester.sh: line 5: echo: write error: Invalid argument
> > > > ) =3D 72
> > > > write(1, "x\ny\nz\n", 6)                =3D -1 EINVAL (Invalid argu=
ment)
> > > > write(1, "x\ny\nz\n", 6)                =3D -1 EINVAL (Invalid argu=
ment)
> > > > write(2, "/home/andrew/tmp/tester.sh: line"...,=20
72/home/andrew/tmp/tester.sh: line 6: echo: write error: Invalid argument
> > > > ) =3D 72
> > > > write(1, "x\ny\nz\n", 6x
> > > > y
> > > > z
> > > > )                =3D 6
> > > > Process 3800 detached
> > >=20
> > > Eeeeeeeekkkk.... That's scary.  Which distro are you using and what d=
oes
> > > 'bash --version' say?
> >=20
> > IA64 Debian lenny. =20
> >=20
> > # bash --version
> > GNU bash, version 3.1.17(1)-release (ia64-unknown-linux-gnu)
> >=20
> > # zsh --version=20
> > zsh 4.3.4 (ia64-unknown-linux-gnu)
> >=20
> > # csh --version
> > tcsh 6.14.00 (Astron) 2005-03-25 (ia64-unknown-linux) options
> > wide,nls,dl,al,kan,rh,nd,color,filec
> >=20
> > I suppose I should try this an ia32 box again, and perhaps with some
> > other distros.  I am not sure what the kernel can do about this, but it
> > might be nice to report it to the shell maintainers.
>=20
> Some further tests:
>=20
> AMD running Debian lenny with i686 kernel -- fails. =20
> Bash version =3D 3.1.17(1)
>=20
> Intel running Ubuntu/gutsy with i686 kernel -- fails.
> Bash version =3D 3.2.25(1)
>=20
> Itanium running SLES10 with ia64 kernel -- succeeds.
> Bash version =3D 3.1.17(1)
>=20
> BTW, I found a way to reproduce this without modifying the kernel.
> The /sys/class/scsi_host/*/state sysfs store routine returns EINVAL if
> an invalid state is written. So just echo 2 bad values to the the state
> sysfs entry while running strace.
>=20

I can't reproduce it using zsh either 4.3.4 as shipped by Mandriva or zsh C=
VS=20
head. In both cases it echoes correct argument. Nor do I see double writes'=
s in=20
strace.

{pts/0}% sudo strace -e trace=3Dwrite /tmp/foo # zsh 4.3.4
write(1, "x\n", 2)                      =3D -1 EINVAL (Invalid argument)
write(2, "/tmp/foo:echo:3: write error: \320\235"..., 72/tmp/foo:echo:3: wr=
ite=20
error: =D0=9D=D0=B5=D0=B4=D0=BE=D0=BF=D1=83=D1=81=D1=82=D0=B8=D0=BC=D1=8B=
=D0=B9 =D0=B0=D1=80=D0=B3=D1=83=D0=BC=D0=B5=D0=BD=D1=82
) =3D 72
write(1, "y\n", 2)                      =3D -1 EINVAL (Invalid argument)
write(2, "/tmp/foo:echo:4: write error: \320\235"..., 72/tmp/foo:echo:4: wr=
ite=20
error: =D0=9D=D0=B5=D0=B4=D0=BE=D0=BF=D1=83=D1=81=D1=82=D0=B8=D0=BC=D1=8B=
=D0=B9 =D0=B0=D1=80=D0=B3=D1=83=D0=BC=D0=B5=D0=BD=D1=82
) =3D 72
write(1, "z\n", 2)                      =3D -1 EINVAL (Invalid argument)
write(2, "/tmp/foo:echo:5: write error: \320\235"..., 72/tmp/foo:echo:5: wr=
ite=20
error: =D0=9D=D0=B5=D0=B4=D0=BE=D0=BF=D1=83=D1=81=D1=82=D0=B8=D0=BC=D1=8B=
=D0=B9 =D0=B0=D1=80=D0=B3=D1=83=D0=BC=D0=B5=D0=BD=D1=82
) =3D 72
{pts/0}% sudo strace -e trace=3Dwrite /tmp/foo # zsh CVS head
write(1, "x\n", 2)                      =3D -1 EINVAL (Invalid argument)
write(2, "/tmp/foo:echo:3: write error: \320\235"..., 72/tmp/foo:echo:3: wr=
ite=20
error: =D0=9D=D0=B5=D0=B4=D0=BE=D0=BF=D1=83=D1=81=D1=82=D0=B8=D0=BC=D1=8B=
=D0=B9 =D0=B0=D1=80=D0=B3=D1=83=D0=BC=D0=B5=D0=BD=D1=82
) =3D 72
write(1, "y\n", 2)                      =3D -1 EINVAL (Invalid argument)
write(2, "/tmp/foo:echo:4: write error: \320\235"..., 72/tmp/foo:echo:4: wr=
ite=20
error: =D0=9D=D0=B5=D0=B4=D0=BE=D0=BF=D1=83=D1=81=D1=82=D0=B8=D0=BC=D1=8B=
=D0=B9 =D0=B0=D1=80=D0=B3=D1=83=D0=BC=D0=B5=D0=BD=D1=82
) =3D 72
write(1, "z\n", 2)                      =3D -1 EINVAL (Invalid argument)
write(2, "/tmp/foo:echo:5: write error: \320\235"..., 72/tmp/foo:echo:5: wr=
ite=20
error: =D0=9D=D0=B5=D0=B4=D0=BE=D0=BF=D1=83=D1=81=D1=82=D0=B8=D0=BC=D1=8B=
=D0=B9 =D0=B0=D1=80=D0=B3=D1=83=D0=BC=D0=B5=D0=BD=D1=82
) =3D 72

{pts/0}% cat /tmp/foo
#!/home/bor/pkg/bin/zsh -f

echo x > state
echo y > state
echo z > state

where state is /sys/power/state


{pts/1}% zsh --version
zsh 4.3.4 (i586-mandriva-linux-gnu)
{pts/1}% ~/pkg/bin/zsh --version
zsh 4.3.4-dev-6 (i686-pc-linux-gnu)

=2Dandrey

--nextPart1403395.XD3rqxXn6z
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)

iEYEABECAAYFAkd94J0ACgkQR6LMutpd94wT3wCgq24S2R4GSoWkMxalzjCAqmjY
umAAnj0Q+BKqIabHYyA9gMcW/IbSxnj6
=uD7h
-----END PGP SIGNATURE-----

--nextPart1403395.XD3rqxXn6z--
