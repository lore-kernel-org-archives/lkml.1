Return-Path: <linux-kernel-owner+w=401wt.eu-S932637Ab0AFTEL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932637Ab0AFTEL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 14:04:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932620Ab0AFTEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 14:04:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1865 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932494Ab0AFTEJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 14:04:09 -0500
Date: Wed, 6 Jan 2010 13:04:00 -0600
From: Clark Williams <williams@redhat.com>
To: RT <linux-rt-users@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [RFC] [rt-tests] change to cyclictest behavior
Message-ID: <20100106130400.7f30ae55@torg>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/SJyudqVlUyknBmoKuo3cu9t"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/SJyudqVlUyknBmoKuo3cu9t
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

RT-ers,

I have a problem with the way cyclictest sets up measurement threads,
but before I went and changed things I thought I would ask if people
cherished this particular behavior.=20

Currently, when cyclictest is run with multiple threads (i.e. -t
option) it distributes both the sample interval and the realtime
priority by adding the 'distance' parameter to the interval and
decrementing the priority by one. This means if you have a distance of
500us (default), a specified RT priority of 95 and start four threads,
they will be started with the following parameters:

$ cyclictest -t4 -p95

Will give you:

thread		priority	sample interval
0		95		500
1		94		1000
2		93		1500
3		92		2000

What I'd like to do is modify this logic so that when '-a' (affinity) is
specified, the priority and sample interval will not be altered. I
don't think there's any point in distributing the priority's and
sample intervals when the measurement threads are pinned to their own
CPU.=20

So:

$ cyclictest -t4 -p95 -a

Would have each thread at SCHED_FIFO 95 and a sample interval of 500us.

Note that this behavior also occurs when the histogram (-h) option is
specified).

Thoughts?

Clark

--Sig_/SJyudqVlUyknBmoKuo3cu9t
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEARECAAYFAktE3qYACgkQHyuj/+TTEp0WHACfT3omcXL1B3L7zbgH+9fluw+H
/ZEAoMbgZb2cCe2HwhLnunUiYLbSO3VB
=FpyC
-----END PGP SIGNATURE-----

--Sig_/SJyudqVlUyknBmoKuo3cu9t--
