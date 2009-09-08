Return-Path: <linux-kernel-owner+w=401wt.eu-S1754012AbZIHIMf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012AbZIHIMf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 04:12:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753665AbZIHIMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 04:12:35 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:47144 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753660AbZIHIMd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 04:12:33 -0400
Date: Tue, 8 Sep 2009 18:12:21 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jayamohan Kallickal <jayamohank@serverengines.com>,
       Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: linux-next: scsi-post-merge tree build failure
Message-Id: <20090908181221.e8f98215.sfr@canb.auug.org.au>
In-Reply-To: <20090907200646.c6d6fadc.sfr@canb.auug.org.au>
References: <20090907200646.c6d6fadc.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__8_Sep_2009_18_12_21_+1000_w38OKG8Im0F/5/uf"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__8_Sep_2009_18_12_21_+1000_w38OKG8Im0F/5/uf
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

On Mon, 7 Sep 2009 20:06:46 +1000 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> Today's linux-next build (powerpc allyesconfig) failed like this:
>=20
> drivers/scsi/be2iscsi/be_main.c: In function 'hwi_write_buffer':
> drivers/scsi/be2iscsi/be_main.c:1481: error: implicit declaration of func=
tion 'virt_to_bus'
>=20
> Caused by commit 9316dc3deb9675c674f96a0c6fb74ccc6c497fae ("[SCSI]
> be2iscsi: add 10Gbps iSCSI - BladeEngine 2 driver") which I have reverted
> for today.

The driver needs to depend on CONFIG_VIRT_TO_BUS if it needs to use
virt_to_bus().  That will prevent it from building on some platforms
(like powerpc) that do not implement virt_to_bus() and its brothers.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__8_Sep_2009_18_12_21_+1000_w38OKG8Im0F/5/uf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqmEeUACgkQjjKRsyhoI8xisACggxjl8Iyepl2j15PlvzaKEnQt
xvYAnRXrTaDUHRv9VV/iV0mdkanIi7et
=vBCQ
-----END PGP SIGNATURE-----

--Signature=_Tue__8_Sep_2009_18_12_21_+1000_w38OKG8Im0F/5/uf--
