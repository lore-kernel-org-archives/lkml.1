Return-Path: <linux-kernel-owner+w=401wt.eu-S1163337AbXD1Rzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163337AbXD1Rzk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 13:55:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1163302AbXD1Ryk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 13:54:40 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:52921 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1163306AbXD1RyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 13:54:22 -0400
X-Sasl-enc: EY85UynyDqUJYEMMsd4UTDj6YhbkFDnWRnndgO7UxbCl 1177782861
Message-ID: <46338AEB.2070109@imap.cc>
Date: Sat, 28 Apr 2007 19:56:59 +0200
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.0.9) Gecko/20061211 SeaMonkey/1.0.7 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: 2.6.21-rc7-mm2 crash: Eeek! page_mapcount(page) went negative! (-1)
References: <20070425225716.8e9b28ca.akpm@linux-foundation.org>
In-Reply-To: <20070425225716.8e9b28ca.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig569612D61238E66C5B7DF4E3"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig569612D61238E66C5B7DF4E3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

With kernel 2.6.21-rc7-mm2, my Dell Optiplex GX110 (P3/933) regularly
crashes during the SuSE 10.1 startup sequence. When booting to RL5,
it panicblinks shortly after the graphical login screen appears.
Booting to RL3, it hangs after the startup message:

Starting Firewall Initialization (phase 2 of 2)

(the last message before "runlevel 3 has been reached") logging this:

[   57.138955] Eeek! page_mapcount(page) went negative! (-1)
[   57.139040]   page pfn =3D 0
[   57.139053]   page->flags =3D 400
[   57.139066]   page->count =3D 1
[   57.139079]   page->mapping =3D 00000000
[   57.139111]   vma->vm_ops =3D generic_file_vm_ops+0x0/0x18
[   57.139147]   vma->vm_ops->nopage =3D 0x0
[   57.139181]   vma->vm_file->f_op->mmap =3D reiserfs_file_mmap+0x0/0x47=

[   57.139220] ------------[ cut here ]------------
[   57.139236] kernel BUG at mm/rmap.c:648!
[   57.139251] invalid opcode: 0000 [#1]
[   57.139264] PREEMPT
[   57.139278] Modules linked in: usbserial snd_rtctimer snd_seq_dummy sn=
d_pcm_oss snd_mixer_oss snd_seq snd_seq_device thermal processor fan butt=
on battery ac af_packet usb_gigaset ser_gigaset bas_gigaset gigaset isdn =
slhc crc_ccitt ip6t_REJECT xt_tcpudp ipt_REJECT xt_state iptable_mangle i=
ptable_nat nf_nat iptable_filter ip6table_mangle nf_conntrack_ipv4 nf_con=
ntrack nfnetlink ip_tables ip6table_filter ip6_tables x_tables ehci_hcd s=
nd_intel8x0 snd_ac97_codec ac97_bus snd_pcm snd_timer snd soundcore snd_p=
age_alloc i2c_i801 uhci_hcd parport_pc lp parport ipv6 nls_iso8859_1 nls_=
cp437 vfat fat nls_utf8 ntfs dm_mod
[   57.139447] CPU:    0
[   57.139450] EIP:    0060:[<c015dfc0>]    Not tainted VLI
[   57.139453] EFLAGS: 00010282   (2.6.21-rc7-mm2-noinitrd #1)
[   57.139506] EIP is at page_remove_rmap+0xd7/0x106
[   57.139522] eax: 0000004b   ebx: c1000000   ecx: 00000001   edx: 00000=
002
[   57.139541] esi: c309fde0   edi: b7f24000   ebp: c373ec90   esp: c373e=
c78
[   57.139559] ds: 007b   es: 007b   fs: 0000  gs: 0000  ss: 0068
[   57.139577] Process getcfg-interfac (pid: 4343, ti=3Dc373e000 task=3Dc=
18734d0 task.ti=3Dc373e000)
[   57.139586] Stack: c042abb5 00000000 c373ec90 c13f91c0 c1000000 c373dc=
90 c373ecf0 c0158df4
[   57.139618]        c04f2ac4 00000001 00000000 c309fde0 c373ed10 00005f=
f1 00000000 00000001
[   57.139647]        b7f62000 c374cb7c c374cb7c c374cb7c c373b344 ffffff=
fe 00000000 c0569c2c
[   57.139677] Call Trace:
[   57.139721]  [<c0158df4>] unmap_vmas+0x2d7/0x4c9
[   57.139748]  [<c015b7dd>] exit_mmap+0x68/0xeb
[   57.139772]  [<c01191b0>] mmput+0x52/0xcb
[   57.139805]  [<c011c368>] exit_mm+0xbb/0xc3
[   57.139832]  [<c011d188>] do_exit+0x1ea/0x73e
[   57.139857]  [<c011d74d>] sys_exit_group+0x0/0x13
[   57.139880]  [<c012524e>] get_signal_to_deliver+0x6cd/0x6f8
[   57.139917]  [<c01036cf>] do_notify_resume+0x91/0x692
[   57.139944]  [<c0103f15>] work_notifysig+0x13/0x1a
[   57.139970]  [<b7f6b7a8>] 0xb7f6b7a8
[   57.139988]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[   57.140002] INFO: lockdep is turned off.
[   57.140015] Code: c0 74 0d 8b 50 0c b8 e5 ab 42 c0 e8 d7 fa fd ff 8b 4=
6 48 85 c0 74 14 8b 40 10 85 c0 74 0d 8b 50 2c b8 04 ac 42 c0 e8 bc fa fd=
 ff <0f> 0b eb fe 8b 53 10 8b 03 83 e2 01 f7 da c1 e8 1e 83 c2 04 69
[   57.140133] EIP: [<c015dfc0>] page_remove_rmap+0xd7/0x106 SS:ESP 0068:=
c373ec78
[   57.140191] Fixing recursive fault but reboot is needed!
[   57.140209] BUG: scheduling while atomic: getcfg-interfac/0x00000002/4=
343
[   57.140225] INFO: lockdep is turned off.
[   57.140247]  [<c0104e80>] dump_trace+0x61/0x1e4
[   57.140275]  [<c010501d>] show_trace_log_lvl+0x1a/0x30
[   57.140298]  [<c0105fe9>] show_trace+0x12/0x14
[   57.140322]  [<c0106000>] dump_stack+0x15/0x17
[   57.140344]  [<c0380849>] schedule+0x6e/0x52c
[   57.140383]  [<c011d08f>] do_exit+0xf1/0x73e
[   57.140407]  [<c010569b>] die+0x1b7/0x1bf
[   57.140429]  [<c0105a66>] do_trap+0x8d/0xa7
[   57.140451]  [<c0105dd2>] do_invalid_op+0x88/0x92
[   57.140474]  [<c03833ba>] error_code+0x6a/0x70
[   57.140500]  [<c015dfc0>] page_remove_rmap+0xd7/0x106
[   57.140525]  [<c0158df4>] unmap_vmas+0x2d7/0x4c9
[   57.140548]  [<c015b7dd>] exit_mmap+0x68/0xeb
[   57.140571]  [<c01191b0>] mmput+0x52/0xcb
[   57.140593]  [<c011c368>] exit_mm+0xbb/0xc3
[   57.140615]  [<c011d188>] do_exit+0x1ea/0x73e
[   57.140638]  [<c011d74d>] sys_exit_group+0x0/0x13
[   57.140661]  [<c012524e>] get_signal_to_deliver+0x6cd/0x6f8
[   57.140686]  [<c01036cf>] do_notify_resume+0x91/0x692
[   57.140708]  [<c0103f15>] work_notifysig+0x13/0x1a
[   57.140731]  [<b7f6b7a8>] 0xb7f6b7a8
[   57.140749]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D


followed by a couple of these:

[   87.264940] BUG: sleeping function called from invalid context at mm/s=
lab.c:3054
[   87.265023] in_atomic():1, irqs_disabled():0
[   87.265038] INFO: lockdep is turned off.
[   87.265079]  [<c0104e80>] dump_trace+0x61/0x1e4
[   87.265119]  [<c010501d>] show_trace_log_lvl+0x1a/0x30
[   87.265161]  [<c0105fe9>] show_trace+0x12/0x14
[   87.265187]  [<c0106000>] dump_stack+0x15/0x17
[   87.265210]  [<c01177b3>] __might_sleep+0xc7/0xcd
[   87.265241]  [<c0168548>] __kmalloc_track_caller+0x67/0xe9
[   87.265281]  [<c0156e0b>] __kzalloc+0x13/0x3d
[   87.265312]  [<c0226a6c>] kobject_get_path+0x3b/0x94
[   87.265342]  [<c02b4004>] dev_uevent+0x2d0/0x36a
[   87.265375]  [<c02b36ac>] show_uevent+0x94/0xe4
[   87.265400]  [<c02b34fd>] dev_attr_show+0x1b/0x1f
[   87.265424]  [<c01a7ac0>] sysfs_read_file+0x17f/0x1b0
[   87.265454]  [<c016bbf8>] vfs_read+0xaf/0x138
[   87.265479]  [<c016c476>] sys_read+0x3d/0x61
[   87.265503]  [<c0103dc2>] sysenter_past_esp+0x5f/0x99
[   87.265531]  [<b7fd7410>] 0xb7fd7410
[   87.265568]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D

separated by 20 or 40 second pauses, before rebooting spontaneously.

2.6.21-rc7-mm1 crashed too. 2.6.21 runs fine.

Please let me know if you need more information or want me to test
anything.

HTH
T.

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
- In theory, there is no difference between theory and practice.
  In practice, there is.


--------------enig569612D61238E66C5B7DF4E3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGM4rzMdB4Whm86/kRAnssAJ9HT1/4TXqm2turgdz3XjmhVTKQlQCeNxtr
dtVjsitFtjlm1U1Qhj8PJA0=
=P8Nw
-----END PGP SIGNATURE-----

--------------enig569612D61238E66C5B7DF4E3--
