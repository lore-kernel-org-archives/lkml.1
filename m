Return-Path: <linux-kernel-owner+w=401wt.eu-S1753552AbZHCKw7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552AbZHCKw7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 06:52:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753346AbZHCKw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 06:52:58 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:60808 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753332AbZHCKw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 06:52:58 -0400
Date: Mon, 3 Aug 2009 12:52:52 +0200
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: Paul Menage <menage@google.com>
Cc: Benjamin Blum <bblum@google.com>, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 5/6] Makes procs file writable to move all threads by
	tgid at once
Message-ID: <20090803105252.GA29252@hawkmoon.kerlabs.com>
Mail-Followup-To: Paul Menage <menage@google.com>,
	Benjamin Blum <bblum@google.com>,
	containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
References: <20090724032033.2463.79256.stgit@hastromil.mtv.corp.google.com> <20090724032200.2463.82408.stgit@hastromil.mtv.corp.google.com> <20090724100220.GF11101@hawkmoon.kerlabs.com> <2f86c2480907241452m74c50975k522c5a43a62e8459@mail.gmail.com> <6599ad830907241457x3d1380b6ne613eb5921d6c5a0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_bohort-17497-1249296742-0001-2"
Content-Disposition: inline
In-Reply-To: <6599ad830907241457x3d1380b6ne613eb5921d6c5a0@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_bohort-17497-1249296742-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 24/07/09 14:57 -0700, Paul Menage wrote:
> On Fri, Jul 24, 2009 at 2:52 PM, Benjamin Blum<bblum@google.com> wrote:
> >> I don't see how css_sets are guaranteed while cgroup_fork_mutex is not=
 held and
> >> thus does not prevent new threads from being created right now. Could =
you
> >> elaborate on that?
> >
> > Prefetching the css sets is independent of the fork lock/race issue.
> > The idea is that we build a list, kept locally, that has references on
> > all the css_sets we'll need to migrate each thread to the new cgroup.
> > Since ordinarily we might need to malloc a new css_set for a thread
> > before moving it, and it's possible that that could fail, we need to
> > do allocations for all threads to be moved before committing any of
> > them. As long as we have the list of prefetched css_sets, they'll stay
> > there, and at the end, we drop the extra references we took on them to
> > make that guarantee when tearing down the list.
>=20
> And more specifically, since only the holder of cgroup_mutex can move
> a thread to a new cgroup (and hence a potentially new unique css_set),
> we know that once we've run through all the threads in the
> thread_group and verified that we have the appropriate pre-fetched
> css_set objects for all of them, it doesn't matter if any new threads
> are created - they'll share one of the pre-fetched css_sets.

css_set sharing is the bit I was missing. Thanks!

Louis

--=20
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

--=_bohort-17497-1249296742-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkp2wYQACgkQVKcRuvQ9Q1QLHQCgsTi4Lz32y34zAgXCK0TqnP0j
gpkAn38blVH/0+LMUB2p0EVojAJb+/gi
=L/VL
-----END PGP SIGNATURE-----

--=_bohort-17497-1249296742-0001-2--
