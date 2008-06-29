Return-Path: <linux-kernel-owner+w=401wt.eu-S1755789AbYF2G0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755789AbYF2G0T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 02:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751296AbYF2G0A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 02:26:00 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:60333 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbYF2GZ7 (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 02:25:59 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>,
       "Duane Griffin" <duaneg@dghda.com>
Cc: linux-kernel@vger.kernel.org
Subject: 2.6.26-rc7-mmotd-0626 ext3-validate-directory-entry-data-before-use.patch
From: Valdis.Kletnieks@vt.edu
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1214720749_25769P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sun, 29 Jun 2008 02:25:49 -0400
Message-ID: <26368.1214720749@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1214720749_25769P
Content-Type: text/plain; charset=us-ascii

I'm seeing some ext3 errors, and I'm suspecting the patch
ext3-validate-directory-entry-data-before-use.patch is causing them
(since it seems to be the only thing in rc7-mmotd at the moment that
touches make_indexed_dir, and -rc5-mm3 works OK).

Jun 28 21:50:29 turing-police kernel: [  240.784199] EXT3-fs error (device dm-7): make_indexed_dir: bad entry in directory #9894: directory entry across blocks - offset=0, inode=10144, rec_len=32, name_len=22
Jun 28 21:50:29 turing-police kernel: [  240.784214] Aborting journal on device dm-7.
Jun 28 21:50:29 turing-police kernel: [  240.784597] Remounting filesystem read-only
Jun 28 21:50:29 turing-police kernel: [  240.785616] EXT3-fs error (device dm-7): do_split: bad entry in directory #9894: rec_len is smaller than minimal - offset=0, inode=2553887680, rec_len=0, name_len=0
Jun 28 21:50:29 turing-police kernel: [  240.785616] EXT3-fs error (device dm-7) in ext3_reserve_inode_write: Journal has aborted
Jun 28 21:50:29 turing-police kernel: [  241.027111] __journal_remove_journal_head: freeing b_committed_data

Jun 28 23:09:54 turing-police kernel: [ 5026.698415] EXT3-fs error (device dm-2): make_indexed_dir: bad entry in directory #369136: directory entry across blocks - offset=0, inode=369138, rec_len=20, name_len=11
Jun 28 23:09:54 turing-police kernel: [ 5026.698415] Aborting journal on device dm-2.
Jun 28 23:09:54 turing-police kernel: [ 5026.698519] Remounting filesystem read-only
Jun 28 23:09:54 turing-police kernel: [ 5026.702730] EXT3-fs error (device dm-2): do_split: bad entry in directory #369136: directory entry across blocks - offset=0, inode=106647, rec_len=12, name_len=1
Jun 28 23:09:54 turing-police kernel: [ 5026.702730] EXT3-fs error (device dm-2) in ext3_reserve_inode_write: Journal has aborted

I believe I have a reasonably good replicator for the error on dm-7, that's my /usr/share
and trying to 'rpm -Fvh' one specific RPM has caused it twice (in two tries).

The file systems appear to be OK (or at least the fsck.ext3 in Fedora's
e2fsprogs-1.41-0.WIP.0617.1.fc10.x86_64 says both file systems are in fact OK).

Any comments/suggestions?  Any testing/debugging you'd like, or should I just revert it
and move on?


--==_Exmh_1214720749_25769P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFIZyrtcC3lWbTT17ARAq9qAKDbEfGOJU7oc/1GUZI+DbTNxjkrVgCgokkW
IsvXXbMrVrmYwoIdgAP4MNU=
=tEjh
-----END PGP SIGNATURE-----

--==_Exmh_1214720749_25769P--
