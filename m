Return-Path: <linux-kernel-owner+w=401wt.eu-S1754540AbZASOzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540AbZASOzm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 09:55:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760599AbZASOxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 09:53:00 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:48168 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760586AbZASOw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 09:52:59 -0500
Date: Tue, 20 Jan 2009 01:52:51 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Howells <dhowells@redhat.com>
Cc: James Morris <jmorris@namei.org>, LKML <linux-kernel@vger.kernel.org>,
       "Hannes Eder" <hannes@hanneseder.net>
Subject: Re: [PATCH] creds: suppress warning in get_cred
Message-Id: <20090120015251.47ea14ff.sfr@canb.auug.org.au>
In-Reply-To: <11956.1232368171@redhat.com>
References: <20090119211031.934b4c19.sfr@canb.auug.org.au>
	<11956.1232368171@redhat.com>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__20_Jan_2009_01_52_51_+1100_zbkffYhRR3suof0/"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__20_Jan_2009_01_52_51_+1100_zbkffYhRR3suof0/
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi David,

On Mon, 19 Jan 2009 12:29:31 +0000 David Howells <dhowells@redhat.com> wrot=
e:
>
> Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>=20
> > +	return get_new_cred((struct cred *)(uintptr_t)cred);
>=20
> That should probably be 'unsigned long' within the kernel.  This is also a
> compiler bug, but I think we can live with this fix.

We do have uintptr_t inside the kernel (it is typedeffed to unsigned
long) but I used it explicitly because its type is defined to be large
enough to store any pointer.

However, I have also verified that using a newer compiler (4.3.2 in my
case) makes the warning go away as Hannes Eder pointed out when
mentioning his earlier patch.

So, your choice.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__20_Jan_2009_01_52_51_+1100_zbkffYhRR3suof0/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkl0k8MACgkQjjKRsyhoI8z+qgCcCcZjiSqa9C8I+mo42M0gH6cu
T+gAoIYEeY8L1wIKI4KduicwHlSs3n7W
=noip
-----END PGP SIGNATURE-----

--Signature=_Tue__20_Jan_2009_01_52_51_+1100_zbkffYhRR3suof0/--
