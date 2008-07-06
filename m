Return-Path: <linux-kernel-owner+w=401wt.eu-S1758723AbYGFSNn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758723AbYGFSNn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 14:13:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755107AbYGFSNe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 14:13:34 -0400
Received: from server.drzeus.cx ([85.8.24.28]:33055 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754224AbYGFSNd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 14:13:33 -0400
Date: Sun, 6 Jul 2008 20:13:26 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: marcel@holtmann.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2 V2] MMC: cleanup endianity conversions and style
 problems
Message-ID: <20080706201326.5a9feda1@mjolnir.drzeus.cx>
In-Reply-To: <C07C4589BE74A34981C3C3525EE1F80104198D56@hasmsx412.ger.corp.intel.com>
References: <1215276725-15588-1-git-send-email-tomas.winkler@intel.com>
	<1215276725-15588-2-git-send-email-tomas.winkler@intel.com>
	<20080706012631.5e43624c@mjolnir.drzeus.cx>
	<C07C4589BE74A34981C3C3525EE1F80104198D56@hasmsx412.ger.corp.intel.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-703-1215368011-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-703-1215368011-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 6 Jul 2008 02:54:56 +0300
"Winkler, Tomas" <tomas.winkler@intel.com> wrote:

> >
> >NAK in its current form. The data needs to be DMA:able, which means
> >that the stack cannot be used.
> >
> I see, anyway only the last hunk is problematic in this matter.
> =20

All of them actually. The other registers are possible DMA victims when
on an SPI host (which is also the only code path your patch modifies).

> So we need to define raw_src as __be32 and translate it in
> mmc_decode_src=20

I'd prefer if raw_scr is in native endian. The conversions should be
done at the entry/exit points IMO.

> I will get to the MMC spec only tomorrow but it sound strange that SDIO
> registers are in little endian and these are in big.

I'd say that it's SDIO that's the odd man. Protocols tend to use big
endian after all. A reason for the difference is probably that SDIO
should be regarded as a register interface, not as a bus protocol.
Different worlds, different norms...

Rgds
--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-703-1215368011-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkhxC0oACgkQ7b8eESbyJLgh5ACgr/n1oDiTWo/REM+Dihwz5XSc
NeoAoJdh07o7IBd/s9j09hfcsqQaheo7
=IINm
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-703-1215368011-0001-2--
