Return-Path: <linux-kernel-owner+w=401wt.eu-S1754672AbYA1UKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672AbYA1UKf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 15:10:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751480AbYA1UK2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 15:10:28 -0500
Received: from threatwall.zlynx.org ([199.45.143.218]:33265 "EHLO zlynx.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751196AbYA1UK1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 15:10:27 -0500
Subject: Re: Fwd: show label for swap partition.
From: Zan Lynx <zlynx@acm.org>
To: Jason Price <japrice@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <83f15e30801281158s36b0da3el210f5a97b0348ea3@mail.gmail.com>
References: <83f15e30801281151w21466ef9m82dc50ab09dc390f@mail.gmail.com>
	 <83f15e30801281156od91c2a8p3ec439cb16232386@mail.gmail.com>
	 <83f15e30801281158s36b0da3el210f5a97b0348ea3@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-bdZ8m63I60gkXEKvUwZq"
Date: Mon, 28 Jan 2008 20:10:42 +0000
Message-Id: <1201551042.9135.5.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
X-Envelope-From: zlynx@acm.org
X-Spam-Id: 20080128/1JJaJD-00061c-0w-linux-kernel@vger.kernel.org:zlynx@acm.org:199.45.143.218
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-bdZ8m63I60gkXEKvUwZq
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Mon, 2008-01-28 at 14:58 -0500, Jason Price wrote:
> I apologize if this is the wrong forum.  Please CC me on replies.
>=20
> A admin accidentally deleted the swap line from the fstab file.  We
> mount the swap filesystem via labels.  However, there seems to be no
> way to list the label on an existing swap partition, via the command
> line swap tools (mkswap, swapon/off, etc)
>=20
> Is this blindness on my part, or should there be an analog to e2label
> for swap partitions?

There's this cheesy way to get it:
# dd if=3Dswapfile bs=3D4k count=3D1 | xxd -a
1+0 records in
1+0 records out
4096 bytes (4.1 kB) copied, 6.2589e-05 s, 65.4 MB/s
0000000: 0000 0000 0000 0000 0000 0000 0000 0000  ................
*
0000400: 0100 0000 ffff 0000 0000 0000 f209 fce3  ................
0000410: 7bc9 486d ac86 5d63 af25 3c99 466c 6173  {.Hm..]c.%<.Flas
0000420: 6853 7761 7000 0000 0000 0000 0000 0000  hSwap...........
0000430: 0000 0000 0000 0000 0000 0000 0000 0000  ................
*
0000ff0: 0000 0000 0000 5357 4150 5350 4143 4532  ......SWAPSPACE2

You can see it is marked as SWAPSPACE2.  The label is FlashSwap.  Looks
like it appears at offset 0x41c.
--=20
Zan Lynx <zlynx@acm.org>

--=-bdZ8m63I60gkXEKvUwZq
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQBHnjbCG8fHaOLTWwgRAl0aAJ9LZkVJT+RfNmOlIsAZFy/WnRUpZACghWTz
opfRHLRzzbleP0NIMmg8E8Q=
=mra7
-----END PGP SIGNATURE-----

--=-bdZ8m63I60gkXEKvUwZq--

