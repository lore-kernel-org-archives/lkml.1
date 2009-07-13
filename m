Return-Path: <linux-kernel-owner+w=401wt.eu-S932119AbZGMVzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932119AbZGMVzA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 17:55:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757547AbZGMVzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 17:55:00 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:33171 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757539AbZGMVy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 17:54:59 -0400
Subject: Re: [PATCH] wireless: wl12xx, fix lock imbalance
From: Johannes Berg <johannes@sipsolutions.net>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <4A5BAC77.9010503@gmail.com>
References: <1247520266-32007-1-git-send-email-jirislaby@gmail.com>
	 <1247521235.7178.1.camel@johannes.local>  <4A5BAABF.9020708@gmail.com>
	 <1247521789.7178.2.camel@johannes.local>  <4A5BAC77.9010503@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-E8TiKi1NXynytDPaTnTB"
Date: Mon, 13 Jul 2009 23:54:27 +0200
Message-Id: <1247522068.7178.4.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-E8TiKi1NXynytDPaTnTB
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-07-13 at 23:51 +0200, Jiri Slaby wrote:
> On 07/13/2009 11:49 PM, Johannes Berg wrote:
> > On Mon, 2009-07-13 at 23:44 +0200, Jiri Slaby wrote:
> >=20
> >>> I've had local hacks
> >>> many times to make sparse aware of mutexes, is there a reason they ar=
e
> >>> not annotated with __acquire(s)/__release(s) like spinlocks etc.?
> >>
> >> Mutexes are often locked/unlocked interprocedural which I think sparse
> >> can't do much about.
> >=20
> > Well, you annotate those functions too, of course.
>=20
> Sorry, I don't understand. What functions I annotate?

Well those that take the mutex, e.g.

void acquire_foo(struct foo *f)
{
	mutex_lock(&f->mtx);
}


turns to

void acquire_foo(struct foo *f)
	__acquires(f->mtx)
{
	mutex_lock(&f->mtx);
}

johannes

--=-E8TiKi1NXynytDPaTnTB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKW60QAAoJEODzc/N7+Qma8T0P/18DYtRI0mgm1YwS7EMTssM6
mkXlWOnaPQKbky8bLw+TzEjVPlBxff+54UGSF8EtKxfVoEk8o7UyfUWb3S6teFtx
PMu91C3QyzYL7BRjjS3+4/vhSO6OOjVglCkDOT4JS/ZCxoAu89ZuxVEEWd582RBY
A0OWCPDpm0Td4s2KGEZHt4LvqFYCgea+KdZgLnvROXwtmoRMQhNNA3/83aN4HY02
JSKp82riC62ZxmXoNshq+nFq/Ydxp5chT/mBvfC020+iUuSfWhJsbQDSnI5Nf4St
25OaB6qdKVS1HMPS/ixc8tFUnuCNo6cqEZLTks5mVnj/i9msTBd2Fekyb6VtiRtp
hFWPYePE9OALaL535uSHhfJNZFdUu5fCJ7wX+YGtWSehCUGpOAhKEVwOpXfpzRtD
dsIenjPMrAy1xzU8A9mMuAJbC1a4cLbCjN78AlO4rRgwOI55dSxniRQ8zdYhX1E+
eV8tCewQ2wvllx6iflyh6SYD3UWtnnx5Y7SOEHWFakoKu/sk+RZvAZw0Q/qv1Yrh
+886RmcTKrOaeZdOBk+ZAOCOcy6wJkP/NFs/N8nIVnsyjdt6nRG34EG3cDTm8t0V
TLht/hQbcASylwsEK0sxhRMtnWVxiy96e/fGFjqRV9VdS906b8jBMds0vWyW8pwC
ReNFH3iXAIc4KoUBvfIe
=TTqF
-----END PGP SIGNATURE-----

--=-E8TiKi1NXynytDPaTnTB--

