Return-Path: <linux-kernel-owner+w=401wt.eu-S1755205AbZJZH66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205AbZJZH66 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 03:58:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755123AbZJZH65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 03:58:57 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:35420 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754995AbZJZH64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 03:58:56 -0400
Subject: Re: [PATCH] net: Adjust softirq raising in __napi_schedule
From: Johannes Berg <johannes@sipsolutions.net>
To: Jarek Poplawski <jarkao2@gmail.com>
Cc: Tilman Schmidt <tilman@imap.cc>, David Miller <davem@davemloft.net>,
       hidave.darkstar@gmail.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, linux-wireless@vger.kernel.org,
       linux-ppp@vger.kernel.org, netdev@vger.kernel.org, paulus@samba.org,
       Michael Buesch <mb@bu3sch.de>, Oliver Hartkopp <oliver@hartkopp.net>
In-Reply-To: <20091026075438.GB6187@ff.dom.local>
References: <4AD76184.6030900@gmail.com> <4ADF5710.4030505@imap.cc>
	 <20091021211906.GA11401@ami.dom.local>
	 <1256160330.12174.2.camel@johannes.local>
	 <20091021213947.GA12202@ami.dom.local>
	 <1256200021.12174.11.camel@johannes.local> <4AE1C00B.5010008@imap.cc>
	 <1256309191.12174.51.camel@johannes.local>
	 <20091026074126.GA6187@ff.dom.local>
	 <1256543054.28230.6.camel@johannes.local>
	 <20091026075438.GB6187@ff.dom.local>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-5UamH4+2+8z4jInfScvN"
Date: Mon, 26 Oct 2009 08:58:52 +0100
Message-ID: <1256543932.28230.9.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-5UamH4+2+8z4jInfScvN
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-10-26 at 07:54 +0000, Jarek Poplawski wrote:

> > No, I wrote that I didn't know. I suppose now that I looked at it I do
> > know, and only disabling preemption is required.
>=20
> But netif_rx has preemption disabled most of the time (by hardirqs
> disabling). So maybe disabling preemption isn't the main reason here
> either?

Not for netpoll though, which may or may not be relevant (if I were to
venture a guess I'd say it isn't and it disables preemption to be able
to do the softirq thing)

However, I lost track now of why we're discussing this.

Basically it boils down to using netif_rx() when in (soft)irq, and
netif_rx_ni() when in process context. That could just be an
optimisation, but it's a very valid one.

johannes

--=-5UamH4+2+8z4jInfScvN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK5Va4AAoJEODzc/N7+QmaGZ0P/3XWgEgM6SCQX98BVmafmXc5
2Mbi7bpGvxC34SPawy9T3H7vUgRrATm8S/DGDscgRjTAY0/bZQaau2dFs+a2UBfc
4XJvc41om+OuhG83o9LvyjlGN1w0XFt8WwPFT7UeXoRRePnXz0DPt3YPMiZ9IkwY
tynu6L3i2yG+G2xR2/rd49Dk15YZJfKzbJs6KrMJhtOWPYMWXrDfXD2CDUApbXOZ
3tzaZrnRF/YbBLvOlNrxoRyBhQyvR+QgiKdnQkf5dD+DqAtPVdFPrJHRdp/W9m1p
Dgqvml35IoWNA71BeDdH+ozEGkLLESp7G8nR1nnZpU2IBR5PhuPfAzfb6t763bW3
qS57TUtAGcokPm+HonmginKt2q34+nN3J+iRyjr0XIRlcm05idvMImxBucVYf6CF
cbVMZ5BGwZRvjj6e2YOdNRZRbcy+5sNfCRF+AGYWuDyF9WbEiaecKnAx0qkWcRQv
BLTDC35t5cS5M4+Qa/cyopFc9uvBxGa1gMUYpqmSqV6Ix24bdzZlM+e9FrTprsud
3L/9XjrA8daRU1DQzaAz0uWAL07gu0xq6kJpBndFsDcTq4HIKJvEERvF4fGogURu
ENDJ6UgqWDMsnIzmVFsOTeZv0YggzRwIc6AxUoSwdHSwSJtszlknjN9Yhzxvw2AR
Wh1lCuj79evprgY5Fhsx
=NWhK
-----END PGP SIGNATURE-----

--=-5UamH4+2+8z4jInfScvN--

