Return-Path: <linux-kernel-owner+w=401wt.eu-S1752408AbYDDVU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752408AbYDDVU0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 17:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751188AbYDDVUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 17:20:17 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:38700 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbYDDVUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 17:20:16 -0400
Subject: Re: debugfs_remove() vs. anything that is dynamic
From: Johannes Berg <johannes@sipsolutions.net>
To: Greg KH <greg@kroah.com>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <1207342644.3625.4.camel@johannes.berg>
References: <1207266986.19189.14.camel@johannes.berg>
	 <20080404153402.GB16923@kroah.com>
	 <1207323684.19189.54.camel@johannes.berg>
	 <20080404202006.GB14016@kroah.com>  <1207342644.3625.4.camel@johannes.berg>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-4d20rFFssmgYnHRNMc9q"
Date: Fri, 04 Apr 2008 23:20:12 +0200
Message-Id: <1207344012.3625.7.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-4d20rFFssmgYnHRNMc9q
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> I think, however, it's not correct when you have a hard-link, and the
> NULLing out of i_private must be done depending on (inode->i_nlink =3D=3D=
 1)
> instead of unconditionally. I will have to test that once I figure out
> if (and if yes, how) you can even create inodes with nlink>1 with simple
> attributes.
>=20
> --- everything.orig/fs/libfs.c	2008-04-04 22:37:18.000000000 +0200
> +++ everything/fs/libfs.c	2008-04-04 22:37:37.000000000 +0200
> @@ -287,6 +287,7 @@ int simple_unlink(struct inode *dir, str
>  {
>  	struct inode *inode =3D dentry->d_inode;
> =20
> +	inode->i_private =3D NULL;

Hm, no, this is likely to conflict with other users of simple_unlink
that use i_private afterwards and don't expect it to have been NULL'ed
out. I haven't found a solution yet.

johannes

--=-4d20rFFssmgYnHRNMc9q
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR/abi6Vg1VMiehFYAQJHQxAAoKfUIc6+WHOqYsyE7VwiY5gnoldVGx8V
NaOhfnePl+vToIsUtBLQ/5EaqHyDyI18ATalf4eHXOpWqJm6lDuHjilLn7Tpf1AE
t2vT95hy5Gwr1a4mz9PCECBF46lYAiKtaTTEYXnM7GYNiZ4rQyoZ3KY7bamISH8l
k07lgbCBjGF4nbfJiKkW0cP0lTdaZrJQnM282rHTTre/GYeJyFAOV8MeJtSSDZWx
hFVv6wHTSh6pIFXvNdTmiGWrMiMiNhPc0lVe5usUFFSrXsw9TJ8rI+8l3UpR9Bct
kKULUm1YHHmhb8xZ9SiFLtuYFeIqpM8LxxqYYbNqCuCBzwdxpW5X5OcPo0HeXpYP
BP77MS4zljAMqPOQK72WLOh1ixzh+BEt58na/ssaGNnxkFZII/E2z48Yk33MMsUb
ahpdWa0O6xyOqzcW4tQeV14SpSDBjKlUzQtJryQo9EqeGKdbevQgZ70+r5enD9uL
fp0UqqArlvjnhdEZMchoZhCLRA8W8OPYV8zvn5W3tqXQAKOnGauUpNFiDiKBqOZm
I3bgHaP1hwtg/S8hCaXotjzev1jw6G4cZ5tk0tojvebD//Ui0ZppO8Gwr9vVJJIl
p/f4GIEba7bVqMXTYlqLDZe3DXOEGlhh+KU2NK135Wepq6FeLZ8i8n3zSBmFqA1H
kwtCgc+6tPc=
=Xrya
-----END PGP SIGNATURE-----

--=-4d20rFFssmgYnHRNMc9q--

