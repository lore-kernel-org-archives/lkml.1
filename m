Return-Path: <linux-kernel-owner+w=401wt.eu-S1752668AbZHBL6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668AbZHBL6h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 07:58:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752293AbZHBL6g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 07:58:36 -0400
Received: from mail.open.by ([193.232.92.17]:59018 "EHLO post.open.by"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751806AbZHBL6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 07:58:35 -0400
X-SpamTest-Envelope-From: sergey.senozhatsky@mail.by
X-SpamTest-Group-ID: 00000000
X-SpamTest-Info: Profiles 9222 [Aug 2 2009]
X-SpamTest-Info: {relay has no DNS name}
X-SpamTest-Method: none
X-SpamTest-Rate: 55
X-SpamTest-SPF: softfail
X-SpamTest-Status: Not detected
X-SpamTest-Status-Extended: not_detected
X-SpamTest-Version: SMTP-Filter Version 3.0.0 [0284], KAS30/Release
Date: Sun, 2 Aug 2009 15:01:20 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, linux-kernel@vger.kernel.org
Subject: WARNING at: drivers/char/tty_ldisc.c
Message-ID: <20090802120120.GA3097@localdomain.by>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AhhlLboLdkugWU4S"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AhhlLboLdkugWU4S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Linus, Ogawa,
Looks like we have one more bug in tty code:
'shutdown -r now' in 'single' user mode gives following trace:

WARNING at: drivers/char/tty_ldisc.c:209 tty_ldisc_put+0x95/0xa0
---
?printk+0x23/0x36
warn_slowpath_common+0x78/0xa0
?tty_ldisc_put+0x95/0xa0
?tty_ldisc_put+0x95/0xa0
warn_slowpath_null+0x21/0x40
tty_ldisc_put+0x95/0xa0
tty_ldisc_hangup+0xfc/0x1f0
do_tty_hangup+0x131/0x380
disassociate_ctty+0x50/0x210
do_exit+0x6b8/0x700
?put_lock_stats+0x18/0x50
?lock_release_holdtime+0xb2/0x190
?_spin_unlock_irq+0x30/0x70
?trace_hardirqs_on_caller+0x14c/0x1a0
do_group_exit+0x45/0xb0
get_signal_to_deliver+0x226/0x410
do_notify_resume+0xc1+0xa90
?trace_hardirqs_on+0x19/0x40
?_spin_unlock_irqrestore+0x47/0x90
?remove_wait_queue+0x47/0x70
?do_wait+0x19d/0x310
?defult_wake_function+0x0/0x40
?sys_wait4+0xa1/0x100
work_notifysig+0x13/0x19

//There is no trace in syslog, so given one is 'copy-paste' from the paper.

	Sergey
--AhhlLboLdkugWU4S
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iJwEAQECAAYFAkp1gBAACgkQfKHnntdSXjRcfQQA0PfDUZwf7POayDdSPg59irZo
LxjqwisgtyfggebIN98Pa8JxAxmn9zINtNx2ZWe9+/3lDGs/A/nlIj76QlHYhCxJ
baBQgEI8UeRt/5tCNqJOwavF7t1LUcY5Xolbu1CfYnizsEpVqaTiQJE68eFu7uuc
//5CUOQTXJtKlX6DJkI=
=T1Vg
-----END PGP SIGNATURE-----

--AhhlLboLdkugWU4S--
