Return-Path: <linux-kernel-owner+w=401wt.eu-S1753286AbXDERDI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286AbXDERDI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 13:03:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753310AbXDERDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 13:03:08 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:57231 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286AbXDERDG (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 13:03:06 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc5-mm4
In-Reply-To: Your message of "Mon, 02 Apr 2007 22:47:45 PDT."
             <20070402224745.71a25af7.akpm@linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <20070402224745.71a25af7.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1175792579_3378P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 05 Apr 2007 13:02:59 -0400
Message-ID: <7763.1175792579@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1175792579_3378P
Content-Type: text/plain; charset=us-ascii

On Mon, 02 Apr 2007 22:47:45 PDT, Andrew Morton said:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc5/2.6.21-rc5-mm4/

Am seeing an Oops 'cannot handle kernel paging request' during late
system startup, hand-copied traceback follows:

avc_has_perm_noaudit+0x2bf/0x506
avc_has_perm+0x2b/0x5b
selinux_socket_stream_connect+0x7e/0xc3
unix_stream_connect+0x202/0x3f3
sys_connect+0x7e/0xa4
tracesys+0xde/0xe1

I've not identified exactly when it happens, but it's towards the very end of
handling /etc/rc5.d, it's already up to the S98's.  Odd thing is it only happens
when I start with RedHat's 'graphical boot', and may be related to the shutdown
of the X server that's displaying the boot progress preparing to launch the
X server for gdm logins (as I'm also seeing a hang sometimes when shutting
down - so it is possibly a "shutting down X server nukes system" bug).

Figured I'd toss this heads-up in case it rings any bells, while I go do
the bisection dance on -rc5-mm4 (-mm2 is OK, and -mm3 doesn't boot for me
for other reasons I didn't chase down before -mm4 came out and fixed it, so
I have a ways to bisect)

--==_Exmh_1175792579_3378P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGFSvDcC3lWbTT17ARAh0KAJ0fxyYF/5iRPpJT4ygvDk9peAVMrgCffXQI
EeLosdbtp40ekInBR8O5g4o=
=mR2L
-----END PGP SIGNATURE-----

--==_Exmh_1175792579_3378P--
