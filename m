Return-Path: <linux-kernel-owner+w=401wt.eu-S1756111AbYHSQq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111AbYHSQq3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 12:46:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750921AbYHSQqT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 12:46:19 -0400
Received: from home.keithp.com ([63.227.221.253]:4901 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753448AbYHSQqS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 12:46:18 -0400
Subject: Re: [PATCH] Export shmem_file_setup and shmem_getpage for DRM-GEM
From: Keith Packard <keithp@keithp.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: keithp@keithp.com, Dave Airlie <airlied@gmail.com>,
       Christoph Hellwig <hch@infradead.org>, Eric Anholt <eric@anholt.net>,
       linux-kernel@vger.kernel.org
In-Reply-To: <200808192000.47070.nickpiggin@yahoo.com.au>
References: <1217573919-7496-1-git-send-email-eric@anholt.net>
	 <200808051443.11858.nickpiggin@yahoo.com.au>
	 <21d7e9970808181817n1d67dc33s58b8d07f63e411a7@mail.gmail.com>
	 <200808192000.47070.nickpiggin@yahoo.com.au>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Itdh3o6WO2JIJOdc7m+q"
Date: Tue, 19 Aug 2008 09:46:07 -0700
Message-Id: <1219164367.10772.420.camel@koto.keithp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Itdh3o6WO2JIJOdc7m+q
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-08-19 at 20:00 +1000, Nick Piggin wrote:

> Not exactly sure what you mean by this. But I would like to see an effort
> made to use existing userspace APIs in order to do this swappable object
> allocation over tmpfs scheme. As I said, I don't object to a nice kernel
> implementation, but we would be in a much better position to assess it if
> we had an existing userspace implementation to compare it with.

We need to allocate objects from kernel mode to get the console running.
I'd prefer to let that occur before user mode was available. Also,
emulating the existing fbdev syscall interface will require that we
allocate objects within the kernel.

Hence, the question about how we should create objects from kernel mode.
I think we can do this with a series of VFS function calls. Would that
series of VFS calls be preferable to directly accessing the existing
shmem API?

Another alternative is to improve the existing shmem API to better
capture what we're trying to do here. Both drm and sysv shm just want
anonymous pages that are backed by swap. If we started from scratch,
what API would we like to have here? Would we have it support both shmem
and hugetlbfs?

--=20
keith.packard@intel.com

--=-Itdh3o6WO2JIJOdc7m+q
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBIqvjPQp8BWwlsTdMRAliNAKCjkpsiQDdTR3XXklB8fV9G8mXsKACgt4w5
2LUd+Lue9ae8AaBtn7ivgJQ=
=aSr4
-----END PGP SIGNATURE-----

--=-Itdh3o6WO2JIJOdc7m+q--

