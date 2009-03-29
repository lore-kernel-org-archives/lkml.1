Return-Path: <linux-kernel-owner+w=401wt.eu-S1756989AbZC2NBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756989AbZC2NBi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 09:01:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755446AbZC2NBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 09:01:25 -0400
Received: from setoy.chost.de ([217.160.209.225]:38561 "EHLO smtp.chost.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754569AbZC2NBY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 09:01:24 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Sun, 29 Mar 2009 09:01:24 EDT
Date: Sun, 29 Mar 2009 14:54:39 +0200
From: Sascha Silbe <sascha-ccparty-c74088b0@silbe.org>
To: linux-kernel@vger.kernel.org
Subject: Flushing the (page?) cache for a block device
Message-ID: <20090329125439.GB4697@twin.sascha.silbe.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hQiwHBbRI9kgIhsi"
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hQiwHBbRI9kgIhsi
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello!

I'd like to do a verification step after writing to a USB stick (block=20
device level, no filesystem involved). For this to work as intended, I=20
need to ensure the reads are not satisfied from blocks still in cache,=20
i.e.: flush "the cache" (page cache IIUC) for the block device in=20
question (and _only_ this device).
Some research resulted in the following options:

1. Open the target file using O_DIRECT while writing.
      Doesn't feel like the right thing to do; only want to flush the=20
cache, not circumvent it. Might severly limit performance as writes are=20
synchronous.
      Interface isn't very nice (need to ensure alignment to page size=20
in memory).

2. Use posix_fadvise() with POSIX_FADV_DONTNEED.
      Probably works with the current kernel (haven't tested yet), but=20
there's absolutely no guarantee.
      Interface much better than O_DIRECT.

3. Flush the entire page cache using procfs.
      Brute force, last resort. Will severly impact performance of my=20
tool (as it's going to write to several devices in parallel).


Is there a better method I've not found yet? Nr. 2 sounds like the way=20
to go, but I don't like that it could (silently!) stop working with any=20
new kernel version.


PS: Not subscribed, so please CC me.

CU Sascha

--=20
http://sascha.silbe.org/
http://www.infra-silbe.de/

--hQiwHBbRI9kgIhsi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iQEcBAEBAgAGBQJJz2+LAAoJELpz82VMF3DailYIAJvM98hvHBwnBMoQYwbZoWUt
spHqpubRUwqrRS8kf1xHX2XQXT3h4ua15ljXB95ZjLxAtVFD91Tyq44OTPPQqP0Y
/HyhxwwKQFuoPmnjXrDUUHcs0eRxScZrzIBDvfKgIiqTmIUMbKN0a1srnwAY2jkO
DlLtzZPUF1jd1XqwtSqUWwdro9o2VSdSNdiZUyAK2xAJTETy2x8MzqiUnrL2EGze
2qIXEriNeBfWs9G8Y9F944V0w9VxHqky/962sdo82aBgtNlR2NeD46otHIkr3M7S
Hh1apySaPCnMVbzMe9wsoPwihMKHAhHsGER3E+OzBLplAEYUiL26ezaQAThk0ek=
=JUAB
-----END PGP SIGNATURE-----

--hQiwHBbRI9kgIhsi--
