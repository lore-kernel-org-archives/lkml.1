Return-Path: <linux-kernel-owner+w=401wt.eu-S1757341AbXE1KAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757341AbXE1KAw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 06:00:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750912AbXE1KAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 06:00:45 -0400
Received: from godel.catalyst.net.nz ([202.78.240.40]:39317 "EHLO
	mail1.catalyst.net.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbXE1KAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 06:00:43 -0400
X-Greylist: delayed 1350 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 May 2007 06:00:43 EDT
Subject: [oops] in bluetooth
From: Andrew Ruthven <puck@catalyst.net.nz>
To: linux-kernel@vger.kernel.org
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-E8mL9LYaHKGhWwHFtmFP"
Organization: Catalyst IT Limited
Date: Mon, 28 May 2007 21:38:09 +1200
Message-Id: <1180345089.819.28.camel@lamb>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.2 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-E8mL9LYaHKGhWwHFtmFP
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

[Please Cc replies to me, I'll try and keep an eye on the acrhives, but
no guarantees]

Hi,

Just a follow-up to Marcel regarding Pavel's bluetooth oops.  I've had
the same issue with both 2.6.21 and 2.6.21.2 (skipped .1).  I'm able to
reproduce the oops.

My scenario is connecting from a Treo650 via bluetooth to access the
Internet by my ADSL link.

The first connection after booting worked just fine, but every attempt
after that failed with a oops.

Changing to 2.6.22-rc3 as suggested by Marcel however works just fine.

Here is an except from kern.log for the failure with the 2.6.21.2
kernel:

May 26 13:01:32 chimaera kernel: BUG: unable to handle kernel NULL
pointer dereference at virtual address 00000008
May 26 13:01:32 chimaera kernel:  printing eip:
May 26 13:01:32 chimaera kernel: c01892e4
May 26 13:01:32 chimaera kernel: *pde =3D 00000000
May 26 13:01:32 chimaera kernel: Oops: 0000 [#1]
May 26 13:01:32 chimaera kernel: Modules linked in: ppp_deflate bsd_comp
ppp_async crc_ccitt ppp_generic slhc lirc_serial lirc_de
v rfcomm l2cap nfsd exportfs thermal fan button processor ac ip6t_LOG
nf_conntrack_ipv6 xt_limit ip6table_filter ip6_tables sit t
unnel4 tun bitrev crc32 ipt_MASQUERADE ipt_REJECT xt_multiport
ipt_recent xt_state xt_mark xt_MARK ipt_LOG xt_tcpudp iptable_mang
le iptable_filter iptable_nat ip_tables nf_nat nf_conntrack_ipv4
nf_conntrack nfnetlink x_tables nfs lockd nfs_acl sunrpc ipv6 pa
rport_pc parport e100 3c59x mii hci_usb bluetooth uhci_hcd usbcore
deflate zlib_deflate zlib_inflate twofish twofish_common serpe
nt aes blowfish des cbc ecb blkcipher sha256 sha1 md5 af_key
snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_p
cm snd_timer snd soundcore snd_page_alloc hostap_pci hostap
ieee80211_crypt
May 26 13:01:32 chimaera kernel: CPU:    0
May 26 13:01:32 chimaera kernel: EIP:    0060:[<c01892e4>]    Not
tainted VLI
May 26 13:01:32 chimaera kernel: EFLAGS: 00010286   (2.6.21.2-chimaera
#1)
May 26 13:01:32 chimaera kernel: EIP is at sysfs_move_dir+0x24/0x130
May 26 13:01:32 chimaera kernel: eax: ccfd72f0   ebx: 00000000   ecx:
00000000   edx: d7e7f760
May 26 13:01:32 chimaera kernel: esi: d7e95dac   edi: c03073fb   ebp:
d7e7f760   esp: c9f95e70
May 26 13:01:32 chimaera kernel: ds: 007b   es: 007b   fs: 00d8  gs:
0033  ss: 0068
May 26 13:01:32 chimaera kernel: Process pppd (pid: 9595, ti=3Dc9f94000
task=3Dc1368590 task.ti=3Dc9f94000)
May 26 13:01:32 chimaera kernel: Stack: c0307409 c37e4e68 c37e4e68
c03073fb cce0ca60 c37e4e68 c03073fb d7e7f760=20
May 26 13:01:32 chimaera kernel:        c01c22f4 d5d309c0 c03073fb
cce0ca60 d5d309c0 d5d309c0 00000000 c37e4e00=20
May 26 13:01:32 chimaera kernel:        00000000 d6ae60f0 d7e7f760
c02240f1 c37e4e68 d49580a0 c5a0b800 d6ae60f0=20
May 26 13:01:32 chimaera kernel: Call Trace:
May 26 13:01:32 chimaera kernel:  [<c01c22f4>] kobject_move+0xa4/0x130
May 26 13:01:32 chimaera kernel:  [<c02240f1>] device_move+0x51/0x110
May 26 13:01:32 chimaera kernel:  [<d8ac4f11>] rfcomm_tty_close
+0x51/0x80 [rfcomm]
May 26 13:01:32 chimaera kernel:  [<c020d8c6>] release_dev+0x146/0x620
May 26 13:01:32 chimaera kernel:  [<c01022e8>] do_notify_resume
+0x438/0x6e0
May 26 13:01:32 chimaera kernel:  [<c01c4248>] rb_insert_color+0x68/0xc0
May 26 13:01:32 chimaera kernel:  [<c012940d>] ktime_get_ts+0x1d/0x50
May 26 13:01:32 chimaera kernel:  [<c01292a9>] hrtimer_nanosleep
+0xa9/0x100
May 26 13:01:32 chimaera kernel:  [<c020dda7>] tty_release+0x7/0x10
May 26 13:01:32 chimaera kernel:  [<c01533e1>] __fput+0x91/0x160
May 26 13:01:32 chimaera kernel:  [<c01509b7>] filp_close+0x47/0x80
May 26 13:01:32 chimaera kernel:  [<c0151cfa>] sys_close+0x6a/0xa0
May 26 13:01:32 chimaera kernel:  [<c0102878>] syscall_call+0x7/0xb
May 26 13:01:32 chimaera kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
May 26 13:01:33 chimaera kernel: Code: 8d bc 27 00 00 00 00 55 57 56 53
83 ec 10 89 44 24 04 8b 40 24 85 c0 0f 84 ea 00 00 00 85=20
d2 8b 58 30 0f 84 f2 00 00 00 8b 72 30 <8b> 43 08 31 ff 3b 46 08 75 10
e9 c3 00 00 00 8b 43 08 83 c0 68=20
May 26 13:01:33 chimaera kernel: EIP: [<c01892e4>] sysfs_move_dir
+0x24/0x130 SS:ESP 0068:c9f95e70

Cheers!

--=20
Andrew Ruthven, Wellington, New Zealand
At work: andrew.ruthven@catalyst.net.nz
At home: andrew@etc.gen.nz
GPG fpr: 34CA 12A3 C6F8 B156 72C2  D0D7 D286 CE0C 0C62 B791

--=-E8mL9LYaHKGhWwHFtmFP
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGWqMB0obODAxit5ERAv5fAJ0dM0UMA4/reAlnXiy/TB5eJuzonQCgjZf2
ILO5LAHC5BSvAPYhxY+eC3A=
=CglU
-----END PGP SIGNATURE-----

--=-E8mL9LYaHKGhWwHFtmFP--

