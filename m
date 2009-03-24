Return-Path: <linux-kernel-owner+w=401wt.eu-S1760482AbZCXNWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760482AbZCXNWo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 09:22:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759761AbZCXNWc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 09:22:32 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:58426 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757479AbZCXNWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 09:22:31 -0400
Subject: Re: [PATCH v5 09/13] PCI: Introduce /sys/bus/pci/devices/.../remove
From: Johannes Berg <johannes@sipsolutions.net>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Alex Chiang <achiang@hp.com>, Oleg Nesterov <oleg@redhat.com>,
       jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org, kaneshige.kenji@jp.fujitsu.com,
       Lai Jiangshan <laijs@cn.fujitsu.com>
In-Reply-To: <1237893427.24918.174.camel@twins>
References: <20090320204327.12275.43010.stgit@bob.kio>
	 <20090320205636.12275.1825.stgit@bob.kio> <49C74FCC.7070308@jp.fujitsu.com>
	 <20090324032304.GB6175@ldl.fc.hp.com> <20090324092525.GE6605@elte.hu>
	 <20090324034659.9e1f97dc.akpm@linux-foundation.org>
	 <1237893427.24918.174.camel@twins>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-i4dQKk/V9Oj8Tf87nSTZ"
Date: Tue, 24 Mar 2009 14:21:13 +0100
Message-Id: <1237900873.4320.91.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-i4dQKk/V9Oj8Tf87nSTZ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-03-24 at 12:17 +0100, Peter Zijlstra wrote:

> > But I don't think we've seen a coherent description of what's actually
> > _wrong_ with the current code.  flush_cpu_workqueue() has been handling
> > this case for many years with no problems reported as far as I know.
>=20
> Might be sheer luck, but afaik we did have some actual deadlocks due to
> workqueue flushing -- a particular one I can remember was cpu-hotplug vs
> cpufreq.

Two cases are relevant here actually -- the recursion which hasn't ever
shown up before, and a number of possible deadlocks of e.g. some people
doing, effectively:

	rtnl_lock();
	flush_scheduled_work();
	rtnl_unlock();

vs. the linkwatch work that can, at this point in time, still be queued,
and needs the rtnl as well.


A little digging through git logs finds more references, e.g. commits
f90d4118bacef87894621a3e8aba853fa0c89abc and
fd781fa25c9e9c6fd1599df060b05e7c4ad724e5.

Some others were fixed that I remember, but apparently without putting
the lockdep report into the commit log.

johannes

--=-i4dQKk/V9Oj8Tf87nSTZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJyN5EAAoJEKVg1VMiehFYTpYQALt2bAq/+IJUgO54AU4NhvJS
komsNZ30deG4n2CAZjnwTq/Tg7EJKTI1QBPrsY4SnHvdBs/Cfq443iIxnR3KejCM
4Ytuzs9n5cwfWWx8Yedujkkr5YFyC+dCD7s+68KpCjH37k3e4LZuB9Tb/8iuLQhE
jQsXxR0HWvlyi7gN55qbzKaJnV+1buc0O1ah8Xj6xBpvx5gMzu0XwbpnlOadOn7Z
j+veAvGGNuTjCNfhJzLNfG1/quP8ppK1xM2+dayfeF1n8yAN3flVyP2Pt58U8jyo
5A3qY6OAzVa1Q1dpPw2BoFGLtqOqfRqASYdU6uDxJv/ykhL2v5X80kiUeWMq20iW
oYj58XuqRwPw0BfwB16uI18DTQpZX0hvC33TYvMX9hrxKRSJpgyon7o2vBte+Op2
GX4Pf6N4bsWU/YACIJWTl7LV+G6N3nvvbyfhe5v7FMFTWOIziYi0xCukscupah46
U9WV7ZYiYMrU8xLPhRfwKjExqeHE6m8hA+9qTmxUZOClavXaJnA4AzL9OiBxx/Ju
a0PrF0gCzgui++7f7wHcMZ/WxPgpptRl3pUkxqk2Spy1qZYyFnaGqjE7DPLl+MAn
FPvP56C+tA4bFVd5otIrIpKzj9YEyy7xBAigR2lAfRvPKJQS0F1/zNOZqZSuG6XP
LZWGHsbLG6jGW4R7Y4wk
=SzIu
-----END PGP SIGNATURE-----

--=-i4dQKk/V9Oj8Tf87nSTZ--

