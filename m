Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752315Ab0BJFvl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 00:51:41 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:39494 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752096Ab0BJFvj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 00:51:39 -0500
Date: Wed, 10 Feb 2010 16:51:33 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Giridhar Malavali <giridhar.malavali@qlogic.com>,
       Sarang Radke <sarang.radke@qlogic.com>
Subject: linux-next: build warning after merge of the scsi tree
Message-Id: <20100210165133.0dd46452.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta7 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__10_Feb_2010_16_51_33_+1100__hxcAmda4k3apKnt"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__10_Feb_2010_16_51_33_+1100__hxcAmda4k3apKnt
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the percpu tree, today's linux-next build (powerpc
ppc64_defconfig) produced these warnings:

drivers/scsi/qla2xxx/qla_attr.c: In function 'qla2x00_process_vendor_specif=
ic':
drivers/scsi/qla2xxx/qla_attr.c:2150: warning: 'req_data' may be used unini=
tialized in this function
drivers/scsi/qla2xxx/qla_attr.c:2152: warning: 'req_data_len' may be used u=
ninitialized in this function

If the first "goto done_unmap_sg;" in this function is followed, the
req_data will be tested even though it has not been assigned to yet and
if it is non zero, it and req_data_len will be passed to
dma_free_coherent() while still uninitialised.

Introduced by commit 9a069e196767d7b87184fd8d8211d22bb5b9c0b8 ("[SCSI]
qla2xxx: Add BSG support for FC ELS/CT passthrough and vendor commands").

The compiler also produces these:

drivers/scsi/qla2xxx/qla_attr.c:2144: warning: 'command_sent' may be used u=
ninitialized in this function
drivers/scsi/qla2xxx/qla_attr.c:2146: warning: 'type' may be used uninitial=
ized in this function

but I can't easily tell if they are false positives.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__10_Feb_2010_16_51_33_+1100__hxcAmda4k3apKnt
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktySWUACgkQjjKRsyhoI8wh0QCfc7WmWBarxjxEwSxzSdW96ufq
LhoAnAqzOwF0xlb+SHaPtL0nFSSePK3Q
=4qzZ
-----END PGP SIGNATURE-----

--Signature=_Wed__10_Feb_2010_16_51_33_+1100__hxcAmda4k3apKnt--
