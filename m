Return-Path: <linux-kernel-owner+w=401wt.eu-S932343AbZIVQ1E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932343AbZIVQ1E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 12:27:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753598AbZIVQ1C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 12:27:02 -0400
Received: from os.eurotux.com ([216.75.63.6]:46873 "EHLO os.eurotux.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752472AbZIVQ1B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 12:27:01 -0400
Date: Tue, 22 Sep 2009 17:26:58 +0100
From: Luciano Rocha <luciano@eurotux.com>
To: Brian McGrew <brian@visionpro.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: (un)mount ramfs from C code
Message-ID: <20090922162658.GB7973@bit.office.eurotux.com>
Mail-Followup-To: Luciano Rocha <luciano@eurotux.com>,
	Brian McGrew <brian@visionpro.com>, linux-kernel@vger.kernel.org
References: <C6DE438F.127DA%brian@visionpro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sdtB3X0nJg68CQEu"
Content-Disposition: inline
In-Reply-To: <C6DE438F.127DA%brian@visionpro.com>
User-Agent: Mutt/1.5.20 (2009-08-08)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 22, 2009 at 09:04:15AM -0700, Brian McGrew wrote:
> Good morning all!
>=20
> So I'm using a ramfs for temporary files, thank you whoever designed that,
> it works great!
>=20
> I can mkdir, mount, chmoud, readand write and then umount the thing from =
the
> command line just fine.
>=20
> What I need now is some method from within my C/C++ code to determine if =
the
> ramfs is mounted, if not, then mount it so I can use it and unmount it wh=
en
> I'm done, without making a system call.

You mean without using system(3), right? System call is how your program
interacts with the outside world.

The relevant system calls are:
  - mount(2): mount("none", "/mnt", "ramfs", 0, NULL);
  - umount(2): umount("/mnt");

The function(section) is the standard Unix way of specifying the manual
section of the function. Use it like this:
  $ man 2 mount

About checking whether it is already mounted, you could parse the file
/proc/mounts, or check the result of statfs(2).

Regards,
Luciano Rocha

--=20
Luciano Rocha <luciano@eurotux.com>
Eurotux Inform=E1tica, S.A. <http://www.eurotux.com/>

--sdtB3X0nJg68CQEu
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkq4+tEACgkQinSul6a7oB/L3ACdG6YuPEznEjkHt77jQXbw0Psz
fGIAoIZv2vFOH2MlxfgguFTXWfCIwi1J
=ZVxm
-----END PGP SIGNATURE-----

--sdtB3X0nJg68CQEu--
