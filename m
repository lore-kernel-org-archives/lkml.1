Return-Path: <linux-kernel-owner+w=401wt.eu-S1756142AbXIEB2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142AbXIEB2T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 21:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755522AbXIEB2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 21:28:12 -0400
Received: from proxy3.bredband.net ([195.54.101.73]:64872 "EHLO
	proxy3.bredband.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755348AbXIEB2L (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 21:28:11 -0400
Subject: Cache not being reclaimed?
From: Ian Kumlien <pomac@vapor.com>
Reply-To: pomac@vapor.com
To: Linux-kernel@vger.kernel.org
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-L1SO7eqS08x8JZeAFu5T"
Date: Wed, 05 Sep 2007 03:28:07 +0200
Message-Id: <1188955687.8365.5.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-L1SO7eqS08x8JZeAFu5T
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,=20

I have just had a quite unexpected 'low memory situation'...

This is a AMD64 machine with 2 gig memory, running 64 bit userland.

Kernel: 2.6.23-rc3-git10, updating to -rc5-* as soon as i can.
I'm using SLUB:s


To me, this looks odd... I thought that any cached memory would be
reclamed but it was always full.

Ideas?

One example from dmesg:
swapper: page allocation failure. order:1, mode:0x4020

Call Trace:
 <IRQ>  [<ffffffff8026c7ef>] __alloc_pages+0x30f/0x330
 [<ffffffff8028a0a1>] __slab_alloc+0x141/0x590
 [<ffffffff805a5937>] __netdev_alloc_skb+0x17/0x40
 [<ffffffff805a5937>] __netdev_alloc_skb+0x17/0x40
 [<ffffffff8028b470>] __kmalloc_track_caller+0xa0/0xc0
 [<ffffffff805a4b3f>] __alloc_skb+0x6f/0x150
 [<ffffffff805a5937>] __netdev_alloc_skb+0x17/0x40
 [<ffffffff88010945>] :sky2:sky2_rx_alloc+0x25/0xf0
 [<ffffffff88013b0c>] :sky2:sky2_poll+0x6dc/0xcf0
 [<ffffffff805e5f60>] tcp_delack_timer+0x0/0x210
 [<ffffffff805ac38a>] net_rx_action+0x8a/0x140
 [<ffffffff80242ac9>] __do_softirq+0x69/0xe0
 [<ffffffff8020cd9c>] call_softirq+0x1c/0x30
 [<ffffffff8020eb75>] do_softirq+0x35/0x90
 [<ffffffff8020ede0>] do_IRQ+0x80/0x100
 [<ffffffff8020ad00>] default_idle+0x0/0x40
 [<ffffffff8020c121>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff8020ad29>] default_idle+0x29/0x40
 [<ffffffff8020ade1>] cpu_idle+0xa1/0xf0

Mem-info:
DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1
usd:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1
usd:   0
DMA32 per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd: 163   Cold: hi:   62, btch:  15
usd:  56
CPU    1: Hot: hi:  186, btch:  31 usd:  33   Cold: hi:   62, btch:  15
usd:  60
Active:348343 inactive:122950 dirty:13504 writeback:0 unstable:0
 free:2665 slab:21427 mapped:243884 pagetables:4816 bounce:0
DMA free:8020kB min:20kB low:24kB high:28kB active:16kB inactive:0kB
present:7636kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 2003 2003 2003
DMA32 free:2640kB min:5716kB low:7144kB high:8572kB active:1393356kB
inactive:491800kB present:2052008kB pages_scanned:22 all_unreclaimable?
no
lowmem_reserve[]: 0 0 0 0
DMA: 1*4kB 0*8kB 1*16kB 2*32kB 4*64kB 2*128kB 3*256kB 1*512kB 0*1024kB
1*2048kB 1*4096kB =3D 8020kB
DMA32: 400*4kB 0*8kB 1*16kB 0*32kB 2*64kB 1*128kB 1*256kB 1*512kB
0*1024kB 0*2048kB 0*4096kB =3D 2640kB
Swap cache: add 985117, delete 960396, find 102684/214435, race 0+193
Free swap  =3D 2136272kB
Total swap =3D 2530180kB
Free swap:       2136272kB
524208 pages of RAM
10098 reserved pages
588916 pages shared
24719 pages swap cached

vmstat
procs -----------memory---------- ---swap-- -----io---- -system--
----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy
id wa
 0  1 393904  16108  13788 1583372    2    1   229    67    9    8  4  2
92  2


--=20
Ian Kumlien <pomac () vapor ! com> -- http://pomac.netswarm.net

--=-L1SO7eqS08x8JZeAFu5T
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7-ecc0.1.6 (GNU/Linux)

iD8DBQBG3gYi7F3Euyc51N8RAoWFAKCba8w8aA03q/VzNp0VEkm0tGeAZgCfZ2fI
6bOBpG/eHlrlzNS2YoEjtao=
=5SZd
-----END PGP SIGNATURE-----

--=-L1SO7eqS08x8JZeAFu5T--

