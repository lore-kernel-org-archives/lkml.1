Return-Path: <linux-kernel-owner+w=401wt.eu-S1753101AbYGYAaz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101AbYGYAaz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 20:30:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753249AbYGYAaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 20:30:30 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:46678 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753120AbYGYAa3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 20:30:29 -0400
Date: Fri, 25 Jul 2008 10:30:21 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-next@vger.kernel.org, Trond Myklebust <trond.myklebust@fys.uio.no>,
       ppc-dev <linuxppc-dev@ozlabs.org>, LKML <linux-kernel@vger.kernel.org>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: linux-next: origin tree build failure
Message-Id: <20080725103021.b913c24c.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__25_Jul_2008_10_30_21_+1000_HmNCL7n6LctfkuOC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__25_Jul_2008_10_30_21_+1000_HmNCL7n6LctfkuOC
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next (really just Linus' tree) build (powerpc
ppc64_defconfig) failed like this:

fs/nfs/nfsroot.c:130: error: tokens causes a section type conflict

"tokens" is a match_table_t which has const added to it in commit
f9247273cb69ba101877e946d2d83044409cc8c5 "UFS: add const to parser token
table".  But "tokens" is also marked __initdata.  I changed it to
__initconst.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__25_Jul_2008_10_30_21_+1000_HmNCL7n6LctfkuOC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkiJHp0ACgkQjjKRsyhoI8xG9wCeOutOS7BqKHvo2K8f1LaW1qlK
zMsAn3XtT+yNaYCbr0xpkkKm+D4N8RPr
=/L8s
-----END PGP SIGNATURE-----

--Signature=_Fri__25_Jul_2008_10_30_21_+1000_HmNCL7n6LctfkuOC--
