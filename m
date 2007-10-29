Return-Path: <linux-kernel-owner+w=401wt.eu-S1759146AbXJ2SsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759146AbXJ2SsT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 14:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755123AbXJ2SsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 14:48:11 -0400
Received: from iucha.net ([209.98.146.184]:37221 "EHLO mail.iucha.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754895AbXJ2SsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 14:48:10 -0400
Date: Mon, 29 Oct 2007 13:48:08 -0500
From: Florin Iucha <florin@iucha.net>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: pdflush stuck in D state with v2.6.24-rc1-192-gef49c32
Message-ID: <20071029184808.GH25561@iucha.net>
References: <20071028152428.GJ7918@iucha.net> <1193665619.7396.8.camel@heimdal.trondhjem.org> <20071029150154.GC25561@iucha.net> <1193683412.7497.10.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2xzXx3ruJf7hsAzo"
Content-Disposition: inline
In-Reply-To: <1193683412.7497.10.camel@heimdal.trondhjem.org>
X-GPG-Key: http://iucha.net/florin_iucha.gpg
X-GPG-Fingerprint: 5E59 C2E7 941E B592 3BA4  7DCF 343D 2B14 2376 6F5B
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--2xzXx3ruJf7hsAzo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 29, 2007 at 02:43:32PM -0400, Trond Myklebust wrote:
>=20
> On Mon, 2007-10-29 at 10:01 -0500, Florin Iucha wrote:
> > On Mon, Oct 29, 2007 at 09:46:59AM -0400, Trond Myklebust wrote:
> > > > What could cause this?  I use NFS4 to automount the home directories
> > > > from a Solaris10 server, and this box found a few bugs in the NFS4
> > > > code (fixed in the 2.6.22 kernel).
> > > >=20
> > > > I'll try running with 2.6.23 again for a few days, to see if I get =
the
> > > > pdflush stuck.  Any other ideas?
> > >=20
> > > One of them appears to be waiting for i/o congestion to clear up. If =
the
> > > filesystem is NFS, then that means that some other thread is busy
> > > writing data out to the server. You'll need to look at the rest of the
> > > thread dump to figure out which thread is writing the data out, and
> > > where it is getting stuck.
> >=20
> > Trond,
> >=20
> > The full dmesg is at http://iucha.net/2.6.24-rc1/dmesg.stuck_pdflush.gz
>=20
> I can't see any evidence of NFS traffic at all in those traces, but
> there is a fuse process that is sleeping in :fuse:fuse_dev_read(). Could
> that perhaps be relevant.

That might be the overzealous Ubuntu trying to make the NTFS partition
available.  I will try to disable it and see if I can reproduce the
hang.  BTW: With 2.6.24-rc1+ it happens after a couple of hours.  With
2.6.23 it did not happen after 6 hours or so.

Cheers,
florin

--=20
Bruce Schneier expects the Spanish Inquisition.
      http://geekz.co.uk/schneierfacts/fact/163

--2xzXx3ruJf7hsAzo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHJiroND0rFCN2b1sRAgygAJ4ysF6uJZTHDRwXJHvfJHOC9eCAJQCfcreR
Zm/4N2/4FbgmnFZsQ1Y+I8U=
=snVW
-----END PGP SIGNATURE-----

--2xzXx3ruJf7hsAzo--
