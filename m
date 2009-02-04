Return-Path: <linux-kernel-owner+w=401wt.eu-S1758066AbZBDRa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758066AbZBDRa7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 12:30:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754603AbZBDRai
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 12:30:38 -0500
Received: from mx71.mail.ru ([194.67.23.4]:50067 "EHLO mx71.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754298AbZBDRah (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 12:30:37 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: How to atomically disable shared device interrupt?
Date: Wed, 4 Feb 2009 20:30:28 +0300
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc3-1avb; KDE/4.2.0; i686; ; )
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart205633831.jsF9pub7Su";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200902042030.31580.arvidjaar@mail.ru>
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart205633831.jsF9pub7Su
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

May be I miss something obvious, but I do not see how is it possible to=20
disable interrupt while also avoiding either "stealing" someone else's=20
interrupt or getting "IRQ: nobody cared" occasionally.

So consider device that has status register that indicates events of=20
interest that happened in device. Those events may also generate=20
interrupt if interrupt generation is enabled; but they also are posted=20
even if interrupt generation is disabled.

So to check whether interrupt handler should handle (shared) interrupt=20
it a) checks that interrupts are currently enabled and b) that device=20
indicates pending events.

No consider what happens when interrupts are disabled on device.

CPU1                       CPU2
IRQ posted
                        disable device interrupts
handler checks IRQ enabled
handler sees IRQ disabled
handler ignores interrupt

Actually the same race happens during enabling of interrupts

CPU1                       CPU2
IRQ enabled
                      other device posts IRQ
handler checks
  IRQ enabled
  events pending
  start processing

but IRQ was posted by some other device in the first place.

Any idea?

--nextPart205633831.jsF9pub7Su
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkmJ0LcACgkQR6LMutpd94zr7wCeOSVkOWCLF0qW0e+NlKkrc6M0
x9wAn3ITjKH5+LsjxyQeeYD8FHSgiWdc
=yNPN
-----END PGP SIGNATURE-----

--nextPart205633831.jsF9pub7Su--
