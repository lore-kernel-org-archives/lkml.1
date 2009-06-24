Return-Path: <linux-kernel-owner+w=401wt.eu-S1755494AbZFXIyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494AbZFXIyR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 04:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752633AbZFXIyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 04:54:06 -0400
Received: from zelda.netsplit.com ([87.194.19.211]:46483 "EHLO
	zelda.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270AbZFXIyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 04:54:05 -0400
Subject: Re: +
 proc-connector-add-event-for-process-becoming-session-leader.patch added to
 -mm tree
From: Scott James Remnant <scott@ubuntu.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Matt Helsley <matthltc@us.ibm.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20090623202937.GA31252@redhat.com>
References: <20090623202937.GA31252@redhat.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-YVOI5tQskgj5pQUcS8XN"
Date: Wed, 24 Jun 2009 09:53:51 +0100
Message-Id: <1245833631.3280.0.camel@wing-commander>
Mime-Version: 1.0
X-Mailer: Evolution 2.27.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-YVOI5tQskgj5pQUcS8XN
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-06-23 at 22:29 +0200, Oleg Nesterov wrote:

> > The act of a process becoming a session leader is a useful signal to a
> > supervising init daemon such as Upstart.
> ...
> > @@ -360,8 +360,10 @@ void __set_special_pids(struct pid *pid)
> >  {
> >  	struct task_struct *curr =3D current->group_leader;
> >
> > -	if (task_session(curr) !=3D pid)
> > +	if (task_session(curr) !=3D pid) {
> >  		change_pid(curr, PIDTYPE_SID, pid);
> > +		proc_sid_connector(curr);
> > +	}
>=20
> Wouldn't it better to change sys_setsid() then? This looks more clear
> imho, and we can move proc_sid_connector() outside of tasklist_lock.
>=20
> Note also that __set_special_pids() does not neccessary mean we are
> becoming a session leader, see daemonize().
>=20
Actually, I specifically wanted to receive this event if the process
called daemonize() which is why this is done here rather than in
sys_setsid()

The new session is important information to init in figuring out what
the process is up to (ie, fork(), setsid(), fork() =3D daemonise)

Scott
--=20
Scott James Remnant
scott@ubuntu.com

--=-YVOI5tQskgj5pQUcS8XN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkpB6ZsACgkQSnQiFMl4yK7ImwCeJ+Mqx637z+C7ih3l7cOUj1cc
9oQAoKPxMXIwrOhKM5/2az44NaZIkQdw
=owtZ
-----END PGP SIGNATURE-----

--=-YVOI5tQskgj5pQUcS8XN--

