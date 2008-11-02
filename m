Return-Path: <linux-kernel-owner+w=401wt.eu-S1754732AbYKBVse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732AbYKBVse (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 16:48:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754030AbYKBVs0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 16:48:26 -0500
Received: from os.inf.tu-dresden.de ([141.76.48.99]:49457 "EHLO
	os.inf.tu-dresden.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740AbYKBVsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 16:48:25 -0500
X-Greylist: delayed 2252 seconds by postgrey-1.27 at vger.kernel.org; Sun, 02 Nov 2008 16:48:25 EST
Date: Sun, 2 Nov 2008 22:09:29 +0100
From: "Udo A. Steinberg" <udo@hypervisor.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Contention on e1000 NVM
Message-ID: <20081102220929.38385d60@laptop.hypervisor.org>
X-Mailer: X-Mailer 5.0 Gold
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/wpzfgOKJbvY4VGfb.yFNkIJ";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/wpzfgOKJbvY4VGfb.yFNkIJ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hello,

I've just hit a case of contention on the e1000 NVM with a vanilla 2.6.27
kernel, which resulted in the following warning being logged. So far I have
not been able to reproduce it a second time. I doubt the binary nvidia
module had anything to do with it, though.

Cheers,

	- Udo


Nov  2 21:52:17 laptop dhcpcd[1477]: timed out waiting for a valid DHCP ser=
ver response
Nov  2 21:52:17 laptop dhcpcd[1477]: timed out waiting for a valid DHCP ser=
ver response
Nov  2 21:52:18 laptop kernel: ------------[ cut here ]------------
Nov  2 21:52:18 laptop kernel: WARNING: at drivers/net/e1000e/ich8lan.c:403=
 e1000_acquire_swflag_ich8lan+0x31/0xa7()
Nov  2 21:52:18 laptop kernel: e1000e mutex contention. Owned by pid -1
Nov  2 21:52:18 laptop kernel: Modules linked in: nvidia(P)
Nov  2 21:52:18 laptop kernel: Pid: 1477, comm: dhcpcd Tainted: P          =
2.6.27 #1
Nov  2 21:52:18 laptop kernel:  [<c011d668>] warn_slowpath+0x61/0x86       =
        =20
Nov  2 21:52:18 laptop kernel:  [<c0115f18>] sched_slice+0x45/0x4b =20
Nov  2 21:52:18 laptop kernel:  [<c012e3c6>] hrtimer_forward+0xe2/0xfe
Nov  2 21:52:18 laptop kernel:  [<c01300e7>] getnstimeofday+0x32/0xb1=20
Nov  2 21:52:18 laptop kernel:  [<c01163e1>] __dequeue_entity+0x1f/0x71
Nov  2 21:52:18 laptop kernel:  [<c0116731>] pick_next_task_fair+0x9d/0xa7
Nov  2 21:52:18 laptop kernel:  [<c03b30e2>] schedule+0x58d/0x5dd        =20
Nov  2 21:52:18 laptop kernel:  [<c0275dad>] e1000_acquire_swflag_ich8lan+0=
x31/0xa7
Nov  2 21:52:18 laptop kernel:  [<c0276590>] e1000_read_nvm_ich8lan+0x50/0x=
f6
Nov  2 21:52:18 laptop kernel:  [<c0124769>] try_to_del_timer_sync+0x44/0x4a
Nov  2 21:52:18 laptop kernel:  [<c0124779>] del_timer_sync+0xa/0x14       =
=20
Nov  2 21:52:18 laptop kernel:  [<c02763e0>] e1000_valid_led_default_ich8la=
n+0x17/0x32
Nov  2 21:52:18 laptop kernel:  [<c02789ac>] e1000e_id_led_init+0x13/0x109 =
          =20
Nov  2 21:52:18 laptop kernel:  [<c0276cbd>] e1000_init_hw_ich8lan+0xcd/0x1=
7c
Nov  2 21:52:18 laptop kernel:  [<c027ec4a>] e1000e_reset+0x124/0x1af
Nov  2 21:52:18 laptop kernel:  [<c027edc8>] e1000e_down+0xf3/0x104
Nov  2 21:52:18 laptop kernel:  [<c027f640>] e1000_close+0x29/0x9f
Nov  2 21:52:18 laptop kernel:  [<c03321de>] dev_close+0x5c/0x73           =
                               =20
Nov  2 21:52:18 laptop kernel:  [<c0332076>] dev_change_flags+0x93/0x13f
Nov  2 21:52:18 laptop kernel:  [<c0360c64>] devinet_ioctl+0x228/0x4f6
Nov  2 21:52:18 laptop kernel:  [<c036c760>] packet_ioctl+0xc6/0xcb
Nov  2 21:52:18 laptop kernel:  [<c0328488>] sock_ioctl+0x1ad/0x1d1
Nov  2 21:52:18 laptop kernel:  [<c03282db>] sock_ioctl+0x0/0x1d1 =20
Nov  2 21:52:18 laptop kernel:  [<c0165310>] vfs_ioctl+0x1c/0x5d
Nov  2 21:52:18 laptop kernel:  [<c0165570>] do_vfs_ioctl+0x21f/0x22b
Nov  2 21:52:18 laptop kernel:  [<c01655a8>] sys_ioctl+0x2c/0x44
Nov  2 21:52:18 laptop kernel:  [<c0102c6e>] syscall_call+0x7/0xb
Nov  2 21:52:18 laptop kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D         =20
Nov  2 21:52:18 laptop kernel: ---[ end trace 841a8f965990a8b9 ]---

--Sig_/wpzfgOKJbvY4VGfb.yFNkIJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkOFwkACgkQnhRzXSM7nSneRwCfVigCWTjoUZhNPjO6XUkdrWoo
Gh8Anjq0LfMo4atCpBbGUSB2g+w7lPl9
=hZzA
-----END PGP SIGNATURE-----

--Sig_/wpzfgOKJbvY4VGfb.yFNkIJ--
