Return-Path: <linux-kernel-owner+w=401wt.eu-S932952AbXAXIYN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932952AbXAXIYN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 03:24:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933111AbXAXIYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 03:24:13 -0500
Received: from mxfep02.bredband.com ([195.54.107.73]:61684 "EHLO
	mxfep02.bredband.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932952AbXAXIYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 03:24:12 -0500
Subject: Re: SATA exceptions with 2.6.20-rc5
From: Ian Kumlien <pomac@vapor.com>
Reply-To: pomac@vapor.com
To: Robert Hancock <hancockr@shaw.ca>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Larry Walton <lwalton@real.com>, B.Steinbrink@gmx.de,
       s0348365@sms.ed.ac.uk, chunkeey@web.de, Jeff Garzik <jeff@garzik.org>
In-Reply-To: <45B697D3.4070707@shaw.ca>
References: <fa.1kBz5luWz8nR0lLqm1VD4hZZYdw@ifi.uio.no>
	 <fa.QZxgjxcwtENaZNY24NMTlKBSgIM@ifi.uio.no>
	 <fa.fkPTbUGmKc/1pt0eD6TE4d02n+Q@ifi.uio.no>
	 <fa.6iQt5OtHZ3x5w8eYbLxwULhLTJ0@ifi.uio.no>
	 <fa.1aqo3IxNGJClHcBVZNTagX6bL9o@ifi.uio.no>
	 <fa.rI60BGlFbSyfLyumqmgiOfDqCI4@ifi.uio.no>  <45B697D3.4070707@shaw.ca>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-VXWypfeUJIeTJcrCTfqH"
Date: Wed, 24 Jan 2007 09:24:00 +0100
Message-Id: <1169627043.11590.1.camel@pi.pomac.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-VXWypfeUJIeTJcrCTfqH
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On tis, 2007-01-23 at 17:18 -0600, Robert Hancock wrote:
> Larry Walton wrote:
> > The last patch (sata_nv-force-int-dev-in-interrupt.patch)=20
> > seems to have fix the problem.  Much appreciated,=20
> > thank you. I'd consider it a must have in 2.6.20.
>=20
> Can any of the rest of you that have been seeing this problem also=20
> confirm that this fixes it?

I applied it yesterday and today my dmesg contains three:
BUG: at mm/truncate.c:60 cancel_dirty_page()

Call Trace:
 [<ffffffff8029f3e5>] cancel_dirty_page+0x43/0x71
 [<ffffffff802ec1ab>] reiserfs_cut_from_item+0x5f8/0x61d
 [<ffffffff802074fc>] find_get_page+0x21/0x47
 [<ffffffff802ec51d>] reiserfs_do_truncate+0x34d/0x495
 [<ffffffff802d9d47>] reiserfs_truncate_file+0x199/0x2aa
 [<ffffffff802df9c5>] reiserfs_file_release+0x261/0x281
 [<ffffffff80211b02>] __fput+0xb1/0x17d
 [<ffffffff802218e0>] filp_close+0x5d/0x65
 [<ffffffff8021bef5>] sys_close+0x8c/0xcf
 [<ffffffff8025725e>] system_call+0x7e/0x83

Which never happened before... I dunno if they are related though, but
they weren't there before...

(It does fix the timeout problem)

--=20
Ian Kumlien <pomac () vapor ! com> -- http://pomac.netswarm.net

--=-VXWypfeUJIeTJcrCTfqH
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6-ecc01.6 (GNU/Linux)

iD8DBQBFtxeg7F3Euyc51N8RAqg4AJ9jRmR2dN+TA7Q6xTGgM4hmRQiEpQCgrFxT
FWcGCc7vElPsxwmv6uRwDEM=
=1bBa
-----END PGP SIGNATURE-----

--=-VXWypfeUJIeTJcrCTfqH--
