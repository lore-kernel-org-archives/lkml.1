Return-Path: <linux-kernel-owner+w=401wt.eu-S1756217AbZETIqP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217AbZETIqP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 04:46:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754296AbZETIqA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 04:46:00 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:33520 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753063AbZETIp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 04:45:59 -0400
Subject: Re: INFO: possible circular locking dependency at 
 cleanup_workqueue_thread
From: Johannes Berg <johannes@sipsolutions.net>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <d82e647a0905200121m6aa68fdcq74cd2825f43b056b@mail.gmail.com>
References: <c4e36d110905120059i4c155508oa00672da0b33a07a@mail.gmail.com>
	 <1242559101.28127.63.camel@johannes.local>
	 <20090518194749.GA3501@redhat.com>
	 <1242723104.17164.5.camel@johannes.local>
	 <20090519120010.GA14782@redhat.com>
	 <1242747203.4797.39.camel@johannes.local>
	 <d82e647a0905192036n22db3f50r58e0a325893c4823@mail.gmail.com>
	 <1242802064.31350.12.camel@johannes.local>
	 <d82e647a0905200009pc894d4yed0f81c83443a0ee@mail.gmail.com>
	 <1242803569.31350.14.camel@johannes.local>
	 <d82e647a0905200121m6aa68fdcq74cd2825f43b056b@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-964W0Y3uyJRyWF62Vt0V"
Date: Wed, 20 May 2009 10:45:03 +0200
Message-Id: <1242809103.19216.2.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-964W0Y3uyJRyWF62Vt0V
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-05-20 at 16:21 +0800, Ming Lei wrote:

> For me, the real puzzle is that  how lockdep introduce  #3
> (dpm_list_mtx){+.+.+.}
>=20
> -> #3 (dpm_list_mtx){+.+.+.}:
>       [<ffffffff80271a64>] __lock_acquire+0xc64/0x10a0
>       [<ffffffff80271f38>] lock_acquire+0x98/0x140
>       [<ffffffff8054e78c>] __mutex_lock_common+0x4c/0x3b0
>       [<ffffffff8054ebf6>] mutex_lock_nested+0x46/0x60
>       [<ffffffff804532ff>] device_pm_add+0x1f/0xe0
>       [<ffffffff8044b9bf>] device_add+0x45f/0x570
>       [<ffffffffa007c578>] wiphy_register+0x158/0x280 [cfg80211]
>       [<ffffffffa017567c>] ieee80211_register_hw+0xbc/0x410 [mac80211]
>       [<ffffffffa01f7c5c>] iwl3945_pci_probe+0xa1c/0x1080 [iwl3945]
>       [<ffffffff803c4307>] local_pci_probe+0x17/0x20
>       [<ffffffff803c5458>] pci_device_probe+0x88/0xb0
>       [<ffffffff8044e1e9>] driver_probe_device+0x89/0x180
>       [<ffffffff8044e37b>] __driver_attach+0x9b/0xa0
>       [<ffffffff8044d67c>] bus_for_each_dev+0x6c/0xa0
>       [<ffffffff8044e03e>] driver_attach+0x1e/0x20
>       [<ffffffff8044d955>] bus_add_driver+0xd5/0x290
>       [<ffffffff8044e668>] driver_register+0x78/0x140
>       [<ffffffff803c56f6>] __pci_register_driver+0x66/0xe0
>       [<ffffffffa00bd05c>] 0xffffffffa00bd05c
>       [<ffffffff8020904f>] do_one_initcall+0x3f/0x1c0
>       [<ffffffff8027d071>] sys_init_module+0xb1/0x200
>       [<ffffffff8020c15b>] system_call_fastpath+0x16/0x1b
>       [<ffffffffffffffff>] 0xffffffffffffffff
>=20
> into the lockdep graph?  in which process context?  and what is the
> previous held lock?
> After all, there is a path ( #0,#1,#2,...,#5 ) in the directed graph
> and #3 is added by
> add_lock_to_list().

Well, as Peter explained in the other part of the thread, lockdep will
always show the first cycle it found, not the shortest. The scenario
that I outlined is actually closer to this report:
http://paste.pocoo.org/show/116240/ but not quite that either, I further
shortened it.

Anyway, I have no idea how to fix it.

johannes

--=-964W0Y3uyJRyWF62Vt0V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKE8MKAAoJEODzc/N7+QmaeCEQAJaBRZk1xEjJMulTjmZvFYLJ
iY2wq8dz84nFKOJewkOSeHbB9uyR0hwpcF0cNA/JlQuZ87mNzuAOdr9y9YFbIu0X
B7crJasq0Sje2M5Pwjm2fV07ZkJIR5XUVSZ9vi4Jx/58dEKpK7eBfhwTSpfSTy1L
spHYHu/hRgQhasVo9+IZNpCXq7INQPeL9hviWPmyhFqpEvoO4SqxUapg6Id5wXTP
6sLLzeAa7gSYbFa3jG5qlXZzRdF/ioHpdJ4DByKiBq1+IVhsIVONC09F/3Q6/atZ
wlTvUOIHFgGXabI91naL9i3tGynIIskv7JMeAzn5sDztPgDKH7EPkGlpZ4FNPGBg
e4Pc+fhc61OIKDIYRHH2RTMoDtH7yYvfrv6F1dFYhlcyEyKs98vuQemSqJKMDZDK
zgJxuHxqKtNRuY42YY6Br9W7U7vWxuwMJQ5RoT1a1Yz0v2qvCLupKFJBp54VZVoe
xmzZiywcIWuSRr6515p1p8zAkigN2yyIugSceoyC9cDqyXgJUb3dmCFVRgtWdsVu
DVKB/KRFrwbcASju1C3NAJ7QJMBv9wUFIW0xEDlDKFiPrEoNRIa3SOn4V3VWpOJq
8/QIJ0n9M01VNoBESEu4rTVL6GG2tiKIz5A30U+vP1OABP9/AD5b5P6vvpUgACd/
ZkaWplnYXvCXqd7f5KLB
=Xzz4
-----END PGP SIGNATURE-----

--=-964W0Y3uyJRyWF62Vt0V--

