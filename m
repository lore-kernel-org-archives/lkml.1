Return-Path: <linux-kernel-owner+w=401wt.eu-S1756652AbXIENB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652AbXIENB7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 09:01:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754137AbXIENBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 09:01:51 -0400
Received: from proxy3.bredband.net ([195.54.101.73]:47126 "EHLO
	proxy3.bredband.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754482AbXIENBv (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 09:01:51 -0400
Subject: Re: Cache not being reclaimed?
From: Ian Kumlien <pomac@vapor.com>
Reply-To: pomac@vapor.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux-kernel@vger.kernel.org
In-Reply-To: <20070905054501.9c59dc56.akpm@linux-foundation.org>
References: <1188955687.8365.5.camel@localhost>
	 <20070905054501.9c59dc56.akpm@linux-foundation.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-YZ+DSFEmVJFZVDODb0eW"
Date: Wed, 05 Sep 2007 15:01:37 +0200
Message-Id: <1188997297.8365.21.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-YZ+DSFEmVJFZVDODb0eW
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On ons, 2007-09-05 at 05:45 -0700, Andrew Morton wrote:
> > On Wed, 05 Sep 2007 03:28:07 +0200 Ian Kumlien <pomac@vapor.com> wrote:
> > Hi,=20
> >=20
> > I have just had a quite unexpected 'low memory situation'...
> >=20
> > This is a AMD64 machine with 2 gig memory, running 64 bit userland.
> >=20
> > Kernel: 2.6.23-rc3-git10, updating to -rc5-* as soon as i can.
> > I'm using SLUB:s
> >=20
> >=20
> > To me, this looks odd... I thought that any cached memory would be
> > reclamed but it was always full.
> >=20
> > Ideas?
> >=20
> > One example from dmesg:
> > swapper: page allocation failure. order:1, mode:0x4020
> >=20
> > Call Trace:
> >  <IRQ>  [<ffffffff8026c7ef>] __alloc_pages+0x30f/0x330
> >  [<ffffffff8028a0a1>] __slab_alloc+0x141/0x590
> >  [<ffffffff805a5937>] __netdev_alloc_skb+0x17/0x40
> >  [<ffffffff805a5937>] __netdev_alloc_skb+0x17/0x40
> >  [<ffffffff8028b470>] __kmalloc_track_caller+0xa0/0xc0
> >  [<ffffffff805a4b3f>] __alloc_skb+0x6f/0x150
> >  [<ffffffff805a5937>] __netdev_alloc_skb+0x17/0x40
> >  [<ffffffff88010945>] :sky2:sky2_rx_alloc+0x25/0xf0
> >  [<ffffffff88013b0c>] :sky2:sky2_poll+0x6dc/0xcf0
> >  [<ffffffff805e5f60>] tcp_delack_timer+0x0/0x210
> >  [<ffffffff805ac38a>] net_rx_action+0x8a/0x140
> >  [<ffffffff80242ac9>] __do_softirq+0x69/0xe0
> >  [<ffffffff8020cd9c>] call_softirq+0x1c/0x30
> >  [<ffffffff8020eb75>] do_softirq+0x35/0x90
> >  [<ffffffff8020ede0>] do_IRQ+0x80/0x100
> >  [<ffffffff8020ad00>] default_idle+0x0/0x40
> >  [<ffffffff8020c121>] ret_from_intr+0x0/0xa
> >  <EOI>  [<ffffffff8020ad29>] default_idle+0x29/0x40
> >  [<ffffffff8020ade1>] cpu_idle+0xa1/0xf0
> >=20
>=20
> An order-1 GFP_ATOMIC allocation can fail, and networking should recover
> from it.

Well, this isn't only networking, It started with all the apps running
and ended up with a pretty basic desktop with almost nothing running...
(due to continued freezes that caused me to shut down more and more
programs)

> If this is happening a lot then someting might have been broken.  Do you
> have reason to believe that the frequency of this happening has inreased?

I have never, to my knowledge, had this happen before...=20

I just happened to start a few downloads with rtorrent and watched the
machine slow down to a crawl... All this with over a gig in cache.

The machine was actually deadlocked for almost a minute at one time.

Top memory usage:
  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND       =
          =20
 2395 pomac     20   0  440m 289m 238m S    2 14.4  32:56.54 rtorrent
21647 root      20   0  203m 120m  10m S    1  6.0 569:45.31 X             =
          =20
 2351 pomac     20   0  170m 111m  53m S    0  5.5  15:43.66 rtorrent      =
   =20

At peak time, one of the rtorrent processes consumed more, but i still
had 1.x gig as cache, which imho should have been reclaimed.

vmstat now:
procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu--=
--
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id =
wa
 0  0 365204  16628  30644 1445316    2    1   362    92   18   21  4  2 91=
  3

PS. I have a dmesg dump from the incident, it's not long enough to
contain all but it could be seen as a snapshot...
DS.

--=20
Ian Kumlien <pomac () vapor ! com> -- http://pomac.netswarm.net

--=-YZ+DSFEmVJFZVDODb0eW
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7-ecc0.1.6 (GNU/Linux)

iD8DBQBG3qix7F3Euyc51N8RAhAXAJ0XIUxjdqpRNFM9DUAdlEZdsrxIcQCeMByx
nvzFkJMqKjWjrvpvkLHkY7o=
=68Wd
-----END PGP SIGNATURE-----

--=-YZ+DSFEmVJFZVDODb0eW--

