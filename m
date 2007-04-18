Return-Path: <linux-kernel-owner+w=401wt.eu-S1031336AbXDRDuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031336AbXDRDuj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 23:50:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031339AbXDRDuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 23:50:39 -0400
Received: from iucha.net ([209.98.146.184]:40491 "EHLO mail.iucha.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031336AbXDRDui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 23:50:38 -0400
X-Greylist: delayed 1182 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Apr 2007 23:50:38 EDT
Date: Tue, 17 Apr 2007 22:30:55 -0500
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] 2.6.21-rc7 NFS writes: fix a series of issues
Message-ID: <20070418033055.GA24044@iucha.net>
References: <1176740307.6761.56.camel@heimdal.trondhjem.org> <1176741408.6761.62.camel@heimdal.trondhjem.org> <1176792399.3035.30.camel@twins> <20070416125905.GA2769@iucha.net> <1176792399.3035.30.camel@twins> <1176796503.3035.33.camel@twins> <87hcrfaqam.fsf@duaron.myhome.or.jp> <20070418011946.11679.34920.stgit@heimdal.trondhjem.org> <20070417195823.943f9472.akpm@linux-foundation.org> <1176865565.6796.16.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fdj2RfSjLxBAspz7"
Content-Disposition: inline
In-Reply-To: <1176865565.6796.16.camel@heimdal.trondhjem.org>
X-GPG-Key: http://iucha.net/florin_iucha.gpg
X-GPG-Fingerprint: 5E59 C2E7 941E B592 3BA4  7DCF 343D 2B14 2376 6F5B
User-Agent: Mutt/1.5.13 (2006-08-11)
From: florin@iucha.net (Florin Iucha)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 17, 2007 at 11:06:05PM -0400, Trond Myklebust wrote:
> > > I've split the issues introduced by the 2.6.21-rcX write code up into=
 4
> > > subproblems.
> > >=20
> > > The first patch is just a cleanup in order to ease review.
> > >=20
> > > Patch number 2 ensures that we never release the PG_writeback flag un=
til
> > > _after_ we've either discarded the unstable request altogether, or pu=
t it
> > > on the nfs_inode's commit or dirty lists.
> > >=20
> > > Patch number 3 fixes the 'desynchronized value of nfs_i.ncommit' erro=
r. It
> > > uses the PG_NEED_COMMIT flag as an indicator for whether or not the r=
equest
> > > may be redirtied.
> > >=20
> > > Patch number 4 protects the NFS '.set_page_dirty' address_space opera=
tion
> > > against races with nfs_inode_add_request.
> >=20
> > For 2.6.21, yes?
>=20
> Right. A couple of nasty regressions have been sighted. This series
> attempts to deal with them all.

The good news is that the Gnome session log-in progresses to the point
where both top and bottom bars are painted (gray) and the bottom bar
is populated with icons (2.6.21-rc7 vanilla stops after displaying the
splash).  The bad news is that it stops there.

Big-copy fails as well, after 2.5G transferred.

The process traces are at:

   http://iucha.net/nfs/21-rc7-nfs1/gnome-session
   http://iucha.net/nfs/21-rc7-nfs1/big-copy

Regards,
florin

--=20
Bruce Schneier expects the Spanish Inquisition.
      http://geekz.co.uk/schneierfacts/fact/163

--fdj2RfSjLxBAspz7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGJZDvND0rFCN2b1sRAg8uAKCTWzPwv7acEOpIVZbvgFubnbJNGQCeNlNp
5rvRTQdLzdEpg2p7wYkYtds=
=y0Vx
-----END PGP SIGNATURE-----

--fdj2RfSjLxBAspz7--
