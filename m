Return-Path: <linux-kernel-owner+w=401wt.eu-S933937AbZGQB3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933937AbZGQB3o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 21:29:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933480AbZGQB3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 21:29:44 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34100 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933930AbZGQB3n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 21:29:43 -0400
Date: Fri, 17 Jul 2009 11:29:35 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Barry Song <21cnbao@gmail.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Greg KH <greg@kroah.com>
Subject: linux-next: sound tree build failure
Message-Id: <20090717112935.2e831eee.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__17_Jul_2009_11_29_35_+1000_FBAQE_+qbyQocvZU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__17_Jul_2009_11_29_35_+1000_FBAQE_+qbyQocvZU
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Takashi,

Today's linux-next build (x86_64 allmodconfig) failed like this:

sound/soc/codecs/ad1938.c: In function 'ad1938_spi_probe':
sound/soc/codecs/ad1938.c:423: error: 'struct device' has no member named '=
driver_data'
sound/soc/codecs/ad1938.c: In function 'ad1938_spi_remove':
sound/soc/codecs/ad1938.c:430: error: 'struct device' has no member named '=
driver_data'

Caused by commit 1274738d85d0e25c4f82d83f50a6bcbe2397e9ea ("ASoC: new
ad1938 codec driver based on asoc") interacting with commit
2e34003ff6237e2216396d61dc8b32ea5959de80 ("Driver core: move
dev_get/set_drvdata to drivers/base/dd.c") from the driver-core.current
tree (which will, I assume, be sent to Linus shortly - right, Greg?).

New drivers need to use the (existing) API's dev_{set,get}_drvdata().

I have used the version of the sound tree from next-20090716 for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__17_Jul_2009_11_29_35_+1000_FBAQE_+qbyQocvZU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpf0/8ACgkQjjKRsyhoI8zRrQCgnJXEofvETcpXrsrUuDINHunL
hp8AoKJp0oe2fzUfsdlUka8n0sODN6zw
=xM4h
-----END PGP SIGNATURE-----

--Signature=_Fri__17_Jul_2009_11_29_35_+1000_FBAQE_+qbyQocvZU--
