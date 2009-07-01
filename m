Return-Path: <linux-kernel-owner+w=401wt.eu-S1759717AbZGAGA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759717AbZGAGA3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 02:00:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753056AbZGAGAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 02:00:19 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:39260 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751514AbZGAGAS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 02:00:18 -0400
Date: Wed, 1 Jul 2009 16:00:14 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Eric Paris <eparis@redhat.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: boot failure
Message-Id: <20090701160014.595e1338.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__1_Jul_2009_16_00_14_+1000_5T565D3f570zuN1o"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__1_Jul_2009_16_00_14_+1000_5T565D3f570zuN1o
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Eric,

next-20090630 failed to boot (on PowerPC Power5/6 machines):

calling  .audit_watch_init+0x0/0x80 @ 1
Unable to handle kernel paging request for data at address 0xffffffffffffff=
ff
Faulting instruction address: 0xc00000000008b440
cpu 0x0: Vector: 300 (Data Access) at [c0000000be683990]
    pc: c00000000008b440: .srcu_read_lock+0x20/0x40
    lr: c0000000001607cc: .fsnotify_recalc_global_mask+0x2c/0xa0
    sp: c0000000be683c10
   msr: 8000000000009032
   dar: ffffffffffffffff
 dsisr: 40010000
  current =3D 0xc0000000be67e000
  paca    =3D 0xc00000000093b200
    pid   =3D 1, comm =3D swapper
enter ? for help
[link register   ] c0000000001607cc .fsnotify_recalc_global_mask+0x2c/0xa0
[c0000000be683c10] c0000000be683ca0 (unreliable)
[c0000000be683ca0] c000000000160bc0 .fsnotify_obtain_group+0x1e0/0x260
[c0000000be683d60] c0000000007879e4 .audit_watch_init+0x34/0x80
[c0000000be683de0] c00000000000947c .do_one_initcall+0x6c/0x1e0
[c0000000be683ee0] c00000000076fd6c .kernel_init+0x23c/0x2c0
[c0000000be683f90] c00000000002a9bc .kernel_thread+0x54/0x70

next-20090629 was fine.  The commits in 0630 and not in 0629 (from the
fsnotify tree) are:

      Audit: clean up the audit_watch split
      audit: convert audit watches to use fsnotify instead of inotify
      audit: redo audit watch locking and refcnt in light of fsnotify
      audit: do not get and put just to free a watch
      fsnotify: duplicate fsnotify_mark_entry data between 2 marks
      fsnotify: allow addition of duplicate fsnotify marks
      audit: reimplement audit_trees using fsnotify rather than inotify
      inotify: deprecate the inotify kernel interface

If I have time, I may do a bisection.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__1_Jul_2009_16_00_14_+1000_5T565D3f570zuN1o
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpK+24ACgkQjjKRsyhoI8zxsgCeJ+S4c21/DJ6zf9Lg08jkQbUS
D2gAoIpNa3sPMkYa31WpMerUwQV9Tr2K
=z1b5
-----END PGP SIGNATURE-----

--Signature=_Wed__1_Jul_2009_16_00_14_+1000_5T565D3f570zuN1o--
