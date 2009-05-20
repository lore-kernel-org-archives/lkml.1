Return-Path: <linux-kernel-owner+w=401wt.eu-S1756217AbZETM7E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217AbZETM7E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 08:59:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751411AbZETM6z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 08:58:55 -0400
Received: from postman.teamix.net ([194.150.191.120]:57062 "EHLO
	rproxy.teamix.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751126AbZETM6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 08:58:55 -0400
From: Martin Steigerwald <ms@teamix.de>
Organization: team(ix) GmbH
To: Marcin Krol <mrkafk@gmail.com>
Subject: Re: inotify limits - thousands (tens of thousands?) of watches
Date: Wed, 20 May 2009 14:58:53 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <4A13CCE1.5000106@gmail.com> <200905201322.15075.ms@teamix.de> <4A13F49D.7000905@gmail.com>
In-Reply-To: <4A13F49D.7000905@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1314861.SP55TCdZJ2";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200905201458.54199.ms@teamix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1314861.SP55TCdZJ2
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Mittwoch, 20. Mai 2009 schrieb Marcin Krol:
> Martin Steigerwald wrote:
> > Hmmm, I think you could just run a rsync periodically. It might even be
> > faster detecting changed files.
>
> I beg to differ on this: rsync does quite intensive (in terms of disk
> activity and CPU activity) comparisons at the beginning of
> synchronization. It's pretty light later, true, but running rsync every
> few minutes on entire /home is IMO out of question.

Another idea that might be applicable:=20

We have a clustered setup - exactly also where that inotify ruby script run=
s -=20
that used LVM and SoftRAID 1 for providing mirroring between both locations.

In each locations there is a RAID array with some hardware RAID, i.e.=20
redundant in itself. Each RAID array is connected via FC to both cluster=20
servers. Then we layer a SoftRAID 1 on top of it. Both cluster servers see=
=20
the SoftRAID 1 device. One usually only does NFS and one usually only MySQL=
=2E=20
Thus we made two volume groups. One of them is used by the NFS server only=
=20
and the other one by the MySQL server.

In failover case the remaining server stoniths the failed server and takes=
=20
over the volume group of it.

This way one of the servers could fail and the remaining server will be abl=
e=20
to access the most recent data. And one of the externel RAID arrays could=20
fail as well.

This worked remarkably well for more than a year, too. It won't work when y=
ou=20
need to access the same volumes on both servers simultaneously, obviously.

=2D-=20
Martin Steigerwald - team(ix) GmbH - http://www.teamix.de
gpg: 19E3 8D42 896F D004 08AC A0CA 1E10 C593 0399 AE90

--nextPart1314861.SP55TCdZJ2
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkoT/o4ACgkQHhDFkwOZrpAswQCfXUj5AaBNABpGcJ4x1hx/FXdo
e3QAn0Xx7bK6pmBPWGB+Np+65JHeX4FF
=ziqL
-----END PGP SIGNATURE-----

--nextPart1314861.SP55TCdZJ2--
