Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353Ab0BBBrX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 20:47:23 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:46878 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752336Ab0BBBrV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 20:47:21 -0500
Date: Tue, 2 Feb 2010 12:47:11 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Samuel Ortiz <sameo@linux.intel.com>
Subject: linux-next: sound tree build failure
Message-Id: <20100202124711.d8cdc220.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta6 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__2_Feb_2010_12_47_11_+1100_TH9SjjbJo5rsKn2K"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__2_Feb_2010_12_47_11_+1100_TH9SjjbJo5rsKn2K
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Takashi,

Today's linux-next build (x86_64 allmodconfig) failed like this:

sound/soc/codecs/wm8994.c:30:35: error: linux/mfd/wm8994/core.h: No such fi=
le or directory
sound/soc/codecs/wm8994.c:31:40: error: linux/mfd/wm8994/registers.h: No su=
ch file or directory
sound/soc/codecs/wm8994.c:32:36: error: linux/mfd/wm8994/pdata.h: No such f=
ile or directory
sound/soc/codecs/wm8994.c:33:35: error: linux/mfd/wm8994/gpio.h: No such fi=
le or directory

And went down hill form there :-(

Caused by commit 9e6e96a197a03752d39a63e4f83e0b707ccedad7 ("ASoC: Add
WM8994 CODEC driver").  I presume that this commit depends on commits
currently only in the mfd tree ...

I have used the sound tree from next-20100201 for today.

To fix this, the relevant commits from the mfd tree could be put into a
"never to be rebased" branch (or separate git tree) and then this branch
merged into both the sound and mfd trees.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__2_Feb_2010_12_47_11_+1100_TH9SjjbJo5rsKn2K
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktnhB8ACgkQjjKRsyhoI8yIxQCeIwVzUKsnx5yXq727JqxsJlrE
ziIAnj8kGGc2NHtI7yKlUx5QgKzlRCFC
=R+d4
-----END PGP SIGNATURE-----

--Signature=_Tue__2_Feb_2010_12_47_11_+1100_TH9SjjbJo5rsKn2K--
