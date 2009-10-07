Return-Path: <linux-kernel-owner+w=401wt.eu-S1751306AbZJGEaB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751306AbZJGEaB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 00:30:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750788AbZJGEaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 00:30:00 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:47872 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770AbZJGE37 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 00:29:59 -0400
Date: Wed, 7 Oct 2009 15:29:14 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: linux-next: suspend tree build failure
Message-Id: <20091007152914.8dadf6d7.sfr@canb.auug.org.au>
In-Reply-To: <200910070031.55135.rjw@sisk.pl>
References: <20091006135505.f07ee40d.sfr@canb.auug.org.au>
	<200910070031.55135.rjw@sisk.pl>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__7_Oct_2009_15_29_14_+1100_mOUsqxFhkX6AOlzY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__7_Oct_2009_15_29_14_+1100_mOUsqxFhkX6AOlzY
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rafael,

On Wed, 7 Oct 2009 00:31:55 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
>
> Thanks for the notification.
>=20
> Did you cross-compile it by chance?  It builds for me on native x86_64 wi=
th
> allmodconfig, which is why I missed this issue.

I cross compile all my x86 builds as my big machines are all PowerPC.

> > I have used the version of the suspend tree from next-20091002 for toda=
y.
>=20
> I added the #include <linux/compiler.h> to freezer.h, but obviously I cou=
ldn't
> verify if that fixed the problem.  Hopefully it did.

My guess was wrong.  You either need to leave the __cold off the
definition in kernel/freezer.c or move it before the function name.  No
other function definition in the kernel is marked __cold, but several
declarations are.

Also __cold only generates something for gcc >=3D 4.3 ...  I am using 4.4.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__7_Oct_2009_15_29_14_+1100_mOUsqxFhkX6AOlzY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkrMGRoACgkQjjKRsyhoI8wJGwCfW7yt0M/oUigA/Icj789ycPvA
TRgAnR2lMJOS+N5WxY6pddk2rvSA4ckK
=fSS5
-----END PGP SIGNATURE-----

--Signature=_Wed__7_Oct_2009_15_29_14_+1100_mOUsqxFhkX6AOlzY--
