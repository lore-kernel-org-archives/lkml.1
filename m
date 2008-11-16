Return-Path: <linux-kernel-owner+w=401wt.eu-S1752794AbYKPMOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794AbYKPMOY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 07:14:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751900AbYKPMOP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 07:14:15 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:36176 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751888AbYKPMOO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 07:14:14 -0500
Date: Sun, 16 Nov 2008 23:13:42 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kyle McMartin <kyle@mcmartin.ca>, <linux-parisc@vger.kernel.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: linux-next: parisc build failure
Message-Id: <20081116231342.0cd747bd.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sun__16_Nov_2008_23_13_42_+1100_n+AZsqsfjkK73wvx"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__16_Nov_2008_23_13_42_+1100_n+AZsqsfjkK73wvx
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Kyle,

Today's linux-next build (parisc allmodconfig) failed like this:

In file included from drivers/serial/mux.c:38:
include/linux/serial_core.h: In function 'uart_handle_sysrq_char':
include/linux/serial_core.h:450: error: 'struct uart_port' has no member na=
med 'sysrq'
include/linux/serial_core.h:451: error: 'struct uart_port' has no member na=
med 'sysrq'
include/linux/serial_core.h:451: error: 'struct uart_port' has no member na=
med 'sysrq'
include/linux/serial_core.h:453: error: 'struct uart_port' has no member na=
med 'sysrq'
include/linux/serial_core.h:456: error: 'struct uart_port' has no member na=
med 'sysrq'
include/linux/serial_core.h:473: error: 'struct uart_port' has no member na=
med 'sysrq'
include/linux/serial_core.h:474: error: 'struct uart_port' has no member na=
med 'sysrq'
include/linux/serial_core.h:477: error: 'struct uart_port' has no member na=
med 'sysrq'

This is happening in mainline as well. In fact, this has been happening
back as far as I have results (Aug 27).  The sysrq element of struct
uart_port is dependent on CONFIG_SERIAL_CORE_CONSOLE while the references
failing above are dependent on SUPPORT_SYSRQ which is defined if
CONFIG_MAGIC_SYSRQ is defined in mux.c.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sun__16_Nov_2008_23_13_42_+1100_n+AZsqsfjkK73wvx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkgDnYACgkQjjKRsyhoI8zyIwCdF+noH6S5a7Ys3tJ8fInPNI2Q
0/UAoJQ6t69Tza0sqB8l6PcCoDH7A9gM
=1jhk
-----END PGP SIGNATURE-----

--Signature=_Sun__16_Nov_2008_23_13_42_+1100_n+AZsqsfjkK73wvx--
