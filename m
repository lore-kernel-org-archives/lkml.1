Return-Path: <linux-kernel-owner+w=401wt.eu-S932197AbXHOQaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932197AbXHOQaV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 12:30:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759555AbXHOQ37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 12:29:59 -0400
Received: from server021.webpack.hosteurope.de ([80.237.130.29]:55203 "EHLO
	server021.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755173AbXHOQ36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 12:29:58 -0400
From: Michael Gerdau <mgd@technosis.de>
Organization: Technosis GmbH
To: Ingo Molnar <mingo@elte.hu>
Subject: 2.6.22.2-cfs-v19.1 stops honouring nice 3 after some hours
Date: Wed, 15 Aug 2007 18:23:17 +0200
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart8932468.1pL4kbxbVv";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200708151823.17623.mgd@technosis.de>
X-bounce-key: webpack.hosteurope.de;mgd@technosis.de;1187195398;35a0c781;
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart8932468.1pL4kbxbVv
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi Ingo,

I played a bit with renicing my (mostly) CPU bound jobs and found
somewhat strange behaviour.

I'm on 2.6.22.2-cfs-v19.1 -- I can't boot into 2.6.23-rc3 as part of
my daily work because my NVIDIA driver doesn't yet work with it though
I could try to do some X-less testing if need be.

I'm running 4 CPU bound jobs, 2 of which are more important to me.
I therefor reniced the other 2 to level 3 and the CPU percentages
were roughly 66/66/33/33 on my Dualcore system. So far all fine.

Some 6 hours later I rechecked with top -d 60 and got the output below:

19629 mgd       20   0  334m 263m 2700 R   49  8.1  69:16.45 perl
29668 mgd       20   0  396m 262m 2700 R   49  8.0 112:17.21 perl
 6933 mgd       23   3 96576  21m 3672 R   47  0.7  46:38.83 perl
14162 mgd       23   3  165m  28m 3672 R   47  0.9 194:55.31 perl

I reniced to 0:

19629 mgd       20   0  334m 263m 2700 R   48  8.1  71:02.86 perl
 6933 mgd       20   0 96652  21m 3672 R   48  0.7  48:23.41 perl
14162 mgd       20   0  165m  28m 3676 R   48  0.9 196:39.81 perl
29668 mgd       20   0  396m 262m 2700 R   48  8.0 114:03.56 perl

=2E..and back to 3 with no noticeable change.

[at this point job 14162 finished and was replaced by an similar
job 22558]

I then decided to do some statistics and reniced to 1:

29668 mgd       20   0  396m 262m 2700 R   48  8.0 115:24.12 perl
19629 mgd       20   0  334m 263m 2700 R   48  8.1  72:23.36 perl
22558 mgd       21   1 92184  17m 3672 R   48  0.5   0:56.81 perl
 6933 mgd       21   1 96576  21m 3672 R   48  0.7  49:54.12 perl

Now I reniced to 2 and without knowing why, the ratios seem to be back
to where I want them.

29668 mgd       20   0  396m 262m 2700 R   59  8.0 116:33.98 perl
19629 mgd       20   0  334m 264m 2700 R   58  8.1  73:31.49 perl
22558 mgd       22   2 92220  17m 3672 R   37  0.5   1:46.99 perl
 6933 mgd       22   2 96688  21m 3672 R   36  0.7  50:44.77 perl

Renicing to 3 again gives me what I want:

29668 mgd       20   0  397m 262m 2700 R   65  8.0 117:25.93 perl
19629 mgd       20   0  334m 264m 2700 R   63  8.1  74:21.84 perl
22558 mgd       23   3 92220  17m 3672 R   32  0.5   2:13.83 perl
 6933 mgd       23   3 96652  21m 3672 R   32  0.7  51:11.24 perl


I don't know why I had the very first output above though.

Best,
Michael
=2D-=20
 Technosis GmbH, Gesch=C3=A4ftsf=C3=BChrer: Heiko Gerdau, Tobias Dittmar
 Sitz Hamburg; HRB 89145 Amtsgericht Hamburg
 Vote against SPAM - see http://www.politik-digital.de/spam/
 Michael Gerdau       email: mgd@technosis.de
 GPG-keys available on request or at public keyserver

--nextPart8932468.1pL4kbxbVv
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGwyh1UYYhyuxDQc4RAsU8AKCpDByVNKs877t14cXbl02DDGrvggCeO538
1TEgMC0ZI+9O1qI1+QeBjGQ=
=emGW
-----END PGP SIGNATURE-----

--nextPart8932468.1pL4kbxbVv--
