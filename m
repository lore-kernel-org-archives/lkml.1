Return-Path: <linux-kernel-owner+w=401wt.eu-S932129AbXGWVzR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932129AbXGWVzR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 17:55:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757550AbXGWVzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 17:55:05 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:56147 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757280AbXGWVzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 17:55:02 -0400
From: Nigel Cunningham <nigel@nigel.suspend2.net>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] Re: Hibernation considerations
Date: Tue, 24 Jul 2007 07:55:00 +1000
User-Agent: KMail/1.9.6
Cc: nigel@suspend2.net, Paul Mackerras <paulus@samba.org>, david@lang.hm,
       Miklos Szeredi <miklos@szeredi.hu>, linux-kernel@vger.kernel.org,
       miltonm@bga.com, ying.huang@intel.com,
       linux-pm@lists.linux-foundation.org,
       Jeremy Maitin-Shepard <jbms@cmu.edu>
References: <Pine.LNX.4.44L0.0707231120380.3545-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0707231120380.3545-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1483447.JhtF0ov2Er";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707240755.01820.nigel@nigel.suspend2.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1483447.JhtF0ov2Er
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi.

On Tuesday 24 July 2007 01:23:15 Alan Stern wrote:
> On Mon, 23 Jul 2007, Nigel Cunningham wrote:
>=20
> > Take a step back for a second.
> >=20
> > The problem we're facing now is that we're getting some userspace threa=
ds,=20
> > used in processing I/O, that are functioning as exceptions to the "free=
ze=20
> > userspace, then freezeable kernel threads" rule. They are only exceptio=
ns=20
> > because of that role in processing I/O - because they're de facto kerne=
l=20
> > threads. So, if we orient our thinking more in terms of I/O processing =
and=20
> > less in terms of the userspace/kernelspace distinction, we'll have a=20
> > solution:
> >=20
> > 1) Freeze processes that aren't fs related (ie stop them generating I/O=
).
>=20
> The problem here is that with things like FUSE, _every_ process is=20
> potentially fs related.  Nothing prevents a FUSE thread from doing IPC=20
> with any other thread.

Yes, but the fuse thread is going to know what other thread it's doing IPC=
=20
with, so it can get that thread flagged too.

> > 2) Flush pending I/O.
> > 3) Freeze filesystems in reverse order of dependency, the primary purpo=
se=20
> > being to stop them generating further I/O on their metadata.
> >=20
> > Locks that are being held are only being held because work is being don=
e.=20
If=20
> > we progressively focus on threads in terms of their create/process work=
=20
> > dependencies, we'll see that the problem isn't at all intractable.
>=20
> As has been mentioned before, keeping track of all that dependency=20
> information would be very fragile and time-consuming.

I disagree. It's at least going to be less fragile and time-consuming then=
=20
maintaining new/extra code for kexec.

Nigel


--nextPart1483447.JhtF0ov2Er
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGpSO1N0y+n1M3mo0RAk3RAKDAb98mqiRLbzd3FCufl+9NxNO6zACgjv4u
mmH/Mz3esbPmL1FSGHVFvvw=
=Kgxx
-----END PGP SIGNATURE-----

--nextPart1483447.JhtF0ov2Er--
