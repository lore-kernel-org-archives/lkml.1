Return-Path: <linux-kernel-owner+w=401wt.eu-S1755499AbZBIVWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499AbZBIVWY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 16:22:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753961AbZBIVWO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 16:22:14 -0500
Received: from xc.sipsolutions.net ([83.246.72.84]:50646 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306AbZBIVWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 16:22:14 -0500
Subject: Re: 2.6.29-rc4-git1 -- iwl3945: Can not allocate SKB buffers
From: Johannes Berg <johannes@sipsolutions.net>
To: Miles Lane <miles.lane@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zhu Yi <yi.zhu@intel.com>, Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <a44ae5cd0902091312t50f31689xe3bc56a25a0ff502@mail.gmail.com> (sfid-20090209_221302_952960_F4B2EC25)
References: <a44ae5cd0902091312t50f31689xe3bc56a25a0ff502@mail.gmail.com>
	 (sfid-20090209_221302_952960_F4B2EC25)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-azSI+Xosc+Rx37UT3/IR"
Date: Mon, 09 Feb 2009 22:21:40 +0100
Message-Id: <1234214500.4175.255.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-azSI+Xosc+Rx37UT3/IR
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-02-09 at 16:12 -0500, Miles Lane wrote:
> [12506.627936] iwl3945: Can not allocate SKB buffers

So iwl3945 prints out that it's out of memory, but probably uses
__GFP_NOWARN.

> [12544.530789] java: page allocation failure. order:1, mode:0x4020
> [12544.530798] Pid: 21292, comm: java Not tainted 2.6.29-rc4-git1 #2
> [12544.530801] Call Trace:
> [12544.530812]  [<ffffffff8028f12d>] __alloc_pages_internal+0x423/0x442
> [12544.530820]  [<ffffffff804cbb4f>] ? pskb_expand_head+0x52/0x16f
> [12544.530826]  [<ffffffff802b13df>] alloc_slab_page+0x20/0x26
> [12544.530830]  [<ffffffff802b1624>] __slab_alloc+0x23f/0x527
> [12544.530835]  [<ffffffff804cbb4f>] ? pskb_expand_head+0x52/0x16f
> [12544.530839]  [<ffffffff804cbb4f>] ? pskb_expand_head+0x52/0x16f
> [12544.530844]  [<ffffffff802b23db>] __kmalloc+0xbc/0x102
> [12544.530848]  [<ffffffff804cbb4f>] pskb_expand_head+0x52/0x16f
> [12544.530854]  [<ffffffff805a0c8b>] ieee80211_skb_resize+0x91/0xca
> [12544.530858]  [<ffffffff805a16fd>] ieee80211_master_start_xmit+0x260/0x=
4c3

and here we have pskb_expand_head failing to allocate memory. And an
order 1 allocation too. Are you saying wireless has a memory leak?

johannes

--=-azSI+Xosc+Rx37UT3/IR
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJkJ5hAAoJEKVg1VMiehFYsZYP/0LJJSuaekvPzT1eIVlc2n+V
ZebSRZXGz5OYJGVpuX+EW0vi0+V+KTSCZTAHQSAoIK1N3SbYnSU4zIo/SX1TFte7
K06dyDMrGSizvCztPaIuA9mPsH/V+SLjGRAfywzOf1hWxIcVfnerXyGcph9gSTT/
OrdBloBfmwzYTnnWjDn7eNMy6lJfBkyBrT0TIVOio8FOhMD4a8iWvc/r9Xf3nnb/
oHjQ/txNM8aIc0mBrnKyviOQKhxnR7LsI/0vDoO3qM127pB6wQT+5QcKHRpN3gfl
Z4toMc0ZhFa3vn0BGrS6G04Wm1oDBpqr83v1FuGkM4VcHGTMXnO9mjVitrNS5GYN
p+J5Z2kn6YN1zLuUYwK1HlYnyRlTDConOmdg898VhMqK6p3Iougbk1/ekTeT6FRP
KHIulitbzUYDBRj+4UC3emfVGJgCfW5mq50jPvfvuErPEhYP+CWBGSHCEVxhvMXB
XZbh0xDeYEj0bT/i9aonyUwIIUFC/Zc6yELqW3GYtVCZD2d8u8GCKsbO1BHQXOzD
tMTixGyIIjsZFBF56s08gVVrf/fxNm17QdDlogF/bZeI1KJyRKR3Y8S/H4e2K6bL
kQy5RejQWLMnRIf/VmlERyr6GNO7zNscXuG4zUUSG3kMnnAapjkbk6/uz+RQ+e22
nNEiLdeX5zpYGiM6blz7
=qYuk
-----END PGP SIGNATURE-----

--=-azSI+Xosc+Rx37UT3/IR--

