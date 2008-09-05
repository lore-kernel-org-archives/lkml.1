Return-Path: <linux-kernel-owner+w=401wt.eu-S1753593AbYIENWF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593AbYIENWF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 09:22:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752766AbYIENVy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 09:21:54 -0400
Received: from systemlinux.org ([83.151.29.59]:49866 "EHLO m18s25.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752761AbYIENVx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 09:21:53 -0400
Date: Fri, 5 Sep 2008 15:12:44 +0200
From: Andre Noll <maan@systemlinux.org>
To: Andrew Patterson <andrew.patterson@hp.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com,
       linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
       andmike@linux.vnet.ibm.com, mike.miller@hp.com, genanr@emsphone.com,
       jmoyer@redhat.com
Subject: Re: [PATCH 2/6] Adjust block device size after an online resize of a disk.
Message-ID: <20080905131244.GC3795@skl-net.de>
References: <20080904202714.10456.88061.stgit@bob.kio> <20080904202725.10456.62289.stgit@bob.kio>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XWOWbaMNXpFDWE00"
Content-Disposition: inline
In-Reply-To: <20080904202725.10456.62289.stgit@bob.kio>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XWOWbaMNXpFDWE00
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 14:27, Andrew Patterson wrote:
>  int revalidate_disk(struct gendisk *disk)
>  {
> +	struct block_device *bdev;
>  	int ret =3D 0;
> =20
>  	if (disk->fops->revalidate_disk)
>  		ret =3D disk->fops->revalidate_disk(disk);

Maybe we should return early at this point if revalidate_disk()
failed or fops->revalidate_disk is NULL.

> +	bdev =3D bdget_disk(disk, 0);
> +	if (!bdev)
> +		return ret;

We might return success here even if bdev is NULL. OTOH, as the callers
of revalidate_disk() do not check the return value anyway (although at
least tapeblock_revalidate_disk() might return a negative value) it's
probably also an option to change the return type of revalidate_disk()
to void.

Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--XWOWbaMNXpFDWE00
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFIwTBMWto1QDEAkw8RAkSFAJ4ofQDaYPHwbl/BU5DYtjDkuow41gCeO3Dg
YgQ8eNj8Hb6hGMH2gcIXzo0=
=hmzE
-----END PGP SIGNATURE-----

--XWOWbaMNXpFDWE00--
