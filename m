Return-Path: <linux-kernel-owner+w=401wt.eu-S1758698AbYFQM5O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758698AbYFQM5O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 08:57:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756967AbYFQM47
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 08:56:59 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:42252 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756018AbYFQM46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 08:56:58 -0400
Date: Tue, 17 Jun 2008 14:56:50 +0200
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: Joel.Becker@oracle.com
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH][BUGFIX] configfs: Fix symlink() to a removing item
Message-ID: <20080617125650.GY30804@localhost>
Reply-To: Louis.Rilling@kerlabs.com
References: <20080616180911.GV30804@localhost> <20080616222900.GD6441@mail.oracle.com> <20080617104259.GX30804@localhost>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_bohort-27758-1213707321-0001-2"
Content-Disposition: inline
In-Reply-To: <20080617104259.GX30804@localhost>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_bohort-27758-1213707321-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 17, 2008 at 12:42:59PM +0200, Louis Rilling wrote:
> On Mon, Jun 16, 2008 at 03:29:00PM -0700, Joel Becker wrote:
> > On Mon, Jun 16, 2008 at 08:09:11PM +0200, Louis Rilling wrote:
> > > This patch introduces a similar (weird?) behavior as with mkdir failu=
res making
> > > rmdir fail: if symlink() races with rmdir() of the parent directory (=
or its
> > > youngest user-created ancestor if parent is a default group) or rmdir=
() of the
> > > target directory, and then fails in configfs_create(), this can make =
the racing
> > > rmdir() fail despite the concerned directory having no user-created e=
ntry (resp.
> > > no symlink pointing to it or one of its default groups) in the end.
> > > If this behavior is found unacceptable, I'll submit a fix in the same=
 spirit as
> > > the racing mkdir() fix.
> >=20
> > 	Ahh, but you can't wait on the mutex like you do in mkdir(),
> > because they're not ordered - it can race rename again.
>=20
> Yes I can. In the mkdir() case, rmdir() waits on the mutex of one of the =
default
> groups. The symlink case will be handled the same. The difference is that=
 while
> mkdir() tags the parent with CONFIGFS_USET_IN_MKDIR, symlink() will tag b=
oth the
> parent and the target with CONFIGFS_USET_IN_SYMLINK. [ We can actually me=
rge the
> two flags in something like CONFIGFS_USET_ATTACHING. ] Since tagging requ=
ires
> only to take configfs_dirent_lock, there will be no deadlock.

Hm, you were right, sorry. We can only solve the race with rmdir() removing=
 the
item where the symlink is created. For the target item, I don't know yet...

Louis

--=20
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

--=_bohort-27758-1213707321-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIV7SSVKcRuvQ9Q1QRAoq5AJ9wR9NPQuO0/uqGIuEF4EGpDI4RZACdErFm
yhqJEBaXEMD+zbo2tJB2pxA=
=L4XT
-----END PGP SIGNATURE-----

--=_bohort-27758-1213707321-0001-2--
