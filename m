Return-Path: <linux-kernel-owner+w=401wt.eu-S1753018AbYIWLde@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018AbYIWLde (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 07:33:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750838AbYIWLdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 07:33:24 -0400
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:30940 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750720AbYIWLdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 07:33:23 -0400
From: Ian Campbell <ijc@hellion.org.uk>
To: Tom Tucker <tom@opengridcomputing.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Grant Coady <gcoady.lk@gmail.com>, linux-kernel@vger.kernel.org,
       neilb@suse.de, linux-nfs@vger.kernel.org
In-Reply-To: <1222156770.6869.13.camel@localhost.localdomain>
References: <48B2D7F8.5020206@opengridcomputing.com>
	 <20080826192711.GJ4380@fieldses.org>
	 <48B567F5.2090605@opengridcomputing.com>
	 <1220111261.31172.14.camel@localhost.localdomain>
	 <20080831193037.GB14876@fieldses.org>
	 <1220211842.31172.18.camel@localhost.localdomain>
	 <48BAF643.4070808@opengridcomputing.com>
	 <1220217505.31172.26.camel@localhost.localdomain>
	 <48BC2466.2070806@opengridcomputing.com>
	 <1221036015.24993.27.camel@zakaz.uk.xensource.com>
	 <20080912224323.GN22126@fieldses.org>
	 <48CAF80A.4010109@opengridcomputing.com>
	 <1221296243.2534.7.camel@localhost.localdomain>
	 <1221544139.2534.18.camel@localhost.localdomain>
	 <48CF9AC3.6060801@opengridcomputing.com>
	 <1221577412.28572.60.camel@zakaz.uk.xensource.com>
	 <48CFD7C3.5080207@opengridcomputing.com>
	 <1221582285.28572.67.camel@zakaz.uk.xensource.com>
	 <1222156770.6869.13.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ehF1K8LzIdZ1HXirJ3HZ"
Date: Tue, 23 Sep 2008 12:33:09 +0100
Message-Id: <1222169589.6869.20.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
X-SA-Exim-Connect-IP: 192.168.1.5
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: NFS regression? Odd delays and lockups accessing an NFS export.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
X-Cloudmark-Analysis: v=1.0 c=1 a=unbeb6qN2T0A:10 a=497XeZ5pv4kA:10 a=skoOCyML1wMEGR22XeQA:9 a=Idsgws0JnRJWTanSGc3iDmyqEicA:4 a=Hf6muOzgCGQA:10 a=0kPLrQdw3YYA:10 a=LY0hPdMaydYA:10 a=p-P7vkYxESJy57_59uAA:9 a=YGHkdD78HK4lTWkOkkczCq3f8m8A:4 a=rPt6xJ-oxjAA:10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ehF1K8LzIdZ1HXirJ3HZ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-09-23 at 08:59 +0100, Ian Campbell wrote:
> I've found that the problem was backported into the stable stream since
> I cannot reproduce the issue with 2.6.26 but I can with 2.6.26.5. This
> is quite useful since there are only 3 relevant looking changesets in
> that range. I will bisect between these before confirming the culprit on
> mainline.

It reports:

        daedfbe2a67628a40076a6c75fb945c60f608a2e is first bad commit
        commit daedfbe2a67628a40076a6c75fb945c60f608a2e
        Author: Trond Myklebust <Trond.Myklebust@netapp.com>
        Date:   Wed Jun 11 17:39:04 2008 -0400
       =20
            NFS: Ensure we zap only the access and acl caches when setting =
new acls
           =20
            commit f41f741838480aeaa3a189cff6e210503cf9c42d upstream
           =20
            ...and ensure that we obey the NFS_INO_INVALID_ACL flag when re=
trieving the
            acls.
           =20
            Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
            Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

I'm just about to build f41f741838480aeaa3a189cff6e210503cf9c42d and the
one before and try those.

I'm not using ACLs as far as I am aware.

Ian.

--=20
Ian Campbell

If we were meant to get up early, God would have created us with alarm cloc=
ks.

--=-ehF1K8LzIdZ1HXirJ3HZ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkjY0/UACgkQM0+0qS9rzVnQMQCfStP9cFVR2Zrx4l/lxXusHXDO
zewAoI3TkgRnaeh7ceb/fbYOgrd08zcA
=zBYW
-----END PGP SIGNATURE-----

--=-ehF1K8LzIdZ1HXirJ3HZ--

