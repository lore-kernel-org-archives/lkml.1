Return-Path: <linux-kernel-owner+w=401wt.eu-S1754990AbZCCT2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754990AbZCCT2R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 14:28:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753603AbZCCT2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 14:28:06 -0500
Received: from clegg.madduck.net ([193.242.105.96]:60494 "EHLO
	clegg.madduck.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601AbZCCT2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 14:28:05 -0500
Date: Tue, 3 Mar 2009 20:27:47 +0100
From: martin f krafft <madduck@madduck.net>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: /proc/sys/net/ip*/conf/all/* does not actually affect
	interfaces
Message-ID: <20090303192747.GA16226@piper.oerlikon.madduck.net>
Mail-Followup-To: linux kernel mailing list <linux-kernel@vger.kernel.org>
References: <20090302122718.GA3906@piper.oerlikon.madduck.net> <20090303070025.GA5042@pmhahn.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sm4nu43k4a2Rpi4c"
Content-Disposition: inline
In-Reply-To: <20090303070025.GA5042@pmhahn.de>
X-Motto: Keep the good times rollin'
X-OS: Debian GNU/Linux squeeze/sid kernel 2.6.26-1-amd64 x86_64
X-Spamtrap: madduck.bogus@madduck.net
X-Subliminal-Message: debian/rules!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sm4nu43k4a2Rpi4c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

also sprach Philipp Matthias Hahn <pmhahn@titan.lahn.de> [2009.03.03.0800 +=
0100]:
> "all" on the other hand allways gets applied in addition to the current
> setting, but it depends on the exact setting, if its ORed, ANDed, or
> whatevered:
[...]

Oh wow. This is very underdocumented. Thanks Philipp for taking the
time to reply!

The only reference I could find was

  http://lkml.indiana.edu/hypermail/linux/kernel/0103.0/0440.html

which was unanswered.

Can anyone recall the rationale for this somewhat complex-seeming
solution?

I suppose the goal is to allow all/* to override (which would be the
right solution). However, it depends on whether the default is 0 or
1 on whether to AND or OR. Example:

> 	log_martians         OR

default off, to turn it on globally, I just need to set all=3D1 and
the OR takes care of it.

> 	rp_filter            AND

default on, but to disable it globally (set all=3D0), it needs the
AND.

> (see include/linux/inetdevice.h:83 for IN_DEV_{AND,OR,MAX}CONF)

Unfortunately, that's just ipv4/conf/* and I cannot seem to find the
ipv6/conf/* counterparts.

> Putting a new value in "all" doesn't change the value you read
> from "$interface", but it only gets computed and used internally.

Hm, that clears it up... kinda. It does *not* explain by the RAs
were still accepted (ipv6.conf.all.accept_ra and .autoconf where
both 0), so unless those values are (wrongly) OR'd, I will need to
investigate this.

I will also work on patches to fix the documentation of this, and
that involves the kernel source as well as e.g. the IPv6 HOWTO and
other docs and manpages.

But to do this, I'd really like to know a bit more about the design
motivation. Anyone?

--=20
martin | http://madduck.net/ | http://two.sentenc.es/
=20
before he died, rabbi zusya said: "in the world to come they will not
ask me, 'why were you not moses?' they will ask me, 'why were you not
zusya?'"
=20
spamtraps: madduck.bogus@madduck.net

--sm4nu43k4a2Rpi4c
Content-Type: application/pgp-signature; name="digital_signature_gpg.asc"
Content-Description: Digital signature (see http://martin-krafft.net/gpg/)
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkmthLIACgkQIgvIgzMMSnWlegCg6Sx3QRTc0hLD13LrqdBqBoPK
IJYAnii5Pqpy1cWK65re41xaQ8jSizsW
=mlNp
-----END PGP SIGNATURE-----

--sm4nu43k4a2Rpi4c--
