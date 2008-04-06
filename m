Return-Path: <linux-kernel-owner+w=401wt.eu-S1755507AbYDFKWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507AbYDFKWu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 06:22:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751909AbYDFKWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 06:22:39 -0400
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:34609 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751766AbYDFKWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 06:22:38 -0400
From: Ian Campbell <ijc@hellion.org.uk>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       virtualization@lists.linux-foundation.org
In-Reply-To: <86802c440804060003q43f14122vd527514daf77cb89@mail.gmail.com>
References: <1202936100-30859-1-git-send-email-ijc@hellion.org.uk>
	 <9d3a007a2bfe774201b6deed5115a0cc8182bbb4.1202935389.git.ijc@hellion.org.uk>
	 <86802c440804060003q43f14122vd527514daf77cb89@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-1lmwKiTOPsysIfgWLmhL"
Date: Sun, 06 Apr 2008 11:22:24 +0100
Message-Id: <1207477344.28696.25.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
X-SA-Exim-Connect-IP: 192.168.1.5
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [PATCHv3 1/3] x86: use ELF format in compressed images.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-1lmwKiTOPsysIfgWLmhL
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Sun, 2008-04-06 at 00:03 -0700, Yinghai Lu wrote:
> so will cost every bzImage extra memory copy? that could be 18M or
> even more big.

Is it a huge deal for something that happens exactly once on boot? How
does the time take compare with the time to do the decompression?

18M seems like an awfully large kernel image to me. My distro (Debian)
kernel is more like 3M uncompressed. If someone was interested in fast
booting presumably they would either build a kernel with exactly what
they need.

> wonder if can have one some other kind elf format, and offset load
> address to avoid that mem copy.

I guess you could reduce the load address by sizeof(headers) and add a
dest =3D=3D (output + phdr->p_offset) test before the copy.

Another possibility, which is much more complex, is that the ELF parsing
could be integrated into the decompressor such that the data is
decompressed into the correct location directly.

Ian.

--=20
Ian Campbell

People who have no faults are terrible; there is no way of taking
advantage of them.

--=-1lmwKiTOPsysIfgWLmhL
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBH+KRgM0+0qS9rzVkRAvSqAJ9S4A+gBdV4Q3L81u518oe8UHrCVwCfT4fe
PWSbeCIcOp8/OABj5DEZaNI=
=OLlf
-----END PGP SIGNATURE-----

--=-1lmwKiTOPsysIfgWLmhL--

