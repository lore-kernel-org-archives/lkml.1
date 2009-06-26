Return-Path: <linux-kernel-owner+w=401wt.eu-S1757496AbZFZMiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757496AbZFZMiy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 08:38:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755743AbZFZMiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 08:38:46 -0400
Received: from zelda.netsplit.com ([87.194.19.211]:43832 "EHLO
	zelda.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754963AbZFZMip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 08:38:45 -0400
Subject: Re: [PATCH] proc connector: add event for process becoming session
 leader
From: Scott James Remnant <scott@ubuntu.com>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Sukadev <sukadev@us.ibm.com>,
       Containers <containers@lists.linux-foundation.org>,
       Michael Kerrisk <mtk.manpages@gmail.com>, linux-man@vger.kernel.org
In-Reply-To: <20090623210110.GB7931@count0.beaverton.ibm.com>
References: <E1MGUmL-00036A-EE@zelda.netsplit.com>
	 <20090622161909.e5706885.akpm@linux-foundation.org>
	 <20090623210110.GB7931@count0.beaverton.ibm.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-CTfRoWWA/NCjTplhDOgz"
Date: Fri, 26 Jun 2009 13:38:51 +0100
Message-Id: <1246019931.10001.7.camel@quest>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-CTfRoWWA/NCjTplhDOgz
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-06-23 at 14:01 -0700, Matt Helsley wrote:

> On Mon, Jun 22, 2009 at 04:19:09PM -0700, Andrew Morton wrote:
> > > +	get_seq(&msg->seq, &ev->cpu);
> > > +	ktime_get_ts(&ts); /* get high res monotonic timestamp */
> > > +	put_unaligned(timespec_to_ns(&ts), (__u64 *)&ev->timestamp_ns);
> > > +	ev->what =3D PROC_EVENT_SID;
> > > +	ev->event_data.sid.process_pid =3D task->pid;
> >=20
> > This is a bit of a worry.  In a containerised environment, pids are not
> > unique.  Now what do we do?
>=20
> An excellent point. It's broadcast via a netlink multicast address. That
> means we'd have pids and listeners from arbitrary combinations of pid
> namespaces.
>=20
Yeah, right now that's a general problem with the netlink approach
compared to the signal approach I was using before.  Of course, it's
also non-obvious how init in the initial pid namespace should deal with
processes dying in a different pid namespace.

> One obvious but poor solution is to only send the pid of the initial
> pid namespace. Then it's not ambiguous what an event refers to. However
> it also means that the events would only be useful to tasks running
> in the initial pid namespace -- not a good solution given Scott's example
> and our desire to run things like sshd in separate pid namespaces.
>=20
> Alternatively, we may be able to split up the connector such that the
> listeners only see events from their own pid namespace. I'm not
> sure that netlink and connectors can enable this change though.
>=20
Or the netlink socket could include both the pid, and a descriptor of
the pid namespace that it is in (isn't it just a pid itself?)  That way
listeners could check the namespace is the same before carrying on.

Though that obviously leaks information you may not actually want
leaked?

Scott
--=20
Scott James Remnant
scott@ubuntu.com

--=-CTfRoWWA/NCjTplhDOgz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkpEwVsACgkQSnQiFMl4yK57OACfVQ8ViJZ7b+jZbZX9uGrUDbm7
j5IAn25/66V08JFiIVSD4sS+GT8iViQz
=d+9F
-----END PGP SIGNATURE-----

--=-CTfRoWWA/NCjTplhDOgz--

