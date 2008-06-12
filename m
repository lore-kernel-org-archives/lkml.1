Return-Path: <linux-kernel-owner+w=401wt.eu-S1760189AbYFLOU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760189AbYFLOU5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 10:20:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753938AbYFLOUs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 10:20:48 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:55400 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753545AbYFLOUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 10:20:47 -0400
Subject: Re: Problem: Out of memory after 2days with 2GB RAM
From: Johannes Berg <johannes@sipsolutions.net>
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Cc: Rik van Riel <riel@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       yi.zhu@intel.com, reinette.chatre@intel.com,
       linux-wireless@vger.kernel.org
In-Reply-To: <c4e36d110806120712h1237d084v2eaeb494cc48b43c@mail.gmail.com> (sfid-20080612_161221_904883_AD0B167C)
References: <c4e36d110806120307n20cce692s9c136f11596f5ab0@mail.gmail.com>
	 <20080612093833.0fb9cdd6@bree.surriel.com>
	 <1213278884.3936.15.camel@johannes.berg>
	 <c4e36d110806120712h1237d084v2eaeb494cc48b43c@mail.gmail.com>
	 (sfid-20080612_161221_904883_AD0B167C)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-w0UlgTSYEeVV4fq0wqp8"
Date: Thu, 12 Jun 2008 16:19:50 +0200
Message-Id: <1213280390.3936.21.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-w0UlgTSYEeVV4fq0wqp8
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> >> It looks like this is because it wants to allocate 2**5 contiguous
> >> pages, which is 128kB of contiguous kernel memory.
> >
> > 64-bit system I assume?
> > The allocation should be 256 * 20 * sizeof(struct sk_buff *).
> >
> > Try the patch below. It should improve code generation too.
>=20
> I'll surely try you patch - but is the iwl the only driver which needs
> 128kB continuous memory chunk?

I don't know. But I think it'll probably fail right after, trying to
allocate a 32kb buffer with pci_alloc_something....

johannes

--=-w0UlgTSYEeVV4fq0wqp8
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIUTCDAAoJEKVg1VMiehFY0/IP/A1YJ/2bqsRu4ceVNYqO5vKk
dy0n1WeCtRTaysoes1/TzVR9292vza0ayIgbR6DQlhbcOFJ15IBUvrLa1hSJ1TfG
gDJxQGFYDF5Foj6hRlLtBd1wpS4GpVmEdjmHPYSZ77D7LmhAnuSULe8nwFjZIieT
0jKZAlxz3ClVuUgRPutvZYDWxsCHGI2yhKW0nkpW5BglPzzkb3VhSP9qacy4CgMA
UPTmZ5BE9wUIsUKU5dmEwUJ/KoX4tlFphghvqUQ7YXtA19uiYfBh4ypXcwebkMFi
3BOWuB3/bkM78r/WU/cBfJAnivF/owar0q2keNklgfwANst96BcNE3ILmDafFYJH
yICbSfDVzisTlV/hC9Bp5ormkDzWgILIJvD+AI55e3B7Zwq28LyQx5p0U2pWVpJs
R9KuPeMgdrlNlaIWIr21l18zoR6+YgTTsLkNrlPb0qWANCAz4wXLf2qJbHiOzm8x
XHwjSTZAO//8U27Jv92rQ95qqM1ro6vMd4RvU4k5I0d9JL9N7/mUmds5x43+OkEh
l/UcqRY+5gVM4gsUY2UKC53a2S/3v38gd9y3u1l4R9PRETzstkaXyn872wLyn6TW
RaWp9qSSIJwGVkczqDSbpwAR0OjbrIJ5h2f4p52H0V7PTvPVQbV/NmTd7Gtqn3gy
gai9zSbpacOfJnRnrKDa
=h2sy
-----END PGP SIGNATURE-----

--=-w0UlgTSYEeVV4fq0wqp8--

