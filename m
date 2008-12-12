Return-Path: <linux-kernel-owner+w=401wt.eu-S1758057AbYLLKGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758057AbYLLKGZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 05:06:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751150AbYLLKGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 05:06:18 -0500
Received: from bohort.kerlabs.com ([62.160.40.57]:35524 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbYLLKGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 05:06:17 -0500
Date: Fri, 12 Dec 2008 11:06:15 +0100
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: Steven Whitehouse <swhiteho@redhat.com>, linux-kernel@vger.kernel.org,
       cluster-devel@redhat.com
Subject: Re: configfs, dlm_controld & lockdep
Message-ID: <20081212100615.GD19128@hawkmoon.kerlabs.com>
Reply-To: Louis.Rilling@kerlabs.com
Mail-Followup-To: Steven Whitehouse <swhiteho@redhat.com>,
	linux-kernel@vger.kernel.org, cluster-devel@redhat.com
References: <1229005208.3625.26.camel@localhost.localdomain> <20081211144441.GA19128@hawkmoon.kerlabs.com> <20081211173437.GA25844@ca-server1.us.oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_bohort-31756-1229076219-0001-2"
Content-Disposition: inline
In-Reply-To: <20081211173437.GA25844@ca-server1.us.oracle.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_bohort-31756-1229076219-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 11/12/08  9:34 -0800, Joel Becker wrote:
> On Thu, Dec 11, 2008 at 03:44:41PM +0100, Louis Rilling wrote:
> > These warnings are known issues. This results from a lack of lockdep an=
notations
> > in configfs. I must admit that I started to send patches for that a few=
 months
> > ago, and then could not find time to finish this work.
> >=20
> > The problem is a bit harder than just playing with I_MUTEX_CHILD, I_MUT=
EX_PARENT
> > and I_MUTEX_NORMAL, since configfs recursively locks variable numbers
> > (this can go to as many as the depth of the whole configfs tree) of
> > config_group inodes during operations like mkdir(), rmdir(), and depend=
_item().
> >=20
> > I was working on two kinds of solutions:
> > 1) insert lockdep_off()/lockdep_on() at the places of recursion,
> > 2) separate default groups inode mutex classes according to their depth=
 under
> > the created group they belong to.
> >=20
> > People tend to reject any proposition like 1), but IIRC Joel was tendin=
g to
> > accept it.
> >=20
> > Solution 2) does not work for depend_item(). This needs to rework the l=
ocking
> > scheme of depend_item() by removing the variable lock recursion depth, =
and I
> > think that it's doable thanks to the configfs_dirent_lock.
> > 	Joel, what do you think about this?
>=20
> 	I've been waiting for your patch for (1).  I am wary of the (2)
> approach.  Not because it wouldn't work for mkdir(2) - I think it would.
> But rmdir(2) has the same recursive locking, with far more importance
> (live objects), and would print the same error.

??

(2) is fine for both mkdir() and rmdir(), since they both lock inodes'
mutexes along paths, and only paths. The problem is depend_item().

Anyway, I'll post patches based on (1) and later I'll propose patches based
on (2).

Louis

--=20
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

--=_bohort-31756-1229076219-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFJQjeXVKcRuvQ9Q1QRAmf1AJ90RCrdFA383hrvLEhpRQ66I6XIMQCdHEyX
gziwabQ6a/dyAUYIivj3qpo=
=iCjC
-----END PGP SIGNATURE-----

--=_bohort-31756-1229076219-0001-2--
