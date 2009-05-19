Return-Path: <linux-kernel-owner+w=401wt.eu-S1755247AbZESIwP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247AbZESIwP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 04:52:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751265AbZESIwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 04:52:06 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:57702 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbZESIwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 04:52:06 -0400
Subject: Re: INFO: possible circular locking dependency at
 cleanup_workqueue_thread
From: Johannes Berg <johannes@sipsolutions.net>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20090518194749.GA3501@redhat.com>
References: <c4e36d110905120059i4c155508oa00672da0b33a07a@mail.gmail.com>
	 <20090517071834.GA8507@elte.hu> <1242559101.28127.63.camel@johannes.local>
	 <20090518194749.GA3501@redhat.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-E+brN6AtQyTxeMkrhYUU"
Date: Tue, 19 May 2009 10:51:44 +0200
Message-Id: <1242723104.17164.5.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-E+brN6AtQyTxeMkrhYUU
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-05-18 at 21:47 +0200, Oleg Nesterov wrote:

> > Maybe it shouldn't do that from the CPU_POST_DEAD
> > notifier?
>=20
> Well, in any case we should understand why we have the problem, before
> changing the code. And CPU_POST_DEAD is not special, why should we treat
> it specially and skip lock_map_acquire(wq->lockdep_map) ?

I'm not familiar enough with the code -- but what are we really trying
to do in CPU_POST_DEAD? It seems to me that at that time things must
already be off the CPU, so ...? On the other hand that calls
flush_cpu_workqueue() so it seems it would actually wait for the work to
be executed on some other CPU, within the CPU_POST_DEAD notification?

johannes

--=-E+brN6AtQyTxeMkrhYUU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKEnMdAAoJEODzc/N7+QmaVW0P/0YfH/YGtoreKBgqEFmo6wqW
iamLMiTsc+7C7/AD25yOPubjISV1BVLgJd3qi4moOnLMv7mK8G4ULS2Wz0FkNHgM
i1fIgJbuwNuigvsBSqt0s07XG0W2lqxHfF8YZsAk8AvYeVzWKhIqTNBPpZQD7d0W
Ck8XtKTDDakY/1RDzg2NKlKb288BwanftzbjH4V1PJvZkzxPcVLUOCUrbY68AC5L
9q6gSYk/ZO6znLqtkFT5Yrm+BchNZZk1fxaKpX9DtwVAaGYOAMQ8tieMzeOYXmV5
3n6n+C4TPqyKspyFbRVS+W/OmuhhD4ZlrbnA6TOOyQUxrH5EI4qrnY98z2/j5lOv
Qns331+DMjzfgkPp35xZNoal4oFaIsHIL6slKiotK4Tt3b8d+/CMvkIqJlSy2A4n
Ck8x5oaoM9JhwxhkQViC4GQS616QMhjqa+GtlKMDHDmj+PIgwXoftoPsSo0GMxMI
xnRqzB77Lk8C+AWLgW+O2DCd4xPXXugD2hExeE5je2xomJN3sYjyz9EgDwZk8GyA
WYnnZKaoLmg+dSbCXn38f4wCWPpO7+3fWDnmfznqsHChPH7VFV4g/oVMRU3VHvQO
wls+YkQ1w9nAX0GJeu8x71nAosFXLCb46T0Rgz2ZUPCFTGejaHETMoEThZJjkLDc
2h/cKX6T0ni/OjH57iJf
=7p/P
-----END PGP SIGNATURE-----

--=-E+brN6AtQyTxeMkrhYUU--

