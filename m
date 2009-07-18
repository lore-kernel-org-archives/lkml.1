Return-Path: <linux-kernel-owner+w=401wt.eu-S1758208AbZGRLd6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758208AbZGRLd6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 07:33:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758174AbZGRLd5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 07:33:57 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:36214 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758130AbZGRLd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 07:33:57 -0400
Subject: Re: [PATCH] wireless: wl12xx, fix lock imbalance
From: Johannes Berg <johannes@sipsolutions.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Slaby <jirislaby@gmail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090718111948.GD27287@elte.hu>
References: <1247520266-32007-1-git-send-email-jirislaby@gmail.com>
	 <1247521235.7178.1.camel@johannes.local> <4A5BAABF.9020708@gmail.com>
	 <1247521789.7178.2.camel@johannes.local> <4A5BAC77.9010503@gmail.com>
	 <1247522068.7178.4.camel@johannes.local>  <20090718111948.GD27287@elte.hu>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-WeQ6k4g6FOqxGcSwZXWT"
Date: Sat, 18 Jul 2009 13:33:49 +0200
Message-Id: <1247916829.1055.24.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-WeQ6k4g6FOqxGcSwZXWT
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-07-18 at 13:19 +0200, Ingo Molnar wrote:

> Yes. And in fact 'nice' code wants to be either annotated explicitly=20
> as 'I am taking locks', or should be balanced.

I agree.

> I was thinking about also using lockdep plus the function-graph=20
> tracer for that (in the dynamic lock debugging department).

Yeah, but that's dynamic again -- all the error paths are never caught.

> It would work like this: __acquires()/__releases() would also emit=20
> section markers like __lockfunc, and lockdep would warn about=20
> functions that return with unbalanced locks, irqs or preempt counts=20
> and do not declare themselves as locking related functions.
>=20
> This would help catch imbalances at their source.

I don't see a need to do it dynamically since sparse warns about things
like this. It's quirky in some ways and I've tried to fix it up before
(and failed) but it's not something that can't be fixed, it just needs
more than a night of hacking.

> Plus static tools like Jiri is working on are very useful as well. I=20
> think Coverty does that too and it's a pity we dont have free tools=20
> for that. In fact Covery will sweep clean the kernel of such bugs,=20
> giving OSS tools like 'stanse' the false impression that there are=20
> no such bugs. There are such bugs - there's a constant influx of=20
> them. So please work on this, it looks very useful.

What's "this" in this context?

johannes

--=-WeQ6k4g6FOqxGcSwZXWT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKYbMaAAoJEODzc/N7+QmaqnEP/1DYg7lkyIwk871ShUGom4+4
3fzwFcYj8DquOvOhcY3x2AwpuuR08s9DRXbtl+jSeBMZ35bVEZnQRZTaJJeJZ5LH
ifpQxubFvylG6eapLthk6Ptb4GTLGYg/spHUxPgLFoJe5clV19qJ5B9XPo5ieNiO
SZsDuDdYYnKQs/qrEyDGwg3Dq62w/opNjiILYII66th92RTsbV/awwxOZi7Y/fqD
tpV4K9SXom2BT0aJNO6AV0HZDVgil/d0akcGTZFn+58fo/YOZ7H1lqE5xBuSpy4T
zSQJBkJWo45bUXdSZ0xIN2k+Ps+wk9qhqd8U6DMEoVgfzbf0BN7d3AFxqSVJxP3U
XnMw1DqzcleFgYgiqysxjtatysbRQzWZvhHoySKJ3yzxZ6QFprziNM0CjTp509ID
a5S6bHwBnfW9ze4RvOKYC1CsS42unj8MMRY9s6Krclx7Ukf1r8YtPpL8My9d/CSK
xbBQPaWGa1E8W84VNh7vTb13Fd/ibDFZioRNq7prAjYxzHSJJJ3u4Z3Ne6ePqv0+
Pc5wymZm3ZOxFeQ2ZsT1i54ScbSWLXen8jvD5XFFsEtwp25EL1Zk459sQx5FxzZz
kHa4cwDNRgdop9SjDbijt18eJwHGWGLnqgwyQEFv5j0O+NMv5GaiZTJqNrtnCBUE
4hRi8bUkM0J18/myyvg9
=ft39
-----END PGP SIGNATURE-----

--=-WeQ6k4g6FOqxGcSwZXWT--

