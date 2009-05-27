Return-Path: <linux-kernel-owner+w=401wt.eu-S1759469AbZE0Rmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759469AbZE0Rmv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 13:42:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754997AbZE0Rmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 13:42:44 -0400
Received: from 69-30-77-85.dq1sn.easystreet.com ([69.30.77.85]:47748 "EHLO
	kingsolver.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbZE0Rmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 13:42:43 -0400
Subject: Re: i915_gem_retire_requests oops on 2.6.30-rc7
From: Eric Anholt <eric@anholt.net>
To: Alex Bennee <kernel-hacker@bennee.com>
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <b2cdc9f30905270050s63a355f8u51644cb076cf7be6@mail.gmail.com>
References: <b2cdc9f30905260520m6d779cdof202dabe511ed49b@mail.gmail.com>
	 <1243373914.8400.29.camel@gaiman.anholt.net>
	 <b2cdc9f30905270050s63a355f8u51644cb076cf7be6@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-O5uL3HAblWjyHyTXcP+P"
Date: Wed, 27 May 2009 10:42:43 -0700
Message-Id: <1243446163.8400.38.camel@gaiman.anholt.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-O5uL3HAblWjyHyTXcP+P
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-05-27 at 08:50 +0100, Alex Bennee wrote:
> 2009/5/26 Eric Anholt <eric@anholt.net>:
> > On Tue, 2009-05-26 at 13:20 +0100, Alex Bennee wrote:
> >> Hi,
> >>
> >> I've just had X crash on me with an attendant oops in the kernel as it=
 did so:
> >
> > That's not an oops, that's a WARN_ON.  The hardware wasn't caught up by
> > the time we gave up when shutting down the harwdare for VT switching.
> > That's bad.  But we don't know how long we should wait, since the GPU
> > may be hung, and waiting forever would be bad.  So we warn that
> > Something Bad may have happened.
>=20
> I can restart X afterwards so it can't be that hung. Would you like a
> reg dump next the problem occurs?
>=20
> >
> > It's gone with KMS since we never shut down the GPU.
> >
>=20
> Although I'm not switching to KMS yet due to the other issues I'm
> seeing (see xorg mails). But with KMS enabled we still see some things
> like:
>=20
> [  660.644103] [drm] TMDS-8: set mode  2f
> [  960.272242] INFO: task events/0:9 blocked for more than 120 seconds.
> [  960.272245] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [  960.272248] events/0      D ffff8800b70a58c0     0     9      2
> [  960.272254]  ffff8800b70b5de0 0000000000000046 ffff8800b103dc41
> ffff880001028980
> [  960.272260]  0000000000004000 0000000000010dc0 000000000000ca38
> ffff8800b0d31678
> [  960.272265]  ffff8800b70b5d60 ffff8800b70a58c0 ffffffff80648350
> ffff8800b70a5c48
> [  960.272270] Call Trace:
> [  960.272280]  [<ffffffff804bfce6>] ? thread_return+0x3e/0xaa
> [  960.272285]  [<ffffffff804c0589>] __mutex_lock_slowpath+0xdf/0x129
> [  960.272290]  [<ffffffff804c092d>] mutex_lock+0x23/0x3b
> [  960.272295]  [<ffffffff803cecd3>] i915_gem_retire_work_handler+0x2d/0x=
6b
> [  960.272301]  [<ffffffff80247666>] worker_thread+0x176/0x20f
> [  960.272306]  [<ffffffff803ceca6>] ? i915_gem_retire_work_handler+0x0/0=
x6b
> [  960.272311]  [<ffffffff8024b463>] ? autoremove_wake_function+0x0/0x3d
> [  960.272315]  [<ffffffff802474f0>] ? worker_thread+0x0/0x20f
> [  960.272319]  [<ffffffff802474f0>] ? worker_thread+0x0/0x20f
> [  960.272323]  [<ffffffff8024b061>] kthread+0x5b/0x88
> [  960.272329]  [<ffffffff8020c0ba>] child_rip+0xa/0x20
> [  960.272333]  [<ffffffff8024b006>] ? kthread+0x0/0x88
> [  960.272337]  [<ffffffff8020c0b0>] ? child_rip+0x0/0x20
>=20
> So are you sure this is a !KMS related thing?

Yes, that looks like something else entirely.

If you have GPU hangs with KMS, please report them at
bugs.freedesktop.org, with intel_gpu_dump output.

--=20
Eric Anholt
eric@anholt.net                         eric.anholt@intel.com



--=-O5uL3HAblWjyHyTXcP+P
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkode5MACgkQHUdvYGzw6vcCIgCgjpwwSOMSiJmxwhFGdS8tPFEC
4N4AnRBZoHWdtNWogy6p4PvRcR2MhDSA
=qyJj
-----END PGP SIGNATURE-----

--=-O5uL3HAblWjyHyTXcP+P--
