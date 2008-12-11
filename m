Return-Path: <linux-kernel-owner+w=401wt.eu-S1756485AbYLKHlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756485AbYLKHlY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 02:41:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751407AbYLKHlQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 02:41:16 -0500
Received: from 69-30-77-85.dq1sn.easystreet.com ([69.30.77.85]:62133 "EHLO
	camus.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094AbYLKHlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 02:41:15 -0500
X-Greylist: delayed 1309 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Dec 2008 02:41:15 EST
Subject: Re: Linux 2.6.28-rc8
From: Eric Anholt <eric@anholt.net>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <49407CE1.9090600@googlemail.com>
References: <alpine.LFD.2.00.0812101651130.3340@localhost.localdomain>
	 <49407CE1.9090600@googlemail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-3GVPkLR24nsLRH8Ihnum"
Date: Wed, 10 Dec 2008 23:19:23 -0800
Message-Id: <1228979963.3254.8.camel@gaiman.anholt.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-3GVPkLR24nsLRH8Ihnum
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-12-11 at 03:37 +0100, Gabriel C wrote:
> While I got some time again I decided to test rc8 and noticed the followi=
ng warning :

Unfortunately DRM comes second to the party, so it gets the backtrace
blame, but that framebuffer should really be mapped WC by vesafb.
You're just losing performance for having it mapped UC, and that should
be the only effect other than the whining in the log.

My recommended solution, of course, is to remove vesafb.

> [   23.090942] resource map sanity check conflict: 0xd0000000 0xdfffffff =
0xd0000000 0xd07effff vesafb
> [   23.090948] ------------[ cut here ]------------
> [   23.090951] WARNING: at arch/x86/mm/ioremap.c:226 __ioremap_caller+0xc=
7/0x2c9()
> [   23.090952] Modules linked in: i915 binfmt_misc acpi_cpufreq freq_tabl=
e w83627ehf hwmon_vid fuse loop lp ppdev joydev i2c_i801 parport_pc button =
evdev parport intel_agp processor sg pcspkr
> [   23.090969] Pid: 4632, comm: X Not tainted 2.6.28-rc8-dirty #25
> [   23.090971] Call Trace:
> [   23.090976]  [<ffffffff8024106f>] warn_on_slowpath+0x58/0x7d
> [   23.090979]  [<ffffffff8022c255>] ? change_page_attr_set_clr+0x136/0x3=
04
> [   23.090982]  [<ffffffff8022c65b>] ? _set_memory_uc+0x22/0x24
> [   23.090985]  [<ffffffff8022b0a3>] ? ioremap_change_attr+0x18/0x28
> [   23.090989]  [<ffffffff8022b17a>] __ioremap_caller+0xc7/0x2c9
> [   23.090997]  [<ffffffffa00b1e1e>] ? i915_gem_entervt_ioctl+0x451/0x4e6=
 [i915]
> [   23.091000]  [<ffffffff8022b46c>] ioremap_wc+0x1b/0x27
> [   23.091006]  [<ffffffffa00b1e1e>] i915_gem_entervt_ioctl+0x451/0x4e6 [=
i915]
> [   23.091010]  [<ffffffff802a8f6f>] ? do_sync_write+0xe7/0x12d
> [   23.091014]  [<ffffffff803e1e36>] drm_ioctl+0x1d6/0x25e
> [   23.091020]  [<ffffffffa00b19cd>] ? i915_gem_entervt_ioctl+0x0/0x4e6 [=
i915]
> [   23.091024]  [<ffffffff802b55d9>] vfs_ioctl+0x5f/0x78
> [   23.091026]  [<ffffffff802b5984>] do_vfs_ioctl+0x392/0x3c0
> [   23.091030]  [<ffffffff80554049>] ? _spin_unlock+0x9/0x32
> [   23.091033]  [<ffffffff802b5a07>] sys_ioctl+0x55/0x77
> [   23.091036]  [<ffffffff8020c15a>] system_call_fastpath+0x16/0x1b
> [   23.091038] ---[ end trace 79a035f1175c4e1d ]---
>=20
> ...
>=20
>=20
> I'm sure this warning was not present on rc1/rc2 back when I've tested th=
ese.
> Also this warning is not present in 2.6.27.*
>=20
>=20
> Regards,
>=20
> Gabriel C
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" i=
n
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
--=20
Eric Anholt
eric@anholt.net                         eric.anholt@intel.com



--=-3GVPkLR24nsLRH8Ihnum
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklAvvsACgkQHUdvYGzw6vcNbgCggHTQDqEhT30OhilL2pFvUUTN
8HIAnir/AqWvJYPBhNg4hQL3ZKq0ljIw
=tEm/
-----END PGP SIGNATURE-----

--=-3GVPkLR24nsLRH8Ihnum--

