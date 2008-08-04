Return-Path: <linux-kernel-owner+w=401wt.eu-S1758934AbYHDBzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758934AbYHDBzd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 21:55:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753349AbYHDBzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 21:55:25 -0400
Received: from home.keithp.com ([63.227.221.253]:2962 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752909AbYHDBzY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 21:55:24 -0400
Subject: Re: [PATCH] Export shmem_file_setup and shmem_getpage for DRM-GEM
From: Keith Packard <keithp@keithp.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: keithp@keithp.com, Eric Anholt <eric@anholt.net>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080801205052.GA28747@infradead.org>
References: <1217573919-7496-1-git-send-email-eric@anholt.net>
	 <1217573919-7496-2-git-send-email-eric@anholt.net>
	 <20080801205052.GA28747@infradead.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-M8lFRuOHcubjwbbXQfSp"
Date: Sun, 03 Aug 2008 18:54:56 -0700
Message-Id: <1217814896.23437.420.camel@koto.keithp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-M8lFRuOHcubjwbbXQfSp
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-08-01 at 16:50 -0400, Christoph Hellwig wrote:

> Nope.  Let the userspace protion create a file in shmfs instead of
> adding fugly kernel interfaces hdiing this fact.

shmem_file_setup is already public, just not exposed to kernel modules.
I suppose we could have user space allocate the shmem file (either via
tmpfs or sysv ipc). tmpfs suffers from the maxfd issue, while sysv ipc
runs up against the SHMMAX value.

The other interface we use, shmem_getpage, doesn't seem supported
through existing interfaces though. I don't want to map the file into
any address space, I just need a pointer to the physical pages which
underlie it. I'll take those pages and hand them to the graphics engine.
shmem_getpage performs precisely the operation needed here.

--=20
keith.packard@intel.com

--=-M8lFRuOHcubjwbbXQfSp
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBIlmFwQp8BWwlsTdMRAvXUAKDS8yX3yMHq/CPGqRdF8zGN9ejiXACgsLpy
QXDUyqy7tHAK55YRiY7laRU=
=GnS9
-----END PGP SIGNATURE-----

--=-M8lFRuOHcubjwbbXQfSp--

