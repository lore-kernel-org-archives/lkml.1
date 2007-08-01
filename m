Return-Path: <linux-kernel-owner+w=401wt.eu-S1758883AbXHADET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758883AbXHADET (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 23:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752150AbXHADEH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 23:04:07 -0400
Received: from norsk.toidinamai.de ([78.47.249.60]:40780 "EHLO
	norsk.toidinamai.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997AbXHADEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 23:04:05 -0400
X-Greylist: delayed 1159 seconds by postgrey-1.27 at vger.kernel.org; Tue, 31 Jul 2007 23:04:05 EDT
Message-ID: <46AFF390.10103@benkstein.net>
Date: Wed, 01 Aug 2007 04:44:32 +0200
From: Frank Benkstein <frank@benkstein.net>
User-Agent: Icedove 1.5.0.12 (X11/20070607)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: VT_PROCESS, VT_LOCKSWITCH capabilities
References: <46AFB62E.2080303@benkstein.net>
In-Reply-To: <46AFB62E.2080303@benkstein.net>
X-Enigmail-Version: 0.94.3.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig083DEEFC6FA53F3FCEE2BFAA"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig083DEEFC6FA53F3FCEE2BFAA
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Frank Benkstein wrote:
> I wonder why there are different permissions needed for VT_PROCESS
> (access to the current virtual console) and VT_LOCKSWITCH
> (CAP_SYS_TTY_CONFIG).

To be more direct:

require CAP_SYS_TTY_CONFIG for VT_SETMODE as its essentially the same as
VT_LOCKSWITCH and said capability is already required there

diff --git a/drivers/char/vt_ioctl.c b/drivers/char/vt_ioctl.c
index c6f6f42..7034a68 100644
--- a/drivers/char/vt_ioctl.c
+++ b/drivers/char/vt_ioctl.c
@@ -662,7 +662,7 @@ int vt_ioctl(struct tty_struct *tty, struct file * fi=
le,
        {
                struct vt_mode tmp;

-               if (!perm)
+               if (!perm || !capable(CAP_SYS_TTY_CONFIG))
                        return -EPERM;
                if (copy_from_user(&tmp, up, sizeof(struct vt_mode)))
                        return -EFAULT;

--=20
GPG (Mail): 7093 7A43 CC40 463A 5564  599B 88F6 D625 BE63 866F
GPG (XMPP): 2243 DBBA F234 7C5A 6D71  3983 9F28 4D03 7110 6D51


--------------enig083DEEFC6FA53F3FCEE2BFAA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGr/OZiPbWJb5jhm8RAgiSAJ4udC2UnWBU9SvgljLMB52EV3MpUQCaA//A
rboFvml/TpbenbfrSK3/6N4=
=gQKV
-----END PGP SIGNATURE-----

--------------enig083DEEFC6FA53F3FCEE2BFAA--
