Return-Path: <linux-kernel-owner+w=401wt.eu-S1756805AbZAGJCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805AbZAGJCY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 04:02:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753306AbZAGJCB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 04:02:01 -0500
Received: from 69-30-77-85.dq1sn.easystreet.com ([69.30.77.85]:51288 "EHLO
	camus.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569AbZAGJCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 04:02:00 -0500
Subject: Re: DRM warnings in current -git
From: Eric Anholt <eric@anholt.net>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: airlied <airlied@linux.ie>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1231311924.5586.1.camel@brick>
References: <1231311924.5586.1.camel@brick>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-AU2jIwXvQH5EaY5dNkvA"
Date: Wed, 07 Jan 2009 01:01:57 -0800
Message-Id: <1231318917.2994.2.camel@gaiman.anholt.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-AU2jIwXvQH5EaY5dNkvA
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-01-06 at 23:05 -0800, Harvey Harrison wrote:
> Just started seeing (many of) these in dmesg:

It's a known issue when you enable the KMS code at the moment -- I had a
fix that I reverted for the last pull request because it caused
recursion.  It's harmless, other than being really noisy, but it's on
the list of things to be fixed.

> [    2.843845] WARNING: at drivers/gpu/drm/drm_crtc.c:213 drm_mode_object=
_get+0xaa/0xb0()
> [    2.843931] Hardware name: TravelMate 2480=20
> [    2.843989] drm_mode_object_get called w/o mode_config lock
> [    2.844062] Modules linked in:
> [    2.844151] Pid: 1, comm: swapper Tainted: G        W  2.6.28 #1
> [    2.844215] Call Trace:
> [    2.844271]  [<c012f1a3>] warn_slowpath+0x73/0xd0
> [    2.844333]  [<c0481fa9>] ? printk+0x18/0x1f
> [    2.844393]  [<c012f1cc>] ? warn_slowpath+0x9c/0xd0
> [    2.844456]  [<c04824dc>] ? schedule+0x3dc/0x9f0
> [    2.844518]  [<c02505ef>] ? __udelay+0x2f/0x40
> [    2.844579]  [<c0354f32>] ? bit_xfer+0x1a2/0x4d0
> [    2.844641]  [<c0249b62>] ? idr_get_empty_slot+0xe2/0x270
> [    2.844705]  [<c02cd93a>] drm_mode_object_get+0xaa/0xb0
> [    2.844768]  [<c02cf603>] drm_mode_create+0x33/0x40
> [    2.844830]  [<c02d24bf>] drm_add_edid_modes+0x3df/0x6b0
> [    2.844893]  [<c0249f78>] ? idr_get_new_above+0x8/0x30
> [    2.844957]  [<c02cd9da>] ? drm_mode_connector_update_edid_property+0x=
9a/0x190
> [    2.845043]  [<c02e2bcb>] intel_ddc_get_modes+0x3b/0x60
> [    2.845106]  [<c02e0d82>] intel_lvds_init+0xd2/0x2d0
> [    2.845169]  [<c02e0641>] ? intel_crt_init+0xb1/0xf0
> [    2.845231]  [<c02dfb95>] intel_modeset_init+0x395/0x8a0
> [    2.845295]  [<c02d530b>] ? i915_driver_irq_postinstall+0xab/0xb0
> [    2.845360]  [<c02d3cc1>] i915_driver_load+0x851/0x9a0
> [    2.845423]  [<c02c9622>] drm_get_dev+0x262/0x400
> [    2.845484]  [<c0263e7b>] ? pci_get_dev_by_id+0x3b/0x80
> [    2.845547]  [<c0263d30>] ? match_pci_dev_by_id+0x0/0x70
> [    2.845609]  [<c0263f98>] ? pci_get_subsys+0x58/0x70
> [    2.845672]  [<c02c475b>] drm_init+0x8b/0xd0
> [    2.845732]  [<c06dd743>] ? i915_init+0x0/0x48
> [    2.845792]  [<c06dd789>] i915_init+0x46/0x48
> [    2.845853]  [<c010111b>] _stext+0x2b/0x150
> [    2.845913]  [<c01f23a4>] ? create_proc_entry+0x54/0xa0
> [    2.845977]  [<c0174c24>] ? register_irq_proc+0xa4/0xc0
> [    2.846039]  [<c0174ca7>] ? init_irq_proc+0x67/0x80
> [    2.846101]  [<c06ba35d>] kernel_init+0x12b/0x185
> [    2.846163]  [<c06ba232>] ? kernel_init+0x0/0x185
> [    2.846224]  [<c0103e87>] kernel_thread_helper+0x7/0x10
> [    2.846287] ---[ end trace 755cc3f36cfb0784 ]---
>=20
>=20
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



--=-AU2jIwXvQH5EaY5dNkvA
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklkb4IACgkQHUdvYGzw6vcoegCgi6RcuTSURwFr4v03plhz/7pA
ZZkAn0N0607WWGC02UqARXkxllsnsTiF
=tfzf
-----END PGP SIGNATURE-----

--=-AU2jIwXvQH5EaY5dNkvA--

