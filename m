Return-Path: <linux-kernel-owner+w=401wt.eu-S1754049AbYAXIkR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049AbYAXIkR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 03:40:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752875AbYAXIkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 03:40:05 -0500
Received: from pan.madism.org ([88.191.52.104]:33412 "EHLO hermes.madism.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752774AbYAXIkE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 03:40:04 -0500
Date: Thu, 24 Jan 2008 09:40:01 +0100
From: Pierre Habouzit <madcoder@debian.org>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: epoll and shared fd's
Message-ID: <20080124084001.GB7356@artemis.madism.org>
Mail-Followup-To: Davide Libenzi <davidel@xmailserver.org>,
	linux-kernel@vger.kernel.org
References: <20080118134318.GD9607@artemis.madism.org> <Pine.LNX.4.64.0801181257240.24685@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="WhfpMioaduB5tiZL";
	protocol="application/pgp-signature"; micalg=SHA1
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0801181257240.24685@alien.or.mcafeemobile.com>
X-Face: $(^e[V4D-[`f2EmMGz@fgWK!e.B~2g.{08lKPU(nc1J~z\4B>*JEVq:E]7G-\6$Ycr4<;Z!|VY6Grt]+RsS$IMV)f>2)M="tY:ZPcU;&%it2D81X^kNya0=L]"vZmLP+UmKhgq+u*\.dJ8G!N&=EvlD
User-Agent: Madmutt/devel (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WhfpMioaduB5tiZL
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 18, 2008 at 09:10:18PM +0000, Davide Libenzi wrote:
> On Fri, 18 Jan 2008, Pierre Habouzit wrote:
>=20
> >   Hi,
> >=20
> >   I just came across a strange behavior of epoll that seems to
> > contradict the documentation. Here is what happens:
> >=20
> > * I have two processes P1 and P2, P1 accept()s connections, and send the
> >   resulting file descriptors to P2 through a unix socket.
> >=20
> > * P2 registers the received socket in his epollfd.
> >=20
> >   [time passes]
> >=20
> > * P2 is done with the socket and closes it
> >=20
> > * P2 gets events for the socket again !
> >=20
> >=20
> >   Though the documentation says that if a process closes a file
> > descriptor, it gets unregistered. And yes I'm sure that P2 doens't dup()
> > the file descriptor. Though (because of a bug) it was still open in
> > P1[0], hence the referenced socket still live at the kernel level.
> >=20
> >   Of course the userland workaround is to force the EPOLL_CTL_DEL before
> > the close, which I now do, but costs me a syscall where I wanted to
> > spare one :|
>=20
> For epoll, a close is when the kernel file* is released (that is, when al=
l=20
> its instances are gone).
> We could put a special handling in filp_close(), but I don't think is a=
=20
> good idea, and we're better live with the current behaviour.

  Okay, maybe updating the linux manpages to be more clear about that is
the way to go then. Thanks

--=20
=C2=B7O=C2=B7  Pierre Habouzit
=C2=B7=C2=B7O                                                madcoder@debia=
n.org
OOO                                                http://www.madism.org

--WhfpMioaduB5tiZL
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHmE7hvGr7W6HudhwRAnKkAJ9Y77TrfcXYjvTwgpQywCZZEJScxwCeLEs6
EQgg+UBFjOhsggWgU2ZzcrM=
=UZm7
-----END PGP SIGNATURE-----

--WhfpMioaduB5tiZL--
