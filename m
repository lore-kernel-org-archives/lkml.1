Return-Path: <linux-kernel-owner+w=401wt.eu-S932396AbXDRF0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932396AbXDRF0S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 01:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932424AbXDRF0S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 01:26:18 -0400
Received: from iucha.net ([209.98.146.184]:57553 "EHLO mail.iucha.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932396AbXDRF0R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 01:26:17 -0400
Date: Wed, 18 Apr 2007 00:26:16 -0500
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Trond Myklebust <Trond.Myklebust@netapp.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Adrian Bunk <bunk@stusta.de>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] 2.6.21-rc7 NFS writes: fix a series of issues
Message-ID: <20070418052616.GE24044@iucha.net>
References: <87hcrfaqam.fsf@duaron.myhome.or.jp> <20070418011946.11679.34920.stgit@heimdal.trondhjem.org> <20070417195823.943f9472.akpm@linux-foundation.org> <1176865565.6796.16.camel@heimdal.trondhjem.org> <20070418033055.GA24044@iucha.net> <1176868485.6796.42.camel@heimdal.trondhjem.org> <20070418040730.GC24044@iucha.net> <20070417211350.ebba1493.akpm@linux-foundation.org> <20070418043040.GD24044@iucha.net> <alpine.LFD.0.98.0704172148490.31155@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7LkOrbQMr4cezO2T"
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0704172148490.31155@woody.linux-foundation.org>
X-GPG-Key: http://iucha.net/florin_iucha.gpg
X-GPG-Fingerprint: 5E59 C2E7 941E B592 3BA4  7DCF 343D 2B14 2376 6F5B
User-Agent: Mutt/1.5.13 (2006-08-11)
From: florin@iucha.net (Florin Iucha)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--7LkOrbQMr4cezO2T
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 17, 2007 at 10:14:02PM -0700, Linus Torvalds wrote:
> On Tue, 17 Apr 2007, Florin Iucha wrote:
> >=20
> > Already did.  Traces from vanilla kernel at
> >    http://iucha.net/nfs/21-rc7/big-copy
>=20
> Well, there's a pdflush in io_schedule_timeout/congestion_wait, and=20
> there's a nfsv4-scv in svc_recv/nfs_callback_sv, and a lot of processes=
=20
> either just in schedule_timeout or similar "normal" waiting (pollwait=20
> etc).
>=20
> [ The call traces could be prettier, but sadly, even if you enable frame=
=20
>   pointers, the x86-64 kernel is too stupid to follow them. So you kind o=
f=20
>   just have to ignore the noise) ]
>=20
> The triggering process looks like it might be that "cp", it is in the=20
> __wait_on_bit/sync_page/wait_on_page_bit/wait_on_page_writeback_range/=20
> filemap_fdatawait.
>=20
> Is this a trace from the "big copy" hang, or from a gnome splashscreen=20
> hang? It *looks* like it's a big copy. Yes/no?

It *is* big copy.

I am monitoring the copy on the server, using "iostat 5".  It writes
for a while at a fairly constant pace (on ext3 *), then it drops to 0 in 5-=
10
seconds and stays there...  Once I left it for a couple of hours and
it did not pick up.

Regards,
florin

(*) XFS exhibited wild ups and downs in the transaction rate, and JFS
starts strong then loses steam and slowly settles to about half ext3's
rate.

--=20
Bruce Schneier expects the Spanish Inquisition.
      http://geekz.co.uk/schneierfacts/fact/163

--7LkOrbQMr4cezO2T
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGJav3ND0rFCN2b1sRAv55AJ9aWNV/QgVEO+vJyTny1ZC8unkWSwCgo5BP
9SgwGGRFFDIh6fm2vk4P8lk=
=lesM
-----END PGP SIGNATURE-----

--7LkOrbQMr4cezO2T--
