Return-Path: <linux-kernel-owner+w=401wt.eu-S1755881AbYDHQJb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755881AbYDHQJb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 12:09:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752512AbYDHQJW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 12:09:22 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:57394 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434AbYDHQJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 12:09:22 -0400
Subject: Re: Using sparse to catch invalid RCU dereferences?
From: Johannes Berg <johannes@sipsolutions.net>
To: paulmck@linux.vnet.ibm.com
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-sparse <linux-sparse@vger.kernel.org>
In-Reply-To: <20080408155259.GA8381@linux.vnet.ibm.com>
References: <1207605856.12481.35.camel@johannes.berg>
	 <20080408155259.GA8381@linux.vnet.ibm.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-68mHHPRgfvVX9k6pfAa6"
Date: Tue, 08 Apr 2008 18:09:15 +0200
Message-Id: <1207670955.5550.15.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-68mHHPRgfvVX9k6pfAa6
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> So the address_space attribute says what the pointer points to rather
> than where the pointer resides, correct?

Yeah. It's currently used for __user and __iomem. Using it for rcu
wouldn't be quite the way it was intended, I think, but hey :)

> It might be.  There are a number of places where it is legal to access
> RCU-protected pointers directly, and all of these would need to be
> changed.  For example, in the example above, one could do:
>=20
> 	foo =3D NULL;

Yeah, all of those would lead to sparse warnings. Are we willing to
change all that code?

> I recently tried to modify rcu_assign_pointer() to issue the memory
> memory barrier only when the pointer was non-NULL, but this ended badly.
> Probably because I am not the greatest gcc expert around...  We ended
> up having to define an rcu_assign_index() to handle the possibility of
> assigning a zero-value array index, but my attempts to do type-checking
> backfired, and I eventually gave it up.  Again, someone a bit more clued
> in to gcc than I am could probably pull it off.

I don't think I would be that person :)

> In addition, it is legal to omit rcu_dereference() and rcu_assign_pointer=
()
> when holding the update-side lock.

Right. Those too would lead to problems, unless we change that code to
use those (or other) macros.

> So I very much like this approach in general, but it will require some
> care to implement.  I would be very happy to review and comment!!!

I'll play with it a bit if I get around, was just reviewing some RCU
usage and had the feeling that it should be possible to automate.

johannes

--=-68mHHPRgfvVX9k6pfAa6
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR/uYqqVg1VMiehFYAQKJIQ/+K4yei2vr3DtJpwjO+zSLA+QyDPzFGq8J
FbYwZh9O7Bnq00Zst6RhZZSeP8Tj4HDnQEFIgxDJ1jM7oKveGaRRqW9siq69NDuW
2EVnJfJvwcJH/D957CqwskATjMgkFhPnDzHiTEsbua3Jwsehm0pyFZhOhxMpqODb
ZwAKGbNJRPU6ez/3UOwDj2XkidWQcJgie2FWhIN7w8J6ZpO48dfy6GiBP3q13vkQ
hukw+jGIoOqkxkAYXvSmRoTVhwioZB+khUdck1ZbjOqjy2eeVAfmtXJTreBRp0aW
IVdUXFP6gH2QipubNdeXYGd42NbJqdIC6hMhnmwbmdTXQRLxoKg9Uf2KFttZnUrw
tgd2psj4WTYgOlI8XtQlDnGmfDNfapqNqMOeIZwT/adIV/PbqggSy+tn9UL3BJf4
MF/0pAKsifte3XuFbuSymd4GsIumsbY+neIHNwvcjYUfJupZbwXqFrnIE3ikr8P+
EYcOFje1Ec7cEIdK78xZRVUb4QvdXQoAhgID203NLlfmLC9q305ZEZJZSm4rUaSK
XuBzSv9h8u0QGq4eVp2+WPAMgedGW8tM5VTkgf0NIlTjq2eQm6aJ3hR8UizwthuX
cdoezNYE3jDvSBzeKibHkPcN7k3o9ahRD5e3yCedtKXbrY5HHpf/7AsYCLbKLThO
GPz3j7USBqY=
=BhbU
-----END PGP SIGNATURE-----

--=-68mHHPRgfvVX9k6pfAa6--

