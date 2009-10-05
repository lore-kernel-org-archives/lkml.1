Return-Path: <linux-kernel-owner+w=401wt.eu-S1758528AbZJEHVt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758528AbZJEHVt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 03:21:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758282AbZJEHVs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 03:21:48 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:51827 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757646AbZJEHVr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 03:21:47 -0400
Date: Mon, 5 Oct 2009 18:21:03 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Philipp Reisner <philipp.reisner@linbit.com>, drbd-dev@linbit.com
Subject: Re: linux-next: block/drbd tree build failure
Message-Id: <20091005182103.0a391d15.sfr@canb.auug.org.au>
In-Reply-To: <20091005063138.GO26573@kernel.dk>
References: <20091005143552.977a2d4d.sfr@canb.auug.org.au>
	<20091005063138.GO26573@kernel.dk>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__5_Oct_2009_18_21_03_+1100_MHtEgfBX0PVloY.h"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__5_Oct_2009_18_21_03_+1100_MHtEgfBX0PVloY.h
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jens,

On Mon, 5 Oct 2009 08:31:38 +0200 Jens Axboe <jens.axboe@oracle.com> wrote:
>
> On Mon, Oct 05 2009, Stephen Rothwell wrote:
> >=20
> > Today's linux-next build (x86_64 allmodconfig) failed like this:
> >=20
> > drivers/block/drbd/drbd_req.c: In function '_drbd_start_io_acct':
> > drivers/block/drbd/drbd_req.c:43: error: subscripted value is neither a=
rray nor pointer
> > drivers/block/drbd/drbd_req.c: In function '_drbd_end_io_acct':
> > drivers/block/drbd/drbd_req.c:56: error: subscripted value is neither a=
rray nor pointer
> >=20
> > I reported a similar error against the dbd tree, which was fixed, but n=
ow
> > the commit that caused that error has been reverted and thus we get
> > this :-(
> >=20
> > I have reverted the drbd commits from the block tree for today.
>=20
> That's probably my fault, not drbd. I moved it to a new branch since it
> isn't going into 2.6.32, and perhaps dropped that fix along the way.
> I'll look into it.

The original problem was caused by commit
a9327cac440be4d8333bba975cbbf76045096275 ("Seperate read and write
statistics of in_flight requests") which went into Linus' tree on Sept
15.  The drbd tee was fixed to cope with that change.  Then that commit
was reverted in Linus' tree on Oct 5, so the fix to the drbd tree needs
to be reverted as well.  Unfortunately, the drbd tree has been rebased
into (basically) one commit, so that commit needs fixing.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__5_Oct_2009_18_21_03_+1100_MHtEgfBX0PVloY.h
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkrJnl8ACgkQjjKRsyhoI8zvMACglTRM6hitGZWiknE5kvzC2mRx
KQAAn17A0+HMaeOR1VbeDw7onsRK0qQq
=yDU5
-----END PGP SIGNATURE-----

--Signature=_Mon__5_Oct_2009_18_21_03_+1100_MHtEgfBX0PVloY.h--
