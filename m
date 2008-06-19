Return-Path: <linux-kernel-owner+w=401wt.eu-S1756474AbYFSJKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756474AbYFSJKW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 05:10:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755010AbYFSJKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 05:10:08 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:35473 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709AbYFSJKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 05:10:06 -0400
Date: Thu, 19 Jun 2008 11:10:03 +0200
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: Joel Becker <Joel.Becker@oracle.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [RFC][PATCH] configfs: Report errors in
	config_*_init_type_name()
Message-ID: <20080619091003.GJ30804@localhost>
Reply-To: Louis.Rilling@kerlabs.com
References: <1213813851-7359-1-git-send-email-louis.rilling@kerlabs.com> <20080618202226.GG16780@ca-server1.us.oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_bohort-23179-1213866514-0001-2"
Content-Disposition: inline
In-Reply-To: <20080618202226.GG16780@ca-server1.us.oracle.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_bohort-23179-1213866514-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 18, 2008 at 01:22:26PM -0700, Joel Becker wrote:
> On Wed, Jun 18, 2008 at 08:30:51PM +0200, Louis Rilling wrote:
> >  [ applies on top of http://lkml.org/lkml/2008/6/12/427 ]
> >=20
> > config_item_set_name() may fail but its error code is not checked in
> > config_*_init_type_name().
> >=20
> > This patch adds the missing error checking and make config_*_init_type_=
name()
> > report errors. In-tree users are updated to report errors as well.
>=20
> 	While this patch is correct on the face, I'd like to try a
> different approach.  I wasn't thinking about it right.
> 	See, config_*_init_type_name() are generally a create-time thing.
> Almost everyone uses it without error checking because they know it is
> safe; they are usually using a static name.  config_item_set_name()
> can only error if strlen(name)>CONFIGFS_ITEM_NAME_LEN.   That's why
> config_*_init_type_name() are void.
> 	In other words, we shouldn't be adding useless error-check
> boilerplate for already-safe things.
> 	But there are a couple of users of config_*_set_type_name() that
> aren't safe.  The lockspace in fs/dlm/config.c is one (lockspace names
> can be 64 characters).  The config_*_init_type_name() helpers are quite
> convenient.
> 	I see two choices:
>=20
> 1) Make your changes to return errors from config_*_init_type_name(),
>    but don't check the errors on known-safe usage (small static
>    strings).

I don't like it very much, since users should check for the value of
CONFIGFS_ITEM_NAME_LEN to ensure that this is a safe usage.

> 2) Provide two API, one that is void and one that is not, so that
>    known-safe usage can use the void call (and BUG_ON() if the strlen()
>    is off), while other usage checks the errors.

Ok. What about config_*_init_type_long_name()?

Louis

--=20
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

--=_bohort-23179-1213866514-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIWiJrVKcRuvQ9Q1QRAjSNAJ9+Crz7BV/k6lVSDtoAz7w6/w8uyQCfU9EL
4gOPvCnLBHyKoFhLRj1HAUI=
=jvF/
-----END PGP SIGNATURE-----

--=_bohort-23179-1213866514-0001-2--
