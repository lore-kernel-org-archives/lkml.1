Return-Path: <linux-kernel-owner+w=401wt.eu-S1753638AbXDCTZI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638AbXDCTZI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 15:25:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966105AbXDCTZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 15:25:07 -0400
Received: from mta-2.ms.rz.RWTH-Aachen.DE ([134.130.7.73]:36816 "EHLO
	mta-2.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753622AbXDCTZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 15:25:05 -0400
Date: Tue, 03 Apr 2007 21:24:02 +0200
From: markus reichelt <ml@mareichelt.de>
Subject: Strange performance drop with reconnected external drives
To: linux-crypto@nl.linux.org
Cc: linux-kernel@vger.kernel.org
Mail-followup-to: linux-crypto@nl.linux.org, linux-kernel@vger.kernel.org
Message-id: <20070403192402.GE4034@tatooine.rebelbase.local>
Organization: still stuck in reorganization mode
MIME-version: 1.0
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary=HG+GLK89HZ1zG0kk
Content-disposition: inline
X-PGP-Key: 0xC2A3FEE4
X-PGP-Fingerprint: FFB8 E22F D2BC 0488 3D56  F672 2CCC 933B C2A3 FEE4
X-Request-PGP: http://mareichelt.de/keys/c2a3fee4.asc
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--HG+GLK89HZ1zG0kk
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

I'm encountered the following scenario:

Several encrypted external USB HDDs were mounted (via a hub) when
Something Bad happened: Accidentially the cable connecting the hub to
the laptop was disconnected. The devices used at that time were
/dev/sda and /dev/sdb.

Logfiles showed the usual USB stuff: disconnections, nothing really
worrysome, no oops, no bugs.

So I almost immediately replugged one drive and mounted it again, the
device used was /dev/sdc and performance was as usual. A few minutes
later I replugged the other drive and the device it was associated
with was /dev/sda. There were no error messages, the mount operation
proceeded normally, filesystem recovery went smoothly. The filesystem
was not corrupted during normal use afterwards.

I don't think the hub is the issue, but the recycling of used
/dev/sd* devices:

The really strange thing was the considerable loss in performance.
Writing files at ~ 1,5 MB/s was about a 10th of the normal
throughput. Reading was also slow. I noticed that the drive's LED was
blinking slower than usual during drive access, as if there was a
delay of ~ 100 ms during write operations.

The kernel used was 2.6.21-rc3 with recent loop-aes v 3.1f.

I strongly suspect the code of handling SCSI-compatible devices (or
whatever the code handling external USB HDDs is called exactly ;-).
Earlier kernels (2.6.16.x) just used the next available devices e.g.
/dev/sdc & /dev/sdd and did not recycle ones that had been in use
already.

Is there a way (apart from going back to earlier kernels) to get the
old behaviour back? I'd very much like that. A .config option, boot
parameter, patch, anything?

--=20
left blank, right bald

--HG+GLK89HZ1zG0kk
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFGEqnSLMyTO8Kj/uQRAod6AJ4hrolq/W5PRjQ8uAsIaPJ5Xcf33gCfacxY
U/oGOc7Y0XgQUpaht/NGGmI=
=awrI
-----END PGP SIGNATURE-----

--HG+GLK89HZ1zG0kk--

