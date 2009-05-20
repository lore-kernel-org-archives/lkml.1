Return-Path: <linux-kernel-owner+w=401wt.eu-S1756811AbZETMsa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756811AbZETMsa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 08:48:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755580AbZETMsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 08:48:22 -0400
Received: from postman.teamix.net ([194.150.191.120]:59126 "EHLO
	rproxy.teamix.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755355AbZETMsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 08:48:22 -0400
From: Martin Steigerwald <ms@teamix.de>
Organization: team(ix) GmbH
To: Marcin Krol <mrkafk@gmail.com>
Subject: Re: inotify limits - thousands (tens of thousands?) of watches
Date: Wed, 20 May 2009 14:48:16 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <4A13CCE1.5000106@gmail.com> <200905201322.15075.ms@teamix.de> <4A13F49D.7000905@gmail.com>
In-Reply-To: <4A13F49D.7000905@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2060960.6NCTbm2UKN";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200905201448.21222.ms@teamix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2060960.6NCTbm2UKN
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

It depends on the amount of directories being watched and the amount direct=
ory=20
entries in there. Rsync version 3 starts of synchronizing before building u=
p=20
the entire trees on both sides. It uses an incremental approach and this=20
appears to make quite a difference.

=46or syncing /home I wonder whether inotify or fsnotify/fanotify is the ri=
ght=20
approach. A cluster filesystem of some sort comes to my mind instead. But=20
question is, which one really works good enough. Didn't do any testing in=20
that area yet.

> > I wrote a ruby script using libinotify-ruby which does just that. I only
> > syncs on demand tough. I.e. when someplace places a special sync file in
> > a watched directory.
> >
> > That script is running productively for well over a year now.
>
> Good to know the idea is not totally off the wall.. Thanks.

Main difference is that the sync is only triggered on demand. But the watch=
ing=20
part appears to work quite nicely. Its not used for /home, but for the stat=
ic=20
html/php/image content for an apache2.2 which handles a lot of domains.

> Anyway, I'll try using fsnotify / fanotify.
>
> My main gripe with it, though, is that it is not in the mainline kernel,
> and thus in all probability it is not tested as widely as inotify.

Well then it will get more testing now I think ;-).

> Are there any chances for its inclusion in the near future?

Indeed would be nice to have.

=2D-=20
Martin Steigerwald - team(ix) GmbH - http://www.teamix.de
gpg: 19E3 8D42 896F D004 08AC A0CA 1E10 C593 0399 AE90

--nextPart2060960.6NCTbm2UKN
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkoT/BAACgkQHhDFkwOZrpB+AACgmZUSO45XbzXo0/Hd421wb9Ca
FWgAoIdRUMfFOAMh8RD3pDYkaI+jaD+e
=17Un
-----END PGP SIGNATURE-----

--nextPart2060960.6NCTbm2UKN--
