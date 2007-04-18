Return-Path: <linux-kernel-owner+w=401wt.eu-S1752851AbXDRNm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851AbXDRNm1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 09:42:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752984AbXDRNm1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 09:42:27 -0400
Received: from iucha.net ([209.98.146.184]:54217 "EHLO mail.iucha.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752851AbXDRNm1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 09:42:27 -0400
Date: Wed, 18 Apr 2007 08:42:26 -0500
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Adrian Bunk <bunk@stusta.de>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] 2.6.21-rc7 NFS writes: fix a series of issues
Message-ID: <20070418134225.GG24044@iucha.net>
References: <1176865565.6796.16.camel@heimdal.trondhjem.org> <20070418033055.GA24044@iucha.net> <1176868485.6796.42.camel@heimdal.trondhjem.org> <20070418040730.GC24044@iucha.net> <20070417211350.ebba1493.akpm@linux-foundation.org> <20070418043040.GD24044@iucha.net> <alpine.LFD.0.98.0704172148490.31155@woody.linux-foundation.org> <20070417223738.8f49a39f.akpm@linux-foundation.org> <20070418123842.GF24044@iucha.net> <1176902131.6796.62.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+sHJum3is6Tsg7/J"
Content-Disposition: inline
In-Reply-To: <1176902131.6796.62.camel@heimdal.trondhjem.org>
X-GPG-Key: http://iucha.net/florin_iucha.gpg
X-GPG-Fingerprint: 5E59 C2E7 941E B592 3BA4  7DCF 343D 2B14 2376 6F5B
User-Agent: Mutt/1.5.13 (2006-08-11)
From: florin@iucha.net (Florin Iucha)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--+sHJum3is6Tsg7/J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 18, 2007 at 09:15:31AM -0400, Trond Myklebust wrote:
> There is only one request on the 'pending' queue. That would usually
> indicate that the connection to the server is down. Can you check using
> "netstat -t" whether or not there is a connection in the 'ESTABLISHED'
> state to the server? Please also repeat the command a couple of times in
> order to see if the socket/port number on the connection changes.

This is with your fifth patch on top of the previous four patches:

   http://iucha.net/nfs/21-rc7-nfs3/big-copy

Again, it has memory, stack traces and rpc_debug.

The iostat 5 output:

   http://iucha.net/nfs/21-rc7-nfs3/iostat

The netstat outputs are stable (not changed in 5 minutes):

   http://iucha.net/nfs/21-rc7-nfs3/netstat-server :

tcp        1      0 hermes.iucha.org:nfs    zeus.iucha.org:799      CLOSE_W=
AIT=20
tcp        0      0 hermes.iucha.org:nfs    zeus.iucha.org:976      ESTABLI=
SHED

   http://iucha.net/nfs/21-rc7-nfs3/netstat-client

Active Internet connections (w/o servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State  =
   =20
tcp        0      0 zeus.iucha.org:976      hermes.iucha.org:nfs    ESTABLI=
SHED
tcp        0      0 zeus.iucha.org:ssh      hermes.iucha.org:56880  ESTABLI=
SHED
tcp        0      0 zeus.iucha.org:ssh      hermes.iucha.org:45176  ESTABLI=
SHED

Could the port in CLOSE_WAIT state be the culprit?  (FWIW
the server has been up for 38 days and subjected to
this nfs test quite a bit without showing any stress).

Regards,
florin

--=20
Bruce Schneier expects the Spanish Inquisition.
      http://geekz.co.uk/schneierfacts/fact/163

--+sHJum3is6Tsg7/J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGJiBBND0rFCN2b1sRAoMvAJ4oU3Rbo/fObJ8JpeQ2/AwR7ds+DACfXMP4
ZIug9qXOc4deOyM9muwJD6U=
=jcin
-----END PGP SIGNATURE-----

--+sHJum3is6Tsg7/J--
