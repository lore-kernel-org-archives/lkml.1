Return-Path: <linux-kernel-owner+w=401wt.eu-S1031014AbXDPWLY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031014AbXDPWLY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 18:11:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031012AbXDPWLY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 18:11:24 -0400
Received: from cantor.suse.de ([195.135.220.2]:44516 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031006AbXDPWLX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 18:11:23 -0400
Date: Mon, 16 Apr 2007 15:11:44 -0700
From: John Johansen <jjohansen@suse.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andreas Gruenbacher <agruen@suse.de>, Andi Kleen <andi@firstfloor.org>,
       jjohansen@suse.de, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chrisw@sous-sol.org
Subject: Re: [AppArmor 39/41] AppArmor: Profile loading and manipulation, pathname matching
Message-ID: <20070416221143.GA1143@suse.de>
References: <20070412090809.917795000@suse.de> <20070412090849.465428000@suse.de> <p733b35903l.fsf@bingen.suse.de> <200704151621.52906.agruen@suse.de> <20070416230001.3143ada1@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/04w6evG8XlLl3ft"
Content-Disposition: inline
In-Reply-To: <20070416230001.3143ada1@the-village.bc.nu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 16, 2007 at 11:00:01PM +0100, Alan Cox wrote:
> > don't actually have to care --- if loading an invalid profile can bring=
 down=20
> > the system, then that's no worse than an arbitrary module that crashes =
the=20
> > machine. Not sure if there will ever be user loadable profiles; at leas=
t at=20
> > that point we had to care.
>=20
> CAP_SYS_RAWIO is needed to do arbitary patching/loading in the capability
> model so if you are using lesser capabilities it is a (minor) capability
> rise but not a big problem, just ugly and wanting a fix
>=20
> > > > +	/*
> > > > +	 * Replacement needs to allocate a new aa_task_context for each
> > > > +	 * task confined by old_profile.  To do this the profile locks
> > > > +	 * are only held when the actual switch is done per task.  While
> > > > +	 * looping to allocate a new aa_task_context the old_task list
> > > > +	 * may get shorter if tasks exit/change their profile but will
> > > > +	 * not get longer as new task will not use old_profile detecting
> > > > +	 * that is stale.
> > > > +	 */
> > > > +	do {
> > > > +		new_cxt =3D aa_alloc_task_context(GFP_KERNEL | __GFP_NOFAIL);
> > >=20
> > > NOFAIL is usually a bad sign. It should be only used if there is no
> > > alternative.
> >=20
> > At this point there is no secure alternative to allocating a task conte=
xt ---=20
> > except killing the task, maybe.
>=20
> Can you count the number needed, preallocate them and then when you know
> for sure either succeed or fail the operation as a whole ?

No, to be accurate the count would have to be made with the profile lock
held, which would then need to be released so as not to use GFP_ATOMIC
for the allocations.

An iterative approach could be taken where we do something like
repeat:
  lock profile
     count
     if preallocated < count
        unlock profile
        if (! allocate count - preallocated)
           Fail
        goto repeat
  do replacement

--/04w6evG8XlLl3ft
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFGI/Sfi/GH5xuqKCcRAgZQAJ43uLsD5zFot1miBm/3Ixr0Wft3FQCgmf0G
7nRNeR2U2lFojgUOYorfunM=
=IoQg
-----END PGP SIGNATURE-----

--/04w6evG8XlLl3ft--
