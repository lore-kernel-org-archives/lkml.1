Return-Path: <linux-kernel-owner+w=401wt.eu-S1750960AbZG3INy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750960AbZG3INy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 04:13:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751167AbZG3INx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 04:13:53 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:39547 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750960AbZG3INw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 04:13:52 -0400
Date: Thu, 30 Jul 2009 18:13:45 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tom Peng <tom_peng@usish.com>, Jack Wang <jack_wang@usish.com>,
       Lindar Liu <lindar_liu@usish.com>, Kevin Ao <aoqingyun@usish.com>
Subject: linux-next: scsi-rc-fixes tree build failure
Message-Id: <20090730181345.cec774b2.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__30_Jul_2009_18_13_45_+1000_7xdrhcSS10AOXcO7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__30_Jul_2009_18_13_45_+1000_7xdrhcSS10AOXcO7
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

Today's linux-next build (powerpc allyesconfig) failed like this:

drivers/scsi/libsas/sas_expander.c: In function 'sas_find_bcast_dev':
drivers/scsi/libsas/sas_expander.c:1701: error: 'FALSE' undeclared (first u=
se in this function)
drivers/scsi/libsas/sas_expander.c: In function 'sas_discover_new':
drivers/scsi/libsas/sas_expander.c:1809: error: 'FALSE' undeclared (first u=
se in this function)
drivers/scsi/libsas/sas_expander.c:1824: error: 'TRUE' undeclared (first us=
e in this function)
drivers/scsi/libsas/sas_expander.c: In function 'sas_rediscover':
drivers/scsi/libsas/sas_expander.c:1903: error: 'TRUE' undeclared (first us=
e in this function)
drivers/scsi/libsas/sas_expander.c:1918: error: 'FALSE' undeclared (first u=
se in this function)
drivers/scsi/libsas/sas_expander.c: In function 'sas_ex_revalidate_domain':
drivers/scsi/libsas/sas_expander.c:1951: error: 'TRUE' undeclared (first us=
e in this function)

Caused by commit 4c70d933a41e1d712f3db90d2a41141730383d5a ("[SCSI]
libsas: fix wide port hotplug issues").  Presumably a missing include
file.

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__30_Jul_2009_18_13_45_+1000_7xdrhcSS10AOXcO7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpxVjkACgkQjjKRsyhoI8wDKwCdH5T38RObD3P3cboNh3h72mfB
TNEAnAiwGRx3H9rLmHj3eDYEShS3tBvj
=NCR+
-----END PGP SIGNATURE-----

--Signature=_Thu__30_Jul_2009_18_13_45_+1000_7xdrhcSS10AOXcO7--
