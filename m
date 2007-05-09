Return-Path: <linux-kernel-owner+w=401wt.eu-S1758459AbXEIQwn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758459AbXEIQwn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 12:52:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756796AbXEIQwZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 12:52:25 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:59391 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756736AbXEIQwY (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 12:52:24 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-mm2 - hanging with initcall_debug and netconsole
In-Reply-To: Your message of "Wed, 09 May 2007 01:23:22 PDT."
             <20070509012322.199f292b.akpm@linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <20070509012322.199f292b.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1178729509_3418P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 09 May 2007 12:51:49 -0400
Message-ID: <6257.1178729509@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1178729509_3418P
Content-Type: text/plain; charset=us-ascii

On Wed, 09 May 2007 01:23:22 PDT, Andrew Morton said:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21/2.6.21-mm2/

So I have a canned grub config for booting with netconsole, initcall_debug, and
all that fun stuff.  Tried it on 21-mm2, and it wedged up hard here:

[   66.842587] TCP: Hash tables configured (established 131072 bind 65536)
[   66.842591] TCP reno registered
[   66.845424] initcall 0xffffffff806ff7c6: inet_init+0x0/0x34d() returned 0.
[   66.845437] initcall 0xffffffff806ff7c6 ran for 14 msecs: inet_init+0x0/0x34d()
[   66.845443] Calling initcall 0xffffffff806e28eb: populate_rootfs+0x0/0xea()
[   66.845566] checking if image is initramfs... it is
[   66.978816] Freeing initrd memory: 1824k freed
[   66.979130] initcall 0xffffffff806e28eb: populate_rootfs+0x0/0xea() returned 0.
[   66.979141] initcall 0xffffffff806e28eb ran for 127 msecs: populate_rootfs+0x0/0xea()
[   66.979146] Calling initcall 0xffffffff8020cf78: time_init_device+0x0/0x22()

Total brick, no sysrq.  Had to power cycle.  Oddly enough, it boots OK
with the same grub line, but minus 'earlyprintk=vga initcall_debug':

[   26.768561] TCP: Hash tables configured (established 131072 bind 65536)
[   26.768566] TCP reno registered
[   26.771502] checking if image is initramfs... it is
[   26.904772] Freeing initrd memory: 1824k freed
[   26.910854] audit: initializing netlink socket (disabled)
[   26.910874] audit(1178725351.514:1): initialized
[   26.911253] VFS: Disk quotas dquot_6.5.1

(My guess is that initcall_debug is trashing some timing constraint that
time_init_device is relying on?)

--==_Exmh_1178729509_3418P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGQfwlcC3lWbTT17ARAmplAKClgMCKHYShWNjh+mbdiAK23mdP1wCgrMxe
rYspkGytTGb702S/X7rZdxM=
=AsZ5
-----END PGP SIGNATURE-----

--==_Exmh_1178729509_3418P--
