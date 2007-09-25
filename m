Return-Path: <linux-kernel-owner+w=401wt.eu-S1761609AbXIYAYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761609AbXIYAYV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 20:24:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756990AbXIYAYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 20:24:13 -0400
Received: from pc175e.fzu.cz ([147.231.127.175]:35274 "EHLO postak-1.fzu.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755947AbXIYAYM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 20:24:12 -0400
X-Greylist: delayed 602 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Sep 2007 20:24:12 EDT
Message-ID: <46F852B6.7030207@gentoo.org>
Date: Tue, 25 Sep 2007 02:13:42 +0200
From: =?ISO-8859-1?Q?Jan_Kundr=E1t?= <jkt@gentoo.org>
Organization: Gentoo
User-Agent: Thunderbird 2.0.0.6 (X11/20070812)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: kswapd high CPU usage with no swap
X-Enigmail-Version: 0.95.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig6A9918657A1D35A9C4E8F513"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig6A9918657A1D35A9C4E8F513
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi folks,
I use a 2.6.22-gentoo-r2 SMP kernel with fglrx 8.40.4 [1], tp_smapi-0.32
and ipw3945-1.2.0 on a Thinkpad T60 with dual core Intel Core CPU. My
root filesystem is XFS stored on an internal SATA disk, and I have 1GB
of RAM and no swap.

After several suspend to RAM/resume cycles, the X interface got pretty
slow today. Looking at the top output, I see that one core was
completely busy in the "wa" state and according to `ps auxww`, the
kswapd0 process was in uninterruptable deep sleep.

I don't use any swap because my applications rarely need more memory
than I have in my system and using 1GB of swap yielded poor performance
when it was actually accessed. I know I can tweak VM's preferences, but
I simply don't feel the need to use swap when I have "plenty" of memory.

That said, I've googled a thread [2] which recommends using at least a
small swap because VM somehow performs better with it.

So I created a small (12MB) swap on a physical partition on the same
SATA disk and swapon-ed it. The swap got full immediately but the load
didn't get lower. After that, I've turned it off again, adjusted its
size to be about 1GB and enabled it again. Several tens of seconds
later, swap usage was at approximately 350MB and RAM usage at about
60MB. There was no unusual activity at the background (no intensive
cronned jobs, no locate, nothing, just an idle KDE session with bunch of
idling applications). Touching the swappiness value (0, 10, 40, 60 and
100) didn't change anything on the fact that switching from one
application to another was slow, and even moving a mouse cursor
(USB-attached mouse) in X was delayed and not smooth.

Could you please provide a hint about what might cause such problems,
what am I doing wrong and how can I avoid it? If there are any details
like kernel config that are relevant here, I'll happily provide them.
I'd also appreciate if you keep me on the CC as I'm not subscribed to
this list. If this is not an appropriate place to ask, please accept my
apologies.

[1] I'm aware of the fact that fglrx is a binary closed source and that
the kernel is tainted by its usage. Unfortunately no other driver
besides VESA supports my VGA card.
[2] http://www.redhat.com/archives/nahant-list/2006-March/msg00033.html

Cheers,
-jkt

--=20
cd /local/pub && more beer > /dev/mouth


--------------enig6A9918657A1D35A9C4E8F513
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFG+FK5amXfqERyJRcRAqbkAJ9UBfocfirQ3zPiax+lWpDMRa+AvACfcgzR
2FwxoF3jdo+Y3k6d3ksVkfg=
=twzQ
-----END PGP SIGNATURE-----

--------------enig6A9918657A1D35A9C4E8F513--
