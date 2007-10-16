Return-Path: <linux-kernel-owner+w=401wt.eu-S932341AbXJPGAM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932341AbXJPGAM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 02:00:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763980AbXJPF75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 01:59:57 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45510 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763796AbXJPF74 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 01:59:56 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       linux-netdev@vger.kernel.org, davem@redhat.com, jgarzik@redhat.com
Subject: Re: [PATCH] ipv4: kernel panic when only one unsecured port available
References: <m3fy0k9yod.fsf@bandura.englab.brq.redhat.com>
	<20071015124919.30ed8f06.akpm@linux-foundation.org>
	<20071015.130614.129757419.davem@davemloft.net>
	<20071015140025.84e73297.akpm@linux-foundation.org>
From: Anton Arapov <aarapov@redhat.com>
X-URL: http://people.redhat.com/aarapov
Date: Tue, 16 Oct 2007 07:59:46 +0200
In-Reply-To: <20071015140025.84e73297.akpm@linux-foundation.org> (Andrew Morton's message of "Mon\, 15 Oct 2007 14\:00\:25 -0700")
Message-ID: <m3wstnioq5.fsf@bandura.englab.brq.redhat.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/23.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

Andrew Morton <akpm@linux-foundation.org> writes:
> <looks>
>
> OK, in ipv4_local_port_range() we have=20
>
>                 if (range[1] <=3D range[0])
>                         ret =3D -EINVAL;
>
[...skipped...]

> : ip_local_port_range
> : -------------------
> :
> : Range of  ports  used  by  TCP  and UDP to choose the local port. Conta=
ins two
> : numbers, the  first  number  is the lowest port, the second number the =
highest
> : local port.  Default  is  1024-4999.  Should  be  changed  to  32768-61=
000 for
> : high-usage systems.
>
> ie: inclusive.
>
> Documentation/networking/ip-sysctl.txt says
>
> : ip_local_port_range - 2 INTEGERS
> : 	Defines the local port range that is used by TCP and UDP to
> : 	choose the local port. The first number is the first, the=20
> : 	second the last local port number. Default value depends on
> : 	amount of memory available on the system:
> : 	> 128Mb 32768-61000
> : 	< 128Mb 1024-4999 or even less.
> : 	This number defines number of active connections, which this
> : 	system can issue simultaneously to systems not supporting
> : 	TCP extensions (timestamps). With tcp_tw_recycle enabled
> : 	(i.e. by default) range 1024-4999 is enough to issue up to
> : 	2000 connections per second to systems supporting timestamps.
>
> also inclusive.

  I'm also agree, that we should have an ability to use the same
minimum/maximum port number for the cases when we want to use only
one port.

=2D-=20
Anton Arapov, <aarapov@redhat.com>
GPG Key ID: 0x6FA8C812

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFHFFNVVub9yW+oyBIRAmUaAJsGVCdVL2VE3DIp3F4ph30tqAKsPwCg0p9s
1MEQPBK7tGc1W0OXDsGLmi0=
=qMqh
-----END PGP SIGNATURE-----
--=-=-=--
