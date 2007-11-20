Return-Path: <linux-kernel-owner+w=401wt.eu-S1757719AbXKTB3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757719AbXKTB3S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 20:29:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756805AbXKTBSI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 20:18:08 -0500
Received: from mail.vapor.com ([85.114.133.49]:59767 "EHLO mail.vapor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755352AbXKTBSF (ORCPT <rfc822;Linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 20:18:05 -0500
X-Greylist: delayed 1126 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Nov 2007 20:18:04 EST
Subject: [BUG?] OOM with large cache....(x86_64, 2.6.24-rc3-git1, nohz)
From: Ian Kumlien <pomac@vapor.com>
Reply-To: pomac@vapor.com
To: Linux-kernel@vger.kernel.org
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-OYpubCa5q3Lm2FG51yil"
Date: Tue, 20 Nov 2007 01:59:15 +0100
Message-Id: <1195520355.8601.14.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-OYpubCa5q3Lm2FG51yil
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,=20

I have had this before and sent a mail about it.

It seems like the diskcache is still in use and is never shrunk. This
happened with a odd load though, trackerd started indexing a bit late
and the other workload which is a large bittorrent seed/download.

The bittorrent app is the one that drives up the diskcache.

I don't think that trackerd was triggering it, i actually upgraded
kernel since it kept happening on 2.6.23...

I really don't know what other information i can provide.

free from now (some hours later)
vmstat from now ^

and the dmesg log.

Ideas? Comments?

free:
             total       used       free     shared    buffers     cached
Mem:       2056484    2039736      16748          0      20776    1585408
-/+ buffers/cache:     433552    1622932
Swap:      2530180     426020    2104160
---

vmstat:
procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu--=
--
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id =
wa
 0  0 426020  16612  20580 1585848   26   21   684    56   34   51  5  3 88=
  4
---

--- 8<--- 8<---
ntpd invoked oom-killer: gfp_mask=3D0x1201d2, order=3D0, oomkilladj=3D0

Call Trace:
 [<ffffffff80270fd6>] oom_kill_process+0xf6/0x110
 [<ffffffff80271476>] out_of_memory+0x1b6/0x200
 [<ffffffff80273a07>] __alloc_pages+0x387/0x3c0
 [<ffffffff80275b03>] __do_page_cache_readahead+0x103/0x260
 [<ffffffff802703f1>] filemap_fault+0x2f1/0x420
 [<ffffffff8027bcbb>] __do_fault+0x6b/0x410
 [<ffffffff802499de>] recalc_sigpending+0xe/0x40
 [<ffffffff8027d9dd>] handle_mm_fault+0x1bd/0x7a0
 [<ffffffff80212cda>] save_i387+0x9a/0xe0
 [<ffffffff80227e76>] do_page_fault+0x176/0x790
 [<ffffffff8020bacf>] sys_rt_sigreturn+0x35f/0x400
 [<ffffffff806acbf9>] error_exit+0x0/0x51

Mem-info:
DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd=
:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd=
:   0
DMA32 per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd: 148   Cold: hi:   62, btch:  15 usd=
:  60
CPU    1: Hot: hi:  186, btch:  31 usd: 116   Cold: hi:   62, btch:  15 usd=
:  18
Active:241172 inactive:241825 dirty:0 writeback:0 unstable:0
 free:3388 slab:8095 mapped:149 pagetables:6263 bounce:0
DMA free:7908kB min:20kB low:24kB high:28kB active:0kB inactive:0kB present=
:7436kB pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 2003 2003 2003
DMA32 free:5644kB min:5716kB low:7144kB high:8572kB active:964688kB inactiv=
e:967188kB present:2052008kB pages_scanned:5519125 all_unreclaimable? yes
lowmem_reserve[]: 0 0 0 0
DMA: 5*4kB 4*8kB 3*16kB 4*32kB 6*64kB 5*128kB 4*256kB 3*512kB 0*1024kB 0*20=
48kB 1*4096kB =3D 7908kB
DMA32: 95*4kB 2*8kB 0*16kB 0*32kB 0*64kB 1*128kB 0*256kB 2*512kB 0*1024kB 0=
*2048kB 1*4096kB =3D 5644kB
Swap cache: add 1979600, delete 1979592, find 144656/307405, race 1+17
Free swap  =3D 0kB
Total swap =3D 2530180kB
Free swap:            0kB
524208 pages of RAM
10149 reserved pages
5059 pages shared
8 pages swap cached
Out of memory: kill process 8421 (trackerd) score 1016524 or a child
Killed process 8421 (trackerd)
trackerd invoked oom-killer: gfp_mask=3D0x1200d2, order=3D0, oomkilladj=3D0

Call Trace:
 [<ffffffff80270fd6>] oom_kill_process+0xf6/0x110
 [<ffffffff80271476>] out_of_memory+0x1b6/0x200
 [<ffffffff80273a07>] __alloc_pages+0x387/0x3c0
 [<ffffffff803c75a9>] elv_insert+0xa9/0x1b0
 [<ffffffff8028782a>] read_swap_cache_async+0xca/0x110
 [<ffffffff8027c0cb>] swapin_readahead+0x6b/0x90
 [<ffffffff80234fe3>] enqueue_task+0x13/0x30
 [<ffffffff8027ddf9>] handle_mm_fault+0x5d9/0x7a0
 [<ffffffff8023688a>] find_busiest_group+0x1ca/0x660
 [<ffffffff80227e76>] do_page_fault+0x176/0x790
 [<ffffffff806aa9eb>] thread_return+0x3a/0x54f
 [<ffffffff80638323>] unix_stream_sendmsg+0x1e3/0x3b0
 [<ffffffff806acbf9>] error_exit+0x0/0x51
 [<ffffffff803dd180>] __get_user_8+0x20/0x2c
 [<ffffffff802601c0>] exit_robust_list+0x20/0x120
 [<ffffffff802423cf>] do_exit+0x85f/0x8b0
 [<ffffffff80249ced>] __dequeue_signal+0x2d/0x1e0
 [<ffffffff8024244c>] do_group_exit+0x2c/0x80
 [<ffffffff8024bc37>] get_signal_to_deliver+0x2f7/0x4b0
 [<ffffffff8020b004>] do_notify_resume+0xc4/0x810
 [<ffffffff8029696b>] do_readv_writev+0x16b/0x220
 [<ffffffff802a7544>] fcntl_setlk+0x54/0x270
 [<ffffffff8025fe59>] sys_futex+0x79/0x130
 [<ffffffff8020bd17>] sysret_signal+0x1c/0x27
 [<ffffffff8020bfa7>] ptregscall_common+0x67/0xb0

Mem-info:
DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd=
:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd=
:   0
DMA32 per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd: 148   Cold: hi:   62, btch:  15 usd=
:  52
CPU    1: Hot: hi:  186, btch:  31 usd: 120   Cold: hi:   62, btch:  15 usd=
:  24
Active:256546 inactive:226760 dirty:0 writeback:0 unstable:0
 free:3405 slab:8094 mapped:136 pagetables:6263 bounce:0
DMA free:7908kB min:20kB low:24kB high:28kB active:0kB inactive:0kB present=
:7436kB pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 2003 2003 2003
DMA32 free:5712kB min:5716kB low:7144kB high:8572kB active:1026188kB inacti=
ve:907040kB present:2052008kB pages_scanned:10392948 all_unreclaimable? yes
lowmem_reserve[]: 0 0 0 0
DMA: 5*4kB 4*8kB 3*16kB 4*32kB 6*64kB 5*128kB 4*256kB 3*512kB 0*1024kB 0*20=
48kB 1*4096kB =3D 7908kB
DMA32: 110*4kB 2*8kB 0*16kB 0*32kB 0*64kB 1*128kB 0*256kB 2*512kB 0*1024kB =
0*2048kB 1*4096kB =3D 5704kB
Swap cache: add 1979600, delete 1979592, find 144656/307406, race 1+17
Free swap  =3D 0kB
Total swap =3D 2530180kB
Free swap:            0kB
524208 pages of RAM
10149 reserved pages
4495 pages shared
8 pages swap cached
hald-addon-stor invoked oom-killer: gfp_mask=3D0x1201d2, order=3D0, oomkill=
adj=3D0

Call Trace:
 [<ffffffff80270fd6>] oom_kill_process+0xf6/0x110
 [<ffffffff80271476>] out_of_memory+0x1b6/0x200
 [<ffffffff80273a07>] __alloc_pages+0x387/0x3c0
 [<ffffffff80275b03>] __do_page_cache_readahead+0x103/0x260
 [<ffffffff802703f1>] filemap_fault+0x2f1/0x420
 [<ffffffff8027bcbb>] __do_fault+0x6b/0x410
 [<ffffffff8027d9dd>] handle_mm_fault+0x1bd/0x7a0
 [<ffffffff802bfe00>] blkdev_open+0x0/0x90
 [<ffffffff802bf954>] do_open+0xf4/0x330
 [<ffffffff80227e76>] do_page_fault+0x176/0x790
 [<ffffffff80294857>] __dentry_open+0x197/0x200
 [<ffffffff802aaa02>] iput+0x42/0x80
 [<ffffffff802bf6f3>] __blkdev_put+0x1a3/0x1b0
 [<ffffffff802a9640>] dput+0xa0/0x130
 [<ffffffff80297688>] __fput+0x148/0x1d0
 [<ffffffff806acbf9>] error_exit+0x0/0x51

Mem-info:
DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd=
:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd=
:   0
DMA32 per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd: 148   Cold: hi:   62, btch:  15 usd=
:  52
CPU    1: Hot: hi:  186, btch:  31 usd: 113   Cold: hi:   62, btch:  15 usd=
:  24
Active:258494 inactive:225220 dirty:0 writeback:0 unstable:0
 free:3401 slab:8098 mapped:136 pagetables:6263 bounce:0
DMA free:7908kB min:20kB low:24kB high:28kB active:0kB inactive:0kB present=
:7436kB pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 2003 2003 2003
DMA32 free:5696kB min:5716kB low:7144kB high:8572kB active:1033976kB inacti=
ve:900880kB present:2052008kB pages_scanned:11379771 all_unreclaimable? yes
lowmem_reserve[]: 0 0 0 0
DMA: 5*4kB 4*8kB 3*16kB 4*32kB 6*64kB 5*128kB 4*256kB 3*512kB 0*1024kB 0*20=
48kB 1*4096kB =3D 7908kB
DMA32: 110*4kB 1*8kB 0*16kB 0*32kB 0*64kB 1*128kB 0*256kB 2*512kB 0*1024kB =
0*2048kB 1*4096kB =3D 5696kB
Swap cache: add 1979609, delete 1979593, find 144656/307406, race 1+17
Free swap  =3D 0kB
Total swap =3D 2530180kB
Free swap:            0kB
524208 pages of RAM
10149 reserved pages
4135 pages shared
16 pages swap cached
Out of memory: kill process 8352 (gnome-session) score 362928 or a child
Killed process 8388 (ssh-agent)
cron invoked oom-killer: gfp_mask=3D0x1201d2, order=3D0, oomkilladj=3D0

Call Trace:
 [<ffffffff80270fd6>] oom_kill_process+0xf6/0x110
 [<ffffffff80271476>] out_of_memory+0x1b6/0x200
 [<ffffffff80273a07>] __alloc_pages+0x387/0x3c0
 [<ffffffff80275b03>] __do_page_cache_readahead+0x103/0x260
 [<ffffffff802703f1>] filemap_fault+0x2f1/0x420
 [<ffffffff8027bcbb>] __do_fault+0x6b/0x410
 [<ffffffff8027d9dd>] handle_mm_fault+0x1bd/0x7a0
 [<ffffffff80227e76>] do_page_fault+0x176/0x790
 [<ffffffff80256e80>] hrtimer_wakeup+0x0/0x30
 [<ffffffff80249a77>] sigprocmask+0x67/0xf0
 [<ffffffff806acbf9>] error_exit+0x0/0x51

Mem-info:
DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd=
:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd=
:   0
DMA32 per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd: 167   Cold: hi:   62, btch:  15 usd=
:  57
CPU    1: Hot: hi:  186, btch:  31 usd: 113   Cold: hi:   62, btch:  15 usd=
:  46
Active:243110 inactive:239426 dirty:0 writeback:0 unstable:0
 free:3401 slab:8100 mapped:136 pagetables:6250 bounce:0
DMA free:7908kB min:20kB low:24kB high:28kB active:0kB inactive:0kB present=
:7436kB pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 2003 2003 2003
DMA32 free:5696kB min:5716kB low:7144kB high:8572kB active:972440kB inactiv=
e:957592kB present:2052008kB pages_scanned:3631724 all_unreclaimable? yes
lowmem_reserve[]: 0 0 0 0
DMA: 5*4kB 4*8kB 3*16kB 4*32kB 6*64kB 5*128kB 4*256kB 3*512kB 0*1024kB 0*20=
48kB 1*4096kB =3D 7908kB
DMA32: 110*4kB 1*8kB 1*16kB 1*32kB 1*64kB 0*128kB 0*256kB 2*512kB 0*1024kB =
0*2048kB 1*4096kB =3D 5680kB
Swap cache: add 1979705, delete 1979697, find 144656/307408, race 1+17
Free swap  =3D 0kB
Total swap =3D 2530180kB
Free swap:            0kB
524208 pages of RAM
10149 reserved pages
5189 pages shared
8 pages swap cached
Out of memory: kill process 8352 (gnome-session) score 361583 or a child
Killed process 8399 (metacity)

--=20
Ian Kumlien <pomac () vapor ! com> -- http://pomac.netswarm.net

--=-OYpubCa5q3Lm2FG51yil
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7-ecc0.1.6 (GNU/Linux)

iD8DBQBHQjFj7F3Euyc51N8RAoLdAKCXD4/ejj9CtKENGRVf9SrR9x86/QCdFH1Z
o9KoYZYP+wMJWOp2NeQYrxE=
=E95x
-----END PGP SIGNATURE-----

--=-OYpubCa5q3Lm2FG51yil--

