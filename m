Return-Path: <linux-kernel-owner+w=401wt.eu-S1754306AbZHCDcK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306AbZHCDcK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 23:32:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754001AbZHCDcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 23:32:09 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34822 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752831AbZHCDcI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 23:32:08 -0400
Date: Mon, 3 Aug 2009 13:32:03 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, Len Brown <len.brown@intel.com>
Subject: linux-next: rr tree build failure
Message-Id: <20090803133203.81174a8e.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__3_Aug_2009_13_32_03_+1000_ZN0O7xbHFyzTueXd"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__3_Aug_2009_13_32_03_+1000_ZN0O7xbHFyzTueXd
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rusty,

Today's linux-next build (x86_64 allmodconfig) failed like this:

drivers/acpi/osl.c: In function 'bind_to_cpu0':
drivers/acpi/osl.c:194: error: implicit declaration of function 'set_cpus_a=
llowed'

Caused by commit 74b5820808215f65b70b05a099d6d3c969b82689 ("ACPI: bind
workqueues to CPU 0 to avoid SMI corruption") (from the acpi tree but now
in Linus' tree) interacting with commit
17e249fb40c814a72f08c1356cb47ec9f87f81a8
("cpumask:remove-set_cpus_allowed") from the rr tree.

I have reverted that rr tree commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__3_Aug_2009_13_32_03_+1000_ZN0O7xbHFyzTueXd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkp2WjMACgkQjjKRsyhoI8y79QCfRDGhK5rmcrdac/VU6imRSAHj
hwMAn0yHVMMpVO7lfuwBIOYjhLbfguyt
=/sKd
-----END PGP SIGNATURE-----

--Signature=_Mon__3_Aug_2009_13_32_03_+1000_ZN0O7xbHFyzTueXd--
