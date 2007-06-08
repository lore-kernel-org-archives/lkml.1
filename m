Return-Path: <linux-kernel-owner+w=401wt.eu-S937768AbXFHFUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937768AbXFHFUc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 01:20:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763749AbXFHFUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 01:20:25 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:1637 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757825AbXFHFUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 01:20:24 -0400
X-AuthUser: davidel@xmailserver.org
Date: Thu, 7 Jun 2007 22:20:22 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Eric Dumazet <dada1@cosmosbay.com>
cc: Kyle Moffett <mrmacman_g4@mac.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
In-Reply-To: <4668DD3C.60000@cosmosbay.com>
Message-ID: <Pine.LNX.4.64.0706072216560.3454@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.4625.1181169040.7>
 <20070606235906.72439d16@the-village.bc.nu>
 <Pine.LNX.4.64.0706061558550.10383@alien.or.mcafeemobile.com>
 <20070607001932.35c9591c@the-village.bc.nu> <466741BD.20106@redhat.com>
 <20070607110432.73be7960@the-village.bc.nu> <B8B9EC80-2E36-433E-87EB-5B31FF42FBCF@mac.com>
 <20070607151243.22caab9e.dada1@cosmosbay.com>
 <Pine.LNX.4.64.0706071243090.6445@alien.or.mcafeemobile.com>
 <466864F8.2050903@cosmosbay.com> <Pine.LNX.4.64.0706071454530.6445@alien.or.mcafeemobile.com>
 <4668DD3C.60000@cosmosbay.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1795850513-2107729467-1181280022=:3454"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1795850513-2107729467-1181280022=:3454
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Fri, 8 Jun 2007, Eric Dumazet wrote:

> Davide Libenzi a =E9crit :
> > On Thu, 7 Jun 2007, Eric Dumazet wrote:
> > > I am afraid randomization wont really work if /sbin/init or /bin/bash=
 for
> > > example uses one (or more) unseq fd :
> > > The 'random base' will be propagated at fork()/exec() time ?
> >=20
> > As I said to Uli, we can't move the base while fds are in there. We can
> > re-randomize it when it's empty. This can also be done (it's a trivial =
and
> > fast operation - just set fmap->base to a new value) even every time th=
e fd
> > count on the map touches zero.
> >=20
>=20
> Hum, I think it would be better to free fmap if it's empty, instead of ch=
ange
> fmap->base. (Only in fork() after removal of O_CLOFORK file handles, and =
in
> exec() after removal of O_CLOEXEC file handles)

That can be done too. When it'll be re-created will be randomized anyway.
I'll probably be doing it everytime fmap->count touches zero in=20
__put_unused_fd(), so even if the map is not empty at fork and/or exec=20
time, the program have other chances of randomize in the middle of its=20
lifetime.


- Davide


--1795850513-2107729467-1181280022=:3454--
