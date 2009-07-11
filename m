Return-Path: <linux-kernel-owner+w=401wt.eu-S1753576AbZGKOgn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576AbZGKOgn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 10:36:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752027AbZGKOgf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 10:36:35 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:58482 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576AbZGKOgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 10:36:35 -0400
Subject: Re: [Bug #13337] [post 2.6.29 regression] hang during suspend of
 b44/b43 modules
From: Johannes Berg <johannes@sipsolutions.net>
To: Jan Scholz <scholz@fias.uni-frankfurt.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Tomas Janousek <tomi@nomi.cz>,
       "John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <87prc78ga9.fsf@scholz.fias.uni-frankfurt.de>
References: <tSdKBEwEOhE.A.2wF.s_oUKB@chimera>
	 <87k52izvd9.fsf@scholz.fias.uni-frankfurt.de>
	 <87y6qxx50z.fsf@scholz.fias.uni-frankfurt.de>
	 <200907092203.10294.rjw@sisk.pl> <1247171295.1905.5.camel@johannes.local>
	 <87prc78ga9.fsf@scholz.fias.uni-frankfurt.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-3SkAbbMpuPMJtysSudZM"
Date: Sat, 11 Jul 2009 16:36:25 +0200
Message-Id: <1247322985.30647.108.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-3SkAbbMpuPMJtysSudZM
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-07-11 at 16:07 +0200, Jan Scholz wrote:

> > Jan, can you run with console_suspend=3D0 (or whatever it is now, Rafae=
l
> > will correct me if I'm wrong) that should work on your platform, and pu=
t
> > a bunch of printk calls into __ieee80211_suspend in net/mac80211/pm.c t=
o
> > see where in there it's hanging?
>=20
> Did that, seems like it hangs in
>   drv_remove_interface(local, &conf);

Ok, thanks! I was going to suggest doing the same in
b43_op_remove_interface in drivers/net/wireless/b43/main.c, but I think
the problem is just that we have an ordering problem and call drv_stop
before drv_remove_interface. I'll try to come up with a fix soon --
might not be able to today though, in the meantime I guess you can just
move the drv_stop call to the end of the function and tell me if that
works -- that would be racy but should be ok most of the time.

johannes

--=-3SkAbbMpuPMJtysSudZM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKWKNmAAoJEODzc/N7+QmaBzEQAMZhLYf3HcNHjubUz1T3tvgN
d6X5JoUbmIVZLPcOmaFPBhi82XJ5PFbPX3RpK136qcLbOF1FgKJwmwZUGjgZkqBZ
WpHEbiO8SGNw0/oB16HEL4NJ3EpRVJdV6IJcNqV66yjTrLn6r8YP7UndDVHk5FAj
ZUL9S/yhf7/A472bI/kiCX+fBrnF6H3xTClvkwt47SvXOexi8Mmx+s6Xm82L8+Kl
MzBM4JPAWR2QAGqRZOZRgr86GxDgoOS6A0GSBVCl3dQm9j5YjD1XCRv6Uy9K63Vu
FYjsqo9ZlAdzDeV6d3DtOciTaY88+pD37+b91qOT/+lVBpDmlHXxdVQS0TFbMX0v
iZnKj0ZOzMRLl7zVziV2SGJNrbFFQmKi24ri4Djz0peKKUhI6sWs1cuQO5dB9N0i
LidHvCiZgMX/Eqn0QbeFV34QmfeC8GpjURGMYOR9yhU19P4FrcU615cKD/eJR07W
2L+h2sDt0uQZc2AvE64upuMZa8ivxTWbmpe1U21DNpCCFztH+ehEHPgCRKsmfqx7
DYImAeJ4mLCZFyGUlZ320NnXNB8fVjDI7X9A+ij9pHeysXyZ6PnQxMNXrq+g2HFq
kgf93DcfjxYhpBiceV0Gz29vF7qds9/cXHKPetq/VH46akgRj1k7m/dBJIUnyEEf
PJLKqbbUGa9g25MuxNKz
=Yx9F
-----END PGP SIGNATURE-----

--=-3SkAbbMpuPMJtysSudZM--

