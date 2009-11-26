Return-Path: <linux-kernel-owner+w=401wt.eu-S1759351AbZKZIA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759351AbZKZIA5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 03:00:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759320AbZKZIAz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 03:00:55 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:55949 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759319AbZKZIAy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 03:00:54 -0500
Date: Thu, 26 Nov 2009 19:00:50 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Peter Ujfalusi <peter.ujfalusi@nokia.com>, Takashi Iwai <tiwai@suse.de>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: linux-next: workqueues tree build failure
Message-Id: <20091126190050.3f9d7fef.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__26_Nov_2009_19_00_50_+1100_fGOSUNzHSHOAJuJs"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__26_Nov_2009_19_00_50_+1100_fGOSUNzHSHOAJuJs
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tejun,

Today's linux-next build (x86_64 allmodconfig) failed like this:

sound/soc/codecs/tlv320dac33.c: In function 'dac33_i2c_probe':
sound/soc/codecs/tlv320dac33.c:1121: error: implicit declaration of functio=
n 'create_rt_workqueue'
sound/soc/codecs/tlv320dac33.c:1121: warning: assignment makes pointer from=
 integer without a cast

Caused by commit 1b2d88bf4c63ed3a8c9033c358905d3463aa8bc2 ("stop_machine:
reimplement without using workqueue") (which removed create_rt_workqueue
()) interacting with commit c8bf93f0fe8c5a509a29e30f3bac823fa0f6d96e
("ASoC: Codec driver for Texas Instruments tlv320dac33 codec") from the
sound tree.

I have no idea how to fix this, so I have used the workqueues tree from
next-20091125 until someone can suggest a solution.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__26_Nov_2009_19_00_50_+1100_fGOSUNzHSHOAJuJs
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksONbIACgkQjjKRsyhoI8y4sACfUyHspJga8DCJng2RuVwxBIXA
ZoQAnR4CjRISlG7iX+K+ksPCxO8lHqrh
=MnC3
-----END PGP SIGNATURE-----

--Signature=_Thu__26_Nov_2009_19_00_50_+1100_fGOSUNzHSHOAJuJs--
