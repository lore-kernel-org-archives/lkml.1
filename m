Return-Path: <linux-kernel-owner+w=401wt.eu-S1765651AbXGUMnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765651AbXGUMnm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 08:43:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761890AbXGUMne
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 08:43:34 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:43584 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755321AbXGUMnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 08:43:33 -0400
From: Nigel Cunningham <nigel@nigel.suspend2.net>
To: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [linux-pm] Re: Hibernation considerations
Date: Sat, 21 Jul 2007 22:43:33 +1000
User-Agent: KMail/1.9.6
Cc: rjw@sisk.pl, miltonm@bga.com, stern@rowland.harvard.edu,
       ying.huang@intel.com, linux-kernel@vger.kernel.org, david@lang.hm,
       linux-pm@lists.linux-foundation.org, jbms@cmu.edu
References: <Pine.LNX.4.64.0707171319140.2467@asgard.lang.hm> <200707202302.07116.rjw@sisk.pl> <E1ICDNw-0008HC-00@dorka.pomaz.szeredi.hu>
In-Reply-To: <E1ICDNw-0008HC-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart15622834.9J3sI0TMqq";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707212243.35602.nigel@nigel.suspend2.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart15622834.9J3sI0TMqq
Content-Type: text/plain;
  charset="cp 850"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi.

On Saturday 21 July 2007 21:44:32 Miklos Szeredi wrote:
> > The problem with FUSE is related to the fact that the freezer can't
> > freeze uninterruptible tasks and we said that perhaps we might avoid
> > it if FUSE was made freezing-aware.  Still, no one has gone in this
> > direction and I don't know of any plans to do that.
>=20
> I thought we have fully explored this direction.  Lots of emails, and
> an IRC session with Pavel.  Conclusion:

What am I missing in the following suggested solution?

1) In the freezer code, we implement a new TIF_LATEFREEZE process flag, whi=
ch,=20
when set, causes a  userspace process to be frozen with kernel threads=20
instead of with userspace ones. When freezing, we freezing !TIF_LATEFREEZE,=
=20
sync and then freeze TIF_LATEFREEZE and freezable kernel threads.

2) In the fuse code, the PID of the process that will do the work gets pass=
ed=20
to the fuse kernel code when the mount is done. The kernel code sets the=20
TIF_LATEFREEZE flag, and resets it on umount.

Sorry, but this is a hit-and-run email - I'm off to bed now.

Regards,

Nigel

--nextPart15622834.9J3sI0TMqq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGof93N0y+n1M3mo0RAtjIAKC72IcfI+29n7sCdQKpsiXhWk7lawCg8f9I
js3PkNzEYGPN456Kc60+f34=
=/GN/
-----END PGP SIGNATURE-----

--nextPart15622834.9J3sI0TMqq--
