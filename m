Return-Path: <linux-kernel-owner+w=401wt.eu-S1759248AbYHTPEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759248AbYHTPEW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 11:04:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758046AbYHTPEL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 11:04:11 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:54241 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758042AbYHTPEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 11:04:10 -0400
Date: Wed, 20 Aug 2008 17:04:08 +0200
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: Martin Uecker <muecker@gwdg.de>
Cc: Steven Whitehouse <swhiteho@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: distributed shared memory / mmap
Message-ID: <20080820150408.GE581@hawkmoon.kerlabs.com>
Reply-To: Louis.Rilling@kerlabs.com
References: <1219238336.8097.29.camel@localhost> <1219243404.20622.156.camel@quoit>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_bohort-26697-1219244518-0001-2"
Content-Disposition: inline
In-Reply-To: <1219243404.20622.156.camel@quoit>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_bohort-26697-1219244518-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 20, 2008 at 03:43:24PM +0100, Steven Whitehouse wrote:
> Hi,
>=20
> On Wed, 2008-08-20 at 15:18 +0200, Martin Uecker wrote:
> >=20
> > Hi!
> >=20
> > Is there any easy way to get shared memory between to
> > processes on different machines? It seems possible using mmap
> > on a file system like GFS on top of a distributed block device.
> >=20
> >=20
> > Sincerly,
> > Martin Uecker
> >=20
> Yes, you can do it using GFS/GFS2 and it should work. On the other hand,
> don't do it. Its probably not what you want and unlikely to give you
> good performance since the locking is "per inode" and thus you'll
> generate a lot of cache flushing if there is any appreciable amount of
> writing to the shared region. If you have a read mostly (or only)
> workload, then it will work much better.

Alternatively, you can use kernel-level DSM like provided by Kerrighed.
Kerrighed provides cluster-wide SYSV shm segments, which sharing is handled
at the page level -> far better than the inode level.

You may find this solution not-so-easy though...

Regards,

Louis

--=20
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

--=_bohort-26697-1219244518-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIrDJoVKcRuvQ9Q1QRAqeAAKCRDWCef83Th7CpZfJRUVppim5DmACdFmzQ
uKnjG3f5K/er1tqJSSJCdMo=
=Z4/3
-----END PGP SIGNATURE-----

--=_bohort-26697-1219244518-0001-2--
