Return-Path: <linux-kernel-owner+w=401wt.eu-S1762195AbXJZSst@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762195AbXJZSst (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 14:48:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752077AbXJZSsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 14:48:37 -0400
Received: from mail.suse.de ([195.135.220.2]:44273 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751962AbXJZSsf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 14:48:35 -0400
Date: Fri, 26 Oct 2007 11:49:46 -0700
From: John Johansen <jjohansen@suse.de>
To: Miklos Szeredi <mszeredi@suse.cz>
Cc: jjohansen@suse.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Andreas Gruenbacher <agruen@suse.de>
Subject: Re: [AppArmor 32/45] Enable LSM hooks to distinguish operations on file descriptors from operations on pathnames
Message-ID: <20071026184946.GD32415@suse.de>
References: <20071026064024.243943043@suse.de> <20071026064051.393728475@suse.de> <1193398252.4721.7.camel@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tNQTSEo8WG/FKZ8E"
Content-Disposition: inline
In-Reply-To: <1193398252.4721.7.camel@localhost>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--tNQTSEo8WG/FKZ8E
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 26, 2007 at 01:30:52PM +0200, Miklos Szeredi wrote:
> On Thu, 2007-10-25 at 23:40 -0700, jjohansen@suse.de wrote:
> > plain text document attachment (file-handle-ops.diff)
> > Struct iattr already contains ia_file since commit cc4e69de from=20
> > Miklos (which is related to commit befc649c). Use this to pass
> > struct file down the setattr hooks. This allows LSMs to distinguish
> > operations on file descriptors from operations on paths.
>=20
> There's a slight problem (other than HCH not liking it) with this
> approach of passing the open file in iattr:  for special files, the
> struct file pointer makes no sense to the filesystem, since it is always
> opened by the generic functions.
>=20
true

> This wasn't a problem with ftruncate(), because that one only works on
> regular files, but fchmod/fchown/futimes will work on special files as
> well, and the filesystem interpreting file->private_data could cause
> nasty bugs.=20
>=20
> So I think the correct solution (which was suggested by Trond and
> others) is to define an f_op->fsetattr() method, which interested
> filesystems can define.
>=20
yeah that does sound like the way to go, thank Miklos

regards
john

--tNQTSEo8WG/FKZ8E
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFHIjbKi/GH5xuqKCcRAhjEAJ9Tyb0kLl0jLJjkkntQrx8Jl9u2bgCfZP+v
vj3wHS+QovRuCGpvyOnx1ZI=
=KRyX
-----END PGP SIGNATURE-----

--tNQTSEo8WG/FKZ8E--
