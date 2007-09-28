Return-Path: <linux-kernel-owner+w=401wt.eu-S1761104AbXI1G7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761104AbXI1G7X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 02:59:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756741AbXI1G7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 02:59:16 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:52164 "EHLO
	viefep31-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757340AbXI1G7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 02:59:16 -0400
Subject: Re: A unresponsive file system can hang all I/O in the system on
	linux-2.6.23-rc6 (dirty_thresh problem?)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chakri n <chakriin5@gmail.com>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, nfs@lists.sourceforge.net
In-Reply-To: <20070927235034.ae7bd73d.akpm@linux-foundation.org>
References: <92cbf19b0709272332s25684643odaade0e98cb3a1f4@mail.gmail.com>
	 <20070927235034.ae7bd73d.akpm@linux-foundation.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-B1Ooclvwi4GWFafBgg8h"
Date: Fri, 28 Sep 2007 08:59:12 +0200
Message-Id: <1190962752.31636.15.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-B1Ooclvwi4GWFafBgg8h
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-09-27 at 23:50 -0700, Andrew Morton wrote:

> What we _don't_ want to happen is for other processes which are writing t=
o
> other, non-dead devices to get collaterally blocked.  We have patches whi=
ch
> might fix that queued for 2.6.24.  Peter?

Nasty problem, don't do that :-)

But yeah, with per BDI dirty limits we get stuck at whatever ratio that
NFS server/mount (?) has - which could be 100%. Other processes will
then work almost synchronously against their BDIs but it should work.

[ They will lower the NFS-BDI's ratio, but some fancy clipping code will
  limit the other BDIs their dirty limit to not exceed the total limit.
  And with all these NFS pages stuck, that will still be nothing. ]



--=-B1Ooclvwi4GWFafBgg8h
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBG/KZAXA2jU0ANEf4RAjISAJ9TSkJmNAVhOu/vmw1bCp3sJRQ79QCeOjWE
ulcriUmObG9ScdbPLab3h9I=
=Lkx1
-----END PGP SIGNATURE-----

--=-B1Ooclvwi4GWFafBgg8h--

