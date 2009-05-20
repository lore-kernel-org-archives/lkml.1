Return-Path: <linux-kernel-owner+w=401wt.eu-S1754197AbZETGsr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197AbZETGsr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 02:48:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751544AbZETGsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 02:48:40 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:38784 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305AbZETGsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 02:48:39 -0400
Subject: Re: INFO: possible circular locking dependency at 
 cleanup_workqueue_thread
From: Johannes Berg <johannes@sipsolutions.net>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <d82e647a0905192036n22db3f50r58e0a325893c4823@mail.gmail.com>
References: <c4e36d110905120059i4c155508oa00672da0b33a07a@mail.gmail.com>
	 <20090517071834.GA8507@elte.hu> <1242559101.28127.63.camel@johannes.local>
	 <20090518194749.GA3501@redhat.com>
	 <1242723104.17164.5.camel@johannes.local>
	 <20090519120010.GA14782@redhat.com>
	 <1242747203.4797.39.camel@johannes.local>
	 <d82e647a0905192036n22db3f50r58e0a325893c4823@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-KnnlO2MYgmMkJDpJR4Cf"
Date: Wed, 20 May 2009 08:47:44 +0200
Message-Id: <1242802064.31350.12.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-KnnlO2MYgmMkJDpJR4Cf
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-05-20 at 11:36 +0800, Ming Lei wrote:

> > Anyway, you can have a deadlock like this:
> >
> > CPU 3                   CPU 2                           CPU 1
> >                                                        suspend/hibernat=
e
> >                        something:
> >                        rtnl_lock()                     device_pm_lock()
> >                                                        -> mutex_lock(&d=
pm_list_mtx)
> >
> >                        mutex_lock(&dpm_list_mtx)
>=20
> Would you give a explaination why mutex_lock(&dpm_list_mtx) runs in CPU2
> and depends on rtnl_lock?

Why not? Something is registering a hotplugged netdev.

johannes

--=-KnnlO2MYgmMkJDpJR4Cf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKE6eMAAoJEODzc/N7+QmaiH8P/jNvMR7F33Xe7cavJkqrcZK2
9p04eYp2kjN5wkxIx452ACPhG6h1HQVVqnuaC/NI4SPztP6ufiuYyC5+ZpQeyHJ7
dyhD1Oe/hyKLlOxJ6o9HLB0w7EZWRsoTNfV2+NZX6GiadBgR6h/cBmbRwbm2opzw
uj9loi8MuWEIswp6KvEBTV3DRmpk5pzor7r/QIvFlXS58EOqgimnUCZo/IjlAUv7
J+GqOTlL9ka66D9ttGk+V1rqGB/27NmeAxlZGCYAiEsqcMH21GkQY9c15jYJytJR
SC28TxCWC/8f1IOatW4mKNVNaBcbpiLBrodIVoQmPEwCpwgal5+PEB0n4Osmd2R1
17bhxADdtATc5Q7ImvUrGP10iShLmmfXHZPrHvDmYgRnI8nUG1sPHE8sccfMDPLK
+4CfniKXwtB+RznOIBD99ZnxPHx40n/DYxDVfNrjFZEWNaEOyF3htDv3AdoAXgvE
dZnAOJP1vycrAV9fccCNyg4kt/MWYYcWHi5DhkxCkSRGfpJhwlvn1oGDWMKu0sNl
/RcL878ZsSI+76460BWz0W4PH+j8/v9kIX77LiFQYiG/fOIsHWRIM49XSvPhB1w7
s84+pdD+OVrtik14npt2pLXxMDvNxI2+7nTqhlSHq5q/cCTIRUIgQ/YoTa4HiIwB
UddrMFZpqfFfpNO62rZi
=B/7G
-----END PGP SIGNATURE-----

--=-KnnlO2MYgmMkJDpJR4Cf--

