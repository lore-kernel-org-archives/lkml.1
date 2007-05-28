Return-Path: <linux-kernel-owner+w=401wt.eu-S1757747AbXE1OKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757747AbXE1OKs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 10:10:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753071AbXE1OKi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 10:10:38 -0400
Received: from daemonizer.de ([87.230.16.230]:33682 "EHLO daemonizer.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750779AbXE1OKf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 10:10:35 -0400
From: Maximilian Engelhardt <maxi@daemonizer.de>
To: Michael Buesch <mb@bu3sch.de>
Subject: Re: b44: regression in 2.6.22 (resend)
Date: Mon, 28 May 2007 16:09:46 +0200
User-Agent: KMail/1.9.7
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
       "linux-wireless" <linux-wireless@vger.kernel.org>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Jeff Garzik <jgarzik@pobox.com>, Gary Zambrano <zambrano@broadcom.com>,
       netdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <20070525172431.60affaca@freepuppy> <200705280240.17910.maxi@daemonizer.de> <200705281216.51690.mb@bu3sch.de>
In-Reply-To: <200705281216.51690.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2680567.p56DHj8tbN";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200705281609.49859.maxi@daemonizer.de>
X-Spam-Score: -4.1 (----)
X-Spam-Report: No, hits=-4.1 required=5.0 tests=ALL_TRUSTED,AWL,BAYES_00 autolearn=ham version=3.1.7-deb 
	* -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	*  0.3 AWL AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2680567.p56DHj8tbN
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 28 May 2007, Michael Buesch wrote:
> Can you give 2.6.16 a try? The diff is not that big and we might
> be able to find out what broke if you find out 2.6.16 works.
> You can also try later kernels like .17, .18, .19 to further
> reduce the patch. (You could also git-bisect, if you have the time).
>
I did some testing and compiled some kernels and here are the results:

I was able to find out what causes the problems for me.  I did build two=20
2.6.21.3 kernels, and one does work fine and the other doesn't.

This is a diff of the kernel configs I used:

=2D-- /usr/src/linux-2.6.21.3-oldconfig1/.config  2007-05-28 13:41:15.00000=
0000=20
+0200
+++ /usr/src/linux-2.6.21.3/.config     2007-05-28 14:46:08.000000000 +0200
@@ -1,7 +1,7 @@
 #
 # Automatically generated make config: don't edit
 # Linux kernel version: 2.6.21.3
=2D# Mon May 28 13:41:15 2007
+# Mon May 28 14:46:09 2007
 #
 CONFIG_X86_32=3Dy
 CONFIG_GENERIC_TIME=3Dy
@@ -32,7 +32,7 @@
 #
 # General setup
 #
=2DCONFIG_LOCALVERSION=3D"-oldconfig1"
+CONFIG_LOCALVERSION=3D""
 CONFIG_LOCALVERSION_AUTO=3Dy
 CONFIG_SWAP=3Dy
 CONFIG_SYSVIPC=3Dy
@@ -108,9 +108,9 @@
 #
 # Processor type and features
 #
=2D# CONFIG_TICK_ONESHOT is not set
+CONFIG_TICK_ONESHOT=3Dy
 # CONFIG_NO_HZ is not set
=2D# CONFIG_HIGH_RES_TIMERS is not set
+CONFIG_HIGH_RES_TIMERS=3Dy
 # CONFIG_SMP is not set
 CONFIG_X86_PC=3Dy
 # CONFIG_X86_ELAN is not set

The -oldconfig1 is the kernel that had no problems and the other shows the =
b44=20
problem. So if High Resolution Timer Support is disabled everything works=20
fine and if I enable it the problems do appear again.

I didn't test this on my 2.6.22-rc3 kernel yet, but I guess disabling High=
=20
Resolution Timer Support will also solve the problem there.

The older kernels I tried also work perfectly fine and they didn't have the=
=20
High Resolution Timer Support yet.

Maxi

--nextPart2680567.p56DHj8tbN
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGWuKtOimwv528XGERAtQ1AKCFy7ttCAxrsBSsWI4oPFp0Gplw/ACg+PAd
xraG3X/P9xk/wJpOGllhhbc=
=07ZM
-----END PGP SIGNATURE-----

--nextPart2680567.p56DHj8tbN--
