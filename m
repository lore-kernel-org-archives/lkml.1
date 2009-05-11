Return-Path: <linux-kernel-owner+w=401wt.eu-S1753839AbZEKD50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839AbZEKD50 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 23:57:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751932AbZEKD5Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 23:57:16 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:50829 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751402AbZEKD5Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 23:57:16 -0400
Date: Mon, 11 May 2009 13:57:07 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: qingtao.cao@windriver.com
Cc: Andrew Morton <akpm@linux-foundation.org>, norsk5@yahoo.com,
       bluesmoke-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [v0 PATCH 1/1] Use dev_name() for AMD8111/AMD8131 EDAC driver
Message-Id: <20090511135707.21e27a5a.sfr@canb.auug.org.au>
In-Reply-To: <4A0791D1.5040303@windriver.com>
References: <1241660858-21105-1-git-send-email-qingtao.cao@windriver.com>
	<1241660858-21105-2-git-send-email-qingtao.cao@windriver.com>
	<20090507145722.b2d89e11.akpm@linux-foundation.org>
	<4A0791D1.5040303@windriver.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__11_May_2009_13_57_07_+1000_7n1Bruf2zaZ7aaS4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__11_May_2009_13_57_07_+1000_7n1Bruf2zaZ7aaS4
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Harry,

On Mon, 11 May 2009 10:47:45 +0800 Harry Ciao <qingtao.cao@windriver.com> w=
rote:
>
> Andrew Morton wrote:
> >
> > The drivers break x86-64 allmodconfig:
> >
> > drivers/edac/amd8111_edac.c: In function 'amd8111_lpc_bridge_init':
> > drivers/edac/amd8111_edac.c:260: error: implicit declaration of functio=
n '__do_inb'
> > drivers/edac/amd8111_edac.c:274: error: implicit declaration of functio=
n '__do_outb'
>=20
> Ah, this is because __do_inb so far only supported on PPC arch:
>=20
> cao@cao-desktop:/work/community/linux-2.6/arch$ grep __do_inb * -r
> powerpc/include/asm/io.h:#define __do_inb(port)        _rec_inb(port)
> powerpc/include/asm/io.h:#define __do_inb(port)       =20
> readb((PCI_IO_ADDR)_IO_BASE + port);
> cao@cao-desktop:/work/community/linux-2.6/arch$
>=20
> So far the only machine that hosts AMD8111 chip is Maple, however,=20
> AMD8111 is of Hypertransport device and not necessarily depends on Maple=
=20
> nor PPC, so its Kconfig option is only depended on EDAC && EDAC_MC_EDAC=20
> && PCI.
>=20
> I think I could put some words into its Kconfig help section that=20
> AMD8111 should be selected on Maple now.
>=20
> What do you think? thanks!

You need to make them depend on CONFIG_PPC (or use a different i/o
interface) since the automated builds will enable them for
all{mod,yes}config builds.  Some explanation of the dependency is, of
course, appropriate.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__11_May_2009_13_57_07_+1000_7n1Bruf2zaZ7aaS4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkoHohMACgkQjjKRsyhoI8xefQCguowWqqD3qiCd48ohrnheGjtk
T/YAoLJsTzjE35O5eI6nmUXq1v0AvZVP
=YthK
-----END PGP SIGNATURE-----

--Signature=_Mon__11_May_2009_13_57_07_+1000_7n1Bruf2zaZ7aaS4--
