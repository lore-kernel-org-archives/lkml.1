Return-Path: <linux-kernel-owner+w=401wt.eu-S1754527AbZFFNga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527AbZFFNga (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 09:36:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752202AbZFFNgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 09:36:23 -0400
Received: from mail8.sea5.speakeasy.net ([69.17.117.10]:36477 "EHLO
	mail8.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001AbZFFNgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 09:36:22 -0400
From: Frank Mori Hess <fmhess@speakeasy.net>
Reply-To: fmhess@users.sourceforge.net
To: Greg KH <greg@kroah.com>
Subject: Re: [BUILD FAILURE 01/04] Next June 04:PPC64 randconfig [drivers/staging/comedi/drivers.o]
Date: Sat, 6 Jun 2009 09:36:17 -0400
User-Agent: KMail/1.9.9
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ian Abbott <abbotti@mev.co.uk>,
       Frank Mori Hess <fmhess@users.sourceforge.net>,
       David Miller <davem@davemloft.net>, subrata@linux.vnet.ibm.com,
       sachinp@linux.vnet.ibm.com, sfr@canb.auug.org.au,
       linux-kernel@vger.kernel.org, Linuxppc-dev@ozlabs.org,
       linux-next@vger.kernel.org, paulus@samba.org,
       Geert.Uytterhoeven@sonycom.com, geert@linux-m68k.org
References: <20090605182625.24093.7808.sendpatchset@elm3a191.beaverton.ibm.com> <1244261806.31984.36.camel@pasglop> <20090606055103.GA9446@kroah.com>
In-Reply-To: <20090606055103.GA9446@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1334805.Ii2zXVS4iC";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200906060936.22322.fmhess@speakeasy.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1334805.Ii2zXVS4iC
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Saturday 06 June 2009, Greg KH wrote:
> Frank and Ian, any thoughts about the vmap call in the
> comedi_buf_alloc() call?  Why is it using PAGE_KERNEL_NOCACHE, and what
> is the prealloc_buf buffer used for?

It is a circular buffer used to hold data streaming either to or from a=20
board (for example when producing an analog output waveform).  Reads and=20
writes to the device files read/write to the circular buffer, plus a few=20
drivers do dma directly to/from it.  I personally don't have a problem=20
with requiring drivers to have their own dma buffers and making them copy=20
data between their private dma buffers and the main circular buffer.  I=20
guess the original design wanted to support zero-copy dma.


--nextPart1334805.Ii2zXVS4iC
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBKKnDT5vihyNWuA4URAm5TAJ9uya8bxVj7LuYrvxrcOgiaZyFqNACg1QmH
YUnOo4ea6+gFgDXBWgPrrd4=
=vopu
-----END PGP SIGNATURE-----

--nextPart1334805.Ii2zXVS4iC--
