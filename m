Return-Path: <linux-kernel-owner+w=401wt.eu-S965724AbXFGV5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965724AbXFGV5o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 17:57:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935230AbXFGV5g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 17:57:36 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:1684 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936440AbXFGV5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 17:57:35 -0400
X-AuthUser: davidel@xmailserver.org
Date: Thu, 7 Jun 2007 14:57:33 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Eric Dumazet <dada1@cosmosbay.com>
cc: Kyle Moffett <mrmacman_g4@mac.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
In-Reply-To: <466864F8.2050903@cosmosbay.com>
Message-ID: <Pine.LNX.4.64.0706071454530.6445@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.4625.1181169040.7>
 <20070606235906.72439d16@the-village.bc.nu>
 <Pine.LNX.4.64.0706061558550.10383@alien.or.mcafeemobile.com>
 <20070607001932.35c9591c@the-village.bc.nu> <466741BD.20106@redhat.com>
 <20070607110432.73be7960@the-village.bc.nu> <B8B9EC80-2E36-433E-87EB-5B31FF42FBCF@mac.com>
 <20070607151243.22caab9e.dada1@cosmosbay.com>
 <Pine.LNX.4.64.0706071243090.6445@alien.or.mcafeemobile.com>
 <466864F8.2050903@cosmosbay.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1795850513-1008335502-1181253453=:6445"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1795850513-1008335502-1181253453=:6445
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Thu, 7 Jun 2007, Eric Dumazet wrote:

> Davide Libenzi a =E9crit :
> > On Thu, 7 Jun 2007, Eric Dumazet wrote:
> >=20
> > > Davide, are you sure we want FIFO for non sequential allocations ?
> > >=20
> > > This tends to use all the fmap slots, and not very cache friendly
> > > if an app does a lot of [open(),...,close()] things. We already got a=
 perf
> > > drop because of RCUification of file freeing (FIFO mode instead of LI=
FO
> > > given by kmalloc()/kfree())
> > >=20
> > > If the idea behind this FIFO was security (ie not easy for an app to
> > > predict next glibc file handle), we/glibc might use yet another
> > > FD_SECUREMODE flag, wich ORed with O_NONSEQFD would ask to fdmap_newf=
d()
> > > to take the tail of fmap->slist, not head.
> >=20
> > Uli, would it be OK to rely only on base randomization and use a LIFO
> > instead? We have base randomization, plus LIFO does not mean strictly
> > sequential like legacy allocator, just more compatc and cache friendly.
> >=20
>=20
> I am afraid randomization wont really work if /sbin/init or /bin/bash for
> example uses one (or more) unseq fd :
> The 'random base' will be propagated at fork()/exec() time ?

As I said to Uli, we can't move the base while fds are in there. We can=20
re-randomize it when it's empty. This can also be done (it's a trivial and=
=20
fast operation - just set fmap->base to a new value) even every time the=20
fd count on the map touches zero.



- Davide


--1795850513-1008335502-1181253453=:6445--
