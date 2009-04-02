Return-Path: <linux-kernel-owner+w=401wt.eu-S1753761AbZDBIFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761AbZDBIFg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 04:05:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755539AbZDBIFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 04:05:05 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:40064 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751844AbZDBIEy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 04:04:54 -0400
Subject: Re: Resend: /proc/<pid>/maps offset output broken in 2.6.29
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Chris Friesen <cfriesen@nortel.com>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>, peterz@infradead.org
In-Reply-To: <49D3F662.4050100@nortel.com>
References: <49CA8501.1000000@nortel.com>  <49D3F662.4050100@nortel.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-I+icw2neIXGY79VojC/v"
Date: Thu, 02 Apr 2009 19:04:51 +1100
Message-Id: <1238659491.9041.133.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-I+icw2neIXGY79VojC/v
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-04-01 at 17:18 -0600, Chris Friesen wrote:
> Resending due to lack of response to original post.

Hi Chris,

You'll probably get a more useful response on lkml. You CC'ed
linux-kernel-owner originally :)

> I was validating some code dealing with /proc/<pid>/maps on 2.6.29 and=20
> was surprised when it failed.  It turns out that at least on my ppc64 G5=20
> machine the offset value for the last entry is strange--it shows up as a=20
> 64-bit value even though the process itself is only 32-bit.
>=20
> This behaviour also shows up in 2.6.25, but doesn't in 2.6.14.  I=20
> haven't yet tested anything else in between.
>=20
> [cfriesen@localhost cfriesen]$ cat /proc/self/maps
> 00100000-00103000 r-xp 00100000 00:00 0         [vdso]
> 0fe70000-0ffbf000 r-xp 00000000 08:03 4312393   /lib/tls/libc-2.3.3.so
> 0ffbf000-0ffc0000 ---p 0014f000 08:03 4312393   /lib/tls/libc-2.3.3.so
> 0ffc0000-0ffc2000 r--p 00150000 08:03 4312393   /lib/tls/libc-2.3.3.so
> 0ffc2000-0ffc6000 rwxp 00152000 08:03 4312393   /lib/tls/libc-2.3.3.so
> 0ffc6000-0ffc8000 rwxp 0ffc6000 00:00 0
> 0ffd0000-0ffec000 r-xp 00000000 08:03 4309011   /lib/ld-2.3.3.so
> 0fff0000-0fff1000 r--p 00020000 08:03 4309011   /lib/ld-2.3.3.so
> 0fff1000-0fff2000 rwxp 00021000 08:03 4309011   /lib/ld-2.3.3.so
> 10000000-10004000 r-xp 00000000 08:03 917536    /bin/cat
> 10013000-10015000 rwxp 00003000 08:03 917536    /bin/cat
> 10015000-10036000 rwxp 10015000 00:00 0         [heap]
> f7deb000-f7feb000 r--p 00000000 08:03 2560322=20
> /usr/lib/locale/locale-archive
> f7feb000-f7fec000 rw-p f7feb000 00:00 0
> ffe6d000-ffe82000 rw-p ffffffeb000 00:00 0      [stack]
>=20
> I'm at a loss to explain what's going on here.  Anyone got any ideas?

It looks like for vmas that don't have a vm_file (like the stack),
vm_pgoff is basically "internal use" - and so can be > 32 bit.

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-I+icw2neIXGY79VojC/v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAknUcaMACgkQdSjSd0sB4dJJYQCgrRkkIns+Z9ItdYousO0ZelHL
Sa0An0F3llkZt02vP5ebaDfzWctATmzX
=gyl+
-----END PGP SIGNATURE-----

--=-I+icw2neIXGY79VojC/v--

