Return-Path: <linux-kernel-owner+w=401wt.eu-S1756393AbZETLwy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756393AbZETLwy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 07:52:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753935AbZETLwr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 07:52:47 -0400
Received: from postman.teamix.net ([194.150.191.120]:38249 "EHLO
	rproxy.teamix.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752811AbZETLwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 07:52:46 -0400
X-Greylist: delayed 1829 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 May 2009 07:52:46 EDT
From: Martin Steigerwald <ms@teamix.de>
Organization: team(ix) GmbH
To: linux-kernel@vger.kernel.org
Subject: Re: inotify limits - thousands (tens of thousands?) of watches
Date: Wed, 20 May 2009 13:22:05 +0200
User-Agent: KMail/1.9.9
Cc: Marcin Krol <mrkafk@gmail.com>
References: <4A13CCE1.5000106@gmail.com>
In-Reply-To: <4A13CCE1.5000106@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1463671.Ad3lGYoccl";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200905201322.15075.ms@teamix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1463671.Ad3lGYoccl
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Mittwoch, 20. Mai 2009 schrieb Marcin Krol:
> Hello everyone,
>
> First, apols for using up bandwidth, but I honestly found no other place
> where I can ask about this (and get meaningful reply).
>
> I'm not a kernel programmer, but I want to develop a program that would
> watch modifications in *all* user directories on a busy server using
> inotify.
>
> This is for high-availability purposes - events would be collected and
> once every several minutes changed dirs would be rsync'ed to failover
> server or smth like that would be done.

Hmmm, I think you could just run a rsync periodically. It might even be fas=
ter=20
detecting changed files. Unless you are talking really high number of=20
directories and files.

> As inotify watches particular directory and not its subdirs, I would
> have to watch all directories.

Yes. Thats cumbersome.

> This means I would have to create thousands or even tens of thousands of
> inotify watches.

I wrote a ruby script using libinotify-ruby which does just that. I only sy=
ncs=20
on demand tough. I.e. when someplace places a special sync file in a watche=
d=20
directory.

> So my questions are:
>
> 1. is it safe? that is, will it not lock the kernel up, or cause
> excessive memory consumption?
>
> 2. is it economic in terms of CPU time and RAM? I have no idea how to
> even measure such a thing happening in the kernel..

That script is running productively for well over a year now.

There have been some problems with it stopping doing work occasionally. It =
has=20
to be restarted. Now there is a monitor process which restarts it=20
automatically should it end. Might be a race condition or programming error=
=20
in the script. But the customer is happy with the workaround and didn't wan=
t=20
me to put any further efforts in finding the real cause.

Regarding the inotify implementation in the kernel I darkly remember that=20
there were some improvements. Search inotify or fsnotify in kernel-ml.

Ciao,
=2D-=20
Martin Steigerwald - team(ix) GmbH - http://www.teamix.de
gpg: 19E3 8D42 896F D004 08AC A0CA 1E10 C593 0399 AE90

--nextPart1463671.Ad3lGYoccl
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkoT598ACgkQHhDFkwOZrpC0NgCePLlnjud2PFwkylCS12dZcJW/
ioMAn1w8hrD+i5z+psuvX3t2W/VCjzCt
=pm9n
-----END PGP SIGNATURE-----

--nextPart1463671.Ad3lGYoccl--
