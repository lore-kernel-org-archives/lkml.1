Return-Path: <linux-kernel-owner+w=401wt.eu-S1755566AbZETHNs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566AbZETHNs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 03:13:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752220AbZETHNj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 03:13:39 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:60683 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319AbZETHNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 03:13:39 -0400
Subject: Re: INFO: possible circular locking dependency at 
 cleanup_workqueue_thread
From: Johannes Berg <johannes@sipsolutions.net>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <d82e647a0905200009pc894d4yed0f81c83443a0ee@mail.gmail.com>
References: <c4e36d110905120059i4c155508oa00672da0b33a07a@mail.gmail.com>
	 <20090517071834.GA8507@elte.hu> <1242559101.28127.63.camel@johannes.local>
	 <20090518194749.GA3501@redhat.com>
	 <1242723104.17164.5.camel@johannes.local>
	 <20090519120010.GA14782@redhat.com>
	 <1242747203.4797.39.camel@johannes.local>
	 <d82e647a0905192036n22db3f50r58e0a325893c4823@mail.gmail.com>
	 <1242802064.31350.12.camel@johannes.local>
	 <d82e647a0905200009pc894d4yed0f81c83443a0ee@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-H2xL3S1i8JXU6Zb77J29"
Date: Wed, 20 May 2009 09:12:49 +0200
Message-Id: <1242803569.31350.14.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-H2xL3S1i8JXU6Zb77J29
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-05-20 at 15:09 +0800, Ming Lei wrote:
> 2009/5/20 Johannes Berg <johannes@sipsolutions.net>:
> > On Wed, 2009-05-20 at 11:36 +0800, Ming Lei wrote:
> >
> >> > Anyway, you can have a deadlock like this:
> >> >
> >> > CPU 3                   CPU 2                           CPU 1
> >> >                                                        suspend/hiber=
nate
> >> >                        something:
> >> >                        rtnl_lock()                     device_pm_loc=
k()
> >> >                                                        -> mutex_lock=
(&dpm_list_mtx)
> >> >
> >> >                        mutex_lock(&dpm_list_mtx)
> >>
> >> Would you give a explaination why mutex_lock(&dpm_list_mtx) runs in CP=
U2
> >> and depends on rtnl_lock?
> >
> > Why not? Something is registering a hotplugged netdev.
>=20
> I see. I just feel a bit curious how lockdep may build the dependency
> of dpm_list_mtx on rtnl_lock,  and it  is certainly related with
> lockdep internal.

No, it's just the way drivers/base/power/ works -- it acquires the lock
when you register a new struct device.

johannes

--=-H2xL3S1i8JXU6Zb77J29
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKE61tAAoJEODzc/N7+QmacHoP/3CFnvxLsuGIwC8EUGnkatAG
g27m4dBxba/GewrUD97q6GZ6rb8DDwmf7El5ZZlJOWigttvB3mez+NF1PLfvM4vl
DbWkLv34tncxoyFf/ToFEwYsYXlhJx5vKFKPoArsbARGGlKAtaT+REE/RWHT3rhT
HmeXBH18XrWU1aen9an6y05ZEr48QSUfJJtzS2g58WBSJ1uNmD51Z4JJ8c1pl211
0ToRvzeDwDIvkxI4HvbxsIXmj0QPUvM6pGbMe1sYHnOLIOKSRMqikeMtK1G9Z2pa
1hjmSUxeqNuGaU0Z622fVqBmciAh+py5IIkkPfNglBNcZaCvLMrXzlEGWi7x4Ydt
uvgg06N7vDwqm4A95TPnGgbfnw9kdjHHN98GNbJYkLxDosEaXhGJl/+d4vFGkzAj
Mqz1g6JbxERPVqh5tHQ2IgVDsABYgm04HFnIpE6vOUEfivblKXgl+BI9A7K70tLj
xJqJOlEDymg+UsAmifSiQEtS1aaez/zHVGnGI+oTYw0orx0HBUjtCtY4wmn+BJ4o
9qy2jgoDs3oAhwfEBlQXFBIRp6jjSYppfjpsLAh9yLU6syv46Ald1Wn4HOEkNuva
IFJUDLp/NvwWPEjtu+isXAoely/QEWGqfAatBg2nTGpt/7OnyrAQ4Jg3uePwo1GD
IaUHJQ2rISiwJn/5aMXC
=Kp9l
-----END PGP SIGNATURE-----

--=-H2xL3S1i8JXU6Zb77J29--

