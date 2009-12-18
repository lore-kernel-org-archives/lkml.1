Return-Path: <linux-kernel-owner+w=401wt.eu-S933213AbZLRWqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933213AbZLRWqZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 17:46:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933111AbZLRWqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 17:46:23 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:56387 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932612AbZLRWqX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 17:46:23 -0500
Date: Sat, 19 Dec 2009 09:46:16 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: linux-next: manual merge of the limits tree with the  tree
Message-Id: <20091219094616.744fc1c1.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta3 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__19_Dec_2009_09_46_16_+1100_vXIb5pShl2o6Fhfr"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__19_Dec_2009_09_46_16_+1100_vXIb5pShl2o6Fhfr
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jiri,

Today's linux-next merge of the limits tree got a conflict in fs/exec.c
between commit f6151dfea21496d43dbaba32cfcd9c9f404769bc ("mm: introduce
coredump parameter structure") from the  tree and commit
1157605c47673fc63b052df4688697695a9873d5 ("FS: use helpers for rlimits")
from the limits tree.

I fixed it up (see below - thanks Andrew) and can carry the fix for a
while.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
diff --cc fs/exec.c
index ac52447,8a160a1..0000000
--- a/fs/exec.c
+++ b/fs/exec.c
@@@ -1772,11 -1763,6 +1772,11 @@@ void do_coredump(long signr, int exit_c
  	int helper_argc =3D 0;
  	int dump_count =3D 0;
  	static atomic_t core_dump_count =3D ATOMIC_INIT(0);
 +	struct coredump_params cprm =3D {
 +		.signr =3D signr,
 +		.regs =3D regs,
- 		.limit =3D current->signal->rlim[RLIMIT_CORE].rlim_cur,
++		.limit =3D rlimit(RLIMIT_CORE),
 +	};
 =20
  	audit_core_dumps(signr);
 =20

--Signature=_Sat__19_Dec_2009_09_46_16_+1100_vXIb5pShl2o6Fhfr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkssBjgACgkQjjKRsyhoI8y/oACeKhKBPTmT+1fxvA7PVX9WsdOG
0J0An1qtMihKhxYO8ajhnOY7RuJwTYWD
=lyKk
-----END PGP SIGNATURE-----

--Signature=_Sat__19_Dec_2009_09_46_16_+1100_vXIb5pShl2o6Fhfr--
