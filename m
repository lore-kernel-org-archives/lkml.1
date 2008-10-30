Return-Path: <linux-kernel-owner+w=401wt.eu-S1758851AbYJ3Ss3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758851AbYJ3Ss3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 14:48:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758189AbYJ3SsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 14:48:15 -0400
Received: from mx38.mail.ru ([194.67.23.16]:59442 "EHLO mx38.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757703AbYJ3SsO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 14:48:14 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.28-rc2: initrd fails to create bloc devices
Date: Thu, 30 Oct 2008 21:48:10 +0300
User-Agent: KMail/1.9.10
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1785610.ydKtPmfaHL";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200810302148.10761.arvidjaar@mail.ru>
X-Spam: Not detected
X-Mras: OK
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1785610.ydKtPmfaHL
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

I am using Mandriva which has mkinitrd based on RedHat (current version
in 6.0.63). With 2.6.28 it sporadically fails (or I should rather say,
it sporadically manages) to created block devices in initrd which of
course prevents kernel from finding root later.

The control flow is

1. mkblkdevs (I assume, it is for any built-in driver)
2. load modules, needed for disk access/file system
3. mkblkdevs again
4. mount real root etc etc etc

First mkblkdevs will initially traverse /sys/block and create all it
finds there. It is empty in my case (no built-in driver).

Second mkblkdev will notice that device tree was already initialized
and will not descend into /sys/block but rather listen and process to
hotplug events generated in step 2. At least that is how I interpret
nash code.

So it looks like something has changed between 2.6.27 and 2.6.28 regarding
event delivery. It looks like race condition. I do not see any pattern
except after several attempts it would suddenly boot.

I tried both IDE and PATA, both show the same problem.

Any idea?

-andrey

--nextPart1785610.ydKtPmfaHL
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkkKAWoACgkQR6LMutpd94yvXQCbBJcjvOjh+PmqzO+M9KGclpSY
+iUAn2qVeLpn5799dZaAOiMBAwowYhO8
=3Tfd
-----END PGP SIGNATURE-----

--nextPart1785610.ydKtPmfaHL--
