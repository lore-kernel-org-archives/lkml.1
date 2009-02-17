Return-Path: <linux-kernel-owner+w=401wt.eu-S1752035AbZBQHvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035AbZBQHvx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 02:51:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751028AbZBQHvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 02:51:44 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:58916 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883AbZBQHvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 02:51:43 -0500
Message-ID: <499A6C7C.9060106@linux.vnet.ibm.com>
Date: Tue, 17 Feb 2009 01:51:24 -0600
From: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 7/8] ecryptfs: use kzfree()
References: <20090216142926.440561506@cmpxchg.org> <20090216144726.088020837@cmpxchg.org>
In-Reply-To: <20090216144726.088020837@cmpxchg.org>
X-Enigmail-Version: 0.95.7
OpenPGP: id=5D35E502
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig82585C0BC219E1CC4686197B"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig82585C0BC219E1CC4686197B
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Johannes Weiner wrote:
> Use kzfree() instead of memset() + kfree().
>=20
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Tyler Hicks <tyhicks@linux.vnet.ibm.com>

Acked-by: Tyler Hicks <tyhicks@linux.vnet.ibm.com>

Thanks for kzfree() and the updates to eCryptfs - I will put it to use
in the future.

> ---
>  fs/ecryptfs/keystore.c  |    3 +--
>  fs/ecryptfs/messaging.c |    3 +--
>  2 files changed, 2 insertions(+), 4 deletions(-)
>=20
> --- a/fs/ecryptfs/keystore.c
> +++ b/fs/ecryptfs/keystore.c
> @@ -740,8 +740,7 @@ ecryptfs_write_tag_70_packet(char *dest,
>  out_release_free_unlock:
>  	crypto_free_hash(s->hash_desc.tfm);
>  out_free_unlock:
> -	memset(s->block_aligned_filename, 0, s->block_aligned_filename_size);=

> -	kfree(s->block_aligned_filename);
> +	kzfree(s->block_aligned_filename);
>  out_unlock:
>  	mutex_unlock(s->tfm_mutex);
>  out:
> --- a/fs/ecryptfs/messaging.c
> +++ b/fs/ecryptfs/messaging.c
> @@ -291,8 +291,7 @@ int ecryptfs_exorcise_daemon(struct ecry
>  	if (daemon->user_ns)
>  		put_user_ns(daemon->user_ns);
>  	mutex_unlock(&daemon->mux);
> -	memset(daemon, 0, sizeof(*daemon));
> -	kfree(daemon);
> +	kzfree(daemon);
>  out:
>  	return rc;
>  }
>=20
>=20



--------------enig82585C0BC219E1CC4686197B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iEYEARECAAYFAkmabIIACgkQqDCb9l015QLPyACcCSOVkzCRUeBe3Jc1N0Cfxxf0
CZ8AnA+6FD4jFxDuGQGfrrQuzDb+9Zko
=8FHV
-----END PGP SIGNATURE-----

--------------enig82585C0BC219E1CC4686197B--
