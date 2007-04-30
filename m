Return-Path: <linux-kernel-owner+w=401wt.eu-S1946524AbXD3ROZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946524AbXD3ROZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 13:14:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946526AbXD3ROY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 13:14:24 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:45487 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946524AbXD3ROX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 13:14:23 -0400
X-Sasl-enc: GCUDInMcr4Ql0SxpqWt91Vq99mD7JgIXjWq4l3j7J4po 1177953262
Message-ID: <4636248E.7030309@imap.cc>
Date: Mon, 30 Apr 2007 19:17:02 +0200
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.0.9) Gecko/20061211 SeaMonkey/1.0.7 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Nick Piggin <nickpiggin@yahoo.com.au>, Hugh Dickins <hugh@veritas.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: 2.6.21-rc7-mm2 crash: Eeek! page_mapcount(page) went negative!
 (-1)
References: <20070425225716.8e9b28ca.akpm@linux-foundation.org>	<46338AEB.2070109@imap.cc> <20070428141024.887342bd.akpm@linux-foundation.org>
In-Reply-To: <20070428141024.887342bd.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig55AD27A617EA337FCF304DA9"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig55AD27A617EA337FCF304DA9
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

>> With kernel 2.6.21-rc7-mm2, my Dell Optiplex GX110 (P3/933) regularly
>> crashes during the SuSE 10.1 startup sequence. When booting to RL5,
>> it panicblinks shortly after the graphical login screen appears.
>> Booting to RL3, it hangs after the startup message:

I have now bisected this down to the section in the series file between
#GREGKH-DRIVER-START and #GREGKH-DRIVER-END, and therefore added GregKH
to the CC list. I'll try bisecting further inside that section (unless
you tell me not to), but it may take some time.

The exact point during the startup sequence when the crash occurred and
the amount of BUG messages produced varied somewhat during these tests.
The common denominator, and my criterion for the good/bad decisions
during the bisect, was the crash (panic blink) just before completion
of the system startup.
Sometimes there weren't any BUG messages in the log (or perhaps they
just didn't make it to the disk.) Sometimes I just had a couple of the
"sleeping function called from invalid context at mm/slab.c:3054"
ones but no "Eeek! page_mapcount(page) went negative!" one before them.
However, whenever the "Eeek!" did appear it announced "getcfg-interfac"
as the current process and was followed by a few of the "mm/slab.c:3054"
ones.

HTH
Tilman

--=20
In the long run, we'll all be dead.


--------------enig55AD27A617EA337FCF304DA9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGNiSWMdB4Whm86/kRAjSwAJ0bMeAS1XKx+b6XlnYjVDRu/HXZTACfe2Ni
Z4ocLxKggGO0OLjEPBCfxEo=
=ySAb
-----END PGP SIGNATURE-----

--------------enig55AD27A617EA337FCF304DA9--
