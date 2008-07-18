Return-Path: <linux-kernel-owner+w=401wt.eu-S1754609AbYGRIsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609AbYGRIsS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 04:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752825AbYGRIsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 04:48:10 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:49564 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733AbYGRIsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 04:48:09 -0400
Date: Fri, 18 Jul 2008 10:48:03 +0200
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: Joel.Becker@localdomain
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Mark Fasheh <mfasheh@suse.com>, linux-kernel@vger.kernel.org,
       ocfs2-devel@oss.oracle.com, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Ocfs2-devel] [git patches] Ocfs2 and Configfs updates for
	2.6.27
Message-ID: <20080718084803.GB3887@localdomain>
Reply-To: Louis.Rilling@kerlabs.com
References: <20080717175146.GH28014@wotan.suse.de> <alpine.LFD.1.10.0807171056520.2959@woody.linux-foundation.org> <20080717212038.GA8283@ca-server1.us.oracle.com> <20080717214512.GB8283@ca-server1.us.oracle.com> <20080717223018.GC8283@ca-server1.us.oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_bohort-3797-1216370777-0001-2"
Content-Disposition: inline
In-Reply-To: <20080717223018.GC8283@ca-server1.us.oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_bohort-3797-1216370777-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 17, 2008 at 03:30:18PM -0700, Joel Becker wrote:
> On Thu, Jul 17, 2008 at 02:45:12PM -0700, Joel Becker wrote:
> > On Thu, Jul 17, 2008 at 02:20:38PM -0700, Joel Becker wrote:
> > > On Thu, Jul 17, 2008 at 11:01:40AM -0700, Linus Torvalds wrote:
> > > > I pulled it, but I want to register my protest.
> > >=20
> > > 	I wish you hadn't, because it won't be to difficult to go back
> > > to PTR_ERR().  However, don't revert it - that affects some of the
> > > follow-on patches that were affected by the change.
> >=20
> > 	I lied.  I'll cleanup the fallout.  You can revert it or wait
> > for my revert + PTR_ERR.  Let me know if you revert it.
>=20
> Linus,
> 	Pull this to get the revert and the PTR_ERR() version:
>=20
> git://oss.oracle.com/git/jlbec/linux-2.6.git configfs-fixup-ptr-error
>=20
> It's tested with the same testing I did before - ocfs2 and netconsole.

While this new version looks ok, it seems that it still allows client
subsystems to return NULL in ->make_group()/->make_item(), in which case
configfs_mkdir() turns the result into -ENOMEM. Maybe this is intended to
smoothly update out-of-tree subsystems? I'd suggest to schedule a removal
of this backward compatibility, and display an error log to encourage
fixing the subsystems that still return NULL.

Louis

--=20
Dr Louis Rilling			Kerlabs - IRISA
Skype: louis.rilling			Campus Universitaire de Beaulieu
Phone: (+33|0) 2 99 84 71 52		Avenue du General Leclerc
Fax: (+33|0) 2 99 84 71 71		35042 Rennes CEDEX - France
http://www.kerlabs.com/

--=_bohort-3797-1216370777-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIgFjDVKcRuvQ9Q1QRAtEcAKC0RrIqxjDULZ48lbCnnLHJC5q2NgCbBBrD
Ua71XtPq8RnV3B7sRYogScQ=
=L+w7
-----END PGP SIGNATURE-----

--=_bohort-3797-1216370777-0001-2--
