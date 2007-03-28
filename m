Return-Path: <linux-kernel-owner+w=401wt.eu-S965756AbXC1UUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965756AbXC1UUW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 16:20:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965765AbXC1UUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 16:20:21 -0400
Received: from threatwall.zlynx.org ([199.45.143.218]:44493 "EHLO zlynx.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965756AbXC1UUU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 16:20:20 -0400
Subject: Re: 2.6.21-rc5-mm2 OOPS and spinlock lockup
From: Zan Lynx <zlynx@acm.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070326211627.c681af3b.akpm@linux-foundation.org>
References: <20070326211627.c681af3b.akpm@linux-foundation.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-gbi2x7iCPuN70Vwbesqs"
Date: Wed, 28 Mar 2007 14:20:16 -0600
Message-Id: <1175113216.7466.6.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 
X-Envelope-From: zlynx@acm.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-gbi2x7iCPuN70Vwbesqs
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-03-26 at 21:16 -0800, Andrew Morton wrote:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc5/=
2.6.21-rc5-mm2/
>=20
>=20
> - This is the same as 2.6.12-rc5-mm1, except the staircase deadline CPU
>   scheduler has been added.

Here is the last bit of netconsole dump I had from my laptop when the
kernel died just now.

Note that the kernel is compiled with SMP but the laptop is one core
only. I have CONFIG_DEBUG_SPINLOCK=3Dy and CONFIG_DEBUG_SPINLOCK_SLEEP=3Dy

It's AMD-64.

[ 2597.436421] Hangcheck: hangcheck value past margin!
[ 2794.356033] Unable to handle kernel NULL pointer dereference at 00000000=
000000c0 RIP:=20
[ 2794.356058]  [<ffffffff8020761f>] _raw_spin_lock+0x1f/0x140
[ 2794.356088] PGD 9f39067 PUD 9f38067 PMD 0=20
[ 2794.356180] Oops: 0000 [1] PREEMPT SMP=20
[ 2794.356261] last sysfs file: devices/system/cpu/cpu0/cpufreq/scaling_set=
speed
[ 2794.356328] CPU 0=20
[ 2794.356341] Modules linked in: netconsole nls_iso8859_1 nls_cp437 vfat f=
at nls_base zaurus cdc_ether usbnet snd_pcm_oss snd_mixer_oss rfcomm hidp h=
id l2cap ipv6 hci_usb bluetooth usb_storage snd_intel8x0 psmouse serio_raw =
snd_ac97_codec ac97_bus snd_pcm snd_timer snd snd_page_alloc ehci_hcd ohci_=
hcd ssb usbcore evdev sg
[ 2794.357227] Pid: 8049, comm: khidpd_046db3e1 Not tainted 2.6.21-rc5-mm2 =
#1
[ 2794.357295] RIP: 0010:[<ffffffff8020761f>]  [<ffffffff8020761f>] _raw_sp=
in_lock+0x1f/0x140
[ 2794.357318] RSP: 0000:ffff81000d865d10  EFLAGS: 00010282
[ 2794.357329] RAX: ffff81000d739040 RBX: 00000000000000b8 RCX: 00000000000=
00000
[ 2794.357396] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00000000000=
000b8
[ 2794.357408] RBP: ffff81000e23dd08 R08: 0000000000000002 R09: 00000000000=
00000
[ 2794.357422] R10: ffffffff80318019 R11: 2222222222222222 R12: ffff81000e2=
3dd10
[ 2794.357435] R13: 0000000000000000 R14: ffff81000e16b928 R15: ffff81000b5=
18720
 [<ffffffff8020761f>] _raw_spin_lock+0x1f/0x140
[ 2794.359149]  RSP <ffff81000d865d10>
[ 2794.359214] CR2: 00000000000000c0
[ 2794.359268] note: khidpd_046db3e1[8049] exited with preempt_count 3
[ 2804.355026] BUG: soft lockup detected on CPU#0!
[ 2804.355037]=20
[ 2804.355039] Call Trace:
[ 2804.355051]  <IRQ>  [<ffffffff802c7659>] softlockup_tick+0xf9/0x140
[ 2804.355140]  [<ffffffff8029ba37>] update_process_times+0x57/0x90
[ 2804.355157]  [<ffffffff8027b1e4>] smp_local_timer_interrupt+0x34/0x60
[ 2804.355171]  [<ffffffff8027b5ba>] smp_send_timer_broadcast_ipi+0x3a/0x60
[ 2804.355188]  [<ffffffff80271423>] timer_interrupt+0x23/0x30
[ 2804.355259]  [<ffffffff8020fe0e>] handle_IRQ_event+0x1e/0x60
[ 2804.355275]  [<ffffffff802c919a>] handle_edge_irq+0xfa/0x150
[ 2804.355291]  [<ffffffff80270180>] do_IRQ+0x110/0x190
[ 2804.355306]  [<ffffffff8025f666>] ret_from_intr+0x0/0xf
[ 2804.355371]  <EOI>  [<ffffffff8024e22c>] shrink_dcache_parent+0x2c/0x120
[ 2804.355399]  [<ffffffff802076ac>] _raw_spin_lock+0xac/0x140
[ 2804.355413]  [<ffffffff802076b9>] _raw_spin_lock+0xb9/0x140
[ 2804.355484]  [<ffffffff8024e22c>] shrink_dcache_parent+0x2c/0x120
[ 2804.355499]  [<ffffffff80312456>] proc_flush_task+0x76/0x220
[ 2804.355518]  [<ffffffff80216f56>] release_task+0x316/0x360
[ 2804.355532]  [<ffffffff8022796f>] do_wait+0x80f/0xc10
[ 2804.355607]  [<ffffffff80290d90>] default_wake_function+0x0/0x10
[ 2804.355624]  [<ffffffff8025f11e>] system_call+0x7e/0x83
[ 2804.355639]=20
[ 2804.355646] INFO: lockdep is turned off.
[ 2821.783782] BUG: spinlock lockup on CPU#0, init/1, ffffffff806b0e00
[ 2821.783793]=20
[ 2821.783794] Call Trace:
[ 2821.783830]  [<ffffffff802076fa>] _raw_spin_lock+0xfa/0x140
[ 2821.783845]  [<ffffffff8024e22c>] shrink_dcache_parent+0x2c/0x120
[ 2821.783866]  [<ffffffff80312456>] proc_flush_task+0x76/0x220
[ 2821.783895]  [<ffffffff80216f56>] release_task+0x316/0x360
[ 2821.783910]  [<ffffffff8022796f>] do_wait+0x80f/0xc10
[ 2821.783939]  [<ffffffff80290d90>] default_wake_function+0x0/0x10
[ 2821.783956]  [<ffffffff8025f11e>] system_call+0x7e/0x83
[ 2821.783983]=20
[ 2821.783989] INFO: lockdep is turned off.

--=20
Zan Lynx <zlynx@acm.org>

--=-gbi2x7iCPuN70Vwbesqs
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.3 (GNU/Linux)

iD8DBQBGCs4AG8fHaOLTWwgRAv3QAJ94waT2pZ1DSfYk1hnFk1iJD4rCNwCgi+Zy
Fb+n7RrsoIg5NfE1hhgd82c=
=JDJ2
-----END PGP SIGNATURE-----

--=-gbi2x7iCPuN70Vwbesqs--

