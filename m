Return-Path: <linux-kernel-owner+w=401wt.eu-S932638AbXCFGbP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932638AbXCFGbP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 01:31:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932672AbXCFGbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 01:31:14 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:38313 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932638AbXCFGbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 01:31:14 -0500
X-AuthUser: davidel@xmailserver.org
Date: Mon, 5 Mar 2007 22:31:11 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Eric Dumazet <dada1@cosmosbay.com>
cc: "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch v2] epoll use a single inode ...
In-Reply-To: <45ED08A9.9050501@cosmosbay.com>
Message-ID: <Pine.LNX.4.64.0703052230300.4907@alien.or.mcafeemobile.com>
References: <Pine.LNX.4.64.0703051532590.4907@alien.or.mcafeemobile.com>
 <Pine.LNX.4.64.0703051558070.3998@woody.linux-foundation.org>
 <Pine.LNX.4.64.0703051609430.4907@alien.or.mcafeemobile.com>
 <Pine.LNX.4.64.0703051621590.3998@woody.linux-foundation.org>
 <45ECD122.6020907@zytor.com> <Pine.LNX.4.64.0703051832260.4907@alien.or.mcafeemobile.com>
 <45ECD3D4.5020305@zytor.com> <Pine.LNX.4.64.0703051841380.4907@alien.or.mcafeemobile.com>
 <45ED08A9.9050501@cosmosbay.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1795850513-2079782655-1173162671=:4907"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1795850513-2079782655-1173162671=:4907
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Tue, 6 Mar 2007, Eric Dumazet wrote:

> Davide Libenzi a =E9crit :
> > On Mon, 5 Mar 2007, H. Peter Anvin wrote:
> >=20
> > > Davide Libenzi wrote:
> > > > Right now is using:
> > > >=20
> > > > =09this.len =3D sprintf(name, "[%u.%d]", current->pid, fd);
> > > >=20
> > > > That should be unique and not have the wraparound problem. Ack?
> > > >=20
> > > NAK, very much NAK.
> > >=20
> > > File descriptors aren't file structures, they're *pointers* to file
> > > structures.
> > >=20
> > > It's perfectly possible -- downright common -- for a file descriptor =
to be
> > > inherited by another process, and then the pid is recycled -- collisi=
on.
> >=20
> > Ugh! Right! 64 bit counter it is ... :)
>=20
> For epoll, I suspect this is harmless : Programs dont allocate epolls fd =
every
> milli second, but at startup only.
>=20
> For pipes/sockets, using a 64 bits would be problematic, because sprintf(=
)
> uses a divide for each digit. And a divide is slow. Ten divides are *very=
*
> slow.

This would be used for epoll, signalfd and timerfd. And the printf format=
=20
is %llu ;)



- Davide


--1795850513-2079782655-1173162671=:4907--
