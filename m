Return-Path: <linux-kernel-owner+w=401wt.eu-S1757819AbYFYPB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757819AbYFYPB7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 11:01:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752112AbYFYPBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 11:01:51 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:48089 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752201AbYFYPBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 11:01:51 -0400
Subject: Re: [PATCH 4/5 v2] x86 boot: show pfn addresses in hex not decimal
	in some kernel info printks
From: Johannes Berg <johannes@sipsolutions.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul Jackson <pj@sgi.com>, hpa@zytor.com, yhlu.kernel@gmail.com,
       akpm@linux-foundation.org, mingo@elte.hu, tglx@linutronix.de,
       steiner@sgi.com, travis@sgi.com, linux-kernel@vger.kernel.org,
       ying.huang@intel.com, andi@firstfloor.org
In-Reply-To: <alpine.LFD.1.10.0806242101460.20369@hp.linux-foundation.org>
References: <20080622142151.5591.4139.sendpatchset@polaris-admin.engr.sgi.com>
	 <20080622142212.5591.64592.sendpatchset@polaris-admin.engr.sgi.com>
	 <86802c440806221238g78300952t2fc7f406c1842273@mail.gmail.com>
	 <20080623060939.6b6b3183.pj@sgi.com>
	 <86802c440806241429s  <alpine.LFD.1.10.0806242101460.20369@hp.linux-foundation.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-AmQdVXDFuzLGnlcU3mX7"
Date: Wed, 25 Jun 2008 17:00:26 +0200
Message-Id: <1214406026.21847.25.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-AmQdVXDFuzLGnlcU3mX7
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-06-24 at 21:04 -0700, Linus Torvalds wrote:

> It's really irritating how we cannot extend on the printk strings without=
=20
> either having to throw out gcc warnings altogether. gcc has no extension=20
> mechanism to the built-in rules ;/
>=20
> The format warnings are too useful to drop entirely. I guess sparse could=
=20
> be taught to do them, and then we could drop the gcc support for them. Bu=
t=20
> that would still limit coverage a _lot_.

We should probably start working on getting this fixed.

In networking, we've gone through various incarnations of print_mac()
which is similar to the sym() macro Paul proposed, and it turned out to
be undesirable because of the way it interacts with static inlines that
only optionally contain code at all, the print_mac() function call is
still emitted by the compiler. People experimented with marking it
__pure but that had other problems.

It would be nice to be able to say

u8 *eaddr;

printk(... %M ..., eaddr);

and get
03:45:67:89:ab:cd

out of it, which avoids both the large string/code you get when doing it
manually (printf("%2.x:...:%.2x", eaddr[0], ...) for which there are
macros) and the "function call in hotpath even when debugging is
disabled" problem I mentioned above.

johannes

--=-AmQdVXDFuzLGnlcU3mX7
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIYl2GAAoJEKVg1VMiehFYPwoP+QG7Sbi/PV0STxK/DZI4LqEA
zSMg7T5yt3f+QeUupeCgL1kKumCEulNJClDSWFLXtSSPBidHxWZtkw40zfUVQWlX
LLcC18s2Dq9Eyr49fXShvplUrN+4TjMR88vktbxZMkR1AQL6ncR5V6RNjyUko9pe
7gB8m/DCeAxSfoQfjL8mKBeHsxaTkVJQMAuFHCbYvv65wYv6aVjM5t8u1eWvMo2W
0hlGXz1tH8U9L5xszYWM1CzOTVxrejt0O9dFlRRccxuLbCPKgXlSt7adSioTbR0w
YqdZfLx5Fw/bkNQZijWHL/getF9Hro/8wYDgYurG82ECXLYHC+02+hJz3Pm5UIzC
TRxNfNm2qQtiib3d5QSiLcLOn6ZujfUYdhRdtWAB4vd6SVXHO5ODrap5c21ENGZu
XoDAyFzV2OZpAwe2Lx4Zd+3l+MUxmUxeiCY7qdKM8/WFQ0AKy9Bwbiwh8lPQM0cD
SCwkOUzto/0InzbduI6zidUnv5NLcoGHr8x8UgnMkySLDR6JOSb9dTb7P5i4Uva5
9ZHQ6TZ42geJAy6KGhoqfHgL8+TsTrRBoXq4RnOUTmXKF+OIXZkdVJ5JgiQIWuU5
Sw1UHH4/vDQheKZw+yCqVWXRDB6cJTFkSNiVlcbQ9nBvS5hbMtGvjMp78Lfyn+Y9
XxFrY95i5+GabQt49kbZ
=AiM/
-----END PGP SIGNATURE-----

--=-AmQdVXDFuzLGnlcU3mX7--

