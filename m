Return-Path: <linux-kernel-owner+w=401wt.eu-S1757589AbZGGNa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757589AbZGGNa0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 09:30:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754074AbZGGNaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 09:30:14 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:53986 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175AbZGGNaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 09:30:13 -0400
Message-ID: <4A534DD0.7090606@novell.com>
Date: Tue, 07 Jul 2009 09:29:52 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: linux-kernel@vger.kernel.org, mst@redhat.com, swhiteho@redhat.com
Subject: Re: [PATCH v4] slow-work: add (module*)work->ops->owner to fix races
 with module clients
References: <20090629191653.14240.44995.stgit@dev.haskins.net> <15258.1246972893@redhat.com>
In-Reply-To: <15258.1246972893@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigEB8E3B2C78092FE886DD7728"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigEB8E3B2C78092FE886DD7728
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

David Howells wrote:
> Gregory Haskins <ghaskins@novell.com> wrote:
>
>  =20
>> +	struct module *owner =3D work->ops->owner;
>> +
>> +	work->ops->put_ref(work);
>> +	module_put(owner);
>>    =20
>
> Hmmm...  There needs to be an smp_mb() between the read of the module o=
wner
> and the call to put_ref(), lest the CPU reorder things...  However, if
> put_ref(), say, calls atomic_dec_and_test(), then inserting one here wo=
uld be
> superfluous.
>
> I think documenting this will be enough - perhaps something like:
>
>  (*) Release a reference on an item:
>
> 	void (*put_ref)(struct slow_work *work);
>
>      This allows the thread pool to unpin an item by releasing the refe=
rence on
>      it.  The thread pool will not touch the item again once this has b=
een
>      called.
>
>      This function must interpolate a general SMP memory barrier before=
 freeing
>      or re-using the work struct as the caller may have read the module=

>      pointer.  Implying a barrier with something like atomic_dec_and_te=
st() is
>      sufficient.
>
> Do you agree?
>
> David
>  =20
Hi David,
  I agree, and think that looks good.  If you want to just fold that
into the patch or something, feel free.  Conversely, if you would like
me to submit a new patch, let me know.

Regards,
-Greg


--------------enigEB8E3B2C78092FE886DD7728
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkpTTdYACgkQlOSOBdgZUxn2lACdHulWmVJJ0FpvJR021lqkV6Fd
euYAmwQAeoulzMvnlkHRnO3sg2DHq+e6
=/HhC
-----END PGP SIGNATURE-----

--------------enigEB8E3B2C78092FE886DD7728--
