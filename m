Return-Path: <linux-kernel-owner+w=401wt.eu-S1755168AbZFOGkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755168AbZFOGkg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 02:40:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750926AbZFOGk0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 02:40:26 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:45013 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750794AbZFOGkZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 02:40:25 -0400
Date: Mon, 15 Jun 2009 16:40:22 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       "David S. Miller" <davem@davemloft.net>
Subject: linux-next: rr tree build failure
Message-Id: <20090615164022.9b06b579.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__15_Jun_2009_16_40_22_+1000_zp=SPhLhjkI9+2MH"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__15_Jun_2009_16_40_22_+1000_zp=SPhLhjkI9+2MH
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rusty,

Today's linux-next build (sparc64 defconfig) failed like this:

arch/sparc/mm/init_64.c: In function 'paging_init':
arch/sparc/mm/init_64.c:1802: error: 'CPU_MASK_ALL_PTR' undeclared (first u=
se in this function)
arch/sparc/kernel/smp_64.c: In function 'setup_per_cpu_areas':
arch/sparc/kernel/smp_64.c:1541: error: 'CPU_MASK_ALL_PTR' undeclared (firs=
t use in this function)

Caused by commit 3360ebad15b16eac7b0205595d6fe561716725c5
("cpumask:remove-CPU_MASK_ALL_PTR") from the rr tree interacting with
commits 21bc149d59288fe43d1ba18a59d874ba6a5f1db9 ("sparc64: Make
mdesc_fill_in_cpu_data take a cpumask_t pointer") and
63750a3dc53a87a1f5ca42101ea88578b934ab52 ("sparc64: Defer cpu_data()
setup until end of per-cpu data initialization") from the sparc tree.

Rusty, I assume that there is something that Dave can use in the sparc
tree already instead of CPU_MASK_ALL_PTR (cpu_all_mask?).

I have reverted the rr tree patch for today - after reverting these other
patches as well:

cpumask:move-obsolete-functions-to-end-of-header
cpumask:remove-unused-deprecated-functions
cpumask:remove-cpu_mask_all

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__15_Jun_2009_16_40_22_+1000_zp=SPhLhjkI9+2MH
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAko17NYACgkQjjKRsyhoI8zCPwCggbl8jnlXoDPAsNINMtu6/+ZQ
UHgAnA8hZfRQoxcSNO2P5ew8v38EAekq
=SfJ2
-----END PGP SIGNATURE-----

--Signature=_Mon__15_Jun_2009_16_40_22_+1000_zp=SPhLhjkI9+2MH--
