Return-Path: <linux-kernel-owner+w=401wt.eu-S1031054AbXDSBwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031054AbXDSBwe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 21:52:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031058AbXDSBwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 21:52:34 -0400
Received: from iucha.net ([209.98.146.184]:55530 "EHLO mail.iucha.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031054AbXDSBwe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 21:52:34 -0400
Date: Wed, 18 Apr 2007 20:52:33 -0500
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Adrian Bunk <bunk@stusta.de>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] 2.6.21-rc7 NFS writes: fix a series of issues
Message-ID: <20070419015232.GO24044@iucha.net>
References: <1176868485.6796.42.camel@heimdal.trondhjem.org> <20070418040730.GC24044@iucha.net> <20070417211350.ebba1493.akpm@linux-foundation.org> <20070418043040.GD24044@iucha.net> <alpine.LFD.0.98.0704172148490.31155@woody.linux-foundation.org> <20070417223738.8f49a39f.akpm@linux-foundation.org> <20070418123842.GF24044@iucha.net> <1176902131.6796.62.camel@heimdal.trondhjem.org> <20070418134225.GG24044@iucha.net> <1176905506.6796.84.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wxIXENaY2CYUgF8u"
Content-Disposition: inline
In-Reply-To: <1176905506.6796.84.camel@heimdal.trondhjem.org>
X-GPG-Key: http://iucha.net/florin_iucha.gpg
X-GPG-Fingerprint: 5E59 C2E7 941E B592 3BA4  7DCF 343D 2B14 2376 6F5B
User-Agent: Mutt/1.5.13 (2006-08-11)
From: florin@iucha.net (Florin Iucha)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--wxIXENaY2CYUgF8u
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 18, 2007 at 10:11:46AM -0400, Trond Myklebust wrote:
> Do you have a copy of wireshark or ethereal on hand? If so, could you
> take a look at whether or not any NFS traffic is going between the
> client and server once the hang happens?

I used the following command=20

   tcpdump -w nfs-traffic -i eth0 -vv -tt dst port nfs

to capture

   http://iucha.net/nfs/21-rc7-nfs4/nfs-traffic.bz2

I started the capture before starting the copy and left it to run for
a few minutes after the traffic slowed to a crawl.

The iostat and vmstat are at:

   http://iucha.net/nfs/21-rc7-nfs4/iostat
   http://iucha.net/nfs/21-rc7-nfs4/vmstat
  =20
It seems that my original problem report had a big mistake!  There is
no hang, but at some point the write slows down to a trickle (from
40,000 blocks/s to 22 blocks/s) as can be seen from the iostat log.

Regards,
florin

--=20
Bruce Schneier expects the Spanish Inquisition.
      http://geekz.co.uk/schneierfacts/fact/163

--wxIXENaY2CYUgF8u
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGJstgND0rFCN2b1sRAoQVAJ4qyHnoWVhmtWl5ZPlrJNsMT6RKMgCfXIWv
Yg4UqU+uiWpAS2eKqzSvY3M=
=uE6N
-----END PGP SIGNATURE-----

--wxIXENaY2CYUgF8u--
