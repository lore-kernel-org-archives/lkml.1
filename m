Return-Path: <linux-kernel-owner+w=401wt.eu-S1753729AbZKIDyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729AbZKIDyw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 22:54:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753571AbZKIDyv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 22:54:51 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:57227 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753478AbZKIDyv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 22:54:51 -0500
Date: Mon, 9 Nov 2009 14:54:51 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: pcmcia tree build warning
Message-Id: <20091109145451.c9f1c4c3.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__9_Nov_2009_14_54_51_+1100_zOx8ZIjvcYUrwOYF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__9_Nov_2009_14_54_51_+1100_zOx8ZIjvcYUrwOYF
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dominik,

Today's linux-next build (x86_64 allmodconfig) produced this warning:

drivers/char/pcmcia/cm4000_cs.c: In function 'cmm_ioctl':
/scratch/sfr/next/drivers/char/pcmcia/cm4000_cs.c:1630: warning: the frame =
size of 2176 bytes is larger than 2048 bytes

Introduced by commit 7194198b163c83725f52ce8e34b24cca053deea7 ("pcmcia:
use dynamic debug infrastructure, deprecate CS_CHECK (char)") which
unconditionalised "char *ioctl_names[CM_IOC_MAXNR + 1]" on the stack.
CM_IOC_MAXNR is 255, so this adds 2k to the stack frame just to allow the
printing of one of five ioctl names in a debug message.  It could be made
static ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__9_Nov_2009_14_54_51_+1100_zOx8ZIjvcYUrwOYF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkr3kosACgkQjjKRsyhoI8w6ZgCgvES2lGYx1ytihQj1qEI/ykd9
gQMAn3adEVFJE7tUbFBc6l67f6Kc4Zh4
=Yvcc
-----END PGP SIGNATURE-----

--Signature=_Mon__9_Nov_2009_14_54_51_+1100_zOx8ZIjvcYUrwOYF--
