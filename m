Return-Path: <linux-kernel-owner+w=401wt.eu-S1759230AbZIQBMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759230AbZIQBMc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 21:12:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756241AbZIQBMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 21:12:31 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:42358 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754699AbZIQBMb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 21:12:31 -0400
Date: Thu, 17 Sep 2009 11:12:28 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: input-current tree build failure
Message-Id: <20090917111228.800851b0.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__17_Sep_2009_11_12_28_+1000_.pvjPoyieskdnTOI"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__17_Sep_2009_11_12_28_+1000_.pvjPoyieskdnTOI
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dmitry,

Today's linux-next build (x86_64 allmodconfig) failed like this:

In file included from drivers/input/serio/i8042.c:23:
include/linux/i8042.h: In function 'i8042_check_port_owner':
include/linux/i8042.h:58: error: parameter name omitted
drivers/input/serio/i8042.c: At top level:
drivers/input/serio/i8042.c:130: error: redefinition of 'i8042_lock_chip'
include/linux/i8042.h:45: note: previous definition of 'i8042_lock_chip' wa=
s here
drivers/input/serio/i8042.c:136: error: redefinition of 'i8042_unlock_chip'
include/linux/i8042.h:49: note: previous definition of 'i8042_unlock_chip' =
was here
drivers/input/serio/i8042.c:246: error: redefinition of 'i8042_command'
include/linux/i8042.h:53: note: previous definition of 'i8042_command' was =
here
drivers/input/serio/i8042.c:1193: error: redefinition of 'i8042_check_port_=
owner'
include/linux/i8042.h:58: note: previous definition of 'i8042_check_port_ow=
ner' was here

Caused by commit 1f57f19e6245c5534c3518a8455419461ec06778 ("Input: libps2
- additional locking for i8042 ports").

Please, if you add code that depends on a CONFIG option, build it with
and without the options set ...

I have used the input-current tree from next-20090916 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__17_Sep_2009_11_12_28_+1000_.pvjPoyieskdnTOI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkqxjPwACgkQjjKRsyhoI8xoEgCggU6VE6X91BvjBoS7ElKaE4hq
qgkAninoQA/2VeLch2CRJ/7An2Nh9f6Y
=3Ht2
-----END PGP SIGNATURE-----

--Signature=_Thu__17_Sep_2009_11_12_28_+1000_.pvjPoyieskdnTOI--
