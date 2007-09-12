Return-Path: <linux-kernel-owner+w=401wt.eu-S1764988AbXILJBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764988AbXILJBT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 05:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763313AbXILJBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 05:01:05 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:15750 "EHLO
	viefep34-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752857AbXILJBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 05:01:04 -0400
Subject: Re: [PATCH 00/23] per device dirty throttling -v10
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: John Stoffel <john@stoffel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, miklos@szeredi.hu,
       akpm@linux-foundation.org, neilb@suse.de, dgc@sgi.com,
       tomoki.sekiyama.qu@hitachi.com, nikita@clusterfs.com,
       trond.myklebust@fys.uio.no, yingchao.zhou@gmail.com,
       richard@rsk.demon.co.uk, torvalds@linux-foundation.org
In-Reply-To: <18151.20356.862163.430265@stoffel.org>
References: <20070911195350.825778000@chello.nl>
	 <18151.20356.862163.430265@stoffel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-CJuUtTUukrRDlkmrjFkk"
Date: Wed, 12 Sep 2007 11:00:59 +0200
Message-Id: <1189587659.21778.104.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-CJuUtTUukrRDlkmrjFkk
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-09-11 at 22:31 -0400, John Stoffel wrote:

I hope the snipped questions were sufficiently answered in the other
mail. If not, holler :-)

> Peter> 3 is done by also scaling the dirty limit proportional to the
> Peter> current task's recent dirty rate.
>=20
> Do you mean task or device here?  I'm just wondering how well this
> works with a bunch of devices with wildly varying speeds. =20

Task. What I do is modify the limit like this:

  current_limit =3D dirty_limit * p(bdi_writeout) * (1 - p(task_dirty)/8)

Where the p() values are [0, 1].

By including the inverse of the task dirty rate one gets that tasks that
are more agressive dirtiers get throttled more aggressively, whereas
tasks that occasionally dirty a page get a little more room.

--=-CJuUtTUukrRDlkmrjFkk
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBG56rLXA2jU0ANEf4RAgoNAJ9oZ6x4zIh+sgiFt+rcWGJBapCQ5gCcCKu5
qn++C+cgC9zEBLqaND5CAGI=
=JXs2
-----END PGP SIGNATURE-----

--=-CJuUtTUukrRDlkmrjFkk--

