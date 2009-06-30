Return-Path: <linux-kernel-owner+w=401wt.eu-S1760577AbZF3DRA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760577AbZF3DRA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 23:17:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752959AbZF3DQv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 23:16:51 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:40701 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751820AbZF3DQu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 23:16:50 -0400
Date: Tue, 30 Jun 2009 13:16:45 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Len Brown <lenb@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: linux-next: acpi tree build failure
Message-Id: <20090630131645.68c81f0b.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__30_Jun_2009_13_16_45_+1000_skK0OkCuvHYB+unJ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__30_Jun_2009_13_16_45_+1000_skK0OkCuvHYB+unJ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Len,

Today's linux-next build (powerpc ppc64_defconfig) failed like this:

  GEN     /scratch/sfr/powerpc_ppc64_defconfig/Makefile
drivers/platform/x86/Kconfig:353:error: found recursive dependency: EEEPC_L=
APTOP -> HOTPLUG_PCI -> EEEPC_LAPTOP

Caused by commit 6af05c22969dce2776375953131b56e9f4282848 ("eeepc-laptop:
Register as a pci-hotplug device") interacting with commit
44b3615b8cb3b016a49eb7ef4236e77a77793cec ("eeepc-laptop: Fix build
failure with HOTPLUG_PCI && !SYSFS") from Linus' tree.  Commit 6af05c2
from the acpi tree is the same as commit
2b121bc262fa03c94e653b2d44356c2f86c1bcdc in Linus' tree that 44b3615b is
fixing, so I have reverted the drivers/platform/x86/Kconfig part of
6af05c2 for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__30_Jun_2009_13_16_45_+1000_skK0OkCuvHYB+unJ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpJg50ACgkQjjKRsyhoI8zIogCfY0cACjhewkEEAJT2/HM7rF6i
8oUAoLpAjOvUgNfJXWm8+qM/BiVjWLoT
=i+FQ
-----END PGP SIGNATURE-----

--Signature=_Tue__30_Jun_2009_13_16_45_+1000_skK0OkCuvHYB+unJ--
