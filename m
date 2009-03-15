Return-Path: <linux-kernel-owner+w=401wt.eu-S1755731AbZCPPbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755731AbZCPPbt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 11:31:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754961AbZCPPbe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 11:31:34 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:36137 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754679AbZCPPbd (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 11:31:33 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: linux-next - tty_io.c change breaks /dev/console
From: Valdis.Kletnieks@vt.edu
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1237152004_9023P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sun, 15 Mar 2009 17:20:04 -0400
Message-ID: <12675.1237152004@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1237152004_9023P
Content-Type: text/plain; charset=us-ascii

At boot, all attempts to open /dev/console failed.  dmesg shows:

Warning: unable to open an initial console.

from init/main.c:

        if (sys_open((const char __user *) "/dev/console", O_RDWR, 0) < 0)
                printk(KERN_WARNING "Warning: unable to open an initial console.\n");

problem originally hit in -mmotm, traced down to linux-next.
git bisect of linux-next find this:

31f8326f981117fc548d292656fa8dbed28bc42b is first bad commit
commit 31f8326f981117fc548d292656fa8dbed28bc42b
Author: Alan Cox <alan@lxorguk.ukuu.org.uk>
Date:   Thu Mar 12 10:00:15 2009 +1100

    tty-fix-mismatch-in-lookup-han
    
    The lookup methods return NULL or a pointer. The caller expects an ERR_PTR.
    It seems to make sense to just use NULL and return -ENODEV here as it keeps
    the code simple and clean and the way it always used to work (effectively)
    before the restructure
    
    Problem noticed by Jiri Slaby.
    
    Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>

:040000 040000 e6b1ddf54e63b5b7be2bfa07c6a21a9657e91d27 1ef01e18f00a713c3a0299725c6b594da5fcffbe M      drivers

Reverting this one commit made things start working again.  I admit not
understanding why this commit broke the sys_open().


--==_Exmh_1237152004_9023P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJvXEEcC3lWbTT17ARAjMBAKDEq57ee8D0IHzzZEH29XK6hmY3ZQCgkAEh
ggFbqaD71dkz0SkGvDcT/Lg=
=o6/c
-----END PGP SIGNATURE-----

--==_Exmh_1237152004_9023P--
