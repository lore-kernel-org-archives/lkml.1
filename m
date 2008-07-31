Return-Path: <linux-kernel-owner+w=401wt.eu-S1757588AbYGaTFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757588AbYGaTFm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 15:05:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753716AbYGaTFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 15:05:34 -0400
Received: from xsmtp1.ethz.ch ([82.130.70.13]:35084 "EHLO xsmtp1.ethz.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753096AbYGaTFd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 15:05:33 -0400
Message-ID: <48920CF7.4060907@gmx.de>
Date: Thu, 31 Jul 2008 21:05:27 +0200
From: Dieter Ries <clip2@gmx.de>
User-Agent: Thunderbird 2.0.0.14 (X11/20080617)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: jbarnes@virtuousgeek.org, willy@linux.intel.com, pavel@suse.cz,
       len.brown@intel.com, linux-pm@lists.linux-foundation.org, rjw@sisk.pl
Subject: suspend to  ram regression in current GIT, bisected
X-Enigmail-Version: 0.95.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigCC8F929B258B03C3EDD47301"
X-OriginalArrivalTime: 31 Jul 2008 19:05:31.0303 (UTC) FILETIME=[67164B70:01C8F340]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigCC8F929B258B03C3EDD47301
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: quoted-printable

Hi,

starting from 2.6.27-rc1, my Laptop (Thinkpad T60) did not return from=20
suspend to ram anymore.

When it should resume, the sleep LED went off, power went on, HD LED=20
flashed once, but the display stayed black.

It worked perfectly in 2.6.26, so I bisected it:



ce6fce4295ba727b36fdc73040e444bd1aae64cd is first bad commit
commit ce6fce4295ba727b36fdc73040e444bd1aae64cd
Author: Matthew Wilcox <matthew@wil.cx>
Date:   Fri Jul 25 15:42:58 2008 -0600

PCI MSI: Don't disable MSIs if the mask bit isn't supported

David Vrabel has a device which generates an interrupt storm on the INTx
pin if we disable MSI interrupts altogether.  Masking interrupts is only
a performance optimisation, so we can ignore the request to mask the
interrupt.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>

:040000 040000 391a397ab982b7b80c0cb369d8a4999d8f7319fb=20
9a318bf27bf9c1bdd371e25754746397426a79ba M      drivers



Reverting it was not a problem and fixed the issue.

As the screen stays black, I have no idea how to get further details on=20
that problem. Which additional information should I provide? Netconsole=20
didn't show anything.

cu
Dieter

--=20
3rd Law of Computing:
         Anything that can go wr
fortune: Segmentation violation -- Core dumped


--------------enigCC8F929B258B03C3EDD47301
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkiSDPoACgkQ5YzjaZZeXo2AXQCgqElBYpHrRjUAYvxg9klM9agk
PV0AoKYd5P1bkbjSgXM32IyEEucAF4FB
=mXa9
-----END PGP SIGNATURE-----

--------------enigCC8F929B258B03C3EDD47301--
