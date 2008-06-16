Return-Path: <linux-kernel-owner+w=401wt.eu-S1758226AbYFPSOy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758226AbYFPSOy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 14:14:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757514AbYFPSOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 14:14:31 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:35723 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757391AbYFPSOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 14:14:30 -0400
Date: Mon, 16 Jun 2008 20:14:28 +0200
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: Joel.Becker@oracle.com
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC] configfs: module reference counting rules
Message-ID: <20080616181428.GW30804@localhost>
Reply-To: Louis.Rilling@kerlabs.com
References: <20080612235410.GC4012@localdomain> <20080613033309.GE20581@mail.oracle.com> <20080613095159.GH30804@localhost> <20080613202605.GD20576@mail.oracle.com> <20080613222744.GB4153@localdomain> <20080614084701.GA9657@mail.oracle.com> <20080616123912.GR30804@localhost> <20080616180643.GC9657@mail.oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_bohort-18364-1213639980-0001-2"
Content-Disposition: inline
In-Reply-To: <20080616180643.GC9657@mail.oracle.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_bohort-18364-1213639980-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 16, 2008 at 11:06:43AM -0700, Joel Becker wrote:
> > > 	Why can't mod_b provide a ->release() that does
> > > module_put(self)?
> >=20
> > Because this is simply wrong. Doing module_put(self) exposes the module=
s's
> > function to be run while another cpu unloads the module. Note how I sol=
ve this
>=20
> 	How so?  As long as the module_put() is the last thing, you're
> fine.  That said, we both have better solutions with our wrappered
> functions.

With a preemptible kernel, after module_put(self) the few assembly instruct=
ions
cleaning up the stack before returning to the caller can be called after the
memory allocated for the module has been freed. Which will make the kernel
crash.

Louis

--=20
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

--=_bohort-18364-1213639980-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIVq2EVKcRuvQ9Q1QRAsWlAKCu1Wh8+GebNJTNoZDL7qOenxksaQCguTYo
7ctj5+tOuJyYKaJ6o6YAlzY=
=UvEt
-----END PGP SIGNATURE-----

--=_bohort-18364-1213639980-0001-2--
