Return-Path: <linux-kernel-owner+w=401wt.eu-S1752110AbYL2PVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110AbYL2PVc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 10:21:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751368AbYL2PVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 10:21:24 -0500
Received: from zelda.netsplit.com ([87.194.19.211]:56133 "EHLO
	zelda.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273AbYL2PVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 10:21:24 -0500
Subject: Re: [RFC][PATCH] Notify init when processes are reparented to it
From: Scott James Remnant <scott@canonical.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20081229132305.GA31210@redhat.com>
References: <1230378128.7026.50.camel@quest>
	 <20081227114452.GA2919@zelda.netsplit.com>
	 <20081228092024.GA21673@redhat.com>
	 <20081228220122.62940FC278@magilla.sf.frob.com>
	 <1230551457.4664.0.camel@wing-commander>
	 <20081229132305.GA31210@redhat.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-URFyxjz+rq7LqJZPoZa7"
Date: Mon, 29 Dec 2008 07:21:11 -0800
Message-Id: <1230564071.4664.8.camel@wing-commander>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-URFyxjz+rq7LqJZPoZa7
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-12-29 at 14:23 +0100, Oleg Nesterov wrote:

> On 12/29, Scott James Remnant wrote:
> >
> > On Sun, 2008-12-28 at 14:01 -0800, Roland McGrath wrote:
> >
> > > I'm highly skeptical that this is a desireable feature at all, and
> > > certainly I find the abuse of siginfo_t.si_status here extremely
> > > questionable.  I think we need a clear explanation of what problems
> > > the feature is intended to address.
> > >
> > Did the original e-mail not address this?
>=20
> Do you mean
>=20
> 	[RFC] Notify init when processes are reparented to it
> 	http://marc.info/?l=3Dlinux-kernel&m=3D123038049428388
>=20
> ?
>=20
> I am not sure I really understand the problem. And thus I can't
> understand how this patch can help.
>=20
No problem ;)  like anything, it's only ever perfectly clear to the guy
who wrote it - and everyone else wonders what he's going on about :p

> > We want to be able to supervise daemons.
>=20
> What do you mean?
>=20
> > Later on, 1002 will die and init will receive SIGCHLD for it.
> >
> > Unfortunately neither the 1001 or 1002 processes are known to init, eve=
n
> > though they are original children of the process it spawned (1000), for
> > init to be notified about them - this has been forgotten.
>=20
> Ok, with this patch /sbin/init knows that 1002 is a descendant
> of apache(1000) which was spwaned by init. What can init do
> with this info?
>=20
Fundamentally init would now know that the apache service terminated,
and with what exit code or by what signal.

Right now, all we know is that a process terminated (and why) - we can't
link that back to a service in any kind of foolproof manner.

With the ability to do that, when the apache service dies, we can log
that in a more useful manner (including marking the service as down) -
but most importantly, we can respawn it!

This is something we can't do with processes that daemonise right now.

Scott

--=-URFyxjz+rq7LqJZPoZa7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklY6uQACgkQSnQiFMl4yK7Y0ACgowGk+TMP4exQ3rMf9TwKqBmF
RwwAn2GSYdbsRIoFjfSS71sn31WnmfDy
=+HNR
-----END PGP SIGNATURE-----

--=-URFyxjz+rq7LqJZPoZa7--

