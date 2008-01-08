Return-Path: <linux-kernel-owner+w=401wt.eu-S1756599AbYAHUbY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756599AbYAHUbY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 15:31:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755289AbYAHUbB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 15:31:01 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:51400 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753831AbYAHUa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 15:30:59 -0500
X-AuthUser: davidel@xmailserver.org
Date: Tue, 8 Jan 2008 12:30:58 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Eric Dumazet <dada1@cosmosbay.com>
cc: Changli Gao <xiaosuo@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Improve scalability of epoll_ctl
In-Reply-To: <4783A41B.1090100@cosmosbay.com>
Message-ID: <Pine.LNX.4.64.0801081226090.7616@alien.or.mcafeemobile.com>
References: <478397F7.1030005@gmail.com> <4783A41B.1090100@cosmosbay.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1795850513-1773120604-1199824258=:7616"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1795850513-1773120604-1199824258=:7616
Content-Type: TEXT/PLAIN; charset=GB2312
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Tue, 8 Jan 2008, Eric Dumazet wrote:

> Changli Gao a =A8=A6crit :
> > Replace the epitem rbtree with a dynamic array to get the constant inse=
rtion/deletion/modification time of the file descriptors. Reuse the size ar=
gument of epoll_create, however the size must be smaller than the max file =
descriptor number: ether the resource limitation or the compiling time limi=
tation.
> >
> >  =20
> Hum, you should read this :
>=20
> http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.7-rc3/=
2.6.7-rc3-mm2/broken-out/epoll-uses-rbtrees.patch
>=20
>=20
> Your patch is a revert of this change, it probably wont be accepted.
>=20
> epoll_ctl() is scalable, since it's O(log2(N)) : With 1 millions files
> descriptors, that means less than 20 nodes to lookup in the tree.

Indeed, and we aren't going back.


> In what situation do you think epoll_ctl() performance is bad ?

I'm sure you can cook up a microbench that only does epoll_ctl(), and with=
=20
a good hash implementation you get better numbers. This is what I did=20
before I changed to rbtree, and the numbers did not justify the code (the=
=20
"size" in epoll_create() is just an hint, and that means you need to=20
handle resizing - plus other things like locking up memory when the number=
=20
of fds shrinks, and other stuff I don't even remember).



- Davide


--1795850513-1773120604-1199824258=:7616--
