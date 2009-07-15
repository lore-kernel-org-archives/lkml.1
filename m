Return-Path: <linux-kernel-owner+w=401wt.eu-S1753820AbZGOJtP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820AbZGOJtP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 05:49:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753775AbZGOJtO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 05:49:14 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:40388 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753708AbZGOJtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 05:49:14 -0400
Subject: Re: event tracing, ringbuffer and RB_MAX_SMALL_DATA
From: Johannes Berg <johannes@sipsolutions.net>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <4A5D2BF6.6010802@cn.fujitsu.com>
References: <1247591891.7178.20.camel@johannes.local>
	 <4A5D2BF6.6010802@cn.fujitsu.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Mp7M2S11r7HSMM9Tx7oQ"
Date: Wed, 15 Jul 2009 11:48:25 +0200
Message-Id: <1247651305.14973.3.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Mp7M2S11r7HSMM9Tx7oQ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-07-15 at 09:08 +0800, Li Zefan wrote:

> Right, the length of a dynamic array is not recorded, and this
> causes 2 problems:
>=20
> - the event filter is not working properly for dynamic strings
> - userspace parsers can't figure out the length of those arrays
>=20
> I had an idea some time ago, and hopefully will send out a
> patch today or tomorrow.=20

Well except for the corner case I pointed out, you can determine the
length of dynamic arrays by either
 - the next dynamic array's offset or
 - the length of the item.

So, afaict, the simplest solution would be to not embed the length of
the item in type_len if it's not divisible by four and contains dynamic
members, though the latter condition might be hard to check.

johannes

--=-Mp7M2S11r7HSMM9Tx7oQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKXaXlAAoJEODzc/N7+QmaZIgP/3vKMBalUH0Z+KtBfMmcA2aB
vpX0TnUtP5Y/dHMUMJbTmU+qlhF56WJ1noSJR6yfy7gUa7VXHiLTekGfviLDcLd2
1d1cSpBuayDTthqyw/79VIcfGqZvi/U7SsiPf/ffFQnnsA3W7XJmrEMstYGOtegt
T/1KFvyt6OXwpTMd2M6duulAY8wDmE//KpP6/XatiLl4jQbb5L3H45MNC1bU9rUd
qMkYmQPbCx/DYSplybIlyaRZ0nnqxWPS0YZXL7DAmPGSy3yY0Ah61QgcaOeP5L9K
9j+VN7q2CCDHemmyfBtlFlG8ANddlwtsHugwrygAgsxcg3iap6FjAkomNCwDES2q
FbQMuT3jo/7hYg+vhitTVll0WePPkMprhcJqOD4gZxi7oGNTITMqFdv8dc8rut91
PR+7RxsSk077+V9gHNMWwdZNnGExsiFs7gLS4V4ntrT5hq/e74NQMx5ThpKlZYmu
TVoPukPz/LDG5WNEdAoP6EYnGYvJEfJK1wTe0QZgSuZmza/Hjj92b4zbYzwYz0vA
7jIBQtomdQGihwkRqJVNqk+rIhLVfE/LDBLUQUKSkd7GMoxJMXdrIi1ZYY+lG0Es
5u+wMu2P9v/bEh0orCqv2cJuZ+BvUL3IG0SFPoCCkrOQXkuS2yRp1RqdAH5uap0K
LN+9AYWRpEN/9kklBZxb
=WY3m
-----END PGP SIGNATURE-----

--=-Mp7M2S11r7HSMM9Tx7oQ--

