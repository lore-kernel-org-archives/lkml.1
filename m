Return-Path: <linux-kernel-owner+w=401wt.eu-S1754502AbZHJMlE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502AbZHJMlE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 08:41:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754477AbZHJMlB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 08:41:01 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:43641 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754457AbZHJMk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 08:40:59 -0400
Subject: Re: rfkill rework in 2.6.31-rc, hal/dbus access changes?
From: Johannes Berg <johannes@sipsolutions.net>
To: Norbert Preining <preining@logic.at>
Cc: Marcel Holtmann <marcel@holtmann.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20090810122813.GM844@gamma.logic.tuwien.ac.at>
References: <20090711091427.GB14367@gamma.logic.tuwien.ac.at>
	 <1247338473.9709.107.camel@localhost.localdomain>
	 <20090711195911.GA31549@gamma.logic.tuwien.ac.at>
	 <1247346745.9709.129.camel@localhost.localdomain>
	 <20090810104302.GD844@gamma.logic.tuwien.ac.at>
	 <1249906970.12361.11.camel@johannes.local>
	 <20090810122813.GM844@gamma.logic.tuwien.ac.at>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-c553FZQU8IxWzbnnPubv"
Date: Mon, 10 Aug 2009 14:40:24 +0200
Message-Id: <1249908024.32614.3.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.27.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-c553FZQU8IxWzbnnPubv
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-08-10 at 14:28 +0200, Norbert Preining wrote:

> And threads I need (AFAIU) because the read from the fd will blcok
> until there is an event, and in the mean time the user might
> do something with the applet (like disabling manually the rfkill,
> or configuration). So one thread is listening to user events (the=20
> normal pygtk loop) and one is reading from /dev/rfkill and=20
> in case something comes in it takes the respective actions.
>=20
> In python-speak I do:
>=20
> 	fd =3D os.open("/dev/rfkill", os.O_RDONLY)
> 	p =3D select.poll()
> 	p.register(fd, select.POLLIN | select.POLLHUP)
> 	n =3D p.poll()
> 	if (t =3D=3D select.POLLIN)
> 	  buf =3D os.read(fd, 8)
> 	....
>=20
> Isn't that supposed to work like that?

Oh, that's what you mean by polling...

Well, you still don't need threads, since you can just add your fd to
the gtk event loop. You'd probably use
http://library.gnome.org/devel/glib/unstable/glib-IO-Channels.html#g-io-add=
-watch and http://library.gnome.org/devel/glib/unstable/glib-IO-Channels.ht=
ml#g-io-channel-unix-new

johannes

--=-c553FZQU8IxWzbnnPubv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKgBU0AAoJEODzc/N7+QmaDT0QANO3FzqF15+9tg3mm624KUMb
dfPzdB5KgGzRFu3RcYS9tnc6n8UO59G3wd077hcfEI0NmONKVUBaWhkNlhnymSIU
vUiMeeOe6ZTwxEuwudjENFSF5zgnS8+9RmRqlAoSlTmxmX0bSIihgYMxaW/goMbC
BCPEyjbJRfpVWdv0F/ftWszq3WuSzKjGAtkUwt9PBBtu8rJlo0A25ELUPGpfvAhJ
o3ghdqdMiLjAhaw3o9y0Ff3IKEuu+aB3oLfKFDj/80gr2KVAsyyQdT+Lf6vwQX6E
6erl28Wbj3CpmnYlMDLzvmEWDUVrYwNhVWaEsUl5KW4FxVRZxJf7J0rtr+KyivkQ
s/Svqvvs8k1Ngsgl6rHiu9Qo0q1n86XphPfWyeW27tSjkxCKNGy0ME8aEVdx5kOZ
/M9odTLjW4jAaAAhFDFLdJ4OqUhLFpSSg8Flg0aA6EUELyYmeR/mWp/26Y3ydN40
PSY+oQgjGBkAjQxeeZjGTNvB3vUxM7mLn2zMJS+In+U/dZbeDQK2LpPQu8ltjPlw
FQzY57zAb9Nlck8gFerWDcvu4dZVrxKG1uqScv2m47sbhduTFngfilJ47aHVi9H6
QdRm0R2aD234LkRplaAglsAJm2kx4V7jlWY3AcY0FKtIMWv9fOET0ltyRyx1v2Nm
ug8QFRuwpvRcbWpEeuvE
=njT1
-----END PGP SIGNATURE-----

--=-c553FZQU8IxWzbnnPubv--

