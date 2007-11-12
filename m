Return-Path: <linux-kernel-owner+w=401wt.eu-S1759360AbXKLQsd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759360AbXKLQsd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 11:48:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753841AbXKLQsZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 11:48:25 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:27749 "EHLO
	viefep33-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752349AbXKLQsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 11:48:24 -0500
Subject: Re: iozone write 50% regression in kernel 2.6.24-rc1
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Benny Halevy <bhalevy@panasas.com>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       aneesh.kumar@linux.vnet.ibm.com
In-Reply-To: <47386BC4.3050403@panasas.com>
References: <1194601672.20251.60.camel@ymzhang>
	 <1194602064.6289.157.camel@twins>  <1194833640.20251.80.camel@ymzhang>
	 <1194860728.7179.6.camel@twins>  <1194861112.20251.124.camel@ymzhang>
	 <1194873980.7179.31.camel@twins>  <47386BC4.3050403@panasas.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-i1pnZYr0NaGe/YhSV/NN"
Date: Mon, 12 Nov 2007 17:48:20 +0100
Message-Id: <1194886100.9713.13.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-i1pnZYr0NaGe/YhSV/NN
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Mon, 2007-11-12 at 17:05 +0200, Benny Halevy wrote:
> On Nov. 12, 2007, 15:26 +0200, Peter Zijlstra <a.p.zijlstra@chello.nl> wr=
ote:
> > Single socket, dual core opteron, 2GB memory
> > Single SATA disk, ext3
> >=20
> > x86_64 kernel and userland
> >=20
> > (dirty_background_ratio, dirty_ratio) tunables
> >=20
> > ---- (5,10) - default
> >=20
> > 2.6.23.1-42.fc8 #1 SMP
> >=20
> >           524288       4   59580   60356
> >           524288       4   59247   61101
> >           524288       4   61030   62831
> >=20
> > 2.6.24-rc2 #28 SMP PREEMPT
> >=20
> >           524288       4   49277   56582
> >           524288       4   50728   61056
> >           524288       4   52027   59758
> >           524288       4   51520   62426
> >=20
> >=20
> > ---- (20,40) - similar to your 8GB
> >=20
> > 2.6.23.1-42.fc8 #1 SMP
> >=20
> >           524288       4  225977  447461
> >           524288       4  232595  496848
> >           524288       4  220608  478076
> >           524288       4  203080  445230
> >=20
> > 2.6.24-rc2 #28 SMP PREEMPT
> >=20
> >           524288       4   54043   83585
> >           524288       4   69949  516253
> >           524288       4   72343  491416
> >           524288       4   71775  492653
> >=20
> > ---- (60,80) - overkill
> >=20
> > 2.6.23.1-42.fc8 #1 SMP
> >=20
> >           524288       4  208450  491892
> >           524288       4  216262  481135
> >           524288       4  221892  543608
> >           524288       4  202209  574725
> >           524288       4  231730  452482
> >=20
> > 2.6.24-rc2 #28 SMP PREEMPT
> >=20
> >           524288       4   49091   86471
> >           524288       4   65071  217566
> >           524288       4   72238  492172
> >           524288       4   71818  492433
> >           524288       4   71327  493954
> >=20
> >=20
> > While I see that the write speed as reported under .24 ~70MB/s is much
> > lower than the one reported under .23 ~200MB/s, I find it very hard to
> > believe my poor single SATA disk could actually do the 200MB/s for
> > longer than its cache 8/16 MB (not sure).
> >=20
> > vmstat shows that actual IO is done, even though the whole 512MB could
> > fit in cache, hence my suspicion that the ~70MB/s is the most realistic
> > of the two.
>=20
> Even 70 MB/s seems too high.  What throughput do you see for the
> raw disk partition/
>=20
> Also, are the numbers above for successive runs?
> It seems like you're seeing some caching effects so
> I'd recommend using a file larger than your cache size and
> the -e and -c options (to include fsync and close in timings)
> to try to eliminate them.

------ iozone -i 0 -r 4k -s 512m -e -c

.23 (20,40)

          524288       4   31750   33560
          524288       4   29786   32114
          524288       4   29115   31476

.24 (20,40)

          524288       4   25022   32411
          524288       4   25375   31662
          524288       4   26407   33871


------ iozone -i 0 -r 4k -s 4g -e -c

.23 (20,40)

         4194304       4   39699   35550
         4194304       4   40225   36099


.24 (20,40)

         4194304       4   39961   41656
         4194304       4   39244   39673


Yanmin, for that benchmark you ran, what was it meant to measure?
=46rom what I can make of it its just write cache benching.

One thing I don't understand is how the write numbers are so much lower
than the rewrite numbers. The iozone code (which gives me headaches,
damn what a mess) seems to suggest that the only thing that is different
is the lack of block allocation.

Linus posted a patch yesterday fixing up a regression in the ext3 bitmap
block allocator, /me goes apply that patch and rerun the tests.

> > ---- (20,40) - similar to your 8GB
> >=20
> > 2.6.23.1-42.fc8 #1 SMP
> >=20
> >           524288       4  225977  447461
> >           524288       4  232595  496848
> >           524288       4  220608  478076
> >           524288       4  203080  445230
> >=20
> > 2.6.24-rc2 #28 SMP PREEMPT
> >=20
> >           524288       4   54043   83585
> >           524288       4   69949  516253
> >           524288       4   72343  491416
> >           524288       4   71775  492653

2.6.24-rc2 +
        patches/wu-reiser.patch
        patches/writeback-early.patch
        patches/bdi-task-dirty.patch
        patches/bdi-sysfs.patch
        patches/sched-hrtick.patch
        patches/sched-rt-entity.patch
        patches/sched-watchdog.patch
        patches/linus-ext3-blockalloc.patch

          524288       4  179657  487676
          524288       4  173989  465682
          524288       4  175842  489800


Linus' patch is the one that makes the difference here. So I'm unsure
how you bisected it down to:

  04fbfdc14e5f48463820d6b9807daa5e9c92c51f

These results seem to point to

  7c9e69faa28027913ee059c285a5ea8382e24b5d

as being the offending patch.


--=-i1pnZYr0NaGe/YhSV/NN
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHOIPUXA2jU0ANEf4RAs+bAJwMYiLQODdFj6pjvqUoVX3BWVtC0QCeOCbQ
6ImnYvoIKHMFcHkbm3U0uEU=
=VeYk
-----END PGP SIGNATURE-----

--=-i1pnZYr0NaGe/YhSV/NN--

