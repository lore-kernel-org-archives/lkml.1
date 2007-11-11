Return-Path: <linux-kernel-owner+w=401wt.eu-S1755825AbXKKDXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825AbXKKDXT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 22:23:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752737AbXKKDXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 22:23:09 -0500
Received: from cantor.suse.de ([195.135.220.2]:50788 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751882AbXKKDXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 22:23:08 -0500
Date: Sat, 10 Nov 2007 19:23:13 -0800
From: John Johansen <jjohansen@suse.de>
To: Crispin Cowan <crispin@crispincowan.com>
Cc: Andi Kleen <andi@firstfloor.org>, Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       LSM ML <linux-security-module@vger.kernel.org>,
       apparmor-dev <apparmor-dev@forge.novell.com>
Subject: Re: AppArmor Security Goal
Message-ID: <20071111032313.GA19216@suse.de>
References: <473380AD.5070801@crispincowan.com> <p73tzntzuak.fsf@bingen.suse.de> <4736219E.50207@crispincowan.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FL5UXtIhxfXey3p5"
Content-Disposition: inline
In-Reply-To: <4736219E.50207@crispincowan.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 10, 2007 at 01:24:46PM -0800, Crispin Cowan wrote:
> Andi Kleen wrote:
> > Crispin Cowan <crispin@crispincowan.com> writes:
> >
> > The document should be a good base for a merge.
> >
> >  =20
> >>     * A confined process can operate on a file descriptor passed to it
> >>       by an unconfined process, even if it manipulates a file not in t=
he
> >>       confined process's profile. To block this attack, confine the
> >>       process that passed the file descriptor.
> >>    =20
> >
> > That is the only thing that tripped me up a bit while reading the docum=
ent.
> > Can you expand a bit on the reasons why the fd is not rechecked in
> > the context of the target process? Best do it in a new version of the
> > document.
> >  =20
> The reason is a disgusting implementation problem, so instead of going
> into lots of detail, I just disclaimed it.
>=20
Well perhaps a little disgusting but it isn't the reason.  We discussed
this on the rewrite with the vfsmnt passed through the vfs.  We could
have changed the implementation but in the end decided to to leave it
in place for the time being.

> The excuse :) is that UNIX/Linux already has an object-capability
> orientation with respect to passing file descriptors around; you can
> pass an FD to a process that doesn't have access to the file, and DAC
> (user ownership & such) won't check it either.
>=20
yep, the discussion really did come down to object capability and
unconfined processes.

> This aspect of the semantics is not my favorite, but it is at least
> consistent with the AppArmor view that unconfined processes can do
> absolutely anything and AppArmor won't try to stop them.
>=20
and the the other major point surfaces

> The actual reason: FDs that are passed from some other *confined*
> process actually are checked, because the FD has data structures on it
> that we can use to hook for checking. The problem is that an FD from a
> completely unconfined process has no such data structures. To fix this,
> we would have to check access on every single read and write, and that
> would make performance suck.
>=20
Not so, we can add that, and I have prototyped code to do so.  The issue
really is about how unconfined processes should interact with confined
processes.

> If there is a clean way to close this issue, I would be interested.
>=20
What is considered a clean way to change this has been an on and
off again discussion, its been about 9 months since we last discussed
it so I am not surprised Crispin has paged it out.

The issue really does come down to how to express the interaction of
confined and unconfined tasks in policy.  The discussion always comes
back to object capabilities, unconfined's behavior, and how to
best express it.

> On the other hand, there is a fairly passionate community of Object
> Capability fans who really want access rights to be delegable, and the
> other way to go is to remove all checking on passed FDs.
>=20
> There are advantages to going both ways, and I don't believe that
> AppArmor is locked in stone, so either one could be chosen in the
> future. See this interesting thread on LSM
> http://marc.info/?t=3D119464929300003&r=3D1&w=3D2
>=20
No it isn't, the behavior was intended to be revisited when we
had IPC, and or a prototype for expressing which file objects can be
passed.

--FL5UXtIhxfXey3p5
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)

iD8DBQFHNnWhi/GH5xuqKCcRAvTIAKCa3LvHqggXEKktladvPqnPdbEACACePQ3u
sRSyILD7FlVT4rrKYTtJNc4=
=fC2q
-----END PGP SIGNATURE-----

--FL5UXtIhxfXey3p5--
