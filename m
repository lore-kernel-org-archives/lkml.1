Return-Path: <linux-kernel-owner+w=401wt.eu-S933041AbYA2Qyq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933041AbYA2Qyq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 11:54:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755405AbYA2Qyc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 11:54:32 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:46420 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753428AbYA2Qya (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 11:54:30 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: 2.6.24-rc6-mm1 - iget-stop-isofs-from-using-read_inode-fix-2.patch
From: Valdis.Kletnieks@vt.edu
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1201625624_2944P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 29 Jan 2008 11:53:44 -0500
Message-ID: <20420.1201625624@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1201625624_2944P
Content-Type: text/plain; charset=us-ascii

Sorry for the late notice - I hit the original issue with this code,
and I tested the *first* patch, which addressed my immediate problem, but
didn't test the subsequent flurry of "better" patches due to time issues
here.

I back up my laptop by doing one or more 'dump' commands into a $STAGE directory,
and then doing a 'growisofs' onto a DVD.  And of course, I eventually needed
to restore something that got damaged by some misbehaving userspace, so I break
out the disk, which had 8 dump images for smaller filesystems on it. Imagine
my surprise when the disk was unreadable - so I went bisecting and eventually
found it first in the -rc6-mm1 tree.

Under 2.6.4-rc6-mm1 quilted up to iget-stop-isofs-from-using-read_inode.patch,
it's able to see all 8 dump images.  When I quilt push the very next one
(iget-stop-isofs-from-using-read_inode-fix-2.patch), all hell breaks loose:

[root@turing-police ~]# mount -t iso9660 /dev/cdrom /mnt/cdrom
[root@turing-police ~]# ls -la /mnt/cdrom
total 0
[root@turing-police ~]# umount /mnt/cdrom

It claims to mount correctly - but ls can't find anything.

*not even . and .. - how weird is that?*

Looking at the code, I don't see why inode-fix-2 breaks it, nor do I see
why inode-fix-2-update or inode-fix-2-update-fix don't re-fix it...

--==_Exmh_1201625624_2944P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHn1oYcC3lWbTT17ARAuzDAKCgIolPhw7xajUoZpcnx28sCzvT3ACcC1BX
GMeVv5mybwdRw3zSJKz2s64=
=gJg3
-----END PGP SIGNATURE-----

--==_Exmh_1201625624_2944P--
