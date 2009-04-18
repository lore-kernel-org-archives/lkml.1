Return-Path: <linux-kernel-owner+w=401wt.eu-S1751118AbZDREn1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751118AbZDREn1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 00:43:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750928AbZDREnS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 00:43:18 -0400
Received: from mx27.mail.ru ([94.100.176.41]:50745 "EHLO mx27.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750842AbZDREnS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 00:43:18 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: 2.6.30-rc2: format warning in fs/reiserfs/procfs.o
Date: Sat, 18 Apr 2009 08:43:08 +0400
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc2-1avb; KDE/4.2.2; i686; ; )
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart16764081.yDPV8SULm7";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200904180843.11714.arvidjaar@mail.ru>
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart16764081.yDPV8SULm7
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

  CC [M]  fs/reiserfs/procfs.o
/home/bor/src/linux-git/fs/reiserfs/procfs.c: In function 'show_journal':
/home/bor/src/linux-git/fs/reiserfs/procfs.c:393: warning: format '%u'=20
expects type 'unsigned int', but argument 22 has type 'long unsigned int'
  LD [M]  fs/reiserfs/reiserfs.o


Argument 22 is journal->j_last_flush_trans_id. As far as I can tell in all=
=20
contexts where it is used it is assigned unsigned int (and journal->trans_i=
d=20
itself is unsigned int as well). So is this patch appropriate? It compiles=
=20
cleanly, but I am a bit scared to test it on my sole root reiserfs :)

=2D-

Subject: [PATCH] reiserfs: Make j_last_flush_trans_id unsigned int
=46rom: Andrey Borzenkov <arvidjaar@mail.ru>

j_last_flush_trans_id is always assigned unsigned int value; so make it
unsigned int as well. It also removes this warning:

  CC [M]  fs/reiserfs/procfs.o
/home/bor/src/linux-git/fs/reiserfs/procfs.c: In function 'show_journal':
/home/bor/src/linux-git/fs/reiserfs/procfs.c:393: warning: format '%u'
expects type 'unsigned int', but argument 22 has type 'long unsigned int'

Signed-off-by: Andrey Borzenkov <arvidjaar@mail.ru>

=2D--

 include/linux/reiserfs_fs_sb.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/include/linux/reiserfs_fs_sb.h b/include/linux/reiserfs_fs_sb.h
index 5621d87..1d1594a 100644
=2D-- a/include/linux/reiserfs_fs_sb.h
+++ b/include/linux/reiserfs_fs_sb.h
@@ -193,7 +193,7 @@ struct reiserfs_journal {
 	atomic_t j_wcount;	/* count of writers for current commit */
 	unsigned long j_bcount;	/* batch count. allows turning X transactions=20
into 1 */
 	unsigned long j_first_unflushed_offset;	/* first unflushed transactions=20
offset */
=2D	unsigned long j_last_flush_trans_id;	/* last fully flushed journal=20
timestamp */
+	unsigned int j_last_flush_trans_id;	/* last fully flushed journal=20
timestamp */
 	struct buffer_head *j_header_bh;
=20
 	time_t j_trans_start_time;	/* time this transaction started */


--nextPart16764081.yDPV8SULm7
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAknpWl8ACgkQR6LMutpd94x4LQCdFlEfHr1nkILdvtTc6IU9t41Y
BjMAoKs/TVxPfykHjsKan7ejj/j4azVh
=of+a
-----END PGP SIGNATURE-----

--nextPart16764081.yDPV8SULm7--
