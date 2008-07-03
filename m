Return-Path: <linux-kernel-owner+w=401wt.eu-S1755043AbYGCG7O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755043AbYGCG7O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 02:59:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752979AbYGCG5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 02:57:08 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:60300 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118AbYGCBho (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 21:37:44 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Intel Microcode loader, tg3 driver, and the -rc8-mmotd New World Order firmware...
From: Valdis.Kletnieks@vt.edu
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1215048758_4032P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 02 Jul 2008 21:32:38 -0400
Message-ID: <4534.1215048758@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1215048758_4032P
Content-Type: text/plain; charset=us-ascii

I built the -rc8-mmotd kernel, and built it with 'CONFIG_FIRMWARE_IN_KERNEL=n'.
Lo and behold, the microcode.ko was now doing a request_firmware for
'intel-ucode/06-0f-06' (which makes sense, the Core2 Duo in this laptop is
family 6, model 15, stepping 6).  However, what I had in /lib/firmware was
the Intel-distributed 'microcode.dat' with updates for all the CPUs (which
used to work in times past).

What's the magic incantation to take the microcode.dat and create something
that the firmware driver is willing to use, or is this all borked up and
I need to do a major rethink or fix my config?

Another minor annoyance - the tg3 driver, when builtin to the kernel, wouldn't
load the microcode in this config. It complained it couldn't get 'tigon/tg3_tos.bin',
but that's almost certainly an issue with Fedora's 'nash' firmware support and/or
my understanding of it - I got *that* part working by dropping the file into
/lib/firmware/tigon and building the driver as a module. Fortunately, I don't
need the tg3 driver to boot far enough to get a full udev running.


--==_Exmh_1215048758_4032P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFIbCw2cC3lWbTT17ARAsxTAKDvRBFaSHQzYZRjNL8A2QquNZFRvwCg2jiO
yvR4JHM2iJu94kKnypKWjfs=
=uQkU
-----END PGP SIGNATURE-----

--==_Exmh_1215048758_4032P--
