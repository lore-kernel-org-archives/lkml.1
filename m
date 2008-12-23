Return-Path: <linux-kernel-owner+w=401wt.eu-S1755470AbYLWEfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470AbYLWEfp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 23:35:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754439AbYLWEfg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 23:35:36 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:39923 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754359AbYLWEfg (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 23:35:36 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>, Ying Han <yinghan@google.com>
Cc: linux-kernel@vger.kernel.org
Subject: 28-rc9-mmotm1219 page_fault-retry-with-nopage_retry.patch hoses xmms
From: Valdis.Kletnieks@vt.edu
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1230006925_3683P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 22 Dec 2008 23:35:25 -0500
Message-ID: <4576.1230006925@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1230006925_3683P
Content-Type: text/plain; charset="us-ascii"
Content-Id: <4564.1230006916.1@turing-police.cc.vt.edu>

OK, here's a weird one.. ;)

Dell Latitude D820 laptop, x86_64 kernel and userspace.

Symptom: The 'xmms' media player will consistently (every time) get stuck and
keep repeating the first 1 second or so of the song over and over (sounding
very similar to how an audio card will keep looping the ring buffer if the
system crashes). However, xmms is responsive.  It claims it's making progress
through the song - and the spectrum analyzer display is changing, *not* looping
the same second over and over.

The spectrum analyzer convinces me that the xmms thread reading from disk is
getting new data, but I'm unable to tell if the looping is happening on the
xmms->pulseaudio handoff or the pulseaudio->ALSA side.

Bisect results:

shmem-unify-regular-and-tiny-shmem.patch        GOOD
#
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch        BAD



--==_Exmh_1230006925_3683P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJUGqNcC3lWbTT17ARArJpAJwOiaoYgJBKMTpWgeKpG7DAgi24/QCgwc0K
+Wp/FS8Z2c52aEYt/DXdWko=
=e24m
-----END PGP SIGNATURE-----

--==_Exmh_1230006925_3683P--
