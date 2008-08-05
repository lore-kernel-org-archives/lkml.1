Return-Path: <linux-kernel-owner+w=401wt.eu-S1757711AbYHEFUR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757711AbYHEFUR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 01:20:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753285AbYHEFUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 01:20:04 -0400
Received: from home.keithp.com ([63.227.221.253]:1978 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753267AbYHEFUD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 01:20:03 -0400
Subject: Re: [PATCH] Export shmem_file_setup and shmem_getpage for DRM-GEM
From: Keith Packard <keithp@keithp.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: keithp@keithp.com, Christoph Hellwig <hch@infradead.org>,
       Eric Anholt <eric@anholt.net>, linux-kernel@vger.kernel.org,
       Dave Airlie <airlied@linux.ie>
In-Reply-To: <200808051443.11858.nickpiggin@yahoo.com.au>
References: <1217573919-7496-1-git-send-email-eric@anholt.net>
	 <200808041902.23970.nickpiggin@yahoo.com.au>
	 <1217887116.24714.118.camel@koto.keithp.com>
	 <200808051443.11858.nickpiggin@yahoo.com.au>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-PW4+nbwIKal8CIohyTnh"
Date: Mon, 04 Aug 2008 22:19:54 -0700
Message-Id: <1217913594.24714.164.camel@koto.keithp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-PW4+nbwIKal8CIohyTnh
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-08-05 at 14:43 +1000, Nick Piggin wrote:

> In my opinion, doing this little song and dance (which is a few lines
> of quite well defined APIs, btw) in userspace is preferable to adding
> a single line or exporting a single function in kernel space. Unless
> there is a better reason than eliminating a few lines of userspace code.

Yeah, Dave Airlie just reminded me of the real reason for creating an
API within the kernel. We need this to support kernel mode setting where
we want to provide a frame buffer console and smoothly transition to an
X desktop. Ideally, the console would start before user mode was running
so that our treasured boot messages could be displayed.

> I'm absolutely not against exporting a nice API for a swappable, object
> based memory allocator using ipc or shm to the wider kernel (with a nice
> API rather than just using shmem functions directly of course).

Yeah, we really only need a single argument.

> In the worst case it completely fails, the effort will still show much
> better how and why it needs to be done in kernel.

Sure, let's see if Dave can address the need to allocate these objects
from within the kernel. Of course, that allocation could also be done
using existing kernel APIs.

--=20
keith.packard@intel.com

--=-PW4+nbwIKal8CIohyTnh
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBIl+L6Qp8BWwlsTdMRAsIwAJ0RDalbwjAIuIUJ5DeaEpMYZnbMTgCgmC7u
M7sUVyP6uThs9JAO9CS4DMg=
=iYUm
-----END PGP SIGNATURE-----

--=-PW4+nbwIKal8CIohyTnh--

