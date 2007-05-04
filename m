Return-Path: <linux-kernel-owner+w=401wt.eu-S1031357AbXEDQ0e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031357AbXEDQ0e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 12:26:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031346AbXEDQ0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 12:26:34 -0400
Received: from home.keithp.com ([63.227.221.253]:3481 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031357AbXEDQ0d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 12:26:33 -0400
Subject: Re: [RFC] [PATCH] DRM TTM Memory Manager patch
From: Keith Packard <keithp@keithp.com>
To: Keith Whitwell <keith@tungstengraphics.com>
Cc: keithp@keithp.com,
       Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thomas@tungstengraphics.com>,
       dri-devel@lists.sourceforge.net, Dave Airlie <airlied@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
In-Reply-To: <463B5803.6050802@tungstengraphics.com>
References: <21d7e9970704252355m4765b65fyb547b9ba2763b103@mail.gmail.com>
	 <1178137279.53297.114.camel@vonnegut>
	 <46391860.3070409@tungstengraphics.com>
	 <1178251621.27028.9.camel@neko.keithp.com>
	 <463AE9AE.7070806@tungstengraphics.com>
	 <1178291702.27028.30.camel@neko.keithp.com>
	 <463B5803.6050802@tungstengraphics.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-+Fig/mjlujhzt6jVn6KL"
Date: Fri, 04 May 2007 09:26:09 -0700
Message-Id: <1178295969.27028.51.camel@neko.keithp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-+Fig/mjlujhzt6jVn6KL
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-05-04 at 16:57 +0100, Keith Whitwell wrote:

> That's a special case of a the general problem of what do you do when a=20
> client submits any validation list that can't be satisfied.  Failing to=20
> render isn't really an option, either the client or the memory manager=20
> has to either prevent it happening in the first place or have some=20
> mechanism for chopping up the dma buffer into segments which are=20
> satisfiable...  Neither of which I can see an absolutely reliable way to=20
> do.

I think we must return an error from the kernel and let user mode sort
it out; potentially by breaking up the operation into smaller pieces, or
(ick), simply falling back to software. Eliminating per-submit flushing
will even make this reasonably efficient as we remap the GTT as objects
are used. I don't think we want to support automatic partitioning of the
operation in the kernel; punting that step to user mode seems like a
sensible option.

Certainly presenting all of the objects to the kernel atomically will
permit it to succeed if the device can possibly perform the operation;
ejecting all existing objects and reloading with precisely the objects
proposed by the application can be done, and is even inexpensive on UMA
hardware.

> The way to get around this is to mandate that hardware supports paged=20
> virtual memory...  But that seems to be a difficult trick.

Yeah, especially as we don't currently have any examples in our
environment.

--=20
keith.packard@intel.com

--=-+Fig/mjlujhzt6jVn6KL
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGO16gQp8BWwlsTdMRAs07AJ92gaFL3kV5GuQWsUs/FEv6QS0E7QCfWLhZ
gFvzCorr8dZy3z4LqFdPIm0=
=fZsD
-----END PGP SIGNATURE-----

--=-+Fig/mjlujhzt6jVn6KL--
