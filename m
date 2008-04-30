Return-Path: <linux-kernel-owner+w=401wt.eu-S1758290AbYD3DuM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758290AbYD3DuM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 23:50:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753364AbYD3Dt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 23:49:58 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:55302 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752266AbYD3Dt6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 23:49:58 -0400
Date: Wed, 30 Apr 2008 13:49:50 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>
Subject: linux-next: v4l-dvb merge conflicts (Re: linux-next: upstream build
 failure: v4l/dvb)
Message-Id: <20080430134950.03b858e9.sfr@canb.auug.org.au>
In-Reply-To: <20080429230040.45fc6a96@gaivota>
References: <20080430114124.45017177.sfr@canb.auug.org.au>
	<20080429230040.45fc6a96@gaivota>
X-Mailer: Sylpheed 2.5.0beta3 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__30_Apr_2008_13_49_50_+1000_bYgbXapu7jEIMYt6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__30_Apr_2008_13_49_50_+1000_bYgbXapu7jEIMYt6
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mauro,

On Tue, 29 Apr 2008 23:00:40 -0300 Mauro Carvalho Chehab <mchehab@infradead=
.org> wrote:
>
> On Wed, 30 Apr 2008 11:41:24 +1000
> Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>=20
> > Hi all,
> >=20
> > Today's linux-next build (Linus' tree, x86_64 allmodconfig) fails like
> > this:
> >=20
> > ERROR: "tea5767_autodetection" [drivers/media/video/tuner.ko] undefined!
> > ERROR: "tda829x_probe" [drivers/media/video/tuner.ko] undefined!
> > ERROR: "tea5761_autodetection" [drivers/media/video/tuner.ko] undefined!
>=20
> I suspect that something wrong happened on your compilation, or at linux-=
next
> merge. Those three drivers (tea5767, tea5761 and tea829x) were moved
> from /drivers/media/video to /drivers/common/tuners, but the above messag=
es are
> pointing to the old path.

OK, interesting.  This was a build of just Linus' tree so others may get
this problem if they don't do a "make clean" or similar (as I don't).

I have now done the merge of the v4l-dvb tree in linux-next and I have had =
several conflicts, the worst being in the file drivers/media/Kconfig betwee=
n commit 7c91f0624a9a2b8b9b122cf94fef34bc7f7347a6 ("V4L/DVB(7767): Move tun=
ers to common/tuners") in Linus' tree and commit 9c76e847539ab7a73e82ff6928=
62f3de9fa19ddb ("V4L/DVB(7767): Move tuners to common/tuners") in the v4l-d=
vb tree.  The former leaves

source "drivers/media/common/Kconfig"

while the latter removes it.  I suspect I have a bad version of the
v4l-dvb/stable tree (though I did fetch it this morning).

I managed to fix it all up to the point that it builds, though.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__30_Apr_2008_13_49_50_+1000_bYgbXapu7jEIMYt6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIF+xjTgG2atn1QN8RArHcAJwOKBjo1N3KfUMJF3DjjJdz6xArOwCggDjM
i8Ap6whNtmeuwXjUEeKMtOU=
=aDlr
-----END PGP SIGNATURE-----

--Signature=_Wed__30_Apr_2008_13_49_50_+1000_bYgbXapu7jEIMYt6--
