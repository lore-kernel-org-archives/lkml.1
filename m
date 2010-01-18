Return-Path: <linux-kernel-owner+w=401wt.eu-S1751199Ab0ARFYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751199Ab0ARFYW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 00:24:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750790Ab0ARFYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 00:24:20 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:45755 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750764Ab0ARFYU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 00:24:20 -0500
Date: Mon, 18 Jan 2010 16:24:12 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>,
       Linus Walleij <linus.walleij@stericsson.com>,
       Samuel Ortiz <sameo@linux.intel.com>
Subject: linux-next: trivial tree build failure
Message-Id: <20100118162412.9944c571.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta4 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__18_Jan_2010_16_24_12_+1100_IImoN4uRB0M+=9zo"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__18_Jan_2010_16_24_12_+1100_IImoN4uRB0M+=9zo
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jiri,

Today's linux-next build (x86_64_allmodconfig) failed like this:

drivers/mfd/ab3100-otp.c: In function 'show_otp':
drivers/mfd/ab3100-otp.c:101: error: dereferencing pointer to incomplete ty=
pe
drivers/mfd/ab3100-otp.c:104: error: implicit declaration of function 'seq_=
printf'
drivers/mfd/ab3100-otp.c:102: warning: unused variable 'err'
drivers/mfd/ab3100-otp.c: In function 'ab3100_otp_open':
drivers/mfd/ab3100-otp.c:116: error: implicit declaration of function 'sing=
le_open'
drivers/mfd/ab3100-otp.c:116: error: 'ab3100_otp_show' undeclared (first us=
e in this function)
drivers/mfd/ab3100-otp.c: At top level:
drivers/mfd/ab3100-otp.c:121: error: 'seq_read' undeclared here (not in a f=
unction)
drivers/mfd/ab3100-otp.c:122: error: 'seq_lseek' undeclared here (not in a =
function)
drivers/mfd/ab3100-otp.c:123: error: 'single_release' undeclared here (not =
in a function)
drivers/mfd/ab3100-otp.c: In function 'ab3100_otp_init_debugfs':
drivers/mfd/ab3100-otp.c:134: error: 'err' undeclared (first use in this fu=
nction)
drivers/mfd/ab3100-otp.c: In function 'ab3100_otp_exit_debugfs':
drivers/mfd/ab3100-otp.c:140: error: implicit declaration of function 'debu=
gfs_remove_file'

Exposed by commit 8dcafdf0475eb4633401d1f0bf0e0d35e4ebb9d5
"CONFIG_DEBUG_FS wrongly written as CONFIG_DEBUGFS".

I have reverted that commit for today.

That file probably just needs to include <linux/seq_file.h> ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__18_Jan_2010_16_24_12_+1100_IImoN4uRB0M+=9zo
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEUEARECAAYFAktT8HwACgkQjjKRsyhoI8xnAACfX51gj+p64K+7kdktnpgYgFX0
07oAl3+vgdCfsaTHLWwa0/0kgIsG/Bs=
=gVYC
-----END PGP SIGNATURE-----

--Signature=_Mon__18_Jan_2010_16_24_12_+1100_IImoN4uRB0M+=9zo--
