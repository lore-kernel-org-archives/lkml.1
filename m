Return-Path: <linux-kernel-owner+w=401wt.eu-S1756824AbYFQKnQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824AbYFQKnQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 06:43:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754257AbYFQKnD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 06:43:03 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:41142 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754064AbYFQKnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 06:43:01 -0400
Date: Tue, 17 Jun 2008 12:42:59 +0200
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: Joel.Becker@oracle.com
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH][BUGFIX] configfs: Fix symlink() to a removing item
Message-ID: <20080617104259.GX30804@localhost>
Reply-To: Louis.Rilling@kerlabs.com
References: <20080616180911.GV30804@localhost> <20080616222900.GD6441@mail.oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_bohort-26428-1213699290-0001-2"
Content-Disposition: inline
In-Reply-To: <20080616222900.GD6441@mail.oracle.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_bohort-26428-1213699290-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 16, 2008 at 03:29:00PM -0700, Joel Becker wrote:
> On Mon, Jun 16, 2008 at 08:09:11PM +0200, Louis Rilling wrote:
> > This patch introduces a similar (weird?) behavior as with mkdir failure=
s making
> > rmdir fail: if symlink() races with rmdir() of the parent directory (or=
 its
> > youngest user-created ancestor if parent is a default group) or rmdir()=
 of the
> > target directory, and then fails in configfs_create(), this can make th=
e racing
> > rmdir() fail despite the concerned directory having no user-created ent=
ry (resp.
> > no symlink pointing to it or one of its default groups) in the end.
> > If this behavior is found unacceptable, I'll submit a fix in the same s=
pirit as
> > the racing mkdir() fix.
>=20
> 	Ahh, but you can't wait on the mutex like you do in mkdir(),
> because they're not ordered - it can race rename again.

Yes I can. In the mkdir() case, rmdir() waits on the mutex of one of the de=
fault
groups. The symlink case will be handled the same. The difference is that w=
hile
mkdir() tags the parent with CONFIGFS_USET_IN_MKDIR, symlink() will tag bot=
h the
parent and the target with CONFIGFS_USET_IN_SYMLINK. [ We can actually merg=
e the
two flags in something like CONFIGFS_USET_ATTACHING. ] Since tagging requir=
es
only to take configfs_dirent_lock, there will be no deadlock.

I'll send a patch later.

Louis

--=20
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

--=_bohort-26428-1213699290-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIV5UzVKcRuvQ9Q1QRAncpAJ9xN2elFXJiDP+fNhC9P8jNr/VSoQCfU3rh
uF8lY7+0uJB9h9zFXyoFKGU=
=iEJF
-----END PGP SIGNATURE-----

--=_bohort-26428-1213699290-0001-2--
