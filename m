Return-Path: <linux-kernel-owner+w=401wt.eu-S1752233AbXCTBh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233AbXCTBh2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 21:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752834AbXCTBh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 21:37:28 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:51043 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233AbXCTBh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 21:37:27 -0400
X-AuthUser: davidel@xmailserver.org
Date: Mon, 19 Mar 2007 18:36:12 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Eric Dumazet <dada1@cosmosbay.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 6/13] signal/timer/event fds v7 - timerfd core ...
In-Reply-To: <45FF2C7B.6080107@cosmosbay.com>
Message-ID: <Pine.LNX.4.64.0703191834530.3733@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.15249.1174348074.6>
 <45FF2C7B.6080107@cosmosbay.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1795850513-753186155-1174354572=:3733"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1795850513-753186155-1174354572=:3733
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Tue, 20 Mar 2007, Eric Dumazet wrote:

> Davide Libenzi a =E9crit :
>=20
> > +struct timerfd_ctx {
> > +=09struct hrtimer tmr;
> > +=09ktime_t tintv;
> > +=09spinlock_t lock;
> > +=09wait_queue_head_t wqh;
> > +=09unsigned long ticks;
> > +};
>=20
> > +static struct kmem_cache *timerfd_ctx_cachep;
>=20
> > +=09timerfd_ctx_cachep =3D kmem_cache_create("timerfd_ctx_cache",
> > +=09=09=09=09=09=09sizeof(struct timerfd_ctx),
> > +=09=09=09=09=09=090, SLAB_PANIC, NULL, NULL);
>=20
>=20
> Do we really expect thousands of active timerfd_ctx ?
>=20
> If not, using kmalloc()/kfree() would be fine, because sizeof(struct
> timerfd_ctx) is so small.
>=20
> on SMP / NUMA platforms, each new kmem_cache is rather expensive. (memory
> allocated at kmem_cache_create(), but also memory used when cache is not
> empty, with slabs in freelist for each cpu/node)
>=20
> Using a general cache might be cheaper : No memory overhead for yet anoth=
er
> kmem_cache.
>=20
> I know individual caches are good to spot memory leaks, but in timerfd ca=
se,
> you dont have mem leaks, do you ? :)

Silly you, of course not :)
Yes, I gues I can use kmalloc/kfree for those fds ...



- Davide


--1795850513-753186155-1174354572=:3733--
