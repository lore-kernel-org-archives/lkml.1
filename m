Return-Path: <linux-kernel-owner+w=401wt.eu-S1755659AbXKEKqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659AbXKEKqd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 05:46:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753933AbXKEKqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 05:46:25 -0500
Received: from viefep31-int.chello.at ([62.179.121.49]:63651 "EHLO
	viefep31-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753726AbXKEKqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 05:46:25 -0500
Subject: Re: device struct bloat
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Greg KH <greg@kroah.com>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       linux-kernel@vger.kernel.org, apw <apw@shadowen.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20071105035855.GA25511@kroah.com>
References: <20071103124823.6059640e@shemminger-laptop>
	 <1194208158.5911.63.camel@lappy>  <20071105035855.GA25511@kroah.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-jJudLO6YecNWNxoLBmS2"
Date: Mon, 05 Nov 2007 11:46:21 +0100
Message-Id: <1194259581.27652.418.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-jJudLO6YecNWNxoLBmS2
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2007-11-04 at 19:58 -0800, Greg KH wrote:
> On Sun, Nov 04, 2007 at 09:29:18PM +0100, Peter Zijlstra wrote:
> >=20
> > On Sat, 2007-11-03 at 12:48 -0700, Stephen Hemminger wrote:
> > > The sizeof(struct device) is way too big, especially in the network d=
evice case.
> > > We want to support 1000's of device's and the change from class_devic=
e to
> > > net_device has caused needless bloat.
> > >=20
> > > sizeof(struct device) =3D 272
> > > sizeof(struct class_device) =3D 92
> > >   * not the class_id in class_device could also be removed or changed=
 to
> > >      a ptr, since it is redundant for net_devices.
> >=20
> > The thing that surprised me most was that it contains a struct
> > semaphore, Greg, is that really needed?
>=20
> Yes, it serializes bind and unbind stuff for the device.  There are
> comments about it in drivers/base/dd.c if you want to look into it.

Ah, that is not what I meant. My question was, why a semaphore, not a
mutex? Semaphores should not be used if at all possible - for one you
don't get lockdep checking your code.

/me converts the stuff over, and boots

Ah, that probably is the reason. This device tree is hard to annotate.
I'll try and think of something..

Anyway, Andy, could you make checkpatch whine on something like:
   ^\+[[::space:]]*struct semaphore




--=-jJudLO6YecNWNxoLBmS2
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHLvR9XA2jU0ANEf4RAqedAJ90OII2TImoK528IUM45Vz4wY7mEgCeI0kA
abLm18JcHDoO0ry4udRtWOo=
=+Xm/
-----END PGP SIGNATURE-----

--=-jJudLO6YecNWNxoLBmS2--

