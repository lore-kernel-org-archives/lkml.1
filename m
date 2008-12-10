Return-Path: <linux-kernel-owner+w=401wt.eu-S1755499AbYLJIQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499AbYLJIQv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 03:16:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753884AbYLJIQo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 03:16:44 -0500
Received: from RedStar.dorchain.net ([212.88.133.153]:40220 "EHLO
	Redstar.dorchain.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753652AbYLJIQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 03:16:43 -0500
X-DKIM: Sendmail DKIM Filter v2.6.0 Redstar.dorchain.net mBA8Ge0e015271
Date: Wed, 10 Dec 2008 09:16:40 +0100
From: Joerg Dorchain <joerg@dorchain.net>
To: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] amiflop: get rid of sleep_on calls
Message-ID: <20081210081640.GG30213@Redstar.dorchain.net>
References: <1228755578-26069-1-git-send-email-aeb@debian.org> <20081209082608.GA10651@Redstar.dorchain.net> <20081210004810.GA5073@infernal.debian.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nHwqXXcoX0o6fKCv"
Content-Disposition: inline
In-Reply-To: <20081210004810.GA5073@infernal.debian.net>
X-message-flag: Formating hard disk. please wait...   10%...  20%...
X-Bindford: 6200 (more Power!)
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nHwqXXcoX0o6fKCv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 10, 2008 at 01:48:10AM +0100, Andreas Bombe wrote:
> I think we're not talking about the same problem.  If I were to use
> complete() together with wait_for_completion() there would be a problem
> if fd_motor_on() can get as far as wait_for_completion() while a
> previous completion is yet uncompleted.  This can not happen for
> different drives, as the fd_select() would block.  If it could happen
> for the same drive, the complete() would allow only one task to
> continue.  The complete_all() takes care of that.
>=20
> If requests are serialized for a drive so that there won't ever be two
> running at the same time for certain (thinking about it, it's probable),
> I could make it a simple complete().  It's hardly worth the risk,
> however.

IIRC (have not touched the driver for quite some time) at a
certain stage all requests for a specific drive are serialized.
The amiga floppy drives read and write whole tracks only, so
follow-up acesses are likely to be on the same track and then
served from the buffer of decoded blocks. I you do wild track
jumping, it is slower than the original AmigaOS-driver.

But as I am not sure, and floppy drives are slow anyway, the
complete_all() won't give any notable performance penalty, I guess.

Joerg

--nHwqXXcoX0o6fKCv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkk/eucACgkQjY4+4PdzvOBtywCfdVKNeWcWJsy9XGuGgFx3OnR3
zmIAmgIQkODWeSwuRFRHzyRMqzWwBca+
=3w/d
-----END PGP SIGNATURE-----

--nHwqXXcoX0o6fKCv--
