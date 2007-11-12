Return-Path: <linux-kernel-owner+w=401wt.eu-S1758949AbXKLN0d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758949AbXKLN0d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 08:26:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758378AbXKLN0Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 08:26:25 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:9348 "EHLO
	viefep14-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758260AbXKLN0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 08:26:24 -0500
Subject: Re: iozone write 50% regression in kernel 2.6.24-rc1
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1194861112.20251.124.camel@ymzhang>
References: <1194601672.20251.60.camel@ymzhang>
	 <1194602064.6289.157.camel@twins>  <1194833640.20251.80.camel@ymzhang>
	 <1194860728.7179.6.camel@twins>  <1194861112.20251.124.camel@ymzhang>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-COOLTh5X0xXPQdAeAAAy"
Date: Mon, 12 Nov 2007 14:26:20 +0100
Message-Id: <1194873980.7179.31.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-COOLTh5X0xXPQdAeAAAy
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Single socket, dual core opteron, 2GB memory
Single SATA disk, ext3

x86_64 kernel and userland

(dirty_background_ratio, dirty_ratio) tunables

---- (5,10) - default

2.6.23.1-42.fc8 #1 SMP

          524288       4   59580   60356
          524288       4   59247   61101
          524288       4   61030   62831

2.6.24-rc2 #28 SMP PREEMPT

          524288       4   49277   56582
          524288       4   50728   61056
          524288       4   52027   59758
          524288       4   51520   62426


---- (20,40) - similar to your 8GB

2.6.23.1-42.fc8 #1 SMP

          524288       4  225977  447461
          524288       4  232595  496848
          524288       4  220608  478076
          524288       4  203080  445230

2.6.24-rc2 #28 SMP PREEMPT

          524288       4   54043   83585
          524288       4   69949  516253
          524288       4   72343  491416
          524288       4   71775  492653

---- (60,80) - overkill

2.6.23.1-42.fc8 #1 SMP

          524288       4  208450  491892
          524288       4  216262  481135
          524288       4  221892  543608
          524288       4  202209  574725
          524288       4  231730  452482

2.6.24-rc2 #28 SMP PREEMPT

          524288       4   49091   86471
          524288       4   65071  217566
          524288       4   72238  492172
          524288       4   71818  492433
          524288       4   71327  493954


While I see that the write speed as reported under .24 ~70MB/s is much
lower than the one reported under .23 ~200MB/s, I find it very hard to
believe my poor single SATA disk could actually do the 200MB/s for
longer than its cache 8/16 MB (not sure).

vmstat shows that actual IO is done, even though the whole 512MB could
fit in cache, hence my suspicion that the ~70MB/s is the most realistic
of the two.

I'll have to look into what iozone actually does though and why this
patch makes the output different.

FWIW - because its a single backing dev it does get to 100% of the dirty
limit after a few runs, so not sure what makes the difference.

--=-COOLTh5X0xXPQdAeAAAy
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHOFR8XA2jU0ANEf4RAoSnAJ99Xf+uRmISFCItACuI2JKQ1D2rfwCfRqAO
qLual9eQV++mQb15Kj58+rg=
=TWAj
-----END PGP SIGNATURE-----

--=-COOLTh5X0xXPQdAeAAAy--

