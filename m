Return-Path: <linux-kernel-owner+w=401wt.eu-S1757476AbZFIGex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757476AbZFIGex (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 02:34:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757383AbZFIGef
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 02:34:35 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:54627 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756939AbZFIGed (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 02:34:33 -0400
Date: Tue, 9 Jun 2009 16:34:05 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Borislav Petkov <petkovbb@googlemail.com>,
       Mark de Wever <koraq@xs4all.nl>
Subject: linux-next: manual merge of the block tree with the ide tree
Message-Id: <20090609163405.69795630.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__9_Jun_2009_16_34_05_+1000_D4oih0KtOAmQhuSo"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__9_Jun_2009_16_34_05_+1000_D4oih0KtOAmQhuSo
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jens,

Today's linux-next merge of the block tree got a conflict in
drivers/ide/ide-tape.c between various commits from the ide tree and
various commits from the block tree.

I fixed it up as best I could (see below).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/ide/ide-tape.c
index 51ea59e,683ff37..0000000
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@@ -610,8 -617,8 +628,8 @@@ static ide_startstop_t idetape_do_reque
  	struct ide_cmd cmd;
  	u8 stat;
 =20
- 	debug_log(DBG_SENSE, "sector: %llu, nr_sectors: %lu\n",
- 		  (unsigned long long)rq->sector, rq->nr_sectors);
 -	debug_log(DBG_SENSE, "sector: %llu, nr_sectors: %u\n"
++	debug_log(DBG_SENSE, "sector: %llu, nr_sectors: %u\n",
+ 		  (unsigned long long)blk_rq_pos(rq), blk_rq_sectors(rq));
 =20
  	if (!(blk_special_request(rq) || blk_sense_request(rq))) {
  		/* We do not support buffer cache originated requests. */

--Signature=_Tue__9_Jun_2009_16_34_05_+1000_D4oih0KtOAmQhuSo
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkouAl0ACgkQjjKRsyhoI8y5ogCff7eV5IE0c2Oh8unyuuGqYMt4
30oAn0IS3AP3ny2dOTiU6COi09LTMLAR
=7xcS
-----END PGP SIGNATURE-----

--Signature=_Tue__9_Jun_2009_16_34_05_+1000_D4oih0KtOAmQhuSo--
