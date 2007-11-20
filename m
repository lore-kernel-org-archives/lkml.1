Return-Path: <linux-kernel-owner+w=401wt.eu-S1757769AbXKTJJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757769AbXKTJJu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 04:09:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754368AbXKTJJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 04:09:33 -0500
Received: from mail.vapor.com ([85.114.133.49]:35370 "EHLO mail.vapor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752806AbXKTJJb (ORCPT <rfc822;Linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 04:09:31 -0500
Subject: Re: [BUG?] OOM with large cache....(x86_64, 2.6.24-rc3-git1, nohz)
From: Ian Kumlien <pomac@vapor.com>
Reply-To: pomac@vapor.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Linux-kernel@vger.kernel.org
In-Reply-To: <200711201513.36711.nickpiggin@yahoo.com.au>
References: <1195520355.8601.14.camel@localhost>
	 <200711201513.36711.nickpiggin@yahoo.com.au>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-O1LG2pfSZMrODOMQb0JL"
Date: Tue, 20 Nov 2007 10:09:27 +0100
Message-Id: <1195549767.8601.22.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-O1LG2pfSZMrODOMQb0JL
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On tis, 2007-11-20 at 15:13 +1100, Nick Piggin wrote:
> On Tuesday 20 November 2007 11:59, Ian Kumlien wrote:
> > Hi,
> >
> > I have had this before and sent a mail about it.
> >
> > It seems like the diskcache is still in use and is never shrunk. This
> > happened with a odd load though, trackerd started indexing a bit late
> > and the other workload which is a large bittorrent seed/download.
> >
> > The bittorrent app is the one that drives up the diskcache.
> >
> > I don't think that trackerd was triggering it, i actually upgraded
> > kernel since it kept happening on 2.6.23...
> >
> > I really don't know what other information i can provide.
> >
> > free from now (some hours later)
> > vmstat from now ^
> >
> > and the dmesg log.
> >
> > Ideas? Comments?
> >
> > free:
> >              total       used       free     shared    buffers     cach=
ed
> > Mem:       2056484    2039736      16748          0      20776    15854=
08
> > -/+ buffers/cache:     433552    1622932
> > Swap:      2530180     426020    2104160
> > ---
> >
> > vmstat:
> > procs -----------memory---------- ---swap-- -----io---- -system--
> > ----cpu---- r  b   swpd   free   buff  cache   si   so    bi    bo   in=
 =20
> > cs us sy id wa 0  0 426020  16612  20580 1585848   26   21   684    56 =
  34
> >   51  5  3 88  4 ---
> >
> > --- 8<--- 8<---
> > ntpd invoked oom-killer: gfp_mask=3D0x1201d2, order=3D0, oomkilladj=3D0
> >
> > Call Trace:
> >  [<ffffffff80270fd6>] oom_kill_process+0xf6/0x110
> >  [<ffffffff80271476>] out_of_memory+0x1b6/0x200
> >  [<ffffffff80273a07>] __alloc_pages+0x387/0x3c0
> >  [<ffffffff80275b03>] __do_page_cache_readahead+0x103/0x260
> >  [<ffffffff802703f1>] filemap_fault+0x2f1/0x420
> >  [<ffffffff8027bcbb>] __do_fault+0x6b/0x410
> >  [<ffffffff802499de>] recalc_sigpending+0xe/0x40
> >  [<ffffffff8027d9dd>] handle_mm_fault+0x1bd/0x7a0
> >  [<ffffffff80212cda>] save_i387+0x9a/0xe0
> >  [<ffffffff80227e76>] do_page_fault+0x176/0x790
> >  [<ffffffff8020bacf>] sys_rt_sigreturn+0x35f/0x400
> >  [<ffffffff806acbf9>] error_exit+0x0/0x51
> >
> > Mem-info:
> > DMA per-cpu:
> > CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1
> > usd:   0 CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0,
> > btch:   1 usd:   0 DMA32 per-cpu:
> > CPU    0: Hot: hi:  186, btch:  31 usd: 148   Cold: hi:   62, btch:  15
> > usd:  60 CPU    1: Hot: hi:  186, btch:  31 usd: 116   Cold: hi:   62,
> > btch:  15 usd:  18 Active:241172 inactive:241825 dirty:0 writeback:0
> > unstable:0
> >  free:3388 slab:8095 mapped:149 pagetables:6263 bounce:0
> > DMA free:7908kB min:20kB low:24kB high:28kB active:0kB inactive:0kB
> > present:7436kB pages_scanned:0 all_unreclaimable? yes lowmem_reserve[]:=
 0
> > 2003 2003 2003
> > DMA32 free:5644kB min:5716kB low:7144kB high:8572kB active:964688kB
> > inactive:967188kB present:2052008kB pages_scanned:5519125
> > all_unreclaimable? yes lowmem_reserve[]: 0 0 0 0
> > DMA: 5*4kB 4*8kB 3*16kB 4*32kB 6*64kB 5*128kB 4*256kB 3*512kB 0*1024kB
> > 0*2048kB 1*4096kB =3D 7908kB DMA32: 95*4kB 2*8kB 0*16kB 0*32kB 0*64kB 1=
*128kB
> > 0*256kB 2*512kB 0*1024kB 0*2048kB 1*4096kB =3D 5644kB Swap cache: add
> > 1979600, delete 1979592, find 144656/307405, race 1+17 Free swap  =3D 0=
kB
> > Total swap =3D 2530180kB
> > Free swap:            0kB
> > 524208 pages of RAM
> > 10149 reserved pages
> > 5059 pages shared
> > 8 pages swap cached
> > Out of memory: kill process 8421 (trackerd) score 1016524 or a child
> > Killed process 8421 (trackerd)
>=20
> It's also used up all your 2.5GB of swap. The output of your `free` shows
> a fair bit of disk cache there, but it also shows a lot of swap free, whi=
ch
> isn't the case at oom-time.

Yes, as i said those was from several hours later...

> Unfortunately, we don't show NR_ANON_PAGES in these stats, but at a guess=
,
> I'd say that the file cache is mostly shrunk and you still don't have
> enough memory. trackerd probably has a memory leak in it, or else is just
> trying to allocate more memory than you have. Is this a regression?

I have had it happen twice before, without tracker running...

It didn't quite get to the oom stage, it just failed alot of allocations
while having 1.5 or more memory locked in cache.

http://marc.info/?l=3Dlinux-kernel&m=3D118895576924867&w=3D2

I saw that again and thought "Lets update and see what happens" and then
this happened. I haven't had the same version of trackerd go haywire on
me before, i haven't had a oom kill gnome-session or metacity before.

--=20
Ian Kumlien <pomac () vapor ! com> -- http://pomac.netswarm.net

--=-O1LG2pfSZMrODOMQb0JL
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7-ecc0.1.6 (GNU/Linux)

iD8DBQBHQqRG7F3Euyc51N8RApJhAKC7IA9aQRsgT1wetPHbT13T3fZveACgiget
/J9cmi2zDglW/g9kCNmRpgY=
=pR2C
-----END PGP SIGNATURE-----

--=-O1LG2pfSZMrODOMQb0JL--

